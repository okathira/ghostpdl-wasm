# GhostPDL (Ghostscript) WASM built with Emscripten

This package provides a WebAssembly (WASM) build of GhostPDL (Ghostscript). It is built with Emscripten on GitHub Actions.

## Traceability

Prioritizes supply‑chain traceability: pinned submodules/toolchains, published build metadata and SHA‑256 checksums, and npm provenance. You can verify each release by rebuilding with the same workflow and confirming that the hashes of dist/gs.js and dist/gs.wasm match, and by reviewing the CI configuration and source code.

## Installation

```bash
npm install @okathira/ghostpdl-wasm
```

## Example Usage

```js
import loadWASM from "@okathira/ghostpdl-wasm";

const run = async () => {
  // load WASM
  const Module = await loadWASM();

  // read source pdf file
  const buffer = await fetch("./example.pdf").then((res) => res.arrayBuffer());
  Module.FS.writeFile("example.pdf", new Uint8Array(buffer));

  // convert pdf to pdf
  Module.callMain([
    "-sDEVICE=pdfwrite",
    "-dPDFSETTINGS=/ebook",
    "-dNOPAUSE",
    "-dBATCH",
    "-sOutputFile=example_output.pdf",
    "example.pdf",
  ]);

  // read output pdf file
  const output = Module.FS.readFile("example_output.pdf", {
    encoding: "binary",
  });

  // create file object
  const file = new File([output], "example_output.pdf", {
    type: "application/pdf",
  });

  // create download button
  const a = document.createElement("a");
  a.href = URL.createObjectURL(file);
  a.download = file.name;
  a.innerText = "Download File";
  document.body.appendChild(a);

  // list files in the root directory
  console.log(Module.FS.readdir("/"));
};

run();
```

## How to build

This repository uses git submodule to handle ghostpdl.

### Build with docker on Windows

```bash
npm run build:docker-cmd
```

## License

### ghostpdl-wasm (This WASM package)

This package is licensed under [the AGPL license](./LICENSE).

### ghostpdl (Original Ghostscript)

Original Ghostscript is licensed under [the AGPL license](https://github.com/ArtifexSoftware/ghostpdl).
