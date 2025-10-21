#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
#include <string.h>
#include <inttypes.h>
#include <sys/mman.h>
#include <unistd.h>

#define BUFFER_MB   256UL
#define PAGE_SIZE   4096UL
#define CACHE_LINE  64UL
#define TRIALS      10
#define EVICT_THRESHOLD_NS 150

// ---------- Architecture-specific timers ----------

#if defined(__x86_64__) || defined(__i386__)
// Intel/AMD RDTSC timer
static inline uint64_t read_timer(void) {
    unsigned hi, lo;
    asm volatile("rdtsc" : "=a"(lo), "=d"(hi));
    return ((uint64_t)hi << 32) | lo;
}
static inline uint64_t ticks_per_second(void) {
    // crude fallback using clock_gettime
    struct timespec t0, t1;
    uint64_t c0 = read_timer();
    clock_gettime(CLOCK_MONOTONIC_RAW, &t0);
    usleep(100000);
    uint64_t c1 = read_timer();
    clock_gettime(CLOCK_MONOTONIC_RAW, &t1);
    double dt = (t1.tv_sec - t0.tv_sec) + (t1.tv_nsec - t0.tv_nsec)/1e9;
    return (uint64_t)((c1 - c0) / dt);
}
#elif defined(__aarch64__)
// ARM Generic Timer
static inline uint64_t read_timer(void) {
    uint64_t v;
    __asm__ volatile("mrs %0, cntvct_el0" : "=r"(v));
    return v;
}
static inline uint64_t ticks_per_second(void) {
    uint64_t f;
    __asm__ volatile("mrs %0, cntfrq_el0" : "=r"(f));
    return f;
}
#else
// Fallback to monotonic clock
static inline uint64_t read_timer(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC_RAW, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + ts.tv_nsec;
}
static inline uint64_t ticks_per_second(void) { return 1000000000ULL; }
#endif

// ---------- Helpers ----------

static inline double ticks_to_ns(uint64_t ticks, uint64_t freq) {
    return (1e9 * (double)ticks) / (double)freq;
}

static inline uint64_t median(uint64_t *vals, int n) {
    for (int i=0;i<n-1;i++)
        for (int j=i+1;j<n;j++)
            if (vals[j]<vals[i]) {uint64_t t=vals[i];vals[i]=vals[j];vals[j]=t;}
    return vals[n/2];
}

// Touch memory to ensure load
static inline void touch_addr(void *addr) {
    volatile uint8_t tmp = *(volatile uint8_t*)addr;
    (void)tmp;
}

// Measure latency of one load
static uint64_t measure_load(void *addr, uint64_t freq) {
    uint64_t t0 = read_timer();
    touch_addr(addr);
    uint64_t t1 = read_timer();
    return (t1 - t0);
}

// ---------- Eviction measurement ----------

static uint64_t measure_after(void **set, size_t n, void *target, uint64_t freq) {
    uint64_t vals[TRIALS];
    for (int t=0; t<TRIALS; ++t) {
        for (size_t i=0; i<n; ++i) touch_addr(set[i]);
        vals[t] = measure_load(target, freq);
    }
    return median(vals, TRIALS);
}

// ---------- Main ----------

int main(void) {
    uint64_t freq = ticks_per_second();
    printf("Detected timer frequency: %.3f MHz\n", freq/1e6);

    size_t pages = (BUFFER_MB * 1024 * 1024) / PAGE_SIZE;
    size_t buf_size = pages * PAGE_SIZE;

    void *buf = mmap(NULL, buf_size, PROT_READ | PROT_WRITE,
                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (buf == MAP_FAILED) { perror("mmap"); return 1; }
    memset(buf, 0xA5, buf_size);

    size_t offset = 128 & ~(CACHE_LINE-1);
    void *target = (uint8_t*)buf + offset;

    printf("Buffer: %lu MB, pages: %zu, page size: %lu\n",
           BUFFER_MB, pages, PAGE_SIZE);
    printf("Target address: %p (offset %zu)\n", target, offset);

    void **cand = malloc(sizeof(void*) * pages);
    size_t cand_n = 0;
    for (size_t i=0; i<pages; ++i)
        cand[cand_n++] = (uint8_t*)buf + i*PAGE_SIZE + offset;

    uint64_t base_t[TRIALS];
    for (int i=0; i<TRIALS; ++i)
        base_t[i] = measure_load(target, freq);
    uint64_t base_ticks = median(base_t, TRIALS);
    double base_ns = ticks_to_ns(base_ticks, freq);
    printf("Baseline load latency: %.2f ns\n", base_ns);

    void **working = malloc(sizeof(void*) * cand_n);
    size_t working_n = 0;

    for (size_t ci=0; ci<cand_n; ++ci) {
        if (cand[ci] == target) continue;
        working[working_n] = cand[ci];
        uint64_t meas = measure_after(working, working_n+1, target, freq);
        double ns = ticks_to_ns(meas, freq);
        if (ns > base_ns + EVICT_THRESHOLD_NS) {
            working_n++;
            printf("Added %p → %.1f ns (set size %zu)\n",
                   cand[ci], ns, working_n);
        }
        if (working_n >= 32) break;
    }

    printf("\nLikely eviction set (%zu addresses):\n", working_n);
    for (size_t i=0; i<working_n; ++i)
        printf("  %p\n", working[i]);

    munmap(buf, buf_size);
    free(cand);
    free(working);
    return 0;
}
