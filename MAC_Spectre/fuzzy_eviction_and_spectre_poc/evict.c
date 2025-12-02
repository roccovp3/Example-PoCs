#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <stdint.h>
#include <time.h>

#include "timer.h"

#define LINE_SIZE 128
#define MIN_SET_SIZE 1000
#define SET_SIZE_DECREMENT 1

// Fisher-Yates Shuffle
void shuffle_ptrs(uint8_t **array, size_t n)
{
    for (size_t i = 0; i < n - 1; i++) {
        size_t j = i + rand() / (RAND_MAX / (n - i) + 1);
        uint8_t *tmp = array[j];
        array[j] = array[i];
        array[i] = tmp;
    }
}

uint8_t **evict_ptrs;
size_t smart_evict_bytes;
uint8_t *smart_evict_buf;

void evict(uint32_t set_size)
{
    for(int i = 0; i < set_size; i++) {
        volatile uint8_t temp = *evict_ptrs[i];
    }
}

uint32_t find_eviction_set(void* addr, uint32_t threshold) {
    uint8_t eviction_set_valid = 0;
    smart_evict_bytes = 128 * 1024 * 1024;
    smart_evict_buf = malloc(smart_evict_bytes);
    if (!smart_evict_buf) exit(1);

    size_t num_lines = smart_evict_bytes / LINE_SIZE;

    uint8_t **candidate_evict_ptrs = (uint8_t**)malloc(sizeof(uint8_t*)*(num_lines));
    evict_ptrs = (uint8_t**)malloc(sizeof(uint8_t*)*(num_lines));

    // Create a pointer array representing each cache line
    for (size_t i = 0; i < num_lines; i++)
        candidate_evict_ptrs[i] = smart_evict_buf + (i * LINE_SIZE);

    // 1. Shuffle all pointers
    shuffle_ptrs(candidate_evict_ptrs, num_lines);

    // 2. Add addresses until secret evicted.
    uint32_t set_size = 0;
    uint32_t candidate_index = 0;
    uint8_t secret_evicted = 0;
    while(candidate_index < num_lines) {
        evict_ptrs[set_size] = candidate_evict_ptrs[candidate_index];
        set_size++, candidate_index++;

        // Check if secret was evicted
        eviction_set_valid = 0;
        for(int i = 0; i < 10; i++) {
            for (size_t i = 0; i < set_size; i++){
                touch(evict_ptrs[i]);
            }

            eviction_set_valid += timer_time_maccess(addr) > threshold;            
        }

        // 3. If secret was evicted by adding the last address, remove it.
        if(eviction_set_valid > 6) {
            evict_ptrs[set_size-1] = 0;
            set_size--;
        }
    }
    return set_size;
}

uint32_t find_eviction_set_build(void* addr, uint32_t threshold) {
    uint8_t eviction_set_valid = 0;
    smart_evict_bytes = 20 * 1024 * 1024;
    smart_evict_buf = malloc(smart_evict_bytes);
    if (!smart_evict_buf) exit(1);

    size_t num_lines = smart_evict_bytes / LINE_SIZE;

    evict_ptrs = (uint8_t**)malloc(sizeof(uint8_t*)*(num_lines + (MIN_SET_SIZE*2)));

    uint32_t set_size = 1;

    for(int j = 0; j < 10; j++) {
        for (size_t i = 0; i < set_size; i++){
            touch(evict_ptrs[i]);
        }

        eviction_set_valid += timer_time_maccess(addr) > threshold;

        if(eviction_set_valid < 0) {
            printf("Found a set of size %d. Reducing...\n", set_size);
            fflush(stdout);
        }
    }
    
    return set_size;
}

int main(int argc, char *argv[])
{
    timer_init(0, 0.3);
    uint8_t* data = (uint8_t*)malloc(sizeof(uint8_t)*LINE_SIZE*16);

    uint32_t threshold = calibrate_latency();

    uint8_t* array_index = (uint8_t*)malloc(sizeof(uint8_t)*LINE_SIZE*16);
    uint32_t set_size = find_eviction_set(data, threshold);

    printf("Done. Eviction set size: %d\n", set_size);

    uint32_t rep = 1000;
    uint32_t hits = 0;
    uint32_t misses = 0;
    uint32_t array_index_misses = 0;
    uint32_t hit_time;
    uint32_t miss_time;

    // Measure cache miss latency
    for (uint32_t n = 0; n < rep; n++) {
        evict(set_size);
        hit_time = timer_time_maccess(data);
        hits += (hit_time < threshold);

        touch(array_index);
        evict(set_size);
        miss_time = timer_time_maccess(array_index);
        array_index_misses += (miss_time >= threshold);
    }

    printf("data_hits: %d, array_index_misses: %d\n", hits, array_index_misses);

    return 0;
}