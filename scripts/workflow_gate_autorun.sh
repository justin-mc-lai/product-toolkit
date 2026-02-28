#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

VERSION=""
TERMINAL_PATH=""
CONSISTENCY_PATH=""
MANIFEST_PATH=""

extract_terminal_path() {
  local file_path="$1"
  local dotted_key="$2"
  python3 - "$file_path" "$dotted_key" <<'PY'
import json
import sys
from pathlib import Path

file_path = Path(sys.argv[1])
dotted_key = sys.argv[2]

if not file_path.exists():
    print("")
    raise SystemExit(0)

try:
    data = json.loads(file_path.read_text(encoding="utf-8"))
except Exception:
    print("")
    raise SystemExit(0)

cur = data
for part in dotted_key.split("."):
    if isinstance(cur, dict) and part in cur:
        cur = cur[part]
    else:
        print("")
        raise SystemExit(0)

print(cur if isinstance(cur, str) else "")
PY
}

is_template_path() {
  local path_value="$1"
  [[ "$path_value" == *"{"* || "$path_value" == *"}"* || "$path_value" == *"<"* || "$path_value" == *">"* ]]
}

usage() {
  cat <<'USAGE'
Usage:
  workflow_gate_autorun.sh --version <vX.Y.Z> [--terminal <path>] [--consistency <path>] [--manifest <path>]

Default paths (when omitted):
  terminal    docs/product/<version>/execution/terminal.json
  consistency docs/product/<version>/execution/gate-consistency-report.json
  manifest    docs/product/<version>/execution/evidence-manifest.json

Exit code follows validate_terminal_artifacts.py:
  0 => Pass
  2 => Blocked
  1 => Error/invalid usage
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      VERSION="${2:-}"
      shift 2
      ;;
    --terminal)
      TERMINAL_PATH="${2:-}"
      shift 2
      ;;
    --consistency)
      CONSISTENCY_PATH="${2:-}"
      shift 2
      ;;
    --manifest)
      MANIFEST_PATH="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$VERSION" ]]; then
  echo "Error: --version is required" >&2
  usage
  exit 1
fi

if [[ -z "$TERMINAL_PATH" ]]; then
  TERMINAL_PATH="docs/product/$VERSION/execution/terminal.json"
fi
if [[ -z "$CONSISTENCY_PATH" ]]; then
  CONSISTENCY_PATH="$(extract_terminal_path "$TERMINAL_PATH" "evidence_integrity.gate_consistency_report")"
fi
if [[ -n "$CONSISTENCY_PATH" ]] && is_template_path "$CONSISTENCY_PATH"; then
  CONSISTENCY_PATH=""
fi
if [[ -z "$CONSISTENCY_PATH" ]]; then
  CONSISTENCY_PATH="docs/product/$VERSION/execution/gate-consistency-report.json"
fi
if [[ -z "$MANIFEST_PATH" ]]; then
  MANIFEST_PATH="$(extract_terminal_path "$TERMINAL_PATH" "evidence_integrity.sha256_manifest")"
fi
if [[ -n "$MANIFEST_PATH" ]] && is_template_path "$MANIFEST_PATH"; then
  MANIFEST_PATH=""
fi
if [[ -z "$MANIFEST_PATH" ]]; then
  MANIFEST_PATH="docs/product/$VERSION/execution/evidence-manifest.json"
fi

cd "$PROJECT_ROOT"

echo "[workflow-gate] check consistency"
python3 scripts/check_gate_consistency.py \
  --version "$VERSION" \
  --terminal "$TERMINAL_PATH" \
  --output "$CONSISTENCY_PATH" \
  --pretty

echo "[workflow-gate] build evidence manifest"
python3 scripts/build_evidence_manifest.py \
  --terminal "$TERMINAL_PATH" \
  --output "$MANIFEST_PATH" \
  --pretty

echo "[workflow-gate] validate terminal artifacts"
python3 scripts/validate_terminal_artifacts.py \
  --version "$VERSION" \
  --terminal "$TERMINAL_PATH" \
  --pretty
