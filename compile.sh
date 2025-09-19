#!/bin/bash
set -euo pipefail

echo "=== Ghostscript WebAssembly Build ==="

echo "0. Entering submodule directory..."
pushd ghostpdl >/dev/null

echo "1. Checking Emscripten tools..."
emcc --version

echo "2. Cleaning previous build..."
make distclean 2>/dev/null || true

echo "3. Installing autoconf..."
apt-get update && apt-get install --yes autoconf=2.71-2

echo "4. Configuring for WebAssembly..."
NOCONFIGURE=1 ./autogen.sh
emconfigure ./configure \
    --host=$(emcc -dumpmachine) \
    --build=$(./config.guess) \
    CFLAGS='-Os -g0' \
    CXXFLAGS='-Os -g0' \
    LDFLAGS='-Os -g0 -sFILESYSTEM=1 -sEXPORTED_RUNTIME_METHODS=FS,callMain -sMODULARIZE=1 -sEXPORT_ES6 -sINVOKE_RUN=0 -sALLOW_MEMORY_GROWTH=1'

echo "5. Building with Emscripten..."
emmake make -j$(nproc)

echo "6. Testing WebAssembly binary..."
if [ -f "./bin/gs" ]; then
    echo "Build SUCCESS!"
    echo "Output files:"
    ls -la ./bin/gs*
else
    echo "Build FAILED!"
    echo "Checking for alternative output locations..."
    find . -name "*.wasm" -o -name "*.js" | head -10
fi

echo "7. Copying files to gs directory..."
mkdir -p ../dist
cp ./bin/gs ../dist/gs.js
cp ./bin/gs.wasm ../dist/gs.wasm

popd >/dev/null

echo "=== Build Complete ==="