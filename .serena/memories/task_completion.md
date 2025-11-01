## Task Completion Checklist
- run builds with `npm run build` (local bash) or `npm run build:docker-cmd` / `npm run build:docker-ps` to validate outputs
- ensure `dist/` contains updated `gs.js` and `gs.wasm`; rerun `./optimize_with_binaryen.sh` if optimization needed
- review GitHub Actions workflows (`check.yml`, `release.yml`) for required steps before publishing
- perform `npm publish --dry-run` prior to releases to confirm package contents