## Ghostpdl-wasm Overview
- builds GhostPDL (Ghostscript) as a WebAssembly package published to npm
- repository wraps GhostPDL git submodule compiled with Emscripten inside containerized workflows
- output artifacts (`dist/gs.js`, `dist/gs.wasm`) provide Emscripten FS + callMain bindings for browser use
- automation handled by Bash scripts and GitHub Actions for build/release provenance