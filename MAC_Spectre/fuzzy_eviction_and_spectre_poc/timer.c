#include <stdio.h>
#include <inttypes.h>
#include <mach/mach_time.h>
#include <sys/_pthread/_pthread_t.h>
#include <pthread.h>
#include <stdatomic.h>
#include <time.h>
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <mach/thread_policy.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

#include "timer.h"



#define _maccess(P) ({                                                         \
    typeof(*(P)) _NO_USE;                                                      \
    if (sizeof(*(P)) == 1) {                                                   \
        __asm__ __volatile__("ldrb %w0, [%1]"                                   \
                             : "=r"(_NO_USE)                                    \
                             : "r"((P))                                         \
                             : "memory");                                       \
    } else if (sizeof(*(P)) == 2) {                                            \
        __asm__ __volatile__("ldrh %w0, [%1]"                                   \
                             : "=r"(_NO_USE)                                    \
                             : "r"((P))                                         \
                             : "memory");                                       \
    } else if (sizeof(*(P)) == 4) {                                            \
        __asm__ __volatile__("ldr %w0, [%1]"                                    \
                             : "=r"(_NO_USE)                                    \
                             : "r"((P))                                         \
                             : "memory");                                       \
    } else { /* 8 bytes or larger: use 64-bit load */                          \
        __asm__ __volatile__("ldr %x0, [%1]"                                    \
                             : "=r"(_NO_USE)                                    \
                             : "r"((P))                                         \
                             : "memory");                                       \
    }                                                                          \
    _NO_USE; /* evaluate to the loaded value */                                \
  })



static _Atomic uint64_t g_counter = 0;
static _Atomic int      g_stop    = 0;
static pthread_t        g_thr;
static mach_timebase_info_data_t g_tb;
static double           g_ticks_per_ns = 0.0;  /* ticks / ns */

/* The following are helper functions that are defined at the bottom */
static void* timer_thread_fn(void* arg);
static void set_affinity_tag(pthread_t th, int tag);
static double calibrate_ticks_per_ns(double seconds);
static inline uint64_t abs_to_ns(uint64_t t_abs); 
static inline uint64_t ns_to_abs(uint64_t ns);








/* Timer API - use this to measure the cache access times */
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




/* Helper functions defined below */

static void* timer_thread_fn(void* arg) {
    void *test = arg; // shut the compiler up
    uint64_t local = 0;
    atomic_store_explicit(&g_counter, 0, memory_order_relaxed);
    atomic_store_explicit(&g_stop, 0, memory_order_relaxed);


    #ifdef QOS_CLASS_USER_INTERACTIVE
        pthread_set_qos_class_self_np(QOS_CLASS_USER_INTERACTIVE, 0);
    #endif
    while (!atomic_load_explicit(&g_stop, memory_order_relaxed)) {
        local++;
        atomic_store_explicit(&g_counter, local, memory_order_relaxed);
    }
    return NULL;
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





void touch(void *p) {
    // volatile to avoid compiler optimizing away
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
    for (size_t i = 0; i < evict_bytes; i ++) {
        touch(evict_buf + i);
    }
}



uint64_t calibrate_latency() {

    
    /* SAVE THIS CODE SEGMENT FOR ENTIRE CACHE WIPES */
     // Sweep through the eviction buffer with cache-line stride to evict target from caches.
    size_t evict_bytes = (size_t)BUF_SIZE_MB * 1024 * 1024;
    uint8_t *evict_buf = malloc(evict_bytes + LINE_SIZE);
    if (!evict_buf) { 
        perror("malloc evict_buf"); 
        exit(-1); 
    }
    // touch pages to allocate physical memory
    for (size_t i = 0; i < evict_bytes; i += 16384) evict_buf[i] = 1;
    /* END SAVE HERE */


    uint64_t hit = 0, miss = 0, threshold, rep = 1000;
    uint8_t *data = malloc(8);
    assert(data); // Lazy "exception" handling

    // Measure cache hit latency
    // I got rid of _maccess define since it's better to let compiler look at types and assign the load than to do something else
    // _maccess(data)
    volatile uint8_t val = *data;
    for (uint32_t n = 0; n < rep; n++) {       
        hit += timer_time_maccess(data);
    }
    hit /= rep;

    // Measure cache miss latency
    for (uint32_t n = 0; n < rep; n++) {
        // _mm_clflush(data);
        evict_by_sweep(evict_buf, evict_bytes);
        miss += timer_time_maccess(data);
    }
    miss /= rep;

    threshold = ((2 * miss) + hit) / 4;
    printf("Avg. hit latency: %" PRIu64 ", Avg. miss latency: %" PRIu64
           ", Threshold: %" PRIu64 "\n",
           hit, miss, threshold);
    free(data);
    free(evict_buf);
    return threshold;
}
