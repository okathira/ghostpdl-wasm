# GhostPDL (Ghostscript) WASM built with Emscripten

This package provides a WebAssembly (WASM) build of GhostPDL (Ghostscript). It is built with Emscripten on GitHub Actions.

## Traceability

This project prioritizes supply‑chain traceability. I pin submodules and toolchains, publish build metadata and SHA‑256 checksums, and enable npm provenance. You can verify each release by rebuilding with the same workflow and confirming that the hashes of `dist/gs.js` and `dist/gs.wasm` match, and by reviewing the CI configuration and source code.

## Installation

```bash
npm install @okathira/ghostpdl-wasm
```

## Example Usage

The Emscripten FS and callMain APIs are exported.

### Basic usage

```js
import loadWASM from "@okathira/ghostpdl-wasm";

const run = async () => {
  // Load WASM
  const Module = await loadWASM();

  // Read the source PDF file
  const buffer = await fetch("./example.pdf").then((res) => res.arrayBuffer());
  Module.FS.writeFile("example.pdf", new Uint8Array(buffer));

  // Convert PDF to PDF (example settings)
  Module.callMain([
    "-sDEVICE=pdfwrite",
    "-dPDFSETTINGS=/ebook",
    "-dNOPAUSE",
    "-dBATCH",
    "-sOutputFile=example_output.pdf",
    "example.pdf",
  ]);

  // Read the output PDF file
  const output = Module.FS.readFile("example_output.pdf", {
    encoding: "binary",
  });

  // Create a downloadable file
  const file = new File([output], "example_output.pdf", {
    type: "application/pdf",
  });

  // Create a download button
  const a = document.createElement("a");
  a.href = URL.createObjectURL(file);
  a.download = file.name;
  a.innerText = "Download File";
  document.body.appendChild(a);

  // List files in the root directory
  console.log(Module.FS.readdir("/"));
};

run();
```

### Build artifacts can be imported directly

```js
import wasm from "@okathira/ghostpdl-wasm/gs.wasm";
import js from "@okathira/ghostpdl-wasm/gs.js"; // the same as `import loadWASM from "@okathira/ghostpdl-wasm";`
```

## How to build

This repository uses a git submodule for GhostPDL.

### Build with Docker on Windows

```bash
npm run build:docker-cmd
```

## TODO

- [ ] Optimize artifacts
- [ ] Auto-update dependencies on GitHub Actions
- [ ] Add type definitions
- [ ] Optimize build process (e.g. remove apt-get install)

## License

### ghostpdl-wasm (this WASM package)

This package is licensed under the AGPLv3. See [LICENSE](./LICENSE).

### ghostpdl (original Ghostscript)

GhostPDL/Ghostscript is licensed under the AGPLv3. See the original repository: <https://github.com/ArtifexSoftware/ghostpdl>
