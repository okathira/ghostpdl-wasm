## Code Structure
- root contains `compile.sh` and `optimize_with_binaryen.sh` Bash scripts orchestrating build/optimization steps
- `ghostpdl/` git submodule holds upstream GhostPDL sources (compiled by scripts)
- npm package metadata lives in `package.json`/`package-lock.json`; built artifacts emitted into `dist/`
- GitHub Actions workflows under `.github/workflows/` perform CI checks, releases, and provenance publishing