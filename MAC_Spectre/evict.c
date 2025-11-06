#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include "timer.h"

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

void fuzzy_evict()
{
    // Evict by iterating random cache-line addresses
    // Macbook Air M4 - 204000
    // Macbook Pro M4 Pro - 327000
    for (size_t i = 0; i < 327000; i++){
        touch(evict_ptrs[i]);
    }
}

void find_fuzzy_eviction_set() {
    smart_evict_bytes = 128 * 1024 * 1024;
    smart_evict_buf = malloc(smart_evict_bytes);
    if (!smart_evict_buf) exit(1);

    // Touch pages to force physical allocation (important!)
    for (size_t i = 0; i < smart_evict_bytes; i += 16384)
        smart_evict_buf[i] = 1;

    // Create a pointer array representing each cache line
    size_t num_lines = smart_evict_bytes / LINE_SIZE;
    evict_ptrs = malloc(sizeof(uint8_t *) * num_lines);
    if (!evict_ptrs) exit(1);

    for (size_t i = 0; i < num_lines; i++)
        evict_ptrs[i] = smart_evict_buf + (i * LINE_SIZE);

    // Randomize pointer order (not bytes)
    shuffle_ptrs(evict_ptrs, num_lines);
}
