#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build

echo ""
echo "Build OK. Run: ./build/supermario_host"
