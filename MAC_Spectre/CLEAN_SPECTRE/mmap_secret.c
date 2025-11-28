#include "mmap_secret.h"

// Secret on mmap region
const char secret_template[] = "The cake is a lie!";
char *secret_mmap = NULL;         // will point inside secret_page
uint8_t *secret_page = NULL; // base of mmap'ed page
size_t secret_line_idx = 0;
size_t secret_len = sizeof(secret_template) - 1; // without '\0'

void init_secret_on_page(size_t line_idx, bool cross_boundary)
{
    

    // mmap a single page (doing 4KB incase page size actually isn't 16KB as sysconf says)
    secret_page = mmap(NULL, PAGE_SIZE_LOCAL >> 2,
                       PROT_READ | PROT_WRITE,
                       MAP_PRIVATE | MAP_ANONYMOUS,
                       -1, 0);
    if (secret_page == MAP_FAILED) {
        perror("mmap secret_page");
        exit(1);
    }

    size_t max_offset   = (PAGE_SIZE_LOCAL >> 2) - (secret_len + 1); // keep entire string in page
    size_t nr_lines     = (PAGE_SIZE_LOCAL >> 2) / CACHE_LINE_SIZE;
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
                    "Cannot place secret at line %zu without leaving page\n",
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

        // Clamp so we stay within [line_idx * line_size, PAGE_SIZE_LOCAL)
        size_t min_offset = line_idx * CACHE_LINE_SIZE;
        if (offset < min_offset) {
            offset = min_offset;
        }

        if (offset > max_offset) {
            fprintf(stderr,
                    "Cannot place secret across line %zu without leaving page\n",
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
    secret_mmap  = (char *)(secret_page + offset);

    // Copy secret into that position (including '\0')
    // I don't trust mem copy since that loads entire pages into cache which can mess up uarch
    for(int i = 0; i < secret_len + 1; i++){
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
    if (secret_page) {
        munmap(secret_page, PAGE_SIZE_LOCAL>>2);
        secret_page = NULL;
        secret_mmap      = NULL;
    }
}