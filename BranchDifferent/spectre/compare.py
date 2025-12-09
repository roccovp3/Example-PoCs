#!/usr/bin/env python3
import sys
from fractions import Fraction

def read_file(path):
    with open(path, "r", encoding="utf-8") as f:
        return f.read().strip()

def char_accuracy(a, b):
    max_len = max(len(a), len(b))
    a = a.ljust(max_len)
    b = b.ljust(max_len)

    matches = [a[i] == b[i] for i in range(max_len)]
    match_count = sum(matches)
    accuracy = match_count / max_len
    return a, b, matches, match_count, max_len, accuracy

def visual_diff(a, b, matches):
    # Create three lines: input, expected, match indicators
    line1 = "Input:    " + " ".join(a)
    line2 = "Expected: " + " ".join(b)
    line3 = "Match:    " + " ".join('^' if m else '.' for m in matches)
    return line1 + "\n" + line2 + "\n" + line3

def main():
    if len(sys.argv) != 3:
        print("Usage: python compare.py <string> <file>")
        sys.exit(1)

    input_str = sys.argv[1]
    file_content = read_file(sys.argv[2])

    a, b, matches, match_count, total, accuracy = char_accuracy(input_str, file_content)
    frac = Fraction(match_count, total)

    print(visual_diff(a, b, matches))
    print()
    print(f"Matched characters: {match_count}/{total}")
    print(f"Accuracy: {accuracy:.4f} ({frac})")

if __name__ == "__main__":
    main()
