#!/usr/bin/env python3
"""Convert 16x16 ASCII art (.txt) to packed indexed C array header."""
import argparse
import pathlib
import sys

CHAR_MAP = {
    '.': 0x0, ' ': 0x0,
    '1': 0x1, '2': 0x2, '3': 0x3, '4': 0x4,
    '5': 0x5, '6': 0x6, '7': 0x7, '8': 0x8,
    '9': 0x9, 'A': 0xA, 'a': 0xA,
    'B': 0xB, 'b': 0xB,
    'C': 0xC, 'c': 0xC,
    'D': 0xD, 'd': 0xD,
    'E': 0xE, 'e': 0xE,
    'F': 0xF, 'f': 0xF,
}


def parse_ascii(lines):
    pixels = []
    for line in lines:
        line = line.rstrip('\n')
        if not line or line.startswith('#'):
            continue
        if len(line) != 16:
            raise ValueError(f"Line must be 16 chars, got {len(line)}: {line!r}")
        for ch in line:
            if ch not in CHAR_MAP:
                raise ValueError(f"Unknown char {ch!r}")
            pixels.append(CHAR_MAP[ch])
    if len(pixels) != 256:
        raise ValueError(f"Expected 256 pixels, got {len(pixels)}")
    return pixels


def pack_pixels(pixels):
    out = []
    for i in range(0, 256, 2):
        out.append((pixels[i] << 4) | pixels[i + 1])
    return out


def emit_c(name, packed, guard=None):
    guard = guard or f"{name.upper()}_H"
    lines = [f"#ifndef {guard}", f"#define {guard}", "", f"static const uint8_t {name}[128] = {{"]
    for i in range(0, 128, 8):
        chunk = packed[i:i + 8]
        lines.append("    " + ", ".join(f"0x{b:02X}" for b in chunk) + ",")
    lines.append("};")
    lines.append("")
    lines.append("#endif")
    return "\n".join(lines) + "\n"


def main():
    p = argparse.ArgumentParser(description="ASCII 16x16 gfx to C header")
    p.add_argument("input", help="Input .txt file")
    p.add_argument("name", help="C array variable name")
    p.add_argument("-o", "--output", help="Output .h file (default stdout)")
    args = p.parse_args()

    text = pathlib.Path(args.input).read_text().splitlines()
    packed = pack_pixels(parse_ascii(text))
    out = emit_c(args.name, packed)

    if args.output:
        pathlib.Path(args.output).write_text(out)
        print(f"Wrote {args.output}", file=sys.stderr)
    else:
        sys.stdout.write(out)


if __name__ == "__main__":
    main()
