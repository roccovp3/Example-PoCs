#include "mmap_secret.h"

// Secret on heap region (was mmap)
const char secret_template[] = "The cake is a lie!";
char *secret_mmap = NULL;          // points inside secret_page
uint8_t *secret_page = NULL;       // "base" of our aligned region
size_t secret_line_idx = 0;
size_t secret_len = sizeof(secret_template) - 1; // without '\0'

static uint8_t *secret_alloc_base = NULL;  // raw malloc pointer
static size_t   secret_alloc_size = 0;

void init_secret_on_page(size_t line_idx, bool cross_boundary)
{
    // If we already had a secret region, free it first.
    if (secret_alloc_base) {
        free(secret_alloc_base);
        secret_alloc_base = NULL;
        secret_page = NULL;
        secret_mmap = NULL;
        secret_alloc_size = 0;
    }

    // We previously used PAGE_SIZE_LOCAL >> 2 as the mapping size (4 KiB if 16 KiB page).
    const size_t page_bytes = PAGE_SIZE_LOCAL >> 2;

    // Allocate a bit extra so we can align to CACHE_LINE_SIZE.
    const size_t alloc_size = page_bytes + CACHE_LINE_SIZE;
    secret_alloc_base = (uint8_t *)malloc(alloc_size);
    if (!secret_alloc_base) {
        perror("malloc secret_page");
        exit(1);
    }
    secret_alloc_size = alloc_size;

    // Align secret_page to a CACHE_LINE_SIZE boundary within the allocated block.
    uintptr_t raw = (uintptr_t)secret_alloc_base;
    uintptr_t aligned = (raw + (CACHE_LINE_SIZE - 1)) & ~(uintptr_t)(CACHE_LINE_SIZE - 1);
    secret_page = (uint8_t *)aligned;

    // Ensure we still have at least page_bytes usable from secret_page.
    if (secret_page + page_bytes > secret_alloc_base + secret_alloc_size) {
        // Fallback: use unaligned base; still contiguous.
        secret_page = secret_alloc_base;
    }

    // Same layout logic as before, but over the heap region instead of an mmap'd page.
    size_t max_offset   = page_bytes - (secret_len + 1); // keep entire string in region
    size_t nr_lines     = page_bytes / CACHE_LINE_SIZE;
    size_t offset       = 0;

    if (!cross_boundary) {
        // Old behavior: start exactly on a cache-line boundary
        if (line_idx >= nr_lines) {
            fprintf(stderr,
                    "Requested line index %zu is too large; max line is %zu\n",
                    line_idx, nr_lines - 1);
            exit(1);
        }

        offset = (line_idx * CACHE_LINE_SIZE);

        if (offset > max_offset) {
            fprintf(stderr,
                    "Cannot place secret at line %zu without leaving region\n",
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
        size_t boundary   = (line_idx + 1) * CACHE_LINE_SIZE;
        offset            = boundary - secret_len / 2;

        // Clamp so we stay within [line_idx * line_size, page_bytes)
        size_t min_offset = line_idx * CACHE_LINE_SIZE;
        if (offset < min_offset) {
            offset = min_offset;
        }

        if (offset > max_offset) {
            fprintf(stderr,
                    "Cannot place secret across line %zu without leaving region\n",
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
    secret_mmap     = (char *)(secret_page + offset);

    // Copy secret into that position (including '\0').
    // Avoid memcpy on purpose to reduce extra cache noise.
    for (size_t i = 0; i < secret_len + 1; i++) {
        secret_mmap[i] = secret_template[i];
    }

    printf("Secret_page base = %p, secret = %p (line %zu, %s boundary)\n",
           (void*)secret_page,
           (void*)secret_mmap,
           secret_line_idx,
           cross_boundary ? "straddling" : "aligned to");
}

void destroy_secret_page(void)
{
    if (secret_alloc_base) {
        free(secret_alloc_base);
        secret_alloc_base = NULL;
    }
    secret_page = NULL;
    secret_mmap = NULL;
    secret_line_idx = 0;
}
