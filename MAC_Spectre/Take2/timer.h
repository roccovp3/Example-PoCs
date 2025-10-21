#ifndef TIMER_H
#define TIMER_H

#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Initialize the two-thread timer. If use_affinity is true the code will
// ask the OS to place both threads on the same affinity tag (Darwin specific).
// calib_seconds controls how long the calibration window is (e.g. 0.2).
int timer_init(bool use_affinity, double calib_seconds);

// Read the raw counter ticks (monotonic, incremented by background thread).
uint64_t timer_now(void);

// Convert a tick count (difference) to nanoseconds using calibration.
double timer_ticks_to_ns(uint64_t ticks);

// Measure the access latency (in ticks) to a pointer by reading the timer
// before and after accessing *ptr. Useful for microbenchmarks on memory you
// own.
uint64_t timer_time_maccess(void *ptr);

// Stop/join timer thread and cleanup.
void timer_shutdown(void);

#ifdef __cplusplus
}
#endif

#endif // TIMER_H
