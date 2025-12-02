#pragma once
#include <inttypes.h>
#include <stdbool.h>

#define BUF_SIZE_MB 128
#define TARGET_STRIDE 1
#define ISB() __asm__ __volatile__("isb" ::: "memory")
/* Need space for this guy somewhere */
// Branchless select based on the predicate (covered in class)
static inline size_t csel(size_t T, size_t F, bool pred) {
    size_t mask = -(size_t)(!!pred); // Need to collapse "pred" to 0/1
    return (T & mask) | (F & ~mask);
    // return F ^ ((T ^ F) & mask);  // This also works and should be a bit
    // faster
}

void touch(void *p);

/* ===================== Timer API ===================== */

/* Initialize the two-thread timer (atomic incrementer). If use_affinity is
 * true we ask the OS to put both threads on the same affinity tag (Darwin).
 * calib_seconds controls the calibration window for ticks->ns conversion. */
int timer_init(bool use_affinity, double calib_seconds);

/* Read the raw monotonic counter (ticks). */
uint64_t timer_now(void);

/* Convert ticks to nanoseconds using the calibrated ratio. */
double timer_ticks_to_ns(uint64_t ticks);

/* Measure the latency to access *ptr in ticks. Safe, uses ISB fences. */
uint64_t timer_time_maccess(void *ptr);

/* Stop/join timer thread and cleanup. */
void timer_shutdown(void);

void evict_by_sweep(uint8_t *evict_buf, size_t evict_bytes);
uint64_t calibrate_latency();
