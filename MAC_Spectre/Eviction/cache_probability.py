
#!/usr/bin/env python3
import math
import argparse
from typing import List

def log_binom_pmf(n: int, k: int, p: float) -> float:
    if k < 0 or k > n:
        return float('-inf')
    logC = math.lgamma(n + 1) - math.lgamma(k + 1) - math.lgamma(n - k + 1)
    return logC + k * math.log(p) + (n - k) * math.log1p(-p)

def logsumexp(logvals: List[float]) -> float:
    m = max(logvals)
    if m == float('-inf'):
        return m
    return m + math.log(sum(math.exp(v - m) for v in logvals))

def prob_at_least_a(n: int, p: float, a: int) -> float:
    "Return P[X >= a] for X ~ Binomial(n, p). Uses log-space to avoid underflow."
    logs = [log_binom_pmf(n, k, p) for k in range(a, n + 1)]
    return math.exp(logsumexp(logs))

def parse_prob(s: str) -> float:
    "Allow inputs like 1/8192 or 1.922e-50"
    if '/' in s:
        num, den = s.split('/', 1)
        return float(num) / float(den)
    return float(s)

def smart_format(x: float, exp_thresh: int = 3, decimals: int = 2) -> str:
    "Format x with fixed decimals if |exponent| < exp_thresh, else scientific."
    if x == 0.0:
        return f"{0.0:.{decimals}f}"
    e = math.floor(math.log10(abs(x)))
    if -exp_thresh <= e < exp_thresh:
        return f"{x:.{decimals}f}"
    return f"{x:.{decimals}e}"

def prob_at_least_one_run_succeeds(p_run: float, runs: int) -> float:
    "Compute 1 - (1 - p_run)^runs accurately for tiny p_run using expm1/log1p."
    if runs <= 0:
        return 0.0
    return -math.expm1(runs * math.log1p(-p_run))

def main():
    ap = argparse.ArgumentParser(description="Compute P[X >= A] for X ~ Binomial(N, p), plus 'at least one of --runs'.")
    ap.add_argument("N", nargs="*", type=int, help="Trial counts (e.g., 50 60 100 1000). Leave empty if using --direct-per-run.")
    ap.add_argument("--p", default="1/8192", type=parse_prob, help="Per-candidate success probability (default: 1/8192)")
    ap.add_argument("--A", default=16, type=int, help="Threshold A (default: 16)")
    ap.add_argument("--exp-thresh", default=3, type=int, help="Use fixed decimals when |exponent| < this (default: 3)")
    ap.add_argument("--decimals", default=2, type=int, help="Number of decimals in fixed/scientific output (default: 2)")
    ap.add_argument("--runs", type=int, default=None, help="If set, compute probability that at least one of these runs succeeds.")
    ap.add_argument("--direct-per-run", dest="direct_per_run", type=parse_prob, default=None, help="If set, use this per-run success probability directly (e.g., 1.922e-50) to compute 'at least one of --runs'.")

    args = ap.parse_args()
    fmt = lambda x: smart_format(x, args.exp_thresh, args.decimals)

    if args.N:
        print(f"p = {args.p}  A = {args.A}")
        for n in args.N:
            p_run = prob_at_least_a(n, args.p, args.A)
            line = f"N = {n:>6}  P[X >= {args.A}] = {fmt(p_run)}"
            if args.runs is not None:
                p_any = prob_at_least_one_run_succeeds(p_run, args.runs)
                line += f"   |   P(at least 1 of {args.runs}) = {fmt(p_any)}"
            print(line)

    if args.direct_per_run is not None:
        if args.runs is None:
            print(f"direct per-run = {fmt(args.direct_per_run)}   |   (set --runs to compute multi-run probability)")
        else:
            p_any = prob_at_least_one_run_succeeds(args.direct_per_run, args.runs)
            print(f"direct per-run = {fmt(args.direct_per_run)}   |   P(at least 1 of {args.runs}) = {fmt(p_any)}")

if __name__ == "__main__":
    main()
