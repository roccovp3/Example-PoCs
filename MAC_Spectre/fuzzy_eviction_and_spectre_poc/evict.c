#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <stdint.h>




#include "timer.h"

#define EVICT_BYTES 128
#define NUM_ADDRESSES 50
#define loop 380000
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

int total_hits[400] = {0};
int total_hits_index = 0;

int main(int argc, char *argv[])
{
    for(int j = 100000; j < 500000; j += 1000){
        int fail = 0;
        int success_count=0, fail_count=0;
        for(int i = 0; i < 100; i++){
            timer_init(true, 1);
            uint64_t threshold = calibrate_latency();

            size_t smart_evict_bytes = 128 * 1024 * 1024;
            uint8_t *smart_evict_buf = malloc(smart_evict_bytes);
            if (!smart_evict_buf) exit(1);

            // Touch pages to force physical allocation (important!)
            for (size_t i = 0; i < smart_evict_bytes; i += 4096)
                smart_evict_buf[i] = 1;

            // Create a pointer array representing each cache line
            size_t num_lines = smart_evict_bytes / LINE_SIZE;
            // printf("NUM_LINES = %zu\n", num_lines/6);


            uint8_t **evict_ptrs = malloc(sizeof(uint8_t *) * num_lines);
            if (!evict_ptrs) exit(1);

            for (size_t i = 0; i < num_lines; i++)
                evict_ptrs[i] = smart_evict_buf + (i * LINE_SIZE);

            // Randomize pointer order (not bytes)
            shuffle_ptrs(evict_ptrs, num_lines);


            uint64_t hit = 0, miss = 0, rep = 100;
            uint8_t *data = malloc(8);
            if (!data) exit(1);

            
            while (true) {
                miss = 0;

                for (uint32_t n = 0; n < rep; n++) {

                    // Evict by iterating random cache-line addresses
                    // Macbook Air M4 - 204000
                    // Macbook Pro M4 Pro - 330000
                    for (size_t k = 0; k < j; k++){
                        touch(evict_ptrs[k]);
                    }

                    miss += timer_time_maccess(data);
                }
                miss /= rep;
                shuffle_ptrs(evict_ptrs, num_lines);
                // printf("MISS %d: %llu\n", fail, miss);
                
                if (fail == 100) {
                    break;
                }
                if (miss > threshold) {
                    success_count++;
                }
                else{
                    fail_count++;
                }
                fail++;
            }
            // printf("Success Evict = %d\nFail Evict = %d\n", success_count, fail_count);
        }
        total_hits[(j-100000)/1000] = success_count; 
    }
    FILE* file = fopen("Results.txt", "w");
    for(int i = 0; i < 400; i++){
        fprintf(file, "%d, %d\n", i, total_hits[i]);
    }
    
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