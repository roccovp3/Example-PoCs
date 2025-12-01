#pragma once

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
#include <mach/mach_time.h>
#include <sys/_pthread/_pthread_t.h>
#include <pthread.h>
#include <stdatomic.h>
#include <time.h>
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <mach/thread_policy.h>


#include "mmap_secret.h"
#include "timer.h"
#include "evict.h"









#define PAGE_SIZE_LOCAL 16384                                // 16 KB Page Size
#define CACHE_LINE_SIZE 128                            // 128B cache line
#define SYMBOL_CNT (1 << (sizeof(char) * 8))           // 128 ASCII Values
#define ISB() __asm__ __volatile__("isb" ::: "memory") // instruction barrier

#define EVICT_SIZE (128 * 1024 * 1024) // size of eviction buffer


// tunable params
#define NUM_ADDRESSES 382000 // this is the number of addresses to read for eviction
#define reps 100
#define mistrain 16