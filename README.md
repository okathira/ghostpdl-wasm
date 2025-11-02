# GhostPDL (Ghostscript) WASM built with Emscripten

This package provides a WebAssembly (WASM) build of GhostPDL (Ghostscript). It is built with Emscripten on GitHub Actions.

## Traceability

This project prioritizes supply‑chain traceability and publishes artifacts with npm Package Provenance.

Provenance provides a cryptographically verifiable link from the published package back to:

- the source repository and the exact commit that produced it,
- the GitHub Actions workflow/job that built and published it.

To verify a release, open the npm package page for that version and view its Provenance. Confirm that it references this repository (okathira/ghostpdl-wasm), the exact commit SHA that published the version, and the GitHub Actions workflow defined in .github/workflows/release.yml.

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

## TypeScript support

Type definitions ship with the package. Importing `@okathira/ghostpdl-wasm`
provides typed factory and module helpers, including the virtual filesystem
(`Module.FS`) and `Module.callMain` entry point.

The default export matches the factory emitted by Emscripten (`Module`), and
the bundled declarations extend `EmscriptenModule` from `@types/emscripten` to
surface `GhostscriptModule` and `GhostscriptModuleFactory` for reuse in your
own typings when needed.

## Runtime notes

The published artifacts are built with the following key options:

- `EM_LD_FLAGS`: `-sFILESYSTEM=1 -sEXPORTED_RUNTIME_METHODS=FS,callMain -sMODULARIZE=1 -sEXPORT_ES6=1 -sINVOKE_RUN=0 -sALLOW_MEMORY_GROWTH=1 -sBINARYEN_EXTRA_PASSES=...`
- `GS_CONFIGURE_FLAGS`: `--disable-contrib --disable-cups --disable-dbus --disable-fontconfig --disable-gtk --without-libpaper --without-libidn --without-pdftoraster --without-ijs --without-x --with-drivers=BMP,JPEG,PNG,PS,TIFF`

In short, `Module.FS` and `Module.callMain` are preserved for the usage shown above, and Ghostscript drivers are limited to the listed file-output devices.

## How to test locally

This repository uses a git submodule for GhostPDL.

### Build with Docker on Windows

```bash
npm run build:docker-cmd
```

### Use as a npm package

To verify the package locally before publishing to npm, install it from the source directory into another project.

1. Register the package globally with `npm link`:

   ```sh
   npm link
   ```

   This makes `@okathira/ghostpdl-wasm` available as a global link.

2. In the project where you want to test the package, link it as a dependency:

   ```sh
   npm link @okathira/ghostpdl-wasm
   ```

   To remove the link later, run `npm unlink @okathira/ghostpdl-wasm` in the consumer project and `npm unlink` in this repository if needed.

After linking, import `@okathira/ghostpdl-wasm` in the consumer project as you would with the published package.

## TODO

- [x] Optimize artifacts
  - [x] ghostscript build options
  - [x] emscripten build options
  - [x] Closure Compiler
- [ ] Auto-update dependencies on GitHub Actions
- [x] Add type definitions
- [ ] Optimize build process (e.g. remove apt-get install)

## License

### ghostpdl-wasm (this WASM package)

This package is licensed under the AGPLv3. See [LICENSE](./LICENSE).

### ghostpdl (original Ghostscript)

GhostPDL/Ghostscript is licensed under the AGPLv3. See the original repository: <https://github.com/ArtifexSoftware/ghostpdl>
