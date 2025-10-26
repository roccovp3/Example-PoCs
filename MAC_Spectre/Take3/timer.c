// timer.c -- macOS two-thread timer shim for benchmarking (safe microbenchmarks)
// Build with: clang -O3 -std=c11 -pthread timer.c -o timer_test

#define _GNU_SOURCE
#include "timer.h"

#include <assert.h>
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <mach/thread_policy.h>
#include <pthread.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <errno.h>
#include <math.h>

// Architecture-dependent ISB-ish fence
#if defined(__aarch64__)
  #define ISB() __asm__ __volatile__("isb" ::: "memory")
#elif defined(__x86_64__)
  #define ISB() __asm__ __volatile__("lfence" ::: "memory")
#else
  #define ISB() __asm__ __volatile__("" ::: "memory")
#endif

static _Atomic uint64_t g_counter = 0;
static _Atomic int      g_stop = 0;
static pthread_t       g_thr;
static mach_timebase_info_data_t g_tb;
static double          g_ticks_per_ns = 0.0; // ticks / ns


static int cmp_u64_(const void *a, const void *b) {
  const uint64_t x = *(const uint64_t*)a, y = *(const uint64_t*)b;
  return (x>y) - (x<y);
}
static uint64_t median_u64_(uint64_t *v, int n) {
  qsort(v, (size_t)n, sizeof(uint64_t), cmp_u64_);
  return v[n/2];
}
static uint64_t mad_u64_(uint64_t *v, int n, uint64_t med) {
  for (int i=0;i<n;i++) v[i] = (v[i] > med) ? (v[i]-med) : (med-v[i]);
  qsort(v, (size_t)n, sizeof(uint64_t), cmp_u64_);
  return v[n/2];
}

// Background incrementing thread
static void* timer_thread_fn(void* arg) {
#ifdef QOS_CLASS_USER_INTERACTIVE
  pthread_set_qos_class_self_np(QOS_CLASS_USER_INTERACTIVE, 0);
#endif
  while (!atomic_load_explicit(&g_stop, memory_order_relaxed)) {
    atomic_fetch_add_explicit(&g_counter, 1, memory_order_relaxed);
  }
  return NULL;
}

// Try to set affinity tag on a thread (Darwin only)
static void set_affinity_tag(pthread_t th, int tag) {
  thread_port_t mth = pthread_mach_thread_np(th);
  thread_affinity_policy_data_t pol = { .affinity_tag = tag };
  (void)thread_policy_set(mth, THREAD_AFFINITY_POLICY,
                          (thread_policy_t)&pol, THREAD_AFFINITY_POLICY_COUNT);
}

// Convert mach absolute to ns
static inline uint64_t abs_to_ns(uint64_t t_abs) {
  return (t_abs * g_tb.numer) / g_tb.denom;
}
static inline uint64_t ns_to_abs(uint64_t ns) {
  return (ns * g_tb.denom) / g_tb.numer;
}

// Busy calibrate ticks-per-nanosecond by comparing counter progress to mach_continuous_time
static double calibrate_ticks_per_ns(double seconds) {
  uint64_t start = atomic_load_explicit(&g_counter, memory_order_relaxed);
  uint64_t t0 = mach_continuous_time();
  uint64_t budget = ns_to_abs((uint64_t)(seconds * 1e9));
  while (mach_continuous_time() - t0 < budget) { /* spin */ }
  uint64_t end = atomic_load_explicit(&g_counter, memory_order_relaxed);
  uint64_t t1 = mach_continuous_time();
  uint64_t ns = abs_to_ns(t1 - t0);
  if (ns == 0) ns = 1;
  return (double)(end - start) / (double)ns;
}

