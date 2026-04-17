#!/bin/sh
ARCH=$(uname -m)
clang++ ohapinger-latest.cpp -O2 -std=c++17 -o "OhAPinger-1.0-$ARCH-UNOFFICIAL-Compiled"
chmod +x OhAPinger-1.0-$ARCH-UNOFFICIAL-Compiled || chmod 755 OhAPinger-1.0-$ARCH-UNOFFICIAL-Compiled
