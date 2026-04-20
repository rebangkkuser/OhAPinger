#!/bin/sh

ARCH=$(uname -m)
OUT="OhAPinger-1.0-$ARCH-UNOFFICIAL-Compiled"

if command -v clang++ >/dev/null 2>&1
then
    COMPILER=clang++
elif command -v g++ >/dev/null 2>&1
then
    COMPILER=g++
else
    echo "[OhAPinger] Error: no compiler available (clang++ or g++)"
    exit 1
fi

$COMPILER ohapinger-latest.cpp -O2 -std=c++17 -o "$OUT"

chmod a+x "$OUT" 2>/dev/null || chmod 755 "$OUT" || chmod +x "$OUT"

echo "[OhAPinger] Build completed: $OUT"
