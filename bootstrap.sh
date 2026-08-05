#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cat <<'EOF'
bootstrap.sh is now a compatibility entry point.
Chezmoi reconciles home state; Homebrew and macOS defaults remain explicit.
EOF

exec "$ROOT_DIR/bin/dot" init "$@"
