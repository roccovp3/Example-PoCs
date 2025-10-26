// timer.c — two-thread timer + eviction set builders (Apple Silicon friendly)

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
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <errno.h>
#include <math.h>

/* ===================== Timer (two-thread) ===================== */

static _Atomic uint64_t g_counter = 0;
static _Atomic int      g_stop    = 0;
static pthread_t        g_thr;
static mach_timebase_info_data_t g_tb;
static double           g_ticks_per_ns = 0.0;  /* ticks / ns */

static void* timer_thread_fn(void* arg) {
#ifdef QOS_CLASS_USER_INTERACTIVE
  pthread_set_qos_class_self_np(QOS_CLASS_USER_INTERACTIVE, 0);
#endif
  while (!atomic_load_explicit(&g_stop, memory_order_relaxed)) {
    atomic_fetch_add_explicit(&g_counter, 1, memory_order_relaxed);
  }
  return NULL;
}

static void set_affinity_tag(pthread_t th, int tag) {
  thread_port_t mth = pthread_mach_thread_np(th);
  thread_affinity_policy_data_t pol = { .affinity_tag = tag };
  (void)thread_policy_set(mth, THREAD_AFFINITY_POLICY,
                          (thread_policy_t)&pol, THREAD_AFFINITY_POLICY_COUNT);
}

static inline uint64_t abs_to_ns(uint64_t t_abs) {
  return (t_abs * g_tb.numer) / g_tb.denom;
}
static inline uint64_t ns_to_abs(uint64_t ns) {
  return (ns * g_tb.denom) / g_tb.numer;
}

static double calibrate_ticks_per_ns(double seconds) {
  uint64_t start  = atomic_load_explicit(&g_counter, memory_order_relaxed);
  uint64_t t0     = mach_continuous_time();
  uint64_t budget = ns_to_abs((uint64_t)(seconds * 1e9));
  while (mach_continuous_time() - t0 < budget) { /* spin */ }
  uint64_t end = atomic_load_explicit(&g_counter, memory_order_relaxed);
  uint64_t t1  = mach_continuous_time();
  uint64_t ns  = abs_to_ns(t1 - t0);
  if (ns == 0) ns = 1;
  return (double)(end - start) / (double)ns;
}

int timer_init(bool use_affinity, double calib_seconds) {
  mach_timebase_info(&g_tb);
  atomic_store_explicit(&g_counter, 0, memory_order_relaxed);
  atomic_store_explicit(&g_stop, 0, memory_order_relaxed);

  if (use_affinity) set_affinity_tag(pthread_self(), 1);

  if (pthread_create(&g_thr, NULL, timer_thread_fn, NULL) != 0) {
    perror("pthread_create");
    return -1;
  }
  if (use_affinity) set_affinity_tag(g_thr, 1);

  struct timespec ts = { .tv_sec = 0, .tv_nsec = 5 * 1000 * 1000 };
  nanosleep(&ts, NULL);

  g_ticks_per_ns = calibrate_ticks_per_ns(calib_seconds > 0.0 ? calib_seconds : 0.3);
  if (g_ticks_per_ns <= 0.0) g_ticks_per_ns = 1.0; /* fail-safe */
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
  volatile unsigned char tmp = *(volatile unsigned char *)ptr; (void)tmp;
  ISB();
  uint64_t t1 = timer_now();
  ISB();
  return t1 - t0;
}

void timer_shutdown(void) {
  atomic_store_explicit(&g_stop, 1, memory_order_relaxed);
  pthread_join(g_thr, NULL);
}

/* ===================== Small utilities ===================== */

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

#ifndef CACHE_LINE_SIZE
#  define CACHE_LINE_SIZE 128
#endif
#ifndef L1D_SETS
#  define L1D_SETS 64    
#endif

static inline size_t cache_index_for(uintptr_t addr, size_t line_size, size_t sets) {
  return (addr / line_size) % sets;
}

/* Fisher–Yates shuffle */
static void shuffle_ptrs_(void **a, size_t n) {
  for (size_t i = n; i > 1; --i) {
    size_t j = (size_t)(rand() % i);
    void *t = a[i-1]; a[i-1] = a[j]; a[j] = t;
  }
}

/* ===================== Eviction set utilities ===================== */
// ---------------- Evset utilities: shuffle, rounds, and composed eviction ----------------
#include <time.h>

