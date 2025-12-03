#ifndef EVICT_H
#define EVICT_H
#include <stdint.h>

void fuzzy_evict();

void shuffle_ptrs_ext();

void find_fuzzy_eviction_set();

#endif