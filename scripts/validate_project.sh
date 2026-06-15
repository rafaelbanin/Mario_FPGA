#!/usr/bin/env bash
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

check() {
    if [ -e "$1" ]; then
        echo "[OK] $2"
        PASS=$((PASS+1))
    else
        echo "[MISSING] $2 -> $1"
        FAIL=$((FAIL+1))
    fi
}

echo "=== Super Mario DE10 - Project Validation ==="

check "$ROOT/fpga/hdl/VGA_Sync.vhd" "M1: VGA_Sync"
check "$ROOT/fpga/hdl/Video_PLL.vhd" "M1: Video_PLL"
check "$ROOT/fpga/hdl/vga_scanout.v" "M1: vga_scanout"
check "$ROOT/fpga/soc_system.qsys" "M1: soc_system.qsys"
check "$ROOT/fpga/SuperMario.qpf" "M1: Quartus project"

check "$ROOT/fpga/hdl/framebuffer_bridge.v" "M2: framebuffer_bridge HDL"
check "$ROOT/software/hw/framebuffer.c" "M2: framebuffer driver"

check "$ROOT/software/tiles.c" "M3: tileset"
check "$ROOT/software/level_data.h" "M3: level data"
check "$ROOT/software/render.c" "M3: renderer"

check "$ROOT/software/sprites.c" "M4: Mario sprites"
check "$ROOT/software/input.c" "M4: input driver"
check "$ROOT/software/camera.c" "M4: camera"

check "$ROOT/software/physics.c" "M5: physics"
check "$ROOT/software/collision.c" "M5: collision"
check "$ROOT/software/game.c" "M5: game loop"

check "$ROOT/tools/gfx_to_c.py" "Asset tool: gfx_to_c"
check "$ROOT/tools/tilemap_to_c.py" "Asset tool: tilemap_to_c"
check "$ROOT/software/gfx.c" "GFX draw indexed"
check "$ROOT/software/enemy.c" "Goomba enemy logic"
check "$ROOT/software/goomba_gfx.h" "Goomba sprites"

echo ""
echo "Passed: $PASS  Failed: $FAIL"
if [ "$FAIL" -gt 0 ]; then exit 1; fi
echo "All project artifacts present."
