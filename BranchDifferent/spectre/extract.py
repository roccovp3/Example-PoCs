#!/usr/bin/env python3
import sys
import re

def extract_leaks_and_times(path):
    leaks = []
    times = []
    prev_nonempty = None

    # Open in binary mode to avoid UnicodeDecodeError
    with open(path, "rb") as f:
        for line in f:
            stripped = line.strip()

            # When we see the "leaked 20 bytes" line, take the previous non-empty line as the leak
            if stripped.startswith(b"leaked 20 bytes"):
                if prev_nonempty is not None:
                    leaks.append(prev_nonempty)

                # extract time in ms from: b"leaked 20 bytes in 10549ms. (1.90 bytes / sec)"
                m = re.search(rb"in\s+(\d+)ms", stripped)
                if m:
                    times.append(int(m.group(1)))

            if stripped:
                prev_nonempty = stripped

    return leaks, times

def main():
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <results.txt> <secret>")
        sys.exit(1)

    results_path = sys.argv[1]
    secret_str = sys.argv[2]

    # Secret as bytes (ASCII/UTF-8 is fine for your "The cake is a lie123")
    secret = secret_str.encode("utf-8")

    leaks, times = extract_leaks_and_times(results_path)

    if not leaks:
        print("No leaked strings found (no lines starting with 'leaked 20 bytes').")
        sys.exit(1)

    bytes_per_run = len(secret)
    total_runs = len(leaks)
    total_positions = bytes_per_run * total_runs

    total_matches = 0

    # Compare each leaked line with the secret, byte by byte
    for leak in leaks:
        # Strip any trailing newlines/spaces in the leaked line itself
        leak_clean = leak.strip()
        # Only compare up to the secret length; shorter leak => remaining bytes = mismatches
        for b_leak, b_secret in zip(leak_clean[:bytes_per_run], secret):
            if b_leak == b_secret:
                total_matches += 1

    total_time_ms = sum(times)

    print(f"total accuracy: {total_matches}/{total_positions}")
    print(f"total time: {total_time_ms} ms")

if __name__ == "__main__":
    main()
