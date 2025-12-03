#define _GNU_SOURCE  // Enable GNU extensions for sched functions
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <assert.h>
#include <inttypes.h>
#include <time.h>
#include <math.h>
#include <sched.h>

#include "timer.h"

/* Simple single-threaded timer using ARMv8 system counter (CNTVCT_EL0).
   Falls back to clock_gettime(CLOCK_MONOTONIC) on non-AArch64 builds. */

int timer_init(bool use_affinity, double calib_seconds) {
    (void)use_affinity;
    (void)calib_seconds;
    /* No initialization required for CNTVCT_EL0 or clock_gettime fallback. */
    cpu_set_t cpuset;
    CPU_ZERO(&cpuset);
    CPU_SET(CORE, &cpuset);
    if (sched_setaffinity(0, sizeof(cpuset), &cpuset) != 0) {
        printf("Warning: Failed to set CPU affinity.\n");
        return -1;
    }
    return 0;
}

uint64_t timer_now(void) {
    uint64_t v;
    /* Ensure previous instructions are completed before reading */
    ISB();
    __asm__ volatile("mrs %0, cntvct_el0" : "=r"(v));
    ISB();
    return v;
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
    /* No resources to free in this implementation. */
    return;
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

    /* touch pages to allocate physical memory */
    for (size_t i = 0; i < evict_bytes; i += 4096) evict_buf[i] = 1;

    uint64_t threshold, rep = 1000;
    uint8_t *data = malloc(8);
    assert(data);

    // First pass: compute means
    uint64_t hit = 0;
    uint64_t hit_sum = 0;
    uint64_t hits[1000];
    uint64_t miss = 0;
    uint64_t miss_sum = 0;
    uint64_t misses[1000];
    uint64_t miss_min = UINT64_MAX;

    /* Measure cache hit latency (first pass) */
    volatile uint8_t val = *data;
    (void)val;
    for (uint32_t n = 0; n < rep; n++) {
        hit = timer_time_maccess(data);
        hit_sum += hit;
        hits[n] = hit;
    }
    double hit_mean = (double)hit_sum / (double)rep;

    /* Measure cache miss latency (first pass) */
    for (uint32_t n = 0; n < rep; n++) {
        evict_by_sweep(evict_buf, evict_bytes);
        miss = timer_time_maccess(data);
        miss_sum += miss;
        misses[n] = miss;
        if (miss < miss_min) miss_min = miss;
    }
    double miss_mean = (double)miss_sum / (double)rep;

    // Second pass: compute sum of squared differences for variance
    double hit_sq_diff_sum = 0.0;
    double miss_sq_diff_sum = 0.0;

    /* Measure cache hit latency (second pass) */
    val = *data;  // Re-touch to ensure cached
    (void)val;
    for (uint32_t n = 0; n < rep; n++) {
        double diff = (double)hits[n] - hit_mean;
        hit_sq_diff_sum += diff * diff;
    }

    /* Measure cache miss latency (second pass) */
    for (uint32_t n = 0; n < rep; n++) {
        double diff = (double)misses[n] - miss_mean;
        // printf("Miss sample %u: %lu, diff = %.2f\n", n, misses[n], diff);
        miss_sq_diff_sum += diff * diff;
    }

    // Compute averages
    uint64_t hit_avg = (uint64_t)hit_mean;
    uint64_t miss_avg = (uint64_t)miss_mean;

    // Compute sample variance and std dev
    double hit_variance = hit_sq_diff_sum / (double)(rep - 1);
    double miss_variance = miss_sq_diff_sum / (double)(rep - 1);
    double hit_stddev = sqrt(hit_variance);
    double miss_stddev = sqrt(miss_variance);

    threshold = ((2 * miss_avg) + hit_avg) / 4;
    printf("Avg. hit latency: %" PRIu64 " (std dev: %.2f), Avg. miss latency: %" PRIu64 " (std dev: %.2f), Min miss: %" PRIu64 ", Threshold: %" PRIu64 "\n",
           hit_avg, hit_stddev, miss_avg, miss_stddev, miss_min, threshold);

    free(data);
    free(evict_buf);
    return threshold;
}

// uint64_t calibrate_latency() {
//     size_t evict_bytes = (size_t)BUF_SIZE_MB * 1024 * 1024;
//     uint8_t *evict_buf = malloc(evict_bytes + LINE_SIZE);
//     if (!evict_buf) {
//         perror("malloc evict_buf");
//         exit(-1);
//     }

//     /* touch pages to allocate physical memory */
//     for (size_t i = 0; i < evict_bytes; i += 4096) evict_buf[i] = 1;

//     uint64_t hit = 0, miss = 0, threshold, rep = 1000;
//     uint8_t *data = malloc(8);
//     assert(data);

//     /* Measure cache hit latency */ 
//     volatile uint8_t val = *data;
//     (void)val;
//     for (uint32_t n = 0; n < rep; n++) {
//         hit += timer_time_maccess(data);
//     }
//     hit /= rep;

//     /* Measure cache miss latency */
//     for (uint32_t n = 0; n < rep; n++) {
//         evict_by_sweep(evict_buf, evict_bytes);
//         miss += timer_time_maccess(data);
//     }
//     miss /= rep;

//     threshold = ((2 * miss) + hit) / 3;
//     printf("Avg. hit latency: %" PRIu64 ", Avg. miss latency: %" PRIu64
//            ", Threshold: %" PRIu64 "\n",
//            hit, miss, threshold);

//     free(data);
//     free(evict_buf);
//     return threshold;
// }

int main2(void) {
    if (timer_init(false, 0.0) != 0) {
        fprintf(stderr, "timer_init failed\n");
        return 1;
    }

    printf("Calibrating latency (may allocate a large buffer)...\n");
    uint64_t threshold = calibrate_latency();
    printf("Calibration threshold = %" PRIu64 "\n", threshold);

    /* simple monotonic check */
    uint64_t a = timer_now();
    usleep(1000);
    uint64_t b = timer_now();
    printf("timer_now delta after 1ms sleep: %" PRIu64 "\n", b - a);

    /* prepare data buffer and ensure it's cached */
    uint8_t *data = malloc(64);
    if (!data) {
        perror("malloc data");
        timer_shutdown();
        return 1;
    }
    memset(data, 0xA5, 64);
    volatile uint8_t tmp = data[0]; (void)tmp; /* bring into cache */

    uint64_t t_hit = timer_time_maccess(data);
    printf("Measured cached access: %" PRIu64 " ticks\n", t_hit);

    /* allocate a modest eviction buffer and evict */
    size_t evict_bytes = 16 * 1024 * 1024; 
    uint8_t *evict_buf = malloc(evict_bytes + LINE_SIZE);
    if (!evict_buf) {
        perror("malloc evict_buf");
        free(data);
        timer_shutdown();
        return 1;
    }
    /* touch pages to allocate physical memory */
    for (size_t i = 0; i < evict_bytes; i += 4096) evict_buf[i] = 1;

    evict_by_sweep(evict_buf, evict_bytes);
    uint64_t t_miss = timer_time_maccess(data);
    printf("Measured evicted access: %" PRIu64 " ticks\n", t_miss);

    printf("Access considered cached? %s\n", (t_hit < threshold) ? "yes" : "no");
    printf("Access considered cached after eviction? %s\n", (t_miss < threshold) ? "yes" : "no");

    free(data);
    free(evict_buf);
    timer_shutdown();
    return 0;
}