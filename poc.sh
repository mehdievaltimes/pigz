#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
./compile.sh >/dev/null

payload="$(python3 - <<'PY'
print(" ".join(["-f"] * 20000), end="")
PY
)"

# pick a timeout wrapper if one exists (macOS may only have gtimeout, or none)
TIMEOUT=""
if command -v timeout >/dev/null 2>&1; then TIMEOUT="timeout 10s"
elif command -v gtimeout >/dev/null 2>&1; then TIMEOUT="gtimeout 10s"; fi

ulimit -s 8192 2>/dev/null || true
PIGZ="$payload" $TIMEOUT ./executable -V
