#pragma once

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