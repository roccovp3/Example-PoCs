#pragma once
#include "utils.h"

// Secret in a heap-allocated region (was mmap)
extern const char secret_template[];
extern char *secret_mmap;
extern uint8_t *secret_page;
extern size_t secret_line_idx;
extern size_t secret_len;


void init_secret_on_page(size_t line_idx, bool cross_boundary);
void destroy_secret_page(void);
