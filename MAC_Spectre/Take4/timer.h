#ifndef TIMER_H
#define TIMER_H

#include <stdbool.h>
#include <stdint.h>
#include <inttypes.h>
#include <stddef.h>

/* --------- Architecture fence used by the timer --------- */
#if defined(__aarch64__)
  #define ISB() __asm__ __volatile__("isb" ::: "memory")
#elif defined(__x86_64__)
  #define ISB() __asm__ __volatile__("lfence" ::: "memory")
#else
  #define ISB() __asm__ __volatile__("" ::: "memory")
#endif

/* ===================== Timer API ===================== */

/* Initialize the two-thread timer (atomic incrementer). If use_affinity is
 * true we ask the OS to put both threads on the same affinity tag (Darwin).
 * calib_seconds controls the calibration window for ticks->ns conversion. */
int      timer_init(bool use_affinity, double calib_seconds);

/* Read the raw monotonic counter (ticks). */
uint64_t timer_now(void);

/* Convert ticks to nanoseconds using the calibrated ratio. */
double   timer_ticks_to_ns(uint64_t ticks);

/* Measure the latency to access *ptr in ticks. Safe, uses ISB fences. */
uint64_t timer_time_maccess(void *ptr);

/* Stop/join timer thread and cleanup. */
void     timer_shutdown(void);

/* ================== Eviction Set Structures ================== */

typedef struct eviction_set {
  void   **lines;         /* array of selected line bases (for debug) */
  size_t   nlines;        /* number of nodes in the list */
  void    *region;        /* owning buffer to free */
  size_t   region_bytes;  /* size of region */
  void    *head;          /* pointer-chase head (node 0) */
} eviction_set_t;

/* ================== Eviction Set Builders ================== */

/* Build an L1-style set for the virtual address (VIPT-Indexed).
 * Connects the selected lines into a NULL-terminated pointer-chase list. */
int evset_build_for_vaddr(eviction_set_t *es,
                          void *victim_addr,
                          size_t nlines,           /* e.g., 8..32 */
                          size_t region_bytes,     /* e.g., 4<<20 */
                          size_t line_size,        /* e.g., 64 */
                          size_t sets,             /* e.g., 128 */
                          bool   randomize_order);

/* Convenience L1 builder with typical defaults (64B line, 128 sets). */
int evset_build_l1_default(eviction_set_t *es,
                           void *victim_addr,
                           size_t nlines,          /* e.g., 16 or 32 */
                           bool   randomize_order);

/* Strict L1 (VIPT) builder: pins VA set congruence and oversubscribes. */
int evset_build_l1_strict(eviction_set_t *es, void *victim_addr,
                          size_t nlines,            /* e.g. 16..32 */
                          size_t region_bytes,      /* e.g. 4<<20 */
                          bool   randomize_order);

/* Adaptive black-box builders for deeper levels (L2/L3/SLC). */
int evset_build_l2_auto_v2(eviction_set_t *es, void *victim_addr,
                           size_t target_ways, size_t region_bytes);
int evset_build_l3_auto_v2(eviction_set_t *es, void *victim_addr,
                           size_t target_ways, size_t region_bytes);

/* (Optional legacy wrappers, still exported for compatibility) */
int evset_build_level_auto(eviction_set_t *es, void *victim_addr,
                           size_t target_ways, size_t region_bytes,
                           size_t line_size, int max_trials,
                           int prune_passes, int randomize_order);
int evset_build_l2_auto(eviction_set_t *es, void *victim_addr,
                        size_t target_ways, size_t region_bytes);
int evset_build_l3_auto(eviction_set_t *es, void *victim_addr,
                        size_t target_ways, size_t region_bytes);

/* ================== Eviction Set Utilities ================== */

/* Traverse the NULL-terminated pointer-chase list once (for testing). */
uint8_t  evset_traverse_once(const eviction_set_t *es);

/* Drive the pointer-chase multiple rounds; useful to increase pressure. */
void     evset_evict_rounds(const eviction_set_t *es, int rounds);

/* Debug dump. */
void     evset_dump(const eviction_set_t *es);

/* Free region + arrays. */
void     evset_free(eviction_set_t *es);

// Shuffle the pointer-chase order (defeats stride prefetch/replacement quirks).
void evset_shuffle(eviction_set_t *es);

// Traverse the eviction set multiple times (no shuffle).
void evset_evict_rounds(const eviction_set_t *es, int rounds);

// Compose a top→down eviction chain: L3 then L2 then L1 (any may be NULL).
void evset_evict_chain(const eviction_set_t *l3, int r3,
                       const eviction_set_t *l2, int r2,
                       const eviction_set_t *l1, int r1,
                       int reshuffle_every);

// Validate that a set actually slows the victim when used at a target “level”.
// - To validate L2: pass level=&l2, below1=&l1 (below2=NULL)
// - To validate L3: pass level=&l3, below1=&l2, below2=&l1
// min_ratio ~1.25 means “slow case ≥ 1.25× baseline”.
int evset_validate_level(const eviction_set_t *level,
                         void *victim,
                         const eviction_set_t *below1,
                         const eviction_set_t *below2,
                         int rounds_level,
                         int rounds_below,
                         int reps,
                         double min_ratio);

#endif /* TIMER_H */
