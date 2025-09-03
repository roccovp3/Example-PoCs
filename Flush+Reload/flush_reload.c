#include "../inline_asm.h"
#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <inttypes.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <unistd.h>
#include <x86intrin.h>

#define PAGE_SIZE 4096
#define CACHE_LINE_SIZE 64
#define SYMBOL_CNT (1 << (sizeof(char) * 8))

#define EPOCH_LENGTH 2000000. // A very conservative epoch length

// Message we want to send
const char *msg = "We live in a twilight world";

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

    // Bias the threshold towards the cache miss latency, because the cache
    // hit latency we measured is the L1 latency, while we need the threshold
    // for L3 hits. This is just a heuristic and there are better ways to
    // accurately determine the L3 latency
    threshold = ((3 * miss) + hit) / 4;
    printf("Avg. hit latency: %" PRIu64 ", Avg. miss latency: %" PRIu64
           ", Threshold: %" PRIu64 "\n",
           hit, miss, threshold);
    free(data);
    return threshold;
}

// Busy wait until the timestamp counter passes a certain value
// There's no guarantee on how far we have gone passed the intended value
static inline void busy_wait_until(uint64_t until) {
    while (_rdtsc() < until) {
        __asm__ __volatile__("rep; nop" ::: "memory");
    }
}

// |------------------- Epoch ------------------|
// |-Recv flushes-|-Sender loads-|-Recv reloads-|
//                 ^^^^^^^^^^^^^^
void flush_reload_send(uint64_t start_tsc, size_t msg_len, uint8_t *pages) {
    uint64_t next_transmission = start_tsc + EPOCH_LENGTH / 3;
    for (size_t i = 0; i < msg_len; i++) {
        busy_wait_until(next_transmission);
        next_transmission += EPOCH_LENGTH;

        // Sender transmits the information
        _maccess(pages + (unsigned char)msg[i] * PAGE_SIZE);

        // Print the epoch information
        uint64_t now = _rdtsc();
        uint64_t epoch_id = (now - start_tsc) / EPOCH_LENGTH;
        printf("EPOCH: %" PRIu64 "; Transmitting: '%c' (ASCII=%#x)\n", epoch_id,
               msg[i], msg[i]);
    }
}

// |------------------- Epoch ------------------|
// |-Recv flushes-|-Sender loads-|-Recv reloads-|
//  ^^^^^^^^^^^^^^                ^^^^^^^^^^^^^^
void flush_reload_recv(uint64_t start_tsc, size_t msg_len, uint8_t *pages,
                       uint64_t threshold) {
    uint64_t next_flush = start_tsc,
             next_reload = start_tsc + 2 * EPOCH_LENGTH / 3;
    char *recv_str = calloc(msg_len + 1, sizeof(*recv_str));
    if (!recv_str) {
        printf("Failed to allocate a receiving buffer\n");
        return;
    }
    memset(recv_str, '?', msg_len);

    for (size_t i = 0; i < msg_len; i++) {
        // Receiver flushes
        busy_wait_until(next_flush);
        next_flush += EPOCH_LENGTH;
        for (size_t j = 0; j < SYMBOL_CNT; j++) { // SYMBOL_CNT=256
            _mm_clflush(pages + j * PAGE_SIZE);
        }

        // Receiver waits for transmission
        busy_wait_until(next_reload);
        next_reload += EPOCH_LENGTH;

        // Receiver reloads
        unsigned char raw_c = '\0';
        for (size_t j = 0; j < SYMBOL_CNT; j++) { // SYMBOL_CNT=256
            uint64_t start = _timer_start();
            _maccess(pages + j * PAGE_SIZE);
            uint64_t lat = _timer_end() - start;
            if (lat < threshold) {
                raw_c = j;
                break;
            }
        }

        // Print the results
        uint64_t now = _rdtsc();
        uint64_t epoch_id = (now - start_tsc) / EPOCH_LENGTH;
        if (raw_c) {
            unsigned char c = isprint(raw_c) ? raw_c : '?';
            printf("EPOCH: %" PRIu64 "; Receiving: '%c' (ASCII=%#x)\n", epoch_id,
                   c, raw_c);
            // This check is necessary because "wait_until" can overshoot and
            // skip an epoch
            if (epoch_id < msg_len) {
                recv_str[epoch_id] = c;
            }
        } else {
            printf("EPOCH: %" PRIu64 "; Character unknown\n", epoch_id);
        }
    }

    printf("-----------------------------------------\n");
    printf("Expecting: %s\n", msg);
    printf("Received:  %s\n", recv_str);
    free(recv_str);
}

int main() {
    int ret = 0;
    // Threshold for determining cache hits and misses
    uint64_t threshold = calibrate_latency();
    printf("-----------------------------------------\n");

    // Create read-only shared pages for Flush+Reload
    // SYMBOL_CNT=256
    uint8_t *pages = mmap(NULL, PAGE_SIZE * SYMBOL_CNT, PROT_READ,
                          MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    if (pages == MAP_FAILED) {
        perror("mmap");
        return errno;
    }

    size_t msg_len = strlen(msg);
    uint64_t start_tsc = (_rdtsc() / EPOCH_LENGTH + 10) * EPOCH_LENGTH;
    pid_t pid = fork();
    if (pid == 0) {
        // Child process, used as the sender process
        flush_reload_send(start_tsc, msg_len, pages);
        goto cleanup;
    } else if (pid > 0) {
        // Parent process, used as the receiver process
        flush_reload_recv(start_tsc, msg_len, pages, threshold);
        wait(NULL); // Wait for the child process
    } else {
        perror("fork");
        ret = errno;
        goto cleanup;
    }

cleanup:
    munmap(pages, PAGE_SIZE * SYMBOL_CNT);
    return ret;
}
