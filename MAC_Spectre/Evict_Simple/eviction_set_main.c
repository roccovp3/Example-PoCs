#include "arch.h"
#include "eviction_set.h"
#include "eviction_set_generation.h"
#include <assert.h>
#include <stdio.h>
#include <stdbool.h>
#include "timer.h"

// this main will return you the eviction set. Run it with the run_cmd function
// guess, make argv[1], the malicious address
char *main(int argc, char *argv[]) {
    assert(argc > 1 && "I need the malicious address");

    if (timer_init(true, 0.2) != 0) {
        fprintf(stderr, "timer_init failed\n");
        return (char *)1;
    }

    uint64_t secret_address = strtoul(argv[1], NULL, 16);

    // L1 Eviction set
    cache_line_set_t *L1_evict =
        find_L1_congruent_cache_lines((uint8_t *)secret_address, PAGE_SIZE);

    print_cache_line_set(L1_evict);
    fprintf(stdout, "Done finding L1 eviction set.\n");


    // L2 Eviction set
    cache_line_set_t *l2_congruent_cache_lines_1 =
        find_L2_eviction_set_using_timer((uint8_t *)secret_address);

    print_cache_line_set(l2_congruent_cache_lines_1);
    fprintf(stdout, "Done finding first half of L2 eviction set.\n");
    
    cache_line_set_t *l2_congruent_cache_lines_2 =
        find_L2_eviction_set_using_timer((uint8_t *)secret_address);

    cache_line_set_t *l2_congruent_cache_lines = merge_two_cache_line_sets(
        l2_congruent_cache_lines_1, l2_congruent_cache_lines_2);

    // L3 Eviction Set

    return (char *)l2_congruent_cache_lines;
    return 0;
}