#ifndef CACHE_LINE_SIZE
#  define CACHE_LINE_SIZE 64
#endif

static void shuffle_ptrs_local(void **a, size_t n) {
  if (!a || n < 2) return;
  srand((unsigned)time(NULL) ^ (unsigned)(uintptr_t)a);
  for (size_t i = n; i > 1; --i) {
    size_t j = (size_t)(rand() % i);
    void *t = a[i-1]; a[i-1] = a[j]; a[j] = t;
  }
}

void evset_shuffle(eviction_set_t *es) {
  if (!es || !es->lines || es->nlines == 0) return;
  shuffle_ptrs_local(es->lines, es->nlines);
  // rebuild pointer-chase
  for (size_t i = 0; i < es->nlines; ++i) {
    *(void**)es->lines[i] = (i + 1 < es->nlines) ? es->lines[i+1] : NULL;
  }
  es->head = es->lines[0];
}

void evset_evict_rounds(const eviction_set_t *es, int rounds) {
  if (!es || !es->head || rounds <= 0) return;
  volatile uint8_t sink = 0;
  for (int r = 0; r < rounds; ++r) {
    sink ^= evset_traverse_once(es);
  }
  (void)sink;
}

// Compose top→down: do L3, then L2, then L1. Optionally reshuffle before each stage.
void evset_evict_chain(const eviction_set_t *l3, int r3,
                       const eviction_set_t *l2, int r2,
                       const eviction_set_t *l1, int r1,
                       int reshuffle_every)
{
  // Cast away const only for optional shuffle; traversal itself is const-safe.
  if (l3 && l3->head) {
    if (reshuffle_every) evset_shuffle((eviction_set_t*)l3);
    evset_evict_rounds(l3, r3);
  }
  if (l2 && l2->head) {
    if (reshuffle_every) evset_shuffle((eviction_set_t*)l2);
    evset_evict_rounds(l2, r2);
  }
  if (l1 && l1->head) {
    if (reshuffle_every) evset_shuffle((eviction_set_t*)l1);
    evset_evict_rounds(l1, r1);
  }
}

// -------------- Validation with proper composition for “level” semantics ---------------
static int cmp_u64_v(const void *a, const void *b) {
  const uint64_t x = *(const uint64_t*)a, y = *(const uint64_t*)b;
  return (x>y) - (x<y);
}
static uint64_t median_u64_v(uint64_t *v, int n) {
  qsort(v, (size_t)n, sizeof(uint64_t), cmp_u64_v);
  return v[n/2];
}

int evset_validate_level(const eviction_set_t *level,
                         void *victim,
                         const eviction_set_t *below1,
                         const eviction_set_t *below2,
                         int rounds_level,
                         int rounds_below,
                         int reps,
                         double min_ratio)
{
  if (!victim || !level || !level->head || reps < 11) return 0;
  if (rounds_level <= 0) rounds_level = 256;
  if (rounds_below <= 0) rounds_below = 256;
  if (min_ratio < 1.05) min_ratio = 1.05;

  uint64_t *vals_base = (uint64_t*)malloc((size_t)reps * sizeof(uint64_t));
  uint64_t *vals_slow = (uint64_t*)malloc((size_t)reps * sizeof(uint64_t));
  if (!vals_base || !vals_slow) { free(vals_base); free(vals_slow); return 0; }

  // Baseline for this "level":
  //   L2 validation: evict L1 (below1=l1), then measure
  //   L3 validation: evict L2 then L1 (below1=l2, below2=l1), then measure
  for (int i=0;i<reps;i++) {
    volatile uint8_t w = *(volatile uint8_t*)victim; (void)w;
    evset_evict_chain(NULL, 0, below1, rounds_below, below2, rounds_below, /*reshuffle=*/1);
    vals_base[i] = timer_time_maccess(victim);
  }

  // Slow case for this "level":
  //   Apply 'level' first, then evict the below* sets, then measure.
  for (int i=0;i<reps;i++) {
    volatile uint8_t w = *(volatile uint8_t*)victim; (void)w;
    evset_evict_chain(level, rounds_level, below1, rounds_below, below2, rounds_below, /*reshuffle=*/1);
    vals_slow[i] = timer_time_maccess(victim);
  }

  uint64_t m_base = median_u64_v(vals_base, reps);
  uint64_t m_slow = median_u64_v(vals_slow, reps);

  free(vals_base); free(vals_slow);

  // accept if slow >= min_ratio * base (integer math)
  // m_slow * 100 >= m_base * (int)(min_ratio*100)
  int thr = (int)(min_ratio * 100.0 + 0.5);
  return ((long long)m_slow * 100LL) >= ((long long)m_base * thr);
}