int timer_init(bool use_affinity, double calib_seconds) {
  mach_timebase_info(&g_tb);
  atomic_store_explicit(&g_counter, 0, memory_order_relaxed);
  atomic_store_explicit(&g_stop, 0, memory_order_relaxed);

  // Optionally set affinity for main thread to bias scheduling
  if (use_affinity) set_affinity_tag(pthread_self(), 1);

  if (pthread_create(&g_thr, NULL, timer_thread_fn, NULL) != 0) {
    perror("pthread_create");
    return -1;
  }

  if (use_affinity) set_affinity_tag(g_thr, 1);

  // give it a small ramp
  struct timespec ts = { .tv_sec = 0, .tv_nsec = 5 * 1000 * 1000 };
  nanosleep(&ts, NULL);

  g_ticks_per_ns = calibrate_ticks_per_ns(calib_seconds);
  if (g_ticks_per_ns <= 0.0) g_ticks_per_ns = 1.0; // fail-safe

  return 0;
}

uint64_t timer_now(void) {
  return atomic_load_explicit(&g_counter, memory_order_relaxed);
}

double timer_ticks_to_ns(uint64_t ticks) {
  return (double)ticks / g_ticks_per_ns;
}

uint64_t timer_time_maccess(void *ptr) {
  ISB();
  uint64_t t0 = timer_now();
  ISB();
  // volatile read to ensure the access happens
  volatile unsigned char tmp = *(volatile unsigned char *)ptr;
  (void)tmp;
  ISB();
  uint64_t t1 = timer_now();
  ISB();
  return t1 - t0;
}



#  define CACHE_LINE_SIZE 64  // 64 bytes (typical cache line size)
#  define L1D_SETS 128     // 64KB / (64B * 8 ways) = 128 sets (typical Apple Silicon)


static inline size_t cache_index_for(uintptr_t addr, size_t line_size, size_t sets) {
  return (addr / line_size) % sets;
}

// Random shuffle (Fisher-Yates)
static void shuffle_ptrs_(void **a, size_t n) {
  for (size_t i = n; i > 1; --i) {
    size_t j = (size_t)(rand() % i);
    void *t = a[i-1]; a[i-1] = a[j]; a[j] = t;
  }
}

// Drive the pointer-chase N times to strengthen replacement pressure.
void evset_evict_rounds(const eviction_set_t *es, int rounds) {
  if (!es || !es->head) return;
  volatile uint8_t sink = 0;
  for (int r=0;r<rounds;r++) {
    sink ^= evset_traverse_once(es);
  }
  (void)sink;
}


// ---------------------------- L1 (strict VIPT) ----------------------------
// Use the VA-set congruence property: keep the lower 16 bits (64KiB window) equal.
// Pick candidates at offsets that preserve (addr / line) % sets == victim_idx.
int evset_build_l1_strict(eviction_set_t *es, void *victim_addr,
                          size_t nlines, size_t region_bytes, bool randomize_order)
{
  if (!es || !victim_addr || nlines == 0) return -1;

  const size_t line = CACHE_LINE_SIZE;
  const size_t sets = 128; // typical 64KiB L1D: 64B*8*128 = 64KiB
  // allocate region (4 MiB default) and collect congruent lines
  size_t pagesz = (size_t)sysconf(_SC_PAGESIZE);
  size_t align  = (pagesz > line ? pagesz : line);
  void *region  = NULL;
  if (posix_memalign(&region, align, region_bytes) != 0 || !region) return -1;

  uintptr_t v = (uintptr_t)victim_addr;
  size_t v_idx = ((v/line) % sets);

  // One candidate per 64B line across region; keep same set index.
  size_t max_c = region_bytes / line;
  void **cand  = (void**)malloc(max_c*sizeof(void*));
  if (!cand) { free(region); return -1; }
  size_t cc = 0;
  for (size_t off=0; off + line <= region_bytes; off += line) {
    void *p = (void *)((uintptr_t)region + off);
    if ( (( (uintptr_t)p / line) % sets) == v_idx ) cand[cc++] = p;
  }
  if (cc < nlines) { free(cand); free(region); return -1; }

  if (randomize_order) { srand((unsigned)time(NULL)); shuffle_ptrs_(cand, cc); }

  // Take first nlines and chain into pointer-chase list
  for (size_t i=0;i<nlines;i++) {
    *(void**)cand[i] = (i+1<nlines) ? cand[i+1] : NULL;
  }

  es->lines        = (void**)malloc(nlines*sizeof(void*));
  if (!es->lines) { free(cand); free(region); return -1; }
  for (size_t i=0;i<nlines;i++) es->lines[i] = cand[i];
  es->nlines       = nlines;
  es->region       = region;
  es->region_bytes = region_bytes;
  es->head         = cand[0];

  free(cand);
  return 0;
}



