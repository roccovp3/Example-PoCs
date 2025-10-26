#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <sys/mman.h>
#include <string.h>
#include <ctype.h>

#include "timer.h"
#include "eviction_set.h"
#include <stddef.h>

#define PAGE_SIZE 4096 * 4
#define CACHE_LINE_SIZE 64
#define SYMBOL_CNT (1 << (sizeof(char) * 8))

// ====== The evil attacker code ======
#define REP 100 // Number of repetitions to de-noise the channel
#define TRAINING_EPOCH 16 // 15 in-bound accesses then 1 out-of-bound access
#define BUF_SIZE 20


// ====== Below is a common Spectre "PoC" ======
uint8_t array[8] = {0, 1, 2, 3, 4, 5, 6, 7};
volatile size_t array_size = 8;

// The secret information
char *secret;

// __attribute__((used, section("__DATA,__mydata"))) uint8_t array[8] = {0,1,2,3,4,5,6,7};
// __attribute__((used, section("__DATA,__mydata"))) char secret[] = "The cake is a lie!";




// Branchless select based on the predicate (covered in class)
inline size_t csel(size_t T, size_t F, bool pred) {
    size_t mask = -(size_t)(!!pred); // Need to collapse "pred" to 0/1
    return (T & mask) | (F & ~mask);
    // return F ^ ((T ^ F) & mask);  // This also works and should be a bit faster
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
    printf("Best guess: '%c' (ASCII=%#4x, #hits=%" PRIu64 "); "
           "2nd best guess: '%c' (ASCII=%#4x, #hits=%"  PRIu64 ")\n",
           *c, *c, most_hits, scd_c, scd_raw_c, scd_most_hits);
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

    

    return;
}

int main(){

    // Initialize our timer
    if(timer_init(true, 1) != 0){
        perror("timer_init");
        exit(-1);
    }
    calibrate_latency();
    // this is how I can force secret-array to be positive
    secret  = strdup("The cake is a lie!"); 
   // Page Initialization
    naive_attacker();


    // uint64_t hits[SYMBOL_CNT] = { 0 };
    // char buf[BUF_SIZE] = { '\0' };

    // // Pages for Flush+Reload
    // uint8_t *pages = mmap(NULL, PAGE_SIZE * SYMBOL_CNT, PROT_READ | PROT_WRITE,
    //                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    // if (pages == MAP_FAILED) { perror("mmap"); exit(-1); }
    // memset(pages, 1, PAGE_SIZE * SYMBOL_CNT);
    // size_t stride = PAGE_SIZE;

    // /* --- minimal addition: place array then secret in one region --- */
    // size_t region_size = PAGE_SIZE * 2;
    // uint8_t *region = mmap(NULL, region_size, PROT_READ | PROT_WRITE,
    //                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    // if (region == MAP_FAILED) { perror("mmap region"); munmap(pages, PAGE_SIZE * SYMBOL_CNT); exit(-1); }
    // memset(region, 0, region_size);

    // /* If array/secret are already declared as pointers elsewhere, drop the types here. */
    // uint8_t *array = region;                     // array at base
    // char *secret   = (char *)(region + PAGE_SIZE); // secret one page above
    // strncpy(secret, "The cake is a lie!", BUF_SIZE - 1);
    // /* --- end minimal addition --- */

    // size_t malicious_index = (uintptr_t)secret - (uintptr_t)array;  // now positive
    // printf("Secret address: %p, Array address: %p\n", secret, array);
    // printf("The malicious index is %p-%p=%#zx\n", secret, array, malicious_index);
    // printf("-----------------------------------------\n");
    
 
    // Construct Eviction Sets...


    



    return 0;
}