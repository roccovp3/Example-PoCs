#include "timer.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>



/* Allocate and optionally touch pages to map them. */
static void *alloc_region(size_t bytes, size_t align, int touch_pages) {
    void *p = NULL;
    if (posix_memalign(&p, align, bytes) != 0) return NULL;
    if (touch_pages) for (size_t i = 0; i < bytes; i += 4096) ((volatile uint8_t*)p)[i] = 0;
    return p;
}

/* ---------- Eviction-callback plumbing (no nested functions) ---------- */
typedef struct {
    const eviction_set_t *es;
    int rounds;
} EvictSetCtx;

static void evict_es_cb(void *ud) {
    EvictSetCtx *ctx = (EvictSetCtx *)ud;
    if (ctx && ctx->es) evset_evict_rounds(ctx->es, ctx->rounds);
}

/* Measure median latency (in ticks) after an optional eviction pass. */
static int cmp_u64(const void *a, const void *b) {
    uint64_t x = *(const uint64_t*)a, y = *(const uint64_t*)b;
    return (x>y) - (x<y);
}
static uint64_t median_ticks(uint64_t *v, int n) {
    qsort(v, (size_t)n, sizeof(uint64_t), cmp_u64);
    return v[n/2];
}

/* Drop-in: put this directly below median_ticks(...) in main.c */
static inline uint64_t median_u64(uint64_t *v, int n) { return median_ticks(v, n); }

static uint64_t measure_after_eviction(void *victim,
                                       void (*evict_fn)(void *),
                                       void *evict_ud,
                                       int reps)
{
    if (reps < 9) reps = 9;
    uint64_t *vals = (uint64_t*)malloc((size_t)reps * sizeof(uint64_t));
    for (int i = 0; i < reps; ++i) {
        volatile uint8_t warm = *(volatile uint8_t*)victim; (void)warm; /* make it hot */
        if (evict_fn) evict_fn(evict_ud);           /* evict chosen level(s) */
        ISB();                                       /* timer fences internally too */
        vals[i] = timer_time_maccess(victim);
    }
    uint64_t med = median_ticks(vals, reps);
    free(vals);
    return med;
}

/* Quick validation: does using this set actually slow the victim down? */
static int evset_validates(const eviction_set_t *es, void *victim, int rounds) {
    if (!es || !es->head) return 0;
    uint64_t t_hit = measure_after_eviction(victim, NULL, NULL, 31);
    EvictSetCtx ctx = { es, rounds };
    uint64_t t_evi = measure_after_eviction(victim, evict_es_cb, &ctx, 31);
    return (t_evi > (t_hit + (t_hit >> 2))); /* > ~1.25x */
}