// --------------------- L2/L3 adaptive black-box builder -------------------
static uint64_t measure_after_prime_(void **nodes, size_t n, void *victim,
                                     int prime_rounds)
{
  // Warm victim to make it a hit first
  volatile uint8_t warm = *(volatile uint8_t*)victim; (void)warm;
  for (int r=0;r<prime_rounds;r++) {
    for (size_t i=0;i<n;i++) {
      volatile uint8_t x = *(volatile uint8_t*)nodes[i]; (void)x;
      // note: the next-pointer deref occurs only in pointer-chase form; for
      // learning we just touch each line directly to maximize footprint speed.
    }
  }
  // Serialize, then time the victim
  ISB();
  return timer_time_maccess(victim);
}

// return 1 if set S produces a slow access beyond threshold (majority vote)
static int set_evicts_(void **nodes, size_t n, void *victim,
                       uint64_t slow_thr, int trials, int prime_rounds)
{
  int votes = 0, need = (trials+1)/2;
  for (int t=0;t<trials;t++) {
    uint64_t dt = measure_after_prime_(nodes, n, victim, prime_rounds);
    if (dt > slow_thr) { if (++votes >= need) return 1; }
  }
  return 0;
}


// Conservative baseline+noise estimate, returns threshold = med + k*mad (+ floor).
static uint64_t adaptive_threshold_(void *victim, int samples, uint64_t floor_ticks) {
  if (samples < 31) samples = 31;
  uint64_t *vals = (uint64_t*)malloc((size_t)samples*sizeof(uint64_t));
  for (int i=0;i<samples;i++) {
    volatile uint8_t w = *(volatile uint8_t*)victim; (void)w; // warm
    vals[i] = timer_time_maccess(victim);
  }
  uint64_t med = median_u64_(vals, samples);
  uint64_t *tmp = (uint64_t*)malloc((size_t)samples*sizeof(uint64_t));
  memcpy(tmp, vals, (size_t)samples*sizeof(uint64_t));
  uint64_t mad = mad_u64_(tmp, samples, med);
  free(tmp);
  free(vals);

  // k=3 is robust; add floor to avoid tiny thresholds on very fast timers.
  uint64_t thr = med + 3*mad;
  if (thr < med + floor_ticks) thr = med + floor_ticks;
  return thr;
}


