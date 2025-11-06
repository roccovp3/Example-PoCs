#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <mach/thread_policy.h>
#include <assert.h>
#include <inttypes.h>
#include <stdatomic.h>
#include <time.h>

#include "timer.h"

static _Atomic uint64_t g_counter = 0;
static _Atomic int g_stop = 0;
static pthread_t g_thr;
static mach_timebase_info_data_t g_tb;
static double g_ticks_per_ns = 0.0;

/* Helper function declarations */
static void* timer_thread_fn(void* arg);
static void set_affinity_tag(pthread_t th, int tag);

/* Timer API */
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

    return 0;
}

uint64_t timer_now(void) {
    return atomic_load_explicit(&g_counter, memory_order_relaxed);
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

/* Helper functions */
static void* timer_thread_fn(void* arg) {
    void *test = arg;
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

void touch(void *p) {
    volatile uint8_t *q = (volatile uint8_t *)p;
    (void)*q;
}

void evict_by_sweep(uint8_t *evict_buf, size_t evict_bytes) {
    size_t step = LINE_SIZE;
    for (size_t i = 0; i < evict_bytes; i += step) {
        touch(evict_buf + i);
    }
}

uint64_t calibrate_latency() {
    size_t evict_bytes = (size_t)BUF_SIZE_MB * 1024 * 1024;
    uint8_t *evict_buf = malloc(evict_bytes + LINE_SIZE);
    if (!evict_buf) {
        perror("malloc evict_buf");
        exit(-1);
    }

    // touch pages to allocate physical memory
    for (size_t i = 0; i < evict_bytes; i += 16384) evict_buf[i] = 1;

    uint64_t hit = 0, miss = 0, threshold, rep = 1000;
    uint8_t *data = malloc(8);
    assert(data);

    // Measure cache hit latency
    volatile uint8_t val = *data;
    for (uint32_t n = 0; n < rep; n++) {
        hit += timer_time_maccess(data);
    }
    hit /= rep;

    // Measure cache miss latency
    for (uint32_t n = 0; n < rep; n++) {
        evict_by_sweep(evict_buf, evict_bytes);
        miss += timer_time_maccess(data);
    }
    miss /= rep;

    threshold = ((2 * miss) + hit) / 3;
    printf("Avg. hit latency: %" PRIu64 ", Avg. miss latency: %" PRIu64
           ", Threshold: %" PRIu64 "\n",
           hit, miss, threshold);

    free(data);
    free(evict_buf);
    return threshold;
}
