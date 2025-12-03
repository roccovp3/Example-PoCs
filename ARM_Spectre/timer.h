#pragma once

#include <stdint.h>
#include <stdbool.h>

#define LINE_SIZE 256
#define BUF_SIZE_MB 32
// #define PAGE_SIZE 4096
#define LLC_SIZE_MB 32
#define CORE 0

#define ISB() __asm__ __volatile__("isb" ::: "memory")

void touch(void *p);

/* ===================== Timer API ===================== */
int timer_init(bool use_affinity, double calib_seconds);
uint64_t timer_now(void);
uint64_t timer_time_maccess(void *ptr);
void timer_shutdown(void);

void evict_by_sweep(uint8_t *evict_buf, size_t evict_bytes);
uint64_t calibrate_latency();
