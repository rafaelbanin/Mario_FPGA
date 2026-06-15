#!/usr/bin/env python3
"""Convert a text sprite definition to C array header."""
import argparse
import sys

def main():
    p = argparse.ArgumentParser(description="Generate sprite C array from hex rows")
    p.add_argument("name", help="sprite variable name")
    p.add_argument("rows", nargs="+", help="hex row values e.g. 0x3C")
    p.add_argument("-o", "--output", default="-")
    args = p.parse_args()

    lines = [f"const uint8_t {args.name}[16] = {{"]
    for i, row in enumerate(args.rows[:16]):
        val = int(row, 0)
        lines.append(f"    0x{val:02X},")
    while len(args.rows) < 16:
        lines.append("    0x00,")
        args.rows.append("0")
    lines.append("};")

    out = "\n".join(lines) + "\n"
    if args.output == "-":
        sys.stdout.write(out)
    else:
        with open(args.output, "w") as f:
            f.write(out)

if __name__ == "__main__":
    main()
