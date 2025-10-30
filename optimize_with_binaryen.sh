#!/bin/bash
set -euo pipefail

echo "=== Binaryen wasm-opt (in-container) ==="

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINARYEN_DIR="${PROJECT_ROOT}/binaryen"
BINARYEN_VERSION="${BINARYEN_VERSION:-version_124}"
BINARYEN_ARCHIVE="${BINARYEN_ARCHIVE:-binaryen-${BINARYEN_VERSION}-x86_64-linux.tar.gz}"
BINARYEN_URL="${BINARYEN_URL:-https://github.com/WebAssembly/binaryen/releases/download/${BINARYEN_VERSION}/${BINARYEN_ARCHIVE}}"

echo "0. Installing Binaryen tools..."
if [ ! -x "${BINARYEN_DIR}/bin/wasm-opt" ]; then
  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "'"${TMP_DIR}"'"' EXIT
  echo "   Downloading ${BINARYEN_URL}"
  curl -fLsS -o "${TMP_DIR}/${BINARYEN_ARCHIVE}" "${BINARYEN_URL}"
  echo "   Extracting ${BINARYEN_ARCHIVE}"
  tar -xzf "${TMP_DIR}/${BINARYEN_ARCHIVE}" -C "${TMP_DIR}"
  EXTRACTED_DIR="$(find "${TMP_DIR}" -mindepth 1 -maxdepth 1 -type d -name 'binaryen*' | head -n 1)"
  if [ -z "${EXTRACTED_DIR}" ]; then
    echo "Failed to locate extracted Binaryen directory inside archive" >&2
    exit 1
  fi
  echo "   Installing to ${BINARYEN_DIR}"
  rm -rf "${BINARYEN_DIR}"
  mv "${EXTRACTED_DIR}" "${BINARYEN_DIR}"
  trap - EXIT
  rm -rf "${TMP_DIR}"
else
  echo "   Binaryen tools already present at ${BINARYEN_DIR}"
fi

export PATH="${BINARYEN_DIR}/bin:${PATH}"

DIST_DIR="${DIST_DIR:-${PROJECT_ROOT}/dist}"
INPUT_WASM="${1:-${DIST_DIR}/gs.wasm}"
OUTPUT_WASM="${2:-${DIST_DIR}/gs.binaryen.wasm}"
WASM_OPT_BIN="${WASM_OPT_BIN:-wasm-opt}"
WASM_OPT_FEATURE_FLAGS="${WASM_OPT_FEATURE_FLAGS:---detect-features --enable-bulk-memory --enable-nontrapping-float-to-int}"
WASM_OPT_FLAGS="${WASM_OPT_FLAGS:--Os --strip-debug --strip-producers}"

echo "Input:  ${INPUT_WASM}"
echo "Output: ${OUTPUT_WASM}"
echo "Binary: ${WASM_OPT_BIN} ${WASM_OPT_FEATURE_FLAGS} ${WASM_OPT_FLAGS}"

if ! command -v "${WASM_OPT_BIN}" >/dev/null 2>&1; then
  echo "wasm-opt binary not found in PATH. Please ensure Binaryen tools are installed inside the container." >&2
  exit 1
fi

if [ ! -f "${INPUT_WASM}" ]; then
  echo "Input file ${INPUT_WASM} not found. Please build the WASM first." >&2
  exit 1
fi

mkdir -p "$(dirname "${OUTPUT_WASM}")"

"${WASM_OPT_BIN}" ${WASM_OPT_FEATURE_FLAGS} ${WASM_OPT_FLAGS} "${INPUT_WASM}" -o "${OUTPUT_WASM}"

ls -lh "${INPUT_WASM}" "${OUTPUT_WASM}"

echo "=== wasm-opt finished ==="

