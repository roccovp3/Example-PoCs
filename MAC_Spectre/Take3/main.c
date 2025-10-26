#include "timer.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

/* ---------- small utils ---------- */
static void *alloc_region(size_t bytes, size_t align) {
    void *p = NULL;
    if (posix_memalign(&p, align, bytes) != 0) return NULL;
    for (size_t i = 0; i < bytes; i += 4096) ((volatile uint8_t*)p)[i] = 0; // map pages
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

/* Pointer-chase evict using an eviction set */
static inline void evict_with(const eviction_set_t *es, int rounds) {
    if (!es || !es->head) return;
    volatile uint8_t sink = 0;
    for (int r = 0; r < rounds; ++r) sink ^= evset_traverse_once(es);
    (void)sink;
}

/* Big streaming evictor (DRAM fallback): touches > LLC capacity */
static void stream_evict(uint8_t *buf, size_t bytes) {
    volatile uint8_t s = 0;
    for (size_t i = 0; i < bytes; i += 64) s ^= buf[i];
    (void)s;
}

/* ---------- “Callbacks” without nested funcs ---------- */
typedef struct {
    const eviction_set_t *es;
    int rounds;
} EvictSetCtx;

typedef struct {
    uint8_t *buf;
    size_t bytes;
} StreamCtx;

static void evict_es_cb(void *ud) {
    EvictSetCtx *ctx = (EvictSetCtx *)ud;
    evict_with(ctx->es, ctx->rounds);
}
static void evict_stream_cb(void *ud) {
    StreamCtx *ctx = (StreamCtx *)ud;
    if (ctx && ctx->buf && ctx->bytes) stream_evict(ctx->buf, ctx->bytes);
}

/* Measure median latency (in ticks) after optional eviction pass */
static uint64_t measure_after_eviction(void *victim,
                                       void (*evict_fn)(void *),
                                       void *evict_ud,
                                       int reps)
{
    if (reps < 9) reps = 9;
    uint64_t *vals = (uint64_t*)malloc((size_t)reps * sizeof(uint64_t));
    for (int i = 0; i < reps; ++i) {
        // warm to L1 first, then let the evictor decide what to evict
        volatile uint8_t w = *(volatile uint8_t*)victim; (void)w;
        if (evict_fn) evict_fn(evict_ud);
        ISB(); // timer_time_maccess() also fences internally
        vals[i] = timer_time_maccess(victim);
    }
    uint64_t med = median_u64(vals, reps);
    free(vals);
    return med;
}

/* Quick black-box check that an eviction set actually slows the victim */
static int evset_validates(const eviction_set_t *es, void *victim, int rounds) {
    if (!es || !es->head) return 0;
    uint64_t t_hit = measure_after_eviction(victim, NULL, NULL, 31);

    EvictSetCtx ctx = { es, rounds };
    uint64_t t_evi = measure_after_eviction(victim, evict_es_cb, &ctx, 31);

    // Require a noticeable uplift (adjust factor if needed)
    return (t_evi > (t_hit + (t_hit >> 2))); // > ~1.25x
}

int main(void) {
    /* 1) Timer */
    if (timer_init(true, 0.3) != 0) { perror("timer_init"); return 1; }

    /* 2) Victim we own */
    const size_t region_bytes = 2u << 20; // 2 MiB
    uint8_t *region = (uint8_t*)alloc_region(region_bytes, 64);
    if (!region) { perror("alloc_region"); timer_shutdown(); return 1; }
    uint8_t *victim = region + 64 * 123;            // 64B aligned
    printf("victim_addr=%p\n", (void*)victim);

    /* 3) Build eviction sets (oversubscribe + larger builders) */
    eviction_set_t l1={0}, l2={0}, l3={0};

    // Oversubscribe L1 to beat replacement/prefetch (16 > 8-way)
    // L1: keep randomize=1, region 4 MiB, oversubscribe (e.g., 24 lines)
    if (evset_build_l1_strict(&l1, victim, /*nlines=*/24, /*region_bytes=*/4u<<20, /*randomize=*/1) != 0)
    fprintf(stderr, "L1 strict evset failed\n");

    // L2/L3: adaptive black-box (bigger pools + oversubscribe)
    if (evset_build_l2_auto_v2(&l2, victim, /*target_ways=*/16, /*region_bytes=*/32u<<20) != 0)
    fprintf(stderr, "L2 evset v2 failed\n");
    if (evset_build_l3_auto_v2(&l3, victim, /*target_ways=*/32, /*region_bytes=*/128u<<20) != 0)
    fprintf(stderr, "L3 evset v2 failed\n");

    /* 4) Validate sets; if a level fails, fall back to streaming */
    const int R1=256, R2=512, R3=1024;


    uint64_t t_l1 = timer_time_maccess(victim);


    // L2 hit (kick out L1)
    evset_evict_rounds(&l1, R1);
    uint64_t t_l2 = timer_time_maccess(victim);

    // L3 hit (kick out L2; if l2 empty, this will be same as L2)
    evset_evict_rounds(&l2, R2);
    uint64_t t_l3 = timer_time_maccess(victim);

    // DRAM (kick out L3)
    evset_evict_rounds(&l3, R3);
    uint64_t t_ram = timer_time_maccess(victim);

    int l1_ok = evset_validates(&l1, victim, R1);
    int l2_ok = evset_validates(&l2, victim, R2);
    int l3_ok = evset_validates(&l3, victim, R3);

    if (!l1_ok) fprintf(stderr, "Warning: L1 set didn’t validate; L2/L3 results may collapse.\n");
    if (!l2_ok) fprintf(stderr, "Warning: L2 set didn’t validate; using streaming fallback for deeper levels.\n");
    if (!l3_ok) fprintf(stderr, "Warning: L3 set didn’t validate; using streaming fallback for DRAM.\n");

    // Allocate a big streaming buffer once (for fallback)
    uint8_t *big = (uint8_t*)alloc_region(256u<<20, 64); // 128 MiB
    if (!big) { perror("alloc 128MB"); }

    /* 5) Prepare “callbacks” + contexts */
    EvictSetCtx l1ctx = { &l1, R1 };
    EvictSetCtx l2ctx = { &l2, R2 };
    EvictSetCtx l3ctx = { &l3, R3 };

    StreamCtx   s16   = { big, 16u<<20  }; // ~L2-ish sweep
    StreamCtx   s64   = { big, 64u<<20  }; // L3-sized sweep
    StreamCtx   s128  = { big, 256u<<20 }; // DRAM pressure

    /* 6) Measure */
    const int reps = 51;

    // L1 hit: no eviction
    t_l1 = measure_after_eviction(victim, NULL, NULL, reps);

    // L2 hit: evict L1 only
    t_l2 = measure_after_eviction(
        victim,
        l1_ok ? evict_es_cb : NULL,
        l1_ok ? (void*)&l1ctx : NULL,
        reps);

    // L3 hit: evict L2 (and L1). If L2 set invalid, stream as fallback.
    t_l3 = measure_after_eviction(
        victim,
        l2_ok ? evict_es_cb : (big ? evict_stream_cb : NULL),
        l2_ok ? (void*)&l2ctx : (big ? (void*)&s16 : NULL),
        reps);

    // DRAM: evict LLC (and upper levels). If L3 set invalid, stream larger.
    t_ram = measure_after_eviction(
        victim,
        l3_ok ? evict_es_cb : (big ? evict_stream_cb : NULL),
        l3_ok ? (void*)&l3ctx : (big ? (void*)&s64 : NULL),
        reps);

    // Try an even larger stream to force DRAM harder if needed
    if (big) {
        uint64_t t_ram2 = measure_after_eviction(victim, evict_stream_cb, &s128, reps);
        if (t_ram2 > t_ram) t_ram = t_ram2;
    }

    /* 7) Print (ticks + ns) */
    printf("\nLatency (median of %d)\n", reps);
    printf("----------------------------------------\n");
    printf("%-8s %12" PRIu64 " ticks   %9.1f ns\n", "L1 hit", t_l1, timer_ticks_to_ns(t_l1));
    printf("%-8s %12" PRIu64 " ticks   %9.1f ns  %s\n", "L2 hit", t_l2, timer_ticks_to_ns(t_l2),
           l1_ok ? "" : "(L1 set invalid)");
    printf("%-8s %12" PRIu64 " ticks   %9.1f ns  %s\n", "L3 hit", t_l3, timer_ticks_to_ns(t_l3),
           l2_ok ? "" : "(streaming fallback)");
    printf("%-8s %12" PRIu64 " ticks   %9.1f ns  %s\n", "DRAM",   t_ram, timer_ticks_to_ns(t_ram),
           l3_ok ? "" : "(streaming +/or larger sweep)");
    printf("----------------------------------------\n");

    /* 8) Cleanup */
    evset_free(&l1);
    evset_free(&l2);
    evset_free(&l3);
    if (big) free(big);
    free(region);
    timer_shutdown();
    return 0;
}