#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdbool.h>
#include <unistd.h>
#include "timer.h"

// Use x86 clflush when available; otherwise provide an eviction-based fallback.
#if defined(__x86_64__) || defined(_M_X64)
  #include <x86intrin.h>
  static inline void flush_line(void *p) {
    _mm_clflush(p);
    _mm_mfence(); _mm_lfence();
  }
#else
  // ---------- ARM / portable fallback ----------
  // Evict caches by reading through a large buffer bigger than LLC.
  // Tune EVICT_SIZE if your Mac has an unusually large LLC.
  #define EVICT_SIZE (64 * 1024 * 1024)  // 64 MiB
  #define STRIDE 64                      // cache line-ish
  static unsigned char *evict_buf = NULL;

  static inline void init_eviction_buffer(void) {
    if (!evict_buf) {
      // posix_memalign for line alignment
      if (posix_memalign((void**)&evict_buf, 64, EVICT_SIZE) != 0 || !evict_buf) {
        perror("evict buffer alloc");
        exit(1);
      }
      memset(evict_buf, 0xA5, EVICT_SIZE);
    }
  }

  static inline void evict_caches(void) {
    volatile unsigned int acc = 0;
    for (size_t i = 0; i < EVICT_SIZE; i += STRIDE) acc += evict_buf[i];
    (void)acc;
  }

  static inline void flush_line(void *p) {
    (void)p; // not line-selective on ARM; we just evict broadly
    init_eviction_buffer();
    evict_caches();
  }
#endif

int main(void) {
    if (timer_init(true, 0.2) != 0) {
        fprintf(stderr, "timer_init failed\n");
        return 1;
    }

    const int reps = 2;
    unsigned char *buf = NULL;
    if (posix_memalign((void**)&buf, 64, 4096) != 0 || !buf) {
        perror("alloc");
        return 1;
    }
    memset(buf, 0xA5, 4096);
    volatile unsigned char sink;

    // Warm cache access
    sink = buf[0];

    // Measure cached accesses
    uint64_t sum_ticks_cached = 0;
    for (int i = 0; i < reps; ++i) {
        uint64_t t = timer_time_maccess(&buf[0]);
        sum_ticks_cached += t;
    }

    // Measure flushed/evicted accesses
    uint64_t sum_ticks_evicted = 0;
    for (int i = 0; i < reps; ++i) {
        flush_line(&buf[0]);
        uint64_t t = timer_time_maccess(&buf[0]);
        sum_ticks_evicted += t;
    }

    double avg_cached_ns  = timer_ticks_to_ns(sum_ticks_cached)  / reps;
    double avg_evicted_ns = timer_ticks_to_ns(sum_ticks_evicted) / reps;

    printf("Avg cached access:   %.2f ns\n", avg_cached_ns);
    printf("Avg evicted access:  %.2f ns\n", avg_evicted_ns);

    free((void*)buf);
    timer_shutdown();
    return 0;
}
