#!/usr/bin/env python3
import pathlib

p = pathlib.Path(__file__).resolve().parents[1] / "software" / "level_data.h"
data = p.read_text().strip().split(",")
expected = 200 * 15
assert len(data) == expected, f"expected {expected} tiles, got {len(data)}"
assert "1" in data, "ground tiles missing"
print(f"PASS: level_data.h has {len(data)} entries")
