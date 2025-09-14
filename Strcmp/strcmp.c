#include "../inline_asm.h"
#include "../color.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include <string.h>
#include <x86intrin.h>

const char *secret = "528491";

int u64_compare(const void *_a, const void *_b) {
    uint64_t a = *(uint64_t *)_a, b = *(uint64_t *)_b;
    if (a < b) return -1;
    else if (a == b) return 0;
    else return 1;
}

uint64_t calc_median(uint64_t *data, size_t len) {
    assert(len >= 1);
    qsort(data, len, sizeof(*data), u64_compare);
    if (len % 2) {
        return data[len / 2];
    } else {
        return (data[len / 2] + data[len / 2 - 1]) / 2;
    }
}

// Naive strncmp for demonstration purpose only
int naive_strncmp(const char *s1, const char *s2, size_t n) {
    for (size_t i = 0; i < n && s1[i] && s2[i]; i++) {
        if (s1[i] != s2[i]) return 0;
        _mm_lfence(); // Artificially serialize iterations to amplify the signal
    }
    return 1;
}

#define REP 10000000
#define BUF_LEN 10
#define THRESHOLD 5

int main() {
    char *guess = calloc(BUF_LEN, sizeof(*guess));
    uint64_t *lats = calloc(REP, sizeof(*lats));
    assert(guess && lats);

    for (size_t i = 0; i < BUF_LEN; i++) {
        size_t longest = 0, shortest = SIZE_MAX;
        char guess_char = '\0';
        for (size_t g = 0; g < 10; g++) { // 10 digits
            guess[i] = '0' + g;
            for (size_t c = 0; c < REP; c++) {
                uint64_t start = _timer_start();
                int ret = naive_strncmp(secret, guess, 12);
                uint64_t lat = _timer_end() - start;
                lats[c] = lat;

                // Prevent compiler from optimizing away strncmp
                __asm__ __volatile__("xor %0, %0\n\t"
                                     : "=r"(ret)
                                     : "r"(ret)
                                     : "memory");
            }

            uint64_t median = calc_median(lats, REP);
            if (median > longest) {
                longest = median;
                guess_char = guess[i];
            }

            if (median < shortest) {
                shortest = median;
            }

            printf("\rIndex %lu; Guessing %lu; Median latency: %3lu | " RED_F
                   "Longest: %3lu; Shortest: %3lu; Best guess %c " RESET_C,
                   i, g, median, longest, shortest, guess_char);
            fflush(stdout);
        }

        if (longest - shortest >= THRESHOLD) {
            printf(GREEN_F"| Final guess: %c\n"RESET_C, guess_char);
            guess[i] = guess_char;
        } else {
            printf(GREEN_F"| Secret string terminated\n"RESET_C);
            guess[i] = '\0';
            break;
        }
    }
    printf("Secret = %s;\nGuessed secret = %s\n", secret, guess);

    free(guess);
    free(lats);
    return 0;
}
