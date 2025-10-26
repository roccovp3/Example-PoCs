#pragma once 
#include <inttypes.h>
#include <stdbool.h>

#define LINE_SIZE 128
#define BUF_SIZE_MB 128
#define TARGET_STRIDE 1



/* ===================== Timer API ===================== */

/* Initialize the two-thread timer (atomic incrementer). If use_affinity is
 * true we ask the OS to put both threads on the same affinity tag (Darwin).
 * calib_seconds controls the calibration window for ticks->ns conversion. */
int      timer_init(bool use_affinity, double calib_seconds);

/* Read the raw monotonic counter (ticks). */
uint64_t timer_now(void);

/* Convert ticks to nanoseconds using the calibrated ratio. */
double   timer_ticks_to_ns(uint64_t ticks);

/* Measure the latency to access *ptr in ticks. Safe, uses ISB fences. */
uint64_t timer_time_maccess(void *ptr);

/* Stop/join timer thread and cleanup. */
void     timer_shutdown(void);



uint64_t calibrate_latency();
