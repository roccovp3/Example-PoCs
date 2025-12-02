#ifndef EVICT_H
#define EVICT_H
#include <stdint.h>

void evict(uint32_t set_size);

uint32_t find_eviction_set(void* addr, uint32_t threshold);

#endif