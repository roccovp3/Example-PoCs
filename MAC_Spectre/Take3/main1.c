#include "timer.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <unistd.h>
#include <string.h>

/* ---------- ISB fence (optional) ---------- */
#if defined(__aarch64__)
  #define ISB() __asm__ __volatile__("isb" ::: "memory")
#elif defined(__x86_64__)
  #define ISB() __asm__ __volatile__("lfence" ::: "memory")
#else
  #define ISB() __asm__ __volatile__("" ::: "memory")
#endif

/* ---------- small utils ---------- */
static void *alloc_region(size_t bytes, size_t align, int touch_pages) {
    void *p = NULL;
    if (posix_memalign(&p, align, bytes) != 0) return NULL;
    if (touch_pages) {
        for (size_t i = 0; i < bytes; i += 4096) ((volatile uint8_t*)p)[i] = 0;
    }
    return p;
}
static int cmp_u64(const void *a, const void *b) {
    uint64_t x = *(const uint64_t*)a, y = *(const uint64_t*)b;
    return (x>y) - (x<y);
}
static uint64_t median_u64(uint64_t *v, int n) {
    qsort(v, (size_t)n, sizeof(uint64_t), cmp_u64);
    return v[n/2];
}

/* ---------- streaming evictors ---------- */
typedef struct {
    uint8_t *buf;
    size_t   bytes;
    size_t   stride;
    int      rounds;
} StreamCtx;

static void stream_walk(uint8_t *buf, size_t bytes, size_t stride) {
    volatile uint8_t s = 0;
    for (size_t i = 0; i < bytes; i += stride) s ^= buf[i];
    (void)s;
}
static void evict_stream_cb(void *ud) {
    StreamCtx *c = (StreamCtx*)ud;
    if (!c || !c->buf || c->bytes == 0) return;
    for (int r = 0; r < c->rounds; ++r) stream_walk(c->buf, c->bytes, c->stride);
}

/* Measure median latency (ticks) after optional eviction pass */
static uint64_t measure_after_eviction(void *victim,
                                       void (*evict_fn)(void *),
                                       void *evict_ud,
                                       int reps)
{
    if (reps < 9) reps = 9;
    uint64_t *vals = (uint64_t*)malloc((size_t)reps * sizeof(uint64_t));
    for (int i = 0; i < reps; ++i) {
        // Warm victim so it starts hot in upper levels.
        volatile uint8_t w = *(volatile uint8_t*)victim; (void)w;
        if (evict_fn) evict_fn(evict_ud);  // evict chosen level(s)
        ISB();                             // belt & suspenders; timer_time_maccess() fences inside
        vals[i] = timer_time_maccess(victim);
    }
    uint64_t med = median_u64(vals, reps);
    free(vals);
    return med;
}

int main(void) {
    /* 1) Timer */
    if (timer_init(true, 0.4) != 0) { perror("timer_init"); return 1; }

    /* 2) Victim we own (2 MiB region; pick a 64B-aligned address) */
    const size_t region_bytes = 2u << 20;
    uint8_t *region = (uint8_t*)alloc_region(region_bytes, 64, /*touch_pages=*/1);
    if (!region) { perror("alloc_region"); timer_shutdown(); return 1; }
    uint8_t *victim = region + 64 * 123;
    printf("victim_addr=%p\n", (void*)victim);

    /* 3) Allocate streaming buffers for level-specific eviction
          Tune sizes to your chip; these are safe defaults for Apple Silicon:
            - L1 trasher:   512 KiB  (≫ L1D, ≪ L2)
            - L2 trasher:    32 MiB  (≫ L2,  ≤ typical SLC/LLC)
            - LLC/DRAM:     128 MiB  (≫ SLC/LLC to force DRAM)
       Use stride=64 so each touch is a distinct cache line.
    */
   
    const size_t S_L1   = 1024u<<10;   // 512 KiB
    const size_t S_L2   = 32u<<20;    // 32 MiB
    const size_t S_LLC  = 128u<<20;   // 128 MiB
    const size_t STRIDE = 64;

    uint8_t *buf_l1  = (uint8_t*)alloc_region(S_L1,  64, /*touch=*/0);
    uint8_t *buf_l2  = (uint8_t*)alloc_region(S_L2,  64, /*touch=*/0);
    uint8_t *buf_llc = (uint8_t*)alloc_region(S_LLC, 64, /*touch=*/0);

    if (!buf_l1)  { fprintf(stderr, "warn: L1 trash buffer alloc failed\n"); }
    if (!buf_l2)  { fprintf(stderr, "warn: L2 trash buffer alloc failed (will fall back)\n"); }
    if (!buf_llc) { fprintf(stderr, "warn: LLC/DRAM trash buffer alloc failed (will fall back)\n"); }

    StreamCtx cL1  = { buf_l1,  S_L1,  STRIDE, /*rounds=*/2 };
    StreamCtx cL2  = { buf_l2,  S_L2,  STRIDE, /*rounds=*/2 };
    StreamCtx cLLC = { buf_llc, S_LLC, STRIDE, /*rounds=*/2 };

    /* 4) Measure medians */
    const int reps = 51;

    // L1 hit: no eviction
    uint64_t t_l1  = measure_after_eviction(victim, NULL, NULL, reps);

    // L2 hit: trash L1 only
    uint64_t t_l2  = measure_after_eviction(victim,
                         buf_l1 ? evict_stream_cb : NULL,
                         buf_l1 ? (void*)&cL1 : NULL, reps);

    // L3 hit: trash L2 (but not LLC). If L2 buffer missing, fall back to L1 trash (still useful).
    uint64_t t_l3  = measure_after_eviction(victim,
                         buf_l2 ? evict_stream_cb : (buf_l1 ? evict_stream_cb : NULL),
                         buf_l2 ? (void*)&cL2 : (buf_l1 ? (void*)&cL1 : NULL), reps);

    // DRAM: trash LLC
    uint64_t t_ram = measure_after_eviction(victim,
                         buf_llc ? evict_stream_cb : (buf_l2 ? evict_stream_cb : NULL),
                         buf_llc ? (void*)&cLLC : (buf_l2 ? (void*)&cL2 : NULL), reps);

    /* 5) Print (ticks + ns) */
    printf("\nLatency (median of %d)\n", reps);
    printf("----------------------------------------\n");
    printf("%-8s %12" PRIu64 " ticks   %9.1f ns\n", "L1 hit", t_l1,  timer_ticks_to_ns(t_l1));
    printf("%-8s %12" PRIu64 " ticks   %9.1f ns\n", "L2 hit", t_l2,  timer_ticks_to_ns(t_l2));
    printf("%-8s %12" PRIu64 " ticks   %9.1f ns\n", "L3 hit", t_l3,  timer_ticks_to_ns(t_l3));
    printf("%-8s %12" PRIu64 " ticks   %9.1f ns\n", "DRAM",   t_ram, timer_ticks_to_ns(t_ram));
    printf("----------------------------------------\n");

    /* 6) Cleanup */
    if (buf_llc) free(buf_llc);
    if (buf_l2)  free(buf_l2);
    if (buf_l1)  free(buf_l1);
    free(region);
    timer_shutdown();
    return 0;
}
