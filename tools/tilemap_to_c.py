#!/usr/bin/env python3
"""Convert CSV tilemap to level_data.h for Super Mario DE10."""
import argparse
import csv

TILE_NAMES = {
    ".": 0, "g": 1, "b": 2, "q": 3, "P": 4, "p": 5, "c": 6, "u": 7
}

def main():
    p = argparse.ArgumentParser()
    p.add_argument("csv_file")
    p.add_argument("-o", "--output", default="level_data.h")
    p.add_argument("--width", type=int, default=200)
    args = p.parse_args()

    rows = []
    with open(args.csv_file, newline="") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            cells = line.split(",") if "," in line else list(line)
            row = [TILE_NAMES.get(c, 0) for c in cells]
            while len(row) < args.width:
                row.append(0)
            rows.append(row[:args.width])

    with open(args.output, "w") as f:
        f.write("/* Generated from " + args.csv_file + " */\n")
        for i, row in enumerate(rows):
            f.write(",".join(str(v) for v in row))
            if i < len(rows) - 1:
                f.write(",\n")
            else:
                f.write("\n")
    print("Wrote", args.output, "(%d rows)" % len(rows))

if __name__ == "__main__":
    main()
