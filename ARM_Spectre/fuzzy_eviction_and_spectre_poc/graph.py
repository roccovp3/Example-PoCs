import os
import pandas as pd
import matplotlib.pyplot as plt

# ---- Config ----
csv_path = "Results/TLB_COLD/100_Reps/Results.csv"

xcol = "reads"          # x-axis column
miss_col = "cache_misses"

# Total accesses per sample (change this to whatever you want)
TOTAL_ACCESSES = 100
# -----------------

# Load CSV
df = pd.read_csv(csv_path)

# Compute cache hits = total - misses
df["cache_hits"] = TOTAL_ACCESSES - df[miss_col]

start_x = 100_000       # first interval start
step = 50_000           # interval width

max_x = int(df[xcol].max())

# Interval edges: [100k, 150k, 200k, ...]
edges = list(range(start_x, max_x + step, step))

# Base name for output files (no extension)
base = os.path.splitext(os.path.basename(csv_path))[0]

# Directory where the CSV lives
csv_dir = os.path.dirname(csv_path)
if csv_dir == "":
    csv_dir = "."  # current dir fallback

# ---------- ONE BIG PLOT WITH ALL DATA ----------
fig_all, ax_all = plt.subplots(figsize=(10, 4))

ax_all.plot(df[xcol], df[miss_col], label="misses")
ax_all.plot(df[xcol], df["cache_hits"], label="hits")

ax_all.set_xlabel("reads")
ax_all.set_ylabel("count")
ax_all.set_title(f"{base}: all data")
ax_all.legend()
ax_all.grid(True, linestyle="--", alpha=0.3)

out_all = os.path.join(csv_dir, f"{base}_all.png")
fig_all.savefig(out_all, dpi=150, bbox_inches="tight")
plt.close(fig_all)
# ------------------------------------------------

# ---------- PER-INTERVAL PLOTS ----------
for idx, s in enumerate(edges[:-1]):
    e = edges[idx + 1]

    # Select data in this interval
    mask = (df[xcol] >= s) & (df[xcol] < e)
    sub = df.loc[mask]

    # Skip empty intervals
    if sub.empty:
        continue

    # One figure per interval
    fig, ax = plt.subplots(figsize=(8, 4))

    ax.plot(sub[xcol], sub[miss_col], label="misses")
    ax.plot(sub[xcol], sub["cache_hits"], label="hits")

    ax.set_xlim(s, e)
    ax.set_xlabel("reads")
    ax.set_ylabel("count")
    ax.set_title(f"{base}: {s:,} – {e:,}")
    ax.legend()
    ax.grid(True, linestyle="--", alpha=0.3)

    # File name inside same directory as CSV
    out_name = os.path.join(csv_dir, f"{base}_{idx:02d}_{s}_{e}.png")
    fig.savefig(out_name, dpi=150, bbox_inches="tight")
    plt.close(fig)

print("Done.")
