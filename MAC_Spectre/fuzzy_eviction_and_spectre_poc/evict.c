#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <stdint.h>
#include <time.h>

#include "timer.h"

#define LINE_SIZE 128      // 128B cache line, as you described
#define MIN_SET_SIZE 1000        // not used anymore, but you can delete if unused
#define SET_SIZE_DECREMENT 500

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
    smart_evict_bytes = 20 * 1024 * 1024;
    smart_evict_buf = malloc(smart_evict_bytes);
    if (!smart_evict_buf) exit(1);

    size_t num_lines = smart_evict_bytes / LINE_SIZE;

    evict_ptrs = (uint8_t**)malloc(sizeof(uint8_t*)*(num_lines + (MIN_SET_SIZE*2)));
    printf("a: %d\n", num_lines+2*MIN_SET_SIZE);
    // Create a pointer array representing each cache line
    for (size_t i = 0; i < (num_lines + (MIN_SET_SIZE*2)); i++)
        evict_ptrs[i] = smart_evict_buf + (i * LINE_SIZE);

    uint8_t prev_valid = 0;
    uint32_t set_size = 1 << 17;
    uint32_t prev_set_size = set_size + MIN_SET_SIZE;
    while((set_size > MIN_SET_SIZE) || (!eviction_set_valid)) {
        
        // Randomize pointer order (not bytes)
        shuffle_ptrs(evict_ptrs, prev_set_size);

        prev_valid = eviction_set_valid;
        // Touch pages to force physical allocation (important!)
        for (size_t i = 0; i < smart_evict_bytes; i += 16384)
            smart_evict_buf[i] = 1;

        eviction_set_valid = 0;
        for(int i = 0; i < 3; i++) {
            for (size_t i = 0; i < set_size; i++){
                touch(evict_ptrs[i]);
            }

            eviction_set_valid += timer_time_maccess(addr) > threshold;
        }

        if(eviction_set_valid > 1) {
            printf("Found a set of size %d. Reducing...", set_size);
            prev_set_size = set_size;
            set_size -= SET_SIZE_DECREMENT;
        }
    }   
    return set_size;
}

int main(int argc, char *argv[])
{
    timer_init(0, 0.3);
    uint32_t threshold = calibrate_latency();

    uint8_t* data = (uint8_t*)malloc(sizeof(uint8_t));
    uint32_t set_size = find_eviction_set(data, threshold);

    printf("Done. Eviction set size: %d\n", set_size);

    uint32_t rep = 1000;
    uint32_t hits = 0;
    uint32_t misses = 0;
    uint32_t hit_time;
    uint32_t miss_time;

    for (uint32_t n = 0; n < rep; n++) {  
        volatile uint8_t temp = *data;     
        hit_time = timer_time_maccess(data);
        hits += (hit_time < threshold);
    }

    // Measure cache miss latency
    for (uint32_t n = 0; n < rep; n++) {
        evict(set_size);
        evict(set_size);
        evict(set_size);
        miss_time = timer_time_maccess(data);
        misses += (miss_time >= threshold);
    }

    printf("hits: %d; misses: %d\n", hits, misses);

    return 0;
}