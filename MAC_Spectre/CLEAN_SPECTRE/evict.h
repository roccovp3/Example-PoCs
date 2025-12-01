#pragma once
#include "utils.h"


extern unsigned char *evict_buf;

void flush_whole_cache();


void find_fuzzy_eviction_set();
void fuzzy_evict();