uint8_t evset_traverse_once(const eviction_set_t *es) {
  if (!es || !es->head) return 0;
  volatile void *it = es->head;
  uint8_t acc = 0;
  while (it) {
    acc ^= *(volatile uint8_t *)it;
    it   = *(volatile void * volatile *)it;
  }
  return acc;
}

// void evset_evict_rounds(const eviction_set_t *es, int rounds) {
//   if (!es || !es->head) return;
//   volatile uint8_t sink = 0;
//   for (int r=0;r<rounds;r++) sink ^= evset_traverse_once(es);
//   (void)sink;
// }

void evset_free(eviction_set_t *es) {
  if (!es) return;
  if (es->region) free(es->region);
  if (es->lines)  free(es->lines);
  es->region = NULL;
  es->lines  = NULL;
  es->head   = NULL;
  es->nlines = 0;
  es->region_bytes = 0;
}

static int evset_ptr_in_region_(const eviction_set_t *es, const void *p) {
  if (!es || !es->region || es->region_bytes == 0) return 0;
  uintptr_t base = (uintptr_t)es->region;
  uintptr_t end  = base + es->region_bytes;
  uintptr_t q    = (uintptr_t)p;
  return (q >= base) && (q + sizeof(void*) <= end);
}
static ssize_t evset_index_of_line_(const eviction_set_t *es, const void *p) {
  if (!es || !es->lines) return -1;
  for (size_t i = 0; i < es->nlines; ++i) if (es->lines[i] == p) return (ssize_t)i;
  return -1;
}
void evset_dump(const eviction_set_t *es) {
  printf("=== Eviction Set ===\n");
  if (!es) { printf("  (null)\n"); return; }
  printf("  nlines      : %zu\n", es->nlines);
  printf("  region      : %p (size: %zu bytes)\n", es->region, es->region_bytes);
  printf("  head        : %p\n", es->head);
  if (es->lines && es->nlines) {
    for (size_t i=0;i<es->nlines;i++) {
      uintptr_t off = es->region ? ((uintptr_t)es->lines[i] - (uintptr_t)es->region) : 0;
      printf("    lines[%zu] = %p (+0x%zx)\n", i, es->lines[i], (size_t)off);
    }
  }
  printf("  chase order:\n");
  if (!es->head) { printf("    (empty)\n"); return; }
  void *it = es->head;
  size_t hops = 0;
  while (it && hops < es->nlines + 2) {
    ssize_t idx = evset_index_of_line_(es, it);
    uintptr_t off = es->region ? ((uintptr_t)it - (uintptr_t)es->region) : 0;
    printf("    hop[%zu]: %p (+0x%zx)%s\n", hops, it, (size_t)off, (idx>=0? " [in lines]": ""));
    if (!evset_ptr_in_region_(es, it)) { printf("    -> stop: outside region\n"); break; }
    void *next = *(void **)it;
    if (next && evset_index_of_line_(es, next) < 0 && !evset_ptr_in_region_(es, next)) {
      printf("    -> stop: next pointer %p is not a region line\n", next);
      break;
    }
    it = next; ++hops;
  }
  if (it && hops >= es->nlines + 2) printf("    -> stop: safety cap (possible cycle)\n");
  printf("====================\n");
}

/* ===================== L1 builders ===================== */

