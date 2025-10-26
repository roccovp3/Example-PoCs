#ifndef TIMER_H
#define TIMER_H

#include <stdbool.h>
#include <stdint.h>
#include <inttypes.h>
#include <stddef.h>
#if defined(__aarch64__)
  #define ISB() __asm__ __volatile__("isb" ::: "memory")
#elif defined(__x86_64__)
  #define ISB() __asm__ __volatile__("lfence" ::: "memory")
#else
  #define ISB() __asm__ __volatile__("" ::: "memory")
#endif


// Initialize the two-thread timer. If use_affinity is true the code will
// ask the OS to place both threads on the same affinity tag (Darwin specific).
// calib_seconds controls how long the calibration window is (e.g. 0.2).
int timer_init(bool use_affinity, double calib_seconds);

// Read the raw counter ticks (monotonic, incremented by background thread).
uint64_t timer_now(void);

// Convert a tick count (difference) to nanoseconds using calibration.
double timer_ticks_to_ns(uint64_t ticks);

// Measure the access latency (in ticks) to a pointer by reading the timer
// before and after accessing *ptr. Useful for microbenchmarks on memory you
// own.
uint64_t timer_time_maccess(void *ptr);


typedef struct eviction_set {
  void   **lines;         // array of selected line bases (for debug/inspection)
  size_t   nlines;        // number of nodes in the list
  void    *region;        // owning buffer to free
  size_t   region_bytes;  // size of region
  void    *head;          // pointer-chase head (node 0)
} eviction_set_t;

// Build an L1-style eviction set for the virtual address victim_addr.
// Picks 'nlines' congruent cache lines from an internally-allocated region,
// connects them into a NULL-terminated pointer-chase list (head in es->head).
// Returns 0 on success.
int evset_build_for_vaddr(eviction_set_t *es,
                          void *victim_addr,
                          size_t nlines,           // e.g., 8..16
                          size_t region_bytes,     // e.g., 4<<20
                          size_t line_size,        // e.g., 64
                          size_t sets,             // e.g., 128
                          bool   randomize_order); // shuffles candidate order

// Convenience: defaults for typical L1D (64B line, 128 sets, 8-way).
int evset_build_l1_default(eviction_set_t *es,
                           void *victim_addr,
                           size_t nlines,          // e.g., 8 or 16
                           bool   randomize_order);



// Heuristic "black-box" builder (no physical addresses needed).
// Builds a NULL-terminated pointer-chase list whose traversal tends to evict
// 'victim_addr' from the target level. Returns 0 on success, <0 on failure.
int evset_build_level_auto(eviction_set_t *es,
                           void *victim_addr,
                           size_t target_ways,      // desired cardinality, e.g. 8, 12, 16
                           size_t region_bytes,     // e.g. 16<<20 for L2, 64<<20 for L3
                           size_t line_size,        // usually 64
                           int    max_trials,       // e.g. 25
                           int    prune_passes,     // e.g. 3
                           int    randomize_order); // nonzero to shuffle candidates

// Convenience wrappers with reasonable defaults.
int evset_build_l2_auto(eviction_set_t *es, void *victim_addr,
                        size_t target_ways, size_t region_bytes);
int evset_build_l3_auto(eviction_set_t *es, void *victim_addr,
                        size_t target_ways, size_t region_bytes);

void evset_free(eviction_set_t *es);

// Optional: C traversal (useful for testing)
uint8_t evset_traverse_once(const eviction_set_t *es);

void evset_dump(const eviction_set_t *es);


// Stop/join timer thread and cleanup.
void timer_shutdown(void);


// Strict L1 (VIPT) builder that pins virtual set congruence and oversubscribes.
int evset_build_l1_strict(eviction_set_t *es, void *victim_addr,
                          size_t nlines,   // e.g. 16..32 (oversubscribe > 8)
                          size_t region_bytes, // e.g. 4<<20
                          bool randomize_order);

// Improved L2/L3 black-box builders (adaptive thresholds + robust pruning)
int evset_build_l2_auto_v2(eviction_set_t *es, void *victim_addr,
                           size_t target_ways, size_t region_bytes);
int evset_build_l3_auto_v2(eviction_set_t *es, void *victim_addr,
                           size_t target_ways, size_t region_bytes);

// Drive the eviction set for N rounds (pointer-chase multiple times).
void evset_evict_rounds(const eviction_set_t *es, int rounds);


#endif // TIMER_H
