#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdbool.h>
#include <time.h>

#include "timer.h"

#define LINE_SIZE      128                  // aligns with LLC line size
#define EVICT_BYTES    (64 * 1024 * 1024)  // eviction region
#define NUM_ADDRESSES  60                  // sample size per eviction trial


// Simple shuffle (Fisher–Yates)
void shuffle_ptrs(uint8_t **array, size_t n)
{
    for (size_t i = 0; i + 1 < n; i++) {
        size_t j = i + rand() / (RAND_MAX / (n - i) + 1);
        uint8_t *tmp = array[j];
        array[j] = array[i];
        array[i] = tmp;
    }
}



void run_trials(uint8_t **evict_ptrs, size_t num_lines, uint64_t threshold)
{
    uint8_t *data = malloc(8);
    if (!data) { perror("malloc"); exit(1); }

    size_t hits = 0, misses = 0;

    for (size_t iter = 0; iter < 1000; iter++) {

        shuffle_ptrs(evict_ptrs, num_lines);  // random eviction set for this iter

        uint64_t avg = 0;
        const int reps = 200;                 // average over 200 attempts

        for (int k = 0; k < reps; k++) {
            // Prime: ensure 'data' is cached before eviction attempt
            *(volatile uint8_t *)data;

            // Evict attempt using first NUM_ADDRESSES pointers
            for (int j = 0; j < NUM_ADDRESSES; j++)
                touch(evict_ptrs[j]);

            // Probe: time access to 'data'
            avg += timer_time_maccess(data);
        }

        avg /= reps;

        if (avg > threshold) {
            // First pass suggests eviction. Re-test SAME ORDER 10× to rule out fluke.
            int confirm_hits = 0;
            const int confirm_trials = 10;

            for (int r = 0; r < confirm_trials; r++) {
                // Prime again for each confirmation trial
                *(volatile uint8_t *)data;

                // Evict with the same (already shuffled) first NUM_ADDRESSES
                for (int j = 0; j < NUM_ADDRESSES; j++){
                    touch(evict_ptrs[j]);
                }
                    

                // Probe
                uint64_t t = timer_time_maccess(data);
                if (t > threshold) confirm_hits++;
            }

            // Majority vote (tune threshold: 8 is stricter, 5 is looser)
            if (confirm_hits >= 8) {
                printf("Iteration %zu\n", iter);
                exit(EXIT_SUCCESS);
                hits++;
                // printf("iter %zu: confirmed (%d/%d)\n", iter, confirm_hits, confirm_trials);
            } else {
                misses++;
                // printf("iter %zu: false alarm (%d/%d)\n", iter, confirm_hits, confirm_trials);
            }
        } else {
            misses++;
        }

        // Optional per-iter log:
        // printf("iter %zu: avg=%" PRIu64 " -> %s\n", iter, avg, (avg > threshold) ? "CANDIDATE" : "CACHED");
    }

    printf("\n==== RESULTS ====\n");
    printf("Evicted: %zu\n", hits);
    printf("Cached : %zu\n", misses);
    printf("Eviction success rate: %.2f%%\n",
           (100.0 * hits) / (hits + misses));

    free(data);
}


int main(int argc, char *argv[]){


    timer_init(true, 1);
    uint64_t threshold = calibrate_latency(); // Uncomment this when you are actually doing something

    // Allocate an eviction buffer, aligned
    uint8_t *evict_buf;
    if (posix_memalign((void**)&evict_buf, LINE_SIZE, EVICT_BYTES) != 0) {
        perror("posix_memalign failed");
        exit(1);
    }
    for(size_t i =0; i < EVICT_BYTES; i++){
        evict_buf[i] = (uint8_t) i;
    }

    // how many cache line chunks are there
    size_t num_lines = EVICT_BYTES / LINE_SIZE;

    // pointer array that points to each cache line (Asher's words, you know how there's physical and logical cores? not asher: 128B line size is like the logical cores)
    uint8_t **evict_ptrs = malloc(num_lines * sizeof(uint8_t *));
    if (!evict_ptrs) exit(1);

    for (size_t i = 0; i < num_lines; i++)
        evict_ptrs[i] = evict_buf + (i * LINE_SIZE);

    run_trials(evict_ptrs, num_lines, threshold);    

    return 0;
}