int evset_build_for_vaddr(eviction_set_t *es,
                          void *victim_addr,
                          size_t nlines, size_t region_bytes,
                          size_t line_size, size_t sets,
                          bool randomize_order)
{
  if (!es || !victim_addr || nlines == 0) return -1;

  size_t pagesz = (size_t)sysconf(_SC_PAGESIZE);
  size_t align  = (line_size > pagesz ? line_size : pagesz);

  void *region = NULL;
  if (posix_memalign(&region, align, region_bytes) != 0 || !region) return -1;

  uintptr_t vaddr = (uintptr_t)victim_addr;
  size_t    v_idx = cache_index_for(vaddr, line_size, sets);

  size_t max_c = region_bytes / line_size;
  void **cand  = (void**)malloc(max_c * sizeof(void*));
  if (!cand) { free(region); return -1; }

  size_t cc = 0;
  for (size_t off = 0; off + line_size <= region_bytes; off += line_size) {
    void *p = (void *)((uintptr_t)region + off);
    if (cache_index_for((uintptr_t)p, line_size, sets) == v_idx) cand[cc++] = p;
  }
  if (cc < nlines) { free(cand); free(region); return -1; }

  if (randomize_order) { srand((unsigned)time(NULL)); shuffle_ptrs_(cand, cc); }

  for (size_t i=0;i<nlines;i++) *(void**)cand[i] = (i+1<nlines) ? cand[i+1] : NULL;

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

int evset_build_l1_default(eviction_set_t *es,
                           void *victim_addr,
                           size_t nlines,
                           bool   randomize_order)
{
  return evset_build_for_vaddr(es, victim_addr,
                               nlines, /*region=*/4u<<20,
                               /*line=*/CACHE_LINE_SIZE, /*sets=*/L1D_SETS,
                               randomize_order);
}

int evset_build_l1_strict(eviction_set_t *es, void *victim_addr,
                          size_t nlines, size_t region_bytes, bool randomize_order)
{
  /* Strict is a thin wrapper around for_vaddr with typical L1 params,
   * just with a separate entry point to make intent explicit. */
  return evset_build_for_vaddr(es, victim_addr,
                               nlines, region_bytes,
                               /*line=*/CACHE_LINE_SIZE, /*sets=*/L1D_SETS,
                               randomize_order);
}

/* ===================== Adaptive black-box (L2/L3) ===================== */

static uint64_t adaptive_threshold_(void *victim, int samples, uint64_t floor_ticks) {
  if (samples < 31) samples = 31;
  uint64_t *vals = (uint64_t*)malloc((size_t)samples*sizeof(uint64_t));
  for (int i=0;i<samples;i++) {
    volatile uint8_t w = *(volatile uint8_t*)victim; (void)w; /* warm */
    vals[i] = timer_time_maccess(victim);
  }
  uint64_t med = median_u64_(vals, samples);
  uint64_t *tmp = (uint64_t*)malloc((size_t)samples*sizeof(uint64_t));
  memcpy(tmp, vals, (size_t)samples*sizeof(uint64_t));
  uint64_t mad = mad_u64_(tmp, samples, med);
  free(tmp); free(vals);

  uint64_t thr = med + 3*mad;
  if (thr < med + floor_ticks) thr = med + floor_ticks;
  return thr;
}

static uint64_t measure_after_prime_(void **nodes, size_t n, void *victim, int prime_rounds) {
  volatile uint8_t warm = *(volatile uint8_t*)victim; (void)warm;
  for (int r=0;r<prime_rounds;r++) {
    for (size_t i=0;i<n;i++) { volatile uint8_t x = *(volatile uint8_t*)nodes[i]; (void)x; }
  }
  ISB();
  return timer_time_maccess(victim);
}

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

static int build_blackbox_adaptive_(eviction_set_t *es, void *victim,
                                    size_t target_ways, size_t region_bytes,
                                    size_t line_size, int randomize_order)
{
  if (!es || !victim || target_ways == 0) return -1;

  size_t pagesz = (size_t)sysconf(_SC_PAGESIZE);
  size_t align  = (pagesz > line_size ? pagesz : line_size);

  void *region = NULL;
  if (posix_memalign(&region, align, region_bytes) != 0 || !region) return -1;

  size_t pages = region_bytes / pagesz;
  void **cand  = (void**)malloc(pages*sizeof(void*));
  if (!cand) { free(region); return -1; }

  size_t cc = 0;
  for (size_t p=0; p<pages; ++p) cand[cc++] = (void *)((uintptr_t)region + p*pagesz);

  if (randomize_order) { srand((unsigned)time(NULL)); shuffle_ptrs_(cand, cc); }

  uint64_t slow_thr = adaptive_threshold_(victim, /*samples=*/41, /*floor=*/3);

  void **work = (void**)malloc(cc*sizeof(void*));
  if (!work) { free(cand); free(region); return -1; }
  size_t wn = 0;
  int prime_rounds = 4;

  /* Grow until it starts to evict */
  for (size_t i=0;i<cc;i++) {
    work[wn++] = cand[i];
    if (wn >= target_ways) {
      if (set_evicts_(work, wn, victim, slow_thr, /*trials=*/9, prime_rounds)) break;
    }
  }
  if (wn < target_ways) {
    if (!set_evicts_(work, wn, victim, slow_thr, 13, prime_rounds)) {
      free(work); free(cand); free(region); return -1;
    }
  }

  /* Prune by halves, then singles */
  for (;;) {
    if (wn <= target_ways) break;
    size_t chunk = wn/2;
    if (chunk < 1) chunk = 1;
    void **tmp = (void**)malloc(wn*sizeof(void*));
    if (!tmp) break;
    int reduced = 0;
    for (size_t start=0; start+chunk<=wn; start+=chunk) {
      size_t tn = 0;
      for (size_t k=0;k<wn;k++) if (k<start || k>=start+chunk) tmp[tn++] = work[k];
      if (tn >= target_ways && set_evicts_(tmp, tn, victim, slow_thr, 9, prime_rounds)) {
        memcpy(work, tmp, tn*sizeof(void*)); wn = tn; reduced = 1; break;
      }
    }
    free(tmp);
    if (!reduced) break;
  }

  for (size_t i=0; wn>target_ways && i<wn; ) {
    void *save = work[i];
    memmove(&work[i], &work[i+1], (wn-(i+1))*sizeof(void*));
    if (set_evicts_(work, wn-1, victim, slow_thr, 9, prime_rounds)) { --wn; }
    else { memmove(&work[i+1], &work[i], (wn-(i))*sizeof(void*)); work[i] = save; ++i; }
  }

  if (wn == 0) { free(work); free(cand); free(region); return -1; }

  for (size_t i=0;i<wn;i++) *(void**)work[i] = (i+1<wn) ? work[i+1] : NULL;

  es->lines        = (void**)malloc(wn*sizeof(void*));
  if (!es->lines) { free(work); free(cand); free(region); return -1; }
  for (size_t i=0;i<wn;i++) es->lines[i] = work[i];
  es->nlines       = wn;
  es->region       = region;
  es->region_bytes = region_bytes;
  es->head         = work[0];

  free(work); free(cand);
  return 0;
}

int evset_build_l2_auto_v2(eviction_set_t *es, void *victim_addr,
                           size_t target_ways, size_t region_bytes)
{
  if (region_bytes == 0) region_bytes = (size_t)(64u<<20);  // 64 MiB pool
  if (target_ways  == 0) target_ways  = 16;
#if defined(__APPLE__) && defined(__aarch64__)
  return build_blackbox_adaptive_(es, victim_addr, target_ways, region_bytes, 128, 1);
#else
  return build_blackbox_adaptive_(es, victim_addr, target_ways, region_bytes, CACHE_LINE_SIZE, 1);
#endif
}

int evset_build_l3_auto_v2(eviction_set_t *es, void *victim_addr,
                           size_t target_ways, size_t region_bytes)
{
  if (region_bytes == 0) region_bytes = (size_t)(256u<<20); // 256 MiB pool
  if (target_ways  == 0) target_ways  = 32;
#if defined(__APPLE__) && defined(__aarch64__)
  return build_blackbox_adaptive_(es, victim_addr, target_ways, region_bytes, 128, 1);
#else
  return build_blackbox_adaptive_(es, victim_addr, target_ways, region_bytes, CACHE_LINE_SIZE, 1);
#endif
}

/* ---- Legacy wrappers: keep exported but route to the adaptive builder ---- */
int evset_build_level_auto(eviction_set_t *es, void *victim_addr,
                           size_t target_ways, size_t region_bytes,
                           size_t line_size, int max_trials,
                           int prune_passes, int randomize_order)
{
  (void)max_trials; (void)prune_passes; (void)line_size; (void)randomize_order;
  if (line_size == 0) line_size = CACHE_LINE_SIZE;
  return build_blackbox_adaptive_(es, victim_addr, target_ways, region_bytes,
                                  line_size, /*randomize=*/1);
}

int evset_build_l2_auto(eviction_set_t *es, void *victim_addr,
                        size_t target_ways, size_t region_bytes)
{
  return evset_build_l2_auto_v2(es, victim_addr, target_ways, region_bytes);
}
int evset_build_l3_auto(eviction_set_t *es, void *victim_addr,
                        size_t target_ways, size_t region_bytes)
{
  return evset_build_l3_auto_v2(es, victim_addr, target_ways, region_bytes);
}




//Experiments

