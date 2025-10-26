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

// Architecture-dependent ISB-ish fence

static _Atomic uint64_t g_counter = 0;
static _Atomic int      g_stop = 0;
static pthread_t       g_thr;
static mach_timebase_info_data_t g_tb;
static double          g_ticks_per_ns = 0.0; // ticks / ns

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

void timer_shutdown(void) {
  atomic_store_explicit(&g_stop, 1, memory_order_relaxed);
  pthread_join(g_thr, NULL);
}
