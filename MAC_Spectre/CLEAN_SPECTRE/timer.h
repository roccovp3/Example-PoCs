#pragma once
#include "utils.h"

extern _Atomic uint64_t g_counter;
extern _Atomic int      g_stop;
extern pthread_t        g_thr;
extern mach_timebase_info_data_t g_tb;
extern double           g_ticks_per_ns;

extern _Atomic uint64_t counter;
extern _Atomic int      stop;
extern pthread_t        thr;
extern mach_timebase_info_data_t tb;
extern double           ticks_per_ns;


int timer_init(bool use_affinity, double calib_seconds, bool use_atomic);
uint64_t calibrate_latency(bool atomic);

void touch(void *p);
void timer_shutdown(bool atomic);
uint32_t timer_time_maccess(void* ptr, bool atomic);