// Build from a large random pool, grow until it's "slow", then prune to ~target_ways.
static int build_blackbox_adaptive_(eviction_set_t *es, void *victim,
                                    size_t target_ways, size_t region_bytes,
                                    size_t line_size, int randomize_order)
{
  if (!es || !victim || target_ways==0) return -1;

  // Allocate region; candidates pick ONE line per 4KiB page to reduce DTLB set noise.
  size_t pagesz = (size_t)sysconf(_SC_PAGESIZE);
  size_t align  = (pagesz > line_size ? pagesz : line_size);
  void *region  = NULL;
  if (posix_memalign(&region, align, region_bytes) != 0 || !region) return -1;

  size_t pages = region_bytes / pagesz;
  void **cand  = (void**)malloc(pages*sizeof(void*));
  if (!cand) { free(region); return -1; }

  // Choose a fixed offset within the page (e.g., 0) to avoid within-page alias noise.
  size_t cc = 0;
  for (size_t p=0; p<pages; ++p) {
    cand[cc++] = (void *)((uintptr_t)region + p*pagesz);
  }
  if (randomize_order) { srand((unsigned)time(NULL)); shuffle_ptrs_(cand, cc); }

  // Adaptive threshold from baseline noise; floor = 3 ticks
  uint64_t slow_thr = adaptive_threshold_(victim, /*samples=*/41, /*floor=*/3);

  // Phase 1: grow
  void **work = (void**)malloc(cc*sizeof(void*));
  if (!work) { free(cand); free(region); return -1; }
  size_t wn = 0;
  int prime_rounds = 4; // stronger pressure than single pass
  for (size_t i=0;i<cc;i++) {
    work[wn++] = cand[i];
    if (wn >= target_ways) {
      if (set_evicts_(work, wn, victim, slow_thr, /*trials=*/9, prime_rounds)) {
        break;
      }
    }
  }
  if (wn < target_ways) {
    // try once with all candidates; if still no, give up
    if (!set_evicts_(work, wn, victim, slow_thr, 13, prime_rounds)) {
      free(work); free(cand); free(region); return -1;
    }
  }

  // Phase 2: prune by halves, then by singles
  for (;;) {
    if (wn <= target_ways) break;

    // Try removing a half-chunk; if still evicts, keep the removal.
    size_t chunk = wn/2;
    void **tmp = (void**)malloc(wn*sizeof(void*));
    if (!tmp) break;

    int reduced = 0;
    for (size_t start=0; start+chunk<=wn; start+=chunk) {
      size_t tn = 0;
      for (size_t k=0;k<wn;k++) if (k<start || k>=start+chunk) tmp[tn++] = work[k];
      if (tn >= target_ways &&
          set_evicts_(tmp, tn, victim, slow_thr, 9, prime_rounds))
      {
        // commit removal
        memcpy(work, tmp, tn*sizeof(void*));
        wn = tn;
        reduced = 1;
        break;
      }
    }
    free(tmp);
    if (!reduced) break;
  }

  // Individual pruning to get close to target_ways
  for (size_t i=0; wn>target_ways && i<wn; ) {
    void *save = work[i];
    memmove(&work[i], &work[i+1], (wn-(i+1))*sizeof(void*));
    if (set_evicts_(work, wn-1, victim, slow_thr, 9, prime_rounds)) {
      --wn; // removal kept eviction
    } else {
      // restore
      memmove(&work[i+1], &work[i], (wn-(i))*sizeof(void*));
      work[i] = save;
      ++i;
    }
  }

  if (wn == 0) { free(work); free(cand); free(region); return -1; }

  // Build a pointer-chase list from the final work[] set
  for (size_t i=0;i<wn;i++) {
    *(void**)work[i] = (i+1<wn) ? work[i+1] : NULL;
  }

  es->lines        = (void**)malloc(wn*sizeof(void*));
  if (!es->lines) { free(work); free(cand); free(region); return -1; }
  for (size_t i=0;i<wn;i++) es->lines[i] = work[i];
  es->nlines       = wn;
  es->region       = region;
  es->region_bytes = region_bytes;
  es->head         = work[0];

  free(work);
  free(cand);
  return 0;
}

// Public wrappers for L2/L3 (tuned defaults)
int evset_build_l2_auto_v2(eviction_set_t *es, void *victim_addr,
                           size_t target_ways, size_t region_bytes)
{
  if (region_bytes == 0) region_bytes = (size_t)(32u<<20); // 32 MiB pool
  if (target_ways == 0)  target_ways  = 16;               // oversubscribe
  return build_blackbox_adaptive_(es, victim_addr, target_ways, region_bytes,
                                  CACHE_LINE_SIZE, /*randomize=*/1);
}
int evset_build_l3_auto_v2(eviction_set_t *es, void *victim_addr,
                           size_t target_ways, size_t region_bytes)
{
  if (region_bytes == 0) region_bytes = (size_t)(128u<<20); // 128 MiB pool
  if (target_ways == 0)  target_ways  = 32;                 // oversubscribe
  return build_blackbox_adaptive_(es, victim_addr, target_ways, region_bytes,
                                  CACHE_LINE_SIZE, /*randomize=*/1);
}

