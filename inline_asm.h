#pragma once

// Load from a virtual address "P"
#define _maccess(P)                                                            \
  ({                                                                           \
    typeof(*(P)) _NO_USE;                                                      \
    __asm__ __volatile__("mov (%1), %0\n"                                      \
                         : "=r"(_NO_USE)                                       \
                         : "r"((P))                                            \
                         : "memory");                                          \
  })

// https://github.com/google/highwayhash/blob/master/highwayhash/tsc_timer.h
#define _timer_start()                                                         \
  ({                                                                           \
    unsigned long long t;                                                      \
    __asm__ __volatile__("mfence\n\t"                                          \
                         "lfence\n\t"                                          \
                         "rdtsc\n\t"                                           \
                         "shl $32, %%rdx\n\t"                                  \
                         "or %%rdx, %0\n\t"                                    \
                         "lfence"                                              \
                         : "=a"(t)                                             \
                         :                                                     \
                         : "rdx", "memory", "cc");                             \
    /* "memory" clobber avoids reordering. rdx = TSC >> 32. */                 \
    /* "cc" clobber due to flags modified by SHL.*/                            \
    t;                                                                         \
  })

#define _timer_end()                                                           \
  ({                                                                           \
    unsigned long long t;                                                      \
    __asm__ __volatile__("rdtscp\n\t"                                          \
                         "shl $32, %%rdx\n\t"                                  \
                         "or %%rdx, %0\n\t"                                    \
                         "lfence"                                              \
                         : "=a"(t)                                             \
                         : /* rcx = TSC_AUX. rdx = TSC >> 32 */                \
                         : "rcx", "rdx", "memory", "cc");                      \
    t;                                                                         \
  })

#define _rdtsc()                                                               \
  ({                                                                           \
    unsigned long long t;                                                      \
    __asm__ __volatile__("rdtsc\n\t"                                           \
                         "shl $32, %%rdx\n\t"                                  \
                         "or %%rdx, %0\n\t"                                    \
                         : "=a"(t)::"rdx", "memory", "cc");                    \
    t;                                                                         \
  })
