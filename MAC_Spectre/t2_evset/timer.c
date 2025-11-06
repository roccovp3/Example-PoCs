#include <stdio.h>
#include <inttypes.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <pthread.h>
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <mach/thread_policy.h>
#include <pthread/qos.h>

#include "timer.h"   


static volatile uint64_t g_counter = 0;     
static pthread_t        g_thr;

static mach_timebase_info_data_t g_tb;
static double g_ticks_per_ns = 1.0;         


static void*  timer_thread_fn(void* arg);
static void   set_affinity_tag(pthread_t th, int tag);
static double calibrate_ticks_per_ns(double seconds);
static inline uint64_t abs_to_ns(uint64_t t_abs);
static inline uint64_t ns_to_abs(uint64_t ns);


// call from main
int timer_init(bool use_affinity, double calib_seconds) {
    // timebase for mach_continuous_time <-> ns
    mach_timebase_info(&g_tb);
    g_counter = 0;

    // Hint: keep measuring thread & timer thread on same core (soft hint)
    if (use_affinity) set_affinity_tag(pthread_self(), 1);

    if (pthread_create(&g_thr, NULL, timer_thread_fn, NULL) != 0) {
        perror("pthread_create");
        return -1;
    }

    if (use_affinity) set_affinity_tag(g_thr, 1);

    // small warm-up so the increment loop is running
    struct timespec ts = { .tv_sec = 0, .tv_nsec = 5 * 1000 * 1000 };
    nanosleep(&ts, NULL);

    // calibrate ticks -> ns
    const double secs = (calib_seconds > 0.0) ? calib_seconds : 0.3;
    g_ticks_per_ns = calibrate_ticks_per_ns(secs);
    if (g_ticks_per_ns <= 0.0) g_ticks_per_ns = 1.0;

    return 0;
}


uint64_t timer_now(void) {
    return g_counter;
}

double timer_ticks_to_ns(uint64_t ticks) {
    return (double)ticks / g_ticks_per_ns;
}

uint64_t timer_time_maccess(void *ptr) {
    ISB();
    uint64_t t0 = timer_now();
    ISB();

    volatile unsigned char tmp = *(volatile unsigned char *)ptr;
    (void)tmp;

    ISB();
    uint64_t t1 = timer_now();
    ISB();

    return t1 - t0;
}

// Memory functions

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


void smart_evict_by_sweep(uint8_t *evict_buf, size_t evict_bytes) {
  for (size_t i = 0; i < evict_bytes; i++) {
    touch(evict_buf + i);
  }
}

uint64_t calibrate_latency() {
    // Allocate eviction buffer (for full cache sweeps)
    size_t evict_bytes = (size_t)BUF_SIZE_MB * 1024 * 1024;
    uint8_t *evict_buf = (uint8_t*)malloc(evict_bytes + LINE_SIZE);
    if (!evict_buf) {
        perror("malloc evict_buf");
        exit(-1);
    }

    // touch pages to ensure physical memory is committed
    for (size_t i = 0; i < evict_bytes; i += 16384) evict_buf[i] = 1;

    uint64_t hit = 0, miss = 0, threshold, rep = 1000;
    uint8_t *data = (uint8_t*)malloc(8);
    assert(data);

    // ensure it's faulted in
    volatile uint8_t val = *data; (void)val;

    // measure cache-hit latency
    for (uint32_t n = 0; n < rep; n++) {
        hit += timer_time_maccess(data);
    }
    hit /= rep;

    // measure cache-miss latency (evict between trials)
    for (uint32_t n = 0; n < rep; n++) {
        evict_by_sweep(evict_buf, evict_bytes);
        miss += timer_time_maccess(data);
    }
    miss /= rep;

    // simple threshold heuristic
    threshold = ((2 * miss) + hit) >> 2;

    printf("Avg. hit latency: %" PRIu64 ", Avg. miss latency: %" PRIu64
           ", Threshold: %" PRIu64 "\n", hit, miss, threshold);

    free(data);
    free(evict_buf);
    return threshold;
}

// ======================================================================
// Internals
// ======================================================================

// Timer thread: EXACTLY the paper’s loop (volatile ++ forever)
static void* timer_thread_fn(void* arg) {
    (void)arg;
    // Highest QoS to steer to P-core and reduce preemption
    pthread_set_qos_class_self_np(QOS_CLASS_USER_INTERACTIVE, 0);

    while (1) {
        g_counter++;      // MATCHES: “volatile uint64_t counter; while(1) counter++;”
    }
    return NULL;          // never reached
}

static double calibrate_ticks_per_ns(double seconds) {
    uint64_t start  = g_counter;                                // volatile read
    uint64_t t0     = mach_continuous_time();
    uint64_t budget = ns_to_abs((uint64_t)(seconds * 1e9));

    while (mach_continuous_time() - t0 < budget) { /* spin */ }

    uint64_t end = g_counter;                                   // volatile read
    uint64_t t1  = mach_continuous_time();

    uint64_t ns = abs_to_ns(t1 - t0);
    if (ns == 0) ns = 1;

    return (double)(end - start) / (double)ns;
}

static inline uint64_t abs_to_ns(uint64_t t_abs) {
    return (t_abs * g_tb.numer) / g_tb.denom;
}
static inline uint64_t ns_to_abs(uint64_t ns) {
    return (ns * g_tb.denom) / g_tb.numer;
}

static void set_affinity_tag(pthread_t th, int tag) {
    thread_port_t mth = pthread_mach_thread_np(th);
    thread_affinity_policy_data_t pol = { .affinity_tag = tag };
    (void)thread_policy_set(mth, THREAD_AFFINITY_POLICY,
                            (thread_policy_t)&pol, THREAD_AFFINITY_POLICY_COUNT);
}
