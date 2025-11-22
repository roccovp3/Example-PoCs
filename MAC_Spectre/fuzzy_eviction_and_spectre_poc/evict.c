#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <stdint.h>
#include <time.h>

#include "timer.h"

#define LINE_SIZE 128      // 128B cache line, as you described
#define loop 280000        // not used anymore, but you can delete if unused

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

int main(int argc, char *argv[])
{
    // Seed RNG for shuffle
    srand((unsigned)time(NULL));

    timer_init(true, 1);
    uint64_t threshold = calibrate_latency();

    // 128 MB eviction buffer
    size_t smart_evict_bytes = 128 * 1024 * 1024;
    uint8_t *smart_evict_buf = malloc(smart_evict_bytes);
    if (!smart_evict_buf) {
        perror("malloc smart_evict_buf");
        exit(1);
    }

    // Touch pages to force physical allocation
    for (size_t i = 0; i < smart_evict_bytes; i += 4096)
        smart_evict_buf[i] = 1;

    // Create a pointer array representing each cache line
    size_t num_lines = smart_evict_bytes / LINE_SIZE;  // 128MB / 128B = 1,048,576
    printf("NUM_LINES = %zu\n", num_lines);

    uint8_t **evict_ptrs = malloc(sizeof(uint8_t *) * num_lines);
    if (!evict_ptrs) {
        perror("malloc evict_ptrs");
        exit(1);
    }

    for (size_t i = 0; i < num_lines; i++)
        evict_ptrs[i] = smart_evict_buf + (i * LINE_SIZE);

    // Randomize pointer order
    shuffle_ptrs(evict_ptrs, num_lines);

    uint32_t rep = 1000;  // number of trials per N


    const size_t page_size  = 16384;      // or (size_t)sysconf(_SC_PAGESIZE);
    const size_t cache_line = 128;        // actual cache line size
    const size_t min_gap    = 256;       // at least 256B between data and tlb_ptr

    uint8_t *data_page = NULL;
    if (posix_memalign((void **)&data_page, page_size, page_size) != 0) {
        perror("posix_memalign data_page");
        exit(1);
    }

    // pick a cache-line-aligned offset for data such that data+256 is still in page
    size_t max_data_off = page_size - min_gap - cache_line;
    size_t data_off = (size_t)(rand() % max_data_off);
    data_off &= ~(cache_line - 1);   // align down to cache line boundary

    uint8_t *data    = data_page + data_off;
    uint8_t *tlb_ptr = data + min_gap;   // same page, >= 256B away

    // Give data some value; it will be evicted by the eviction loop anyway
    *data = 42;
    

    // Open results file ONCE, and append all measurements
    FILE *output_file = fopen("Results_TLB_Load1.csv", "w");
    if (!output_file) {
        perror("fopen Results.csv");
        exit(1);
    }

    // Optional CSV header
    fprintf(output_file, "reads,cache_misses\n");

    // Sweep j from 100,000 to 500,000 in steps of 1,000
    for (int j = 100000; j <= 500000; j += 1000) {


     


        int cache_miss = 0;
        int cache_hit  = 0;

        // Sanity check: j must be <= num_lines
        // (in your case: 500,000 < 1,048,576 so it's fine)
        if ((size_t)j > num_lines) {
            fprintf(stderr, "j=%d exceeds num_lines=%zu, stopping.\n", j, num_lines);
            break;
        }

        for (uint32_t n = 0; n < rep; n++) {

            // Evict by iterating j random cache-line addresses
            for (int i = 0; i < j; i++) {
                // evict_ptrs is already shuffled; we just walk the first j entries
                // If you want a different subset each repetition, you could reshuffle here instead.
                touch(evict_ptrs[i]);
            }

            touch(tlb_ptr);



            int time = timer_time_maccess(data);
            if ((uint64_t)time > threshold) {
                cache_miss++;
            } else {
                cache_hit++;
            }
        }

        // Re-shuffle for the next j so we change which lines are in the first j
        shuffle_ptrs(evict_ptrs, num_lines);

        // Log: N (j) and total number of misses across rep trials
        fprintf(output_file, "%d,%d\n", j, cache_miss);
  
    }

    fclose(output_file);

    free(data_page);
    free(evict_ptrs);
    free(smart_evict_buf);

    return 0;
}


uint8_t **evict_ptrs;
size_t smart_evict_bytes;
uint8_t *smart_evict_buf;

void fuzzy_evict()
{
    // Evict by iterating random cache-line addresses
    // Macbook Air M4 - 204000
    // Macbook Pro M4 Pro - 327000
    for (size_t i = 0; i < loop; i++){
        touch(evict_ptrs[i]);
    }
}

void find_fuzzy_eviction_set() {
    smart_evict_bytes = 128 * 1024 * 1024;
    smart_evict_buf = malloc(smart_evict_bytes);
    if (!smart_evict_buf) exit(1);

    // Touch pages to force physical allocation (important!)
    for (size_t i = 0; i < smart_evict_bytes; i += 4096)
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