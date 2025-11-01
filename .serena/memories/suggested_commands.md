## Suggested Commands
- `git submodule update --init --recursive` — pull GhostPDL sources before building
- `npm run build` — run local Bash build pipeline (requires Emscripten env)
- `npm run build:docker-cmd` (Windows CMD) / `npm run build:docker-ps` (PowerShell) — build via emscripten/emsdk Docker image
- `./compile.sh` — invoke GhostPDL WASM build inside repo (expects emscripten toolchain)
- `./optimize_with_binaryen.sh` — optimize `dist/gs.wasm` with Binaryen `wasm-opt`
- `npm publish --dry-run` — verify package contents prior to publishing