int evset_build_for_vaddr(eviction_set_t *es,
                          void *victim_addr,
                          size_t nlines,
                          size_t region_bytes,
                          size_t line_size,
                          size_t sets,
                          bool   randomize_order)
{
  if (!es || !victim_addr || nlines == 0) return -1;

  // Allocate a big region; line-align it for clean indexing.
  void *region = NULL;
  size_t align = line_size > (size_t)sysconf(_SC_PAGESIZE) ? line_size : (size_t)sysconf(_SC_PAGESIZE);
  if (posix_memalign(&region, align, region_bytes) != 0 || !region) {
    return -1;
  }

  // Collect all addresses in 'region' that share the same set index as victim_addr.
  uintptr_t vaddr = (uintptr_t)victim_addr;
  size_t v_idx = cache_index_for(vaddr, line_size, sets);

  size_t max_cands = region_bytes / line_size;
  void **cands = (void **)malloc(max_cands * sizeof(void *));
  if (!cands) { free(region); return -1; }

  size_t cc = 0;
  for (size_t off = 0; off + line_size <= region_bytes; off += line_size) {
    void *cand = (void *)((uintptr_t)region + off);
    if (cache_index_for((uintptr_t)cand, line_size, sets) == v_idx) {
      cands[cc++] = cand;
    }
  }

  if (cc < nlines) {
    free(cands);
    free(region);
    return -1; // not enough congruent lines in region; grow region_bytes or lower nlines
  }

  // Optionally randomize to defeat stride/prefetch quirks.
  if (randomize_order) {
    srand((unsigned)time(NULL));
    shuffle_ptrs_(cands, cc);
  }

  // Take the first nlines and build a NULL-terminated pointer-chase list.
  // Each selected cache line stores the *next* node pointer at its first word.
  for (size_t i = 0; i < nlines; ++i) {
    void **node = (void **)cands[i];
    void *next = (i + 1 < nlines) ? cands[i + 1] : NULL;
    *node = next;
  }

  // Fill out struct
  es->lines = (void **)malloc(nlines * sizeof(void *));
  if (!es->lines) {
    free(cands);
    free(region);
    return -1;
  }
  for (size_t i = 0; i < nlines; ++i) es->lines[i] = cands[i];
  es->nlines       = nlines;
  es->region       = region;
  es->region_bytes = region_bytes;
  es->head         = (nlines ? cands[0] : NULL);

  free(cands);
  return 0;
}

int evset_build_l1_default(eviction_set_t *es,
                           void *victim_addr,
                           size_t nlines,
                           bool   randomize_order)
{
  // Reasonable defaults for L1D on Apple Silicon/macOS:
  const size_t line = CACHE_LINE_SIZE; // 64
  const size_t sets = L1D_SETS;        // 128
  // 4 MiB region usually yields many congruent candidates.
  const size_t region = 4u << 20;      // 4 MiB
  return evset_build_for_vaddr(es, victim_addr, nlines, region, line, sets, randomize_order);
}






// Estimate a "hit" baseline (ticks) and choose a threshold multiplier.
static uint64_t estimate_hit_threshold(void *victim, int samples, double mult) {
  if (samples < 5) samples = 5;
  uint64_t *vals = (uint64_t*)malloc((size_t)samples * sizeof(uint64_t));
  for (int i = 0; i < samples; ++i) {
    // Ensure it's hot, then measure
    volatile uint8_t tmp = *(volatile uint8_t*)victim; (void)tmp;
    vals[i] = timer_time_maccess(victim); // ticks delta (safe)
  }
  uint64_t med = median_u64_(vals, samples);
  free(vals);
  // threshold = baseline * multiplier (tune as needed per level)
  return (uint64_t)ceil((double)med * mult);
}

