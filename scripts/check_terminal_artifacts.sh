#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
VALIDATOR="$SCRIPT_DIR/validate_terminal_artifacts.py"

VERSION="v3.6.0"
if [[ "${1:-}" == "--version" ]]; then
  VERSION="${2:-}"
  if [[ -z "$VERSION" ]]; then
    echo "Error: --version requires a value (e.g. v3.6.0)" >&2
    exit 1
  fi
fi

if [[ ! -x "$VALIDATOR" ]]; then
  echo "Error: validator not executable: $VALIDATOR" >&2
  exit 1
fi

run_case() {
  local label="$1"
  local expected_exit="$2"
  local terminal_path="$3"

  echo "== $label =="
  set +e
  local output
  output="$(python3 "$VALIDATOR" --version "$VERSION" --terminal "$terminal_path" --pretty 2>&1)"
  local code=$?
  set -e

  echo "$output"
  echo "exit_code=$code (expected $expected_exit)"
  echo

  if [[ "$code" -ne "$expected_exit" ]]; then
    echo "FAIL: $label exit code mismatch" >&2
    return 1
  fi
}

cd "$PROJECT_ROOT"
run_case "release sample should Pass" 0 "docs/product/$VERSION/execution/terminal.release-sample.json"
run_case "blocked sample should Blocked" 2 "docs/product/$VERSION/execution/terminal.blocked-sample.json"

echo "PASS: terminal artifact checks match expected gate outcomes."
