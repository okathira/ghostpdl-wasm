## Style and Conventions
- Bash scripts start with `#!/bin/bash` and `set -euo pipefail`, echo numbered steps; keep commands explicit and fail-fast
- When scripting installs, pin versions where possible (e.g., `apt-get install autoconf=2.71-2`)
- NPM package uses ES module (`type: module`); exports prebuilt artifacts from `dist/`
- Maintain provenance focus: document build steps and ensure deterministic outputs