// Prime: touch every candidate once (order matters a bit; we already randomized).
static inline void prime_list(void **nodes, size_t n) {
  for (size_t i = 0; i < n; ++i) {
    volatile uint8_t junk = *(volatile uint8_t*)nodes[i]; (void)junk;
  }
}

// Measure victim after priming candidate set, return min of few trials (de-noise).
static uint64_t measure_after_prime(void **nodes, size_t n, void *victim, int trials) {
  if (trials < 1) trials = 1;
  uint64_t best = UINT64_MAX;
  for (int t = 0; t < trials; ++t) {
    prime_list(nodes, n);
    uint64_t dt = timer_time_maccess(victim);
    if (dt < best) best = dt;
  }
  return best;
}

// Test if set 'S' evicts victim beyond threshold (majority voting across trials).
static int set_evicts(void **nodes, size_t n, void *victim,
                      uint64_t hit_thresh, int trials) {
  int votes = 0, need = (trials+1)/2;
  for (int i = 0; i < trials; ++i) {
    prime_list(nodes, n);
    uint64_t dt = timer_time_maccess(victim);
    votes += (dt > hit_thresh);
    if (votes >= need) return 1;
  }
  return 0;
}



// Greedy grow then prune:
//  1) add addresses until we start evicting;
//  2) prune by trying to remove chunks/individuals while still evicting.
static int build_evset_blackbox(eviction_set_t *es, void *victim,
                                size_t target_ways,
                                size_t region_bytes,
                                size_t line_size,
                                int max_trials,
                                int prune_passes,
                                int randomize_order)
{
  if (!es || !victim || target_ways == 0) return -1;
  if (line_size == 0) line_size = CACHE_LINE_SIZE;
  if (max_trials <= 0) max_trials = 25;
  if (prune_passes < 0) prune_passes = 2;

  // Allocate region and create candidate array (one address per cache line).
  void *region = NULL;
  size_t pagesize = (size_t)sysconf(_SC_PAGESIZE);
  size_t align = (line_size > pagesize ? line_size : pagesize);
  if (posix_memalign(&region, align, region_bytes) != 0 || !region) return -1;

  size_t max_cands = region_bytes / line_size;
  void **cand = (void**)malloc(max_cands * sizeof(void*));
  if (!cand) { free(region); return -1; }

  // Fill candidates, avoid the victim's line if victim happens to be inside our region
  size_t cc = 0;
  uintptr_t region_base = (uintptr_t)region;
  for (size_t off = 0; off + line_size <= region_bytes; off += line_size) {
    cand[cc++] = (void *)(region_base + off);
  }
  if (randomize_order) {
    srand((unsigned)time(NULL));
    shuffle_ptrs_(cand, cc);
  }

  // Conservative hit threshold (L2/L3 miss is >> hit).
  // L2 tends to be ~2-3x L1-hit in ticks; L3 even more. Start with 1.8x.
  uint64_t hit_thresh = estimate_hit_threshold(victim, /*samples=*/25, /*mult=*/1.8);

  // Phase 1: grow until we get evictions
  void **work = (void**)malloc(cc * sizeof(void*));
  size_t wn = 0;
  int evicting = 0;
  for (size_t i = 0; i < cc; ++i) {
    work[wn++] = cand[i];
    // Try only every few adds to amortize measurement cost:
    if (wn >= target_ways && (i % 2 == 0)) {
      if (set_evicts(work, wn, victim, hit_thresh, /*trials=*/max_trials/2))
      { evicting = 1; break; }
    }
  }
  if (!evicting) {
    // Last-chance check with all candidates (can be big; ok once)
    if (!set_evicts(work, wn, victim, hit_thresh, /*trials=*/max_trials)) {
      free(work); free(cand); free(region); return -1; // failed to find any signal
    }
  }

  // Phase 2: prune by chunks, then by individual addresses
  for (int pass = 0; pass < prune_passes; ++pass) {
    // Chunk pruning
    size_t chunk = (wn > 2*target_ways ? (wn / 4) : (wn / 2));
    if (chunk < 1) chunk = 1;

    size_t i = 0;
    while (wn > target_ways && i < wn) {
      size_t take = (chunk < (wn - i) ? chunk : (wn - i));
      // Try removing [i, i+take)
      size_t newn = wn - take;
      // Move the tail over the removed chunk (in-place)
      memmove(&work[i], &work[i+take], (wn - (i+take)) * sizeof(void*));

      if (set_evicts(work, newn, victim, hit_thresh, /*trials=*/max_trials)) {
        wn = newn; // removal kept eviction; commit
      } else {
        // undo removal: move elements back
        memmove(&work[i+take], &work[i], (wn - (i+take)) * sizeof(void*));
        // restore original chunk where it was
        memmove(&work[i], &work[wn - take], take * sizeof(void*));
        i += take; // skip this chunk
      }
    }

    // Individual pruning
    i = 0;
    while (wn > target_ways && i < wn) {
      void *save = work[i];
      memmove(&work[i], &work[i+1], (wn - (i+1)) * sizeof(void*));
      if (set_evicts(work, wn-1, victim, hit_thresh, /*trials=*/max_trials)) {
        --wn; // kept eviction without this element
      } else {
        // restore
        memmove(&work[i+1], &work[i], (wn - (i)) * sizeof(void*));
        work[i] = save;
        ++i;
      }
    }
  }

  // Final minimality sweep (optional, try to remove stragglers)
  for (size_t i = 0; wn > target_ways && i < wn; ) {
    void *save = work[i];
    memmove(&work[i], &work[i+1], (wn - (i+1)) * sizeof(void*));
    if (set_evicts(work, wn-1, victim, hit_thresh, /*trials=*/max_trials)) {
      --wn;
    } else {
      // restore
      memmove(&work[i+1], &work[i], (wn - (i)) * sizeof(void*));
      work[i] = save;
      ++i;
    }
  }

  if (wn == 0) { free(work); free(cand); free(region); return -1; }

  // Build pointer-chase (each line's first word points to next; last -> NULL)
  for (size_t i = 0; i < wn; ++i) {
    *(void**)work[i] = (i+1 < wn) ? work[i+1] : NULL;
  }

  // Fill the struct
  es->lines        = (void**)malloc(wn * sizeof(void*));
  if (!es->lines) { free(work); free(cand); free(region); return -1; }
  for (size_t i = 0; i < wn; ++i) es->lines[i] = work[i];
  es->nlines       = wn;
  es->region       = region;
  es->region_bytes = region_bytes;
  es->head         = work[0];

  free(work);
  free(cand);
  return 0;
}