int main(void) {
    /* 1) Timer */
    if (timer_init(true, 0.4) != 0) { perror("timer_init"); return 1; }

    /* 2) Victim we own */
    const size_t region_bytes = 2u << 20;  /* 2 MiB */
    uint8_t *region = (uint8_t*)alloc_region(region_bytes, 64, /*touch_pages=*/1);
    if (!region) { perror("alloc_region"); timer_shutdown(); return 1; }
    uint8_t *victim = region + 64 * 123;   /* 64B aligned */
    printf("victim_addr=%p\n", (void*)victim);

    /* 3) Build eviction sets */
    eviction_set_t l1 = {0}, l2 = {0}, l3 = {0};

    /* L1: strict VA-set congruent lines; oversubscribe to beat replacement */
    if (evset_build_l1_strict(&l1, victim, /*nlines=*/24, /*region=*/4u<<20, /*random=*/1) != 0)
        fprintf(stderr, "L1 strict evset failed\n");

    /* L2/L3: adaptive black-box learning from large pools */
    if (evset_build_l2_auto_v2(&l2, victim, /*target_ways=*/16, /*region=*/32u<<20) != 0)
        fprintf(stderr, "L2 evset v2 failed\n");
    if (evset_build_l3_auto_v2(&l3, victim, /*target_ways=*/32, /*region=*/128u<<20) != 0)
        fprintf(stderr, "L3 evset v2 failed\n");

    // Validate each level with proper composition
const int R1 = 256, R2 = 512, R3 = 1024;
const int REPS_VALID = 31;

int l1_ok = (l1.head != NULL); // for L1 we often just oversubscribe; optional self-test
int l2_ok = evset_validate_level(&l2, victim, &l1, NULL,    R2, R1, REPS_VALID, 1.25);
int l3_ok = evset_validate_level(&l3, victim, &l2, &l1,     R3, R2, REPS_VALID, 1.25);

if (!l2_ok) fprintf(stderr, "Warning: L2 set didn’t validate; L3/DRAM may collapse.\n");
if (!l3_ok) fprintf(stderr, "Warning: L3 set didn’t validate; DRAM may collapse.\n");

// ---- Measurements with proper composed eviction ----
const int REPS_MEAS = 51;
uint64_t *buf = (uint64_t*)malloc(REPS_MEAS * sizeof(uint64_t));

// L1 hit: warm + measure
for (int i=0;i<REPS_MEAS;i++){ volatile uint8_t w=*(volatile uint8_t*)victim;(void)w; buf[i]=timer_time_maccess(victim); }
uint64_t t_l1 = median_u64(buf, REPS_MEAS);

// L2 hit: evict L1 (L1 last)
for (int i=0;i<REPS_MEAS;i++){ volatile uint8_t w=*(volatile uint8_t*)victim;(void)w;
  evset_evict_chain(NULL,0,NULL,0,&l1,R1,/*reshuffle=*/1);
  buf[i]=timer_time_maccess(victim);
}
uint64_t t_l2 = median_u64(buf, REPS_MEAS);

// L3 hit: evict L2 then L1
for (int i=0;i<REPS_MEAS;i++){ volatile uint8_t w=*(volatile uint8_t*)victim;(void)w;
  evset_evict_chain(NULL,0,&l2,R2,&l1,R1,/*reshuffle=*/1);
  buf[i]=timer_time_maccess(victim);
}
uint64_t t_l3 = median_u64(buf, REPS_MEAS);

// DRAM: evict L3 then L2 then L1 (fallbacks: if l3 invalid, we still do l2+l1; if l2 invalid, we still do l1)
for (int i=0;i<REPS_MEAS;i++){ volatile uint8_t w=*(volatile uint8_t*)victim;(void)w;
  evset_evict_chain(l3_ok?&l3:NULL, R3, l2_ok?&l2:NULL, R2, &l1, R1, /*reshuffle=*/1);
  buf[i]=timer_time_maccess(victim);
}
uint64_t t_ram = median_u64(buf, REPS_MEAS);

free(buf);

    /* 6) Print (ticks + ns) */
    printf("\nLatency (median of %d)\n", REPS_MEAS);
    printf("----------------------------------------\n");
    printf("%-8s %12" PRIu64 " ticks   %9.1f ns\n", "L1 hit", t_l1, timer_ticks_to_ns(t_l1));
    printf("%-8s %12" PRIu64 " ticks   %9.1f ns  %s\n", "L2 hit", t_l2, timer_ticks_to_ns(t_l2),
           l1_ok ? "" : "(L1 set invalid)");
    printf("%-8s %12" PRIu64 " ticks   %9.1f ns  %s\n", "L3 hit", t_l3, timer_ticks_to_ns(t_l3),
           l2_ok ? "" : (l1_ok ? "(L2 invalid; fell back to L1)" : "(no evict)"));
    printf("%-8s %12" PRIu64 " ticks   %9.1f ns  %s\n", "DRAM",   t_ram, timer_ticks_to_ns(t_ram),
           l3_ok ? "" : (l2_ok ? "(fell back to L2)" : (l1_ok ? "(fell back to L1)" : "(no evict)")));
    printf("----------------------------------------\n");

    /* 7) Cleanup */
    evset_free(&l1);
    evset_free(&l2);
    evset_free(&l3);
    free(region);
    timer_shutdown();
    return 0;
}