// Public entry points
int evset_build_level_auto(eviction_set_t *es, void *victim_addr,
                           size_t target_ways, size_t region_bytes,
                           size_t line_size, int max_trials,
                           int prune_passes, int randomize_order)
{
  return build_evset_blackbox(es, victim_addr, target_ways, region_bytes,
                              line_size, max_trials, prune_passes, randomize_order);
}

int evset_build_l2_auto(eviction_set_t *es, void *victim_addr,
                        size_t target_ways, size_t region_bytes)
{
  if (region_bytes == 0) region_bytes = (size_t)(16u << 20); // 16 MiB pool
  if (target_ways == 0)  target_ways  = 8;                   // typical ballpark
  return build_evset_blackbox(es, victim_addr, target_ways,
                              region_bytes, CACHE_LINE_SIZE,
                              /*max_trials=*/25, /*prune_passes=*/3,
                              /*randomize=*/1);
}

int evset_build_l3_auto(eviction_set_t *es, void *victim_addr,
                        size_t target_ways, size_t region_bytes)
{
  if (region_bytes == 0) region_bytes = (size_t)(64u << 20); // 64 MiB pool
  if (target_ways == 0)  target_ways  = 16;                  // ballpark for SLC
  return build_evset_blackbox(es, victim_addr, target_ways,
                              region_bytes, CACHE_LINE_SIZE,
                              /*max_trials=*/35, /*prune_passes=*/4,
                              /*randomize=*/1);
}

void evset_free(eviction_set_t *es) {
  if (!es) return;
  if (es->region) free(es->region);
  if (es->lines)  free(es->lines);
  es->region = NULL;
  es->lines = NULL;
  es->head = NULL;
  es->nlines = 0;
  es->region_bytes = 0;
}

uint8_t evset_traverse_once(const eviction_set_t *es) {
  if (!es || !es->head) return 0;
  volatile void *it = es->head;
  uint8_t acc = 0;
  // Walk: it = *(void **)it; stop on NULL
  while (it) {
    acc ^= *(volatile uint8_t *)it; // consume a byte to keep the access "used"
    it = *(volatile void * volatile *)it;
  }
  return acc;
}


static int evset_ptr_in_region(const eviction_set_t *es, const void *p) {
    if (!es || !es->region || es->region_bytes == 0) return 0;
    uintptr_t base = (uintptr_t)es->region;
    uintptr_t end  = base + es->region_bytes;
    uintptr_t q    = (uintptr_t)p;
    return (q >= base) && (q + sizeof(void*) <= end);
}

static ssize_t evset_index_of_line(const eviction_set_t *es, const void *p) {
    if (!es || !es->lines) return -1;
    for (size_t i = 0; i < es->nlines; ++i)
        if (es->lines[i] == p) return (ssize_t)i;
    return -1;
}

void evset_dump(const eviction_set_t *es) {
    printf("=== Eviction Set ===\n");
    if (!es) { printf("  (null)\n"); return; }

    printf("  nlines      : %zu\n", es->nlines);
    printf("  region      : %p (size: %zu bytes)\n", es->region, es->region_bytes);
    printf("  head        : %p\n", es->head);
    printf("  lines array : %s\n", es->lines ? "present" : "(null)");

    if (es->lines && es->nlines) {
        for (size_t i = 0; i < es->nlines; ++i) {
            uintptr_t off = es->region
                ? ((uintptr_t)es->lines[i] - (uintptr_t)es->region)
                : 0;
            printf("    lines[%zu] = %p", i, es->lines[i]);
            if (es->region) printf("  (+0x%zx)", (size_t)off);
            printf("\n");
        }
    }

    // Traverse the pointer-chase list starting at head.
    // We stop if:
    //  - pointer leaves the region
    //  - we detect a loop
    //  - we exceed nlines + 2 hops (safety)
    printf("  chase order :\n");
    if (!es->head) {
        printf("    (empty)\n");
        return;
    }

    void *it = es->head;
    size_t hops = 0;
    // simple visited detection: we reuse lines[] indices if available
    // and also cap hops to nlines+2 to be extra safe.
    while (it && hops < es->nlines + 2) {
        // Print node
        ssize_t idx = evset_index_of_line(es, it);
        uintptr_t off = es->region ? ((uintptr_t)it - (uintptr_t)es->region) : 0;
        printf("    hop[%zu]: %p", hops, it);
        if (es->region) printf("  (+0x%zx)", (size_t)off);
        if (idx >= 0)    printf("  (lines[%zd])", idx);
        printf("\n");

        // Safety: only dereference next if current node is within region
        if (!evset_ptr_in_region(es, it)) {
            printf("    -> stop: node is outside region\n");
            break;
        }

        void *next = *(void **)it;

        // Loop detection: if next equals any earlier node or we've hopped too much
        if (next && evset_index_of_line(es, next) < 0 && !evset_ptr_in_region(es, next)) {
            printf("    -> stop: next pointer %p is not a region line\n", next);
            break;
        }

        it = next;
        ++hops;
    }

    if (it && hops >= es->nlines + 2) {
        printf("    -> stop: safety cap (possible cycle)\n");
    }
    printf("====================\n");
}

void timer_shutdown(void) {
  atomic_store_explicit(&g_stop, 1, memory_order_relaxed);
  pthread_join(g_thr, NULL);
}
