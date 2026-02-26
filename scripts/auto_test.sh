#!/usr/bin/env bash

# Product Toolkit Automated Test Runner
# - Supports optional frontend startup before browser automation
# - Selects external browser tools by priority: agent-browser -> browser-use
# - Persists test learnings to avoid repeating the same pitfalls

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PTK_DIR="$PROJECT_ROOT/.ptk"
STATE_DIR="$PTK_DIR/state"
MEMORY_DIR="$PTK_DIR/memory"
EVIDENCE_DIR="$PTK_DIR/evidence"

MAX_ITERATIONS=3
TEST_TYPE="full"
TEST_FILE=""
DRY_RUN=false

VERSION=""
FEATURE=""

TOOL_MODE="auto"
TOOL_PRIORITY="agent-browser,browser-use"
SELECTED_TOOL=""

START_FRONTEND=true
FRONTEND_CMD=""
FRONTEND_DIR="$PROJECT_ROOT"
FRONTEND_URL=""
FRONTEND_TIMEOUT=120
FRONTEND_PID=""
BROWSER_HEADED=false
FRONTEND_AUTO_DETECT=true

BASE_URL=""
RESULTS_FILE=""

TEST_MEMORY_FILE="$MEMORY_DIR/test-learnings.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

usage() {
  cat <<USAGE
Usage: $(basename "$0") [OPTIONS]

Automated test runner for Product Toolkit (Web UI focus)

Required:
  -v, --version VERSION         Product version (e.g. v1.0.0)
  -f, --feature FEATURE         Feature name (e.g. 电商收藏功能)

Test execution:
  -t, --type TYPE               smoke|regression|full (default: full)
  -i, --iterations N            Max retries when failed (default: 3)
      --test-file PATH          Custom test case file path
      --dry-run                 Print planned execution only

Tool selection:
      --tool TOOL               auto|agent-browser|browser-use (default: auto)
      --tool-priority LIST      Comma list, e.g. agent-browser,browser-use
      --headed                  Run visible browser (mainly for agent-browser)

Frontend startup:
      --frontend-cmd CMD        Start frontend before tests (e.g. "pnpm dev")
      --frontend-dir DIR        Working directory for frontend cmd
      --frontend-url URL        Health URL / base URL to test (e.g. http://127.0.0.1:5173)
      --frontend-timeout SEC    Wait timeout for frontend URL (default: 120)
      --no-frontend-auto-detect Disable package.json based auto detection
      --no-frontend-start       Do not start frontend process

Memory:
      --memory-file PATH        Override learnings memory file path

General:
  -h, --help                    Show this help

Examples:
  $(basename "$0") -v v1.0.0 -f 登录功能 -t smoke
  $(basename "$0") -v v1.0.0 -f 收藏功能 --frontend-cmd "pnpm dev" --frontend-url http://127.0.0.1:5173
  $(basename "$0") -v v1.0.0 -f 收藏功能 --frontend-dir ./apps/web   # auto-detect package.json scripts
  $(basename "$0") -v v1.0.0 -f 购物车 --tool-priority agent-browser,browser-use
USAGE
  exit 1
}

print_header() {
  echo -e "${BLUE}========================================${NC}"
  echo -e "${BLUE}Product Toolkit Automated Test Runner${NC}"
  echo -e "${BLUE}========================================${NC}"
  echo -e "${CYAN}Version:${NC}           $VERSION"
  echo -e "${CYAN}Feature:${NC}           $FEATURE"
  echo -e "${CYAN}Test Type:${NC}         $TEST_TYPE"
  echo -e "${CYAN}Max Iterations:${NC}    $MAX_ITERATIONS"
  echo -e "${CYAN}Test File:${NC}         $TEST_FILE"
  echo -e "${CYAN}Tool Mode:${NC}         $TOOL_MODE"
  echo -e "${CYAN}Selected Tool:${NC}     ${SELECTED_TOOL:-pending}"
  echo -e "${CYAN}Browser Headed:${NC}    $BROWSER_HEADED"
  echo -e "${CYAN}Base URL:${NC}          ${BASE_URL:-pending}"
  echo -e "${CYAN}Frontend Start:${NC}    $START_FRONTEND"
  echo -e "${CYAN}Frontend AutoDetect:${NC} $FRONTEND_AUTO_DETECT"
  if [[ -n "$FRONTEND_CMD" ]]; then
    echo -e "${CYAN}Frontend Command:${NC}  $FRONTEND_CMD"
    echo -e "${CYAN}Frontend Dir:${NC}      $FRONTEND_DIR"
  fi
  if [[ -n "$FRONTEND_URL" ]]; then
    echo -e "${CYAN}Frontend URL:${NC}      $FRONTEND_URL (timeout ${FRONTEND_TIMEOUT}s)"
  fi
  echo -e "${CYAN}Memory File:${NC}       $TEST_MEMORY_FILE"
  echo
}

require_value() {
  local key="$1"
  local value="${2:-}"
  if [[ -z "$value" ]]; then
    echo -e "${RED}Error: Missing value for ${key}${NC}"
    usage
  fi
}

sanitize_name() {
  # shell-safe filename segment
  echo "$1" | sed -E 's/[^A-Za-z0-9._-]+/_/g'
}

iso_now() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

normalize_base_url() {
  if [[ -n "$FRONTEND_URL" ]]; then
    BASE_URL="${FRONTEND_URL%/}"
  else
    BASE_URL="http://localhost:3000"
  fi
}

guess_frontend_url_from_cmd() {
  local cmd="$1"
  python3 - "$cmd" <<'PY'
import re
import sys

cmd = sys.argv[1] or ""
lower = cmd.lower()

port = None
patterns = [
    r'--port(?:=|\s+)(\d{2,5})',
    r'(?<![\w-])-p(?:=|\s+)(\d{2,5})',
    r'PORT=(\d{2,5})',
]
for p in patterns:
    m = re.search(p, cmd)
    if m:
        port = int(m.group(1))
        break

if port is None:
    if "vite" in lower:
        port = 5173
    elif "astro" in lower:
        port = 4321
    elif "parcel" in lower:
        port = 1234
    elif "next" in lower or "nuxt" in lower or "react-scripts" in lower or "webpack-dev-server" in lower:
        port = 3000
    else:
        port = 3000

print(f"http://127.0.0.1:{port}")
PY
}

detect_frontend_from_package_json() {
  local pkg="$FRONTEND_DIR/package.json"
  [[ -f "$pkg" ]] || return 1

  local detected
  detected="$(python3 - "$pkg" <<'PY'
import json
import re
import sys
from pathlib import Path

pkg_path = Path(sys.argv[1])
root = pkg_path.parent

try:
    data = json.loads(pkg_path.read_text(encoding="utf-8"))
except Exception:
    raise SystemExit(1)

scripts = data.get("scripts") or {}
if not isinstance(scripts, dict):
    raise SystemExit(1)

script_name = None
for cand in ("dev", "start", "serve", "preview"):
    v = scripts.get(cand)
    if isinstance(v, str) and v.strip():
        script_name = cand
        break

if not script_name:
    raise SystemExit(1)

script_cmd = scripts.get(script_name, "")

pm = None
if (root / "pnpm-lock.yaml").exists():
    pm = "pnpm"
elif (root / "yarn.lock").exists():
    pm = "yarn"
elif (root / "bun.lockb").exists() or (root / "bun.lock").exists():
    pm = "bun"
elif (root / "package-lock.json").exists() or (root / "npm-shrinkwrap.json").exists():
    pm = "npm"
else:
    package_manager = str(data.get("packageManager", ""))
    if package_manager:
        pm = package_manager.split("@", 1)[0]

if pm not in {"pnpm", "yarn", "bun", "npm"}:
    pm = "npm"

if pm == "pnpm":
    cmd = f"pnpm {script_name}"
elif pm == "yarn":
    cmd = f"yarn {script_name}"
elif pm == "bun":
    cmd = f"bun run {script_name}"
else:
    cmd = f"npm run {script_name}"

port = None
patterns = [
    r'--port(?:=|\s+)(\d{2,5})',
    r'(?<![\w-])-p(?:=|\s+)(\d{2,5})',
    r'PORT=(\d{2,5})',
]
for p in patterns:
    m = re.search(p, script_cmd)
    if m:
        port = int(m.group(1))
        break

if port is None:
    lower = script_cmd.lower()
    if "vite" in lower:
        port = 5173
    elif "astro" in lower:
        port = 4321
    elif "parcel" in lower:
        port = 1234
    elif "next" in lower or "nuxt" in lower or "react-scripts" in lower or "webpack-dev-server" in lower:
        port = 3000
    else:
        port = 3000

url = f"http://127.0.0.1:{port}"
print("\t".join([cmd, url, script_name, pm]))
PY
)" || return 1

  local cmd url script_name pm
  IFS=$'\t' read -r cmd url script_name pm <<< "$detected"

  if [[ -n "$cmd" && -z "$FRONTEND_CMD" ]]; then
    FRONTEND_CMD="$cmd"
    echo -e "${CYAN}Auto-detected frontend command:${NC} $FRONTEND_CMD (script=${script_name}, pm=${pm})"
  fi

  if [[ -n "$url" && -z "$FRONTEND_URL" ]]; then
    FRONTEND_URL="$url"
    echo -e "${CYAN}Auto-detected frontend URL:${NC} $FRONTEND_URL"
  fi

  return 0
}

auto_detect_frontend_if_needed() {
  if [[ "$FRONTEND_AUTO_DETECT" != true ]]; then
    return 0
  fi

  if [[ -n "$FRONTEND_CMD" && -n "$FRONTEND_URL" ]]; then
    return 0
  fi

  if detect_frontend_from_package_json; then
    return 0
  fi

  if [[ -n "$FRONTEND_CMD" && -z "$FRONTEND_URL" ]]; then
    FRONTEND_URL="$(guess_frontend_url_from_cmd "$FRONTEND_CMD")"
    echo -e "${CYAN}Guessed frontend URL from command:${NC} $FRONTEND_URL"
    return 0
  fi

  if [[ -z "$FRONTEND_CMD" && -z "$FRONTEND_URL" ]]; then
    echo -e "${YELLOW}No package.json auto-detection result. Use --frontend-cmd/--frontend-url for better accuracy.${NC}"
  fi
}

is_tool_available() {
  local tool="$1"
  case "$tool" in
    agent-browser)
      command_exists agent-browser
      ;;
    browser-use)
      command_exists browser-use || command_exists npx
      ;;
    *)
      return 1
      ;;
  esac
}

attempt_install_tool() {
  local tool="$1"

  [[ "$DRY_RUN" == true ]] && return 0

  case "$tool" in
    agent-browser)
      if command_exists agent-browser; then
        return 0
      fi
      if ! command_exists npm; then
        return 1
      fi
      echo -e "${YELLOW}agent-browser not found. Installing via npm...${NC}"
      if npm install -g agent-browser >/dev/null 2>&1; then
        command_exists agent-browser || return 1
        agent-browser install >/dev/null 2>&1 || true
        return 0
      fi
      return 1
      ;;
    browser-use)
      if command_exists browser-use || command_exists npx; then
        return 0
      fi
      return 1
      ;;
    *)
      return 1
      ;;
  esac
}

select_tool() {
  if [[ "$TOOL_MODE" != "auto" ]]; then
    attempt_install_tool "$TOOL_MODE" || true
    if ! is_tool_available "$TOOL_MODE"; then
      if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}Warning: requested tool '$TOOL_MODE' is unavailable, but continue in dry-run mode${NC}"
        SELECTED_TOOL="$TOOL_MODE"
        return 0
      fi
      echo -e "${RED}Error: requested tool '$TOOL_MODE' is not available${NC}"
      exit 1
    fi
    SELECTED_TOOL="$TOOL_MODE"
    return 0
  fi

  IFS=',' read -r -a priorities <<< "$TOOL_PRIORITY"
  for raw in "${priorities[@]}"; do
    local t
    t="$(echo "$raw" | xargs)"
    [[ -z "$t" ]] && continue
    attempt_install_tool "$t" || true
    if is_tool_available "$t"; then
      SELECTED_TOOL="$t"
      return 0
    fi
  done

  if [[ "$DRY_RUN" == true ]]; then
    SELECTED_TOOL="$(echo "$TOOL_PRIORITY" | cut -d',' -f1 | xargs)"
    [[ -z "$SELECTED_TOOL" ]] && SELECTED_TOOL="agent-browser"
    echo -e "${YELLOW}Warning: no browser tool available; continue with dry-run planned tool '$SELECTED_TOOL'${NC}"
    return 0
  fi

  echo -e "${RED}Error: no browser tool available. Tried: $TOOL_PRIORITY${NC}"
  echo "Install one of: agent-browser, browser-use (or ensure npx is available)."
  exit 1
}

create_dirs() {
  mkdir -p "$STATE_DIR" "$MEMORY_DIR" "$EVIDENCE_DIR/$VERSION/$FEATURE/screenshots"
  RESULTS_FILE="$EVIDENCE_DIR/$VERSION/$FEATURE/results.tsv"
  : > "$RESULTS_FILE"
}

ensure_memory_file() {
  if [[ ! -f "$TEST_MEMORY_FILE" ]]; then
    mkdir -p "$(dirname "$TEST_MEMORY_FILE")"
    cat > "$TEST_MEMORY_FILE" <<JSON
{
  "version": "1.0",
  "updated_at": "$(iso_now)",
  "pitfalls": []
}
JSON
  fi
}

resolve_test_file() {
  if [[ -n "$TEST_FILE" ]]; then
    [[ -f "$TEST_FILE" ]] || {
      echo -e "${RED}Error: test file not found: $TEST_FILE${NC}"
      exit 1
    }
    return 0
  fi

  local candidates=(
    "$PROJECT_ROOT/docs/product/$VERSION/qa/test-cases/${FEATURE}.md"
    "$PROJECT_ROOT/docs/product/test-cases/${FEATURE}.md"
    "$PROJECT_ROOT/docs/product/$VERSION/test-cases/${FEATURE}.md"
  )

  for path in "${candidates[@]}"; do
    if [[ -f "$path" ]]; then
      TEST_FILE="$path"
      return 0
    fi
  done

  echo -e "${RED}Error: no test case file found for feature '$FEATURE'${NC}"
  echo "Checked:"
  printf '  - %s\n' "${candidates[@]}"
  exit 1
}

wait_for_frontend() {
  local url="$1"
  local timeout="$2"

  if ! command_exists curl; then
    echo -e "${YELLOW}Warning: curl not found, skip frontend readiness check${NC}"
    return 0
  fi

  local elapsed=0
  while (( elapsed < timeout )); do
    if curl -fsS --max-time 2 "$url" >/dev/null 2>&1; then
      echo -e "${GREEN}Frontend is ready: $url${NC}"
      return 0
    fi
    sleep 1
    ((elapsed += 1))
  done

  echo -e "${RED}Error: frontend is not ready within ${timeout}s: $url${NC}"
  return 1
}

start_frontend_if_needed() {
  if [[ "$START_FRONTEND" != true ]]; then
    echo -e "${CYAN}Skip frontend startup (--no-frontend-start)${NC}"
    return 0
  fi

  if [[ -z "$FRONTEND_CMD" ]]; then
    if [[ -n "$FRONTEND_URL" ]]; then
      echo -e "${CYAN}No frontend command provided, only checking existing URL...${NC}"
      wait_for_frontend "$FRONTEND_URL" "$FRONTEND_TIMEOUT"
    else
      echo -e "${CYAN}No frontend startup requested (no --frontend-cmd)${NC}"
    fi
    return 0
  fi

  echo -e "${CYAN}Starting frontend: ${FRONTEND_CMD}${NC}"
  local startup_log="$EVIDENCE_DIR/$VERSION/$FEATURE/frontend-startup.log"
  (
    cd "$FRONTEND_DIR"
    bash -lc "$FRONTEND_CMD"
  ) >"$startup_log" 2>&1 &

  FRONTEND_PID=$!
  echo -e "${CYAN}Frontend PID:${NC} $FRONTEND_PID"

  if [[ -n "$FRONTEND_URL" ]]; then
    wait_for_frontend "$FRONTEND_URL" "$FRONTEND_TIMEOUT"
  else
    sleep 3
  fi
}

verify_server_with_tool() {
  if [[ "$DRY_RUN" == true ]]; then
    echo -e "${CYAN}Skip server verification in dry-run mode${NC}"
    return 0
  fi

  local verify_log="$EVIDENCE_DIR/$VERSION/$FEATURE/server-check.log"
  : > "$verify_log"

  echo -e "${CYAN}Verifying server availability: ${BASE_URL}${NC}"

  if [[ "$SELECTED_TOOL" == "agent-browser" ]]; then
    if [[ "$BROWSER_HEADED" == true ]]; then
      agent-browser --headed open "$BASE_URL" >>"$verify_log" 2>&1 || return 1
      agent-browser --headed snapshot -i --json >>"$verify_log" 2>&1 || return 1
    else
      agent-browser open "$BASE_URL" >>"$verify_log" 2>&1 || return 1
      agent-browser snapshot -i --json >>"$verify_log" 2>&1 || return 1
    fi
    return 0
  fi

  if [[ "$SELECTED_TOOL" == "browser-use" ]]; then
    if command_exists browser-use; then
      browser-use open "$BASE_URL" >>"$verify_log" 2>&1 || return 1
      browser-use state >>"$verify_log" 2>&1 || return 1
    else
      npx -y browser-use open "$BASE_URL" >>"$verify_log" 2>&1 || return 1
      npx -y browser-use state >>"$verify_log" 2>&1 || return 1
    fi
    return 0
  fi

  return 1
}

cleanup() {
  if [[ -n "$FRONTEND_PID" ]] && kill -0 "$FRONTEND_PID" >/dev/null 2>&1; then
    echo -e "${CYAN}Stopping frontend process (PID=$FRONTEND_PID)${NC}"
    kill "$FRONTEND_PID" >/dev/null 2>&1 || true
    wait "$FRONTEND_PID" >/dev/null 2>&1 || true
  fi
}

show_known_pitfalls() {
  ensure_memory_file
  python3 - "$TEST_MEMORY_FILE" "$FEATURE" <<'PY'
import json, sys
from pathlib import Path

path = Path(sys.argv[1])
feature = sys.argv[2]
try:
    data = json.loads(path.read_text(encoding="utf-8"))
except Exception:
    print("[WARN] 测试记忆文件损坏，已跳过读取")
    raise SystemExit(0)

pitfalls = data.get("pitfalls", [])
matched = [
    p for p in pitfalls
    if p.get("feature") == feature or p.get("feature") == "*"
]

if not matched:
    print("暂无历史踩坑记录。")
    raise SystemExit(0)

matched = sorted(matched, key=lambda x: x.get("last_seen", ""), reverse=True)[:5]
print("历史踩坑提醒（最近 5 条）：")
for p in matched:
    print(f"- [{p.get('signature','unknown')}] {p.get('test_case','N/A')} x{p.get('count',1)}")
    print(f"  建议: {p.get('suggestion','(无)')}")
PY
}

extract_case_ids() {
  local mode="$1"
  local regex=""

  case "$mode" in
    smoke)
      regex='^####[[:space:]]*(SMK|SMOKE)-[A-Za-z0-9_-]+'
      ;;
    regression)
      regex='^####[[:space:]]*TC-[A-Za-z0-9_-]+'
      ;;
    full)
      regex='^####[[:space:]]*(SMK|SMOKE|TC)-[A-Za-z0-9_-]+'
      ;;
    *)
      echo -e "${RED}Unsupported test type: $mode${NC}"
      exit 1
      ;;
  esac

  grep -E "$regex" "$TEST_FILE" 2>/dev/null |
    sed -E 's/^####[[:space:]]*([A-Za-z0-9_-]+).*/\1/' |
    awk '!seen[$0]++'
}

extract_case_block() {
  local case_id="$1"
  awk -v id="$case_id" '
    BEGIN { found=0 }
    $0 ~ "^####[[:space:]]*" id "([[:space:]]*:|$)" { found=1; print; next }
    found && $0 ~ "^####[[:space:]]*(SMK|SMOKE|TC)-" { exit }
    found { print }
  ' "$TEST_FILE"
}

join_base_and_path() {
  local base="$1"
  local path="$2"
  if [[ "$path" == "/" ]]; then
    echo "${base}/"
  else
    echo "${base}${path}"
  fi
}

resolve_case_target_url() {
  local case_id="$1"
  local block
  block="$(extract_case_block "$case_id")"

  local full_url
  full_url="$(printf '%s\n' "$block" | grep -Eo 'https?://[^ )|`"]+' | head -n1 || true)"
  if [[ -n "$full_url" ]]; then
    echo "$full_url"
    return 0
  fi

  local first_path
  first_path="$(printf '%s\n' "$block" | grep -Eo '/[A-Za-z0-9._~/%-]+' | grep -Ev '^/product-toolkit' | head -n1 || true)"
  if [[ -n "$first_path" ]]; then
    join_base_and_path "$BASE_URL" "$first_path"
    return 0
  fi

  echo "$BASE_URL"
}

classify_failure_signature() {
  local log_file="$1"

  if grep -Eiq 'ECONNREFUSED|ERR_CONNECTION_REFUSED|connection refused|Failed to fetch' "$log_file"; then
    echo "frontend_unreachable|前端不可达：检查 --frontend-cmd 与 --frontend-url，确认项目已启动"
    return
  fi

  if grep -Eiq 'page\.goto:|net::ERR_|navigating to' "$log_file"; then
    echo "navigation_failure|页面导航失败：检查目标 URL、路由映射与前端服务可用性"
    return
  fi

  if grep -Eiq 'timeout|timed out|TimeoutError' "$log_file"; then
    echo "timeout_or_slow_response|超时：提高 --frontend-timeout，或优化页面首屏/接口性能"
    return
  fi

  if grep -Eiq 'selector|element not found|No node found|locator' "$log_file"; then
    echo "selector_or_dom_changed|元素定位失败：更新测试步骤中的选择器或页面定位策略"
    return
  fi

  if grep -Eiq '401|403|unauthorized|forbidden|auth' "$log_file"; then
    echo "auth_or_permission|权限/认证失败：确认测试账号权限与登录态初始化流程"
    return
  fi

  if grep -Eiq '500|Internal Server Error|server error' "$log_file"; then
    echo "backend_internal_error|后端错误：先检查关键 API 健康状态与错误日志"
    return
  fi

  echo "unknown_failure|未知失败：查看证据日志并补充可复用修复建议"
}

upsert_test_memory() {
  local case_id="$1"
  local status="$2"
  local log_file="$3"

  [[ "$status" == "failed" ]] || return 0

  local classified
  classified="$(classify_failure_signature "$log_file")"
  local signature suggestion
  signature="${classified%%|*}"
  suggestion="${classified#*|}"
  local snippet
  snippet="$(tail -n 20 "$log_file" | tr '\n' ' ' | sed -E 's/[[:space:]]+/ /g' | cut -c1-280)"

  python3 - "$TEST_MEMORY_FILE" "$FEATURE" "$VERSION" "$TEST_TYPE" "$case_id" "$SELECTED_TOOL" "$signature" "$suggestion" "$snippet" <<'PY'
import json, sys
from datetime import datetime, timezone
from pathlib import Path

(path, feature, version, test_type, case_id, tool, signature, suggestion, snippet) = sys.argv[1:]
now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

p = Path(path)
if p.exists():
    try:
        data = json.loads(p.read_text(encoding="utf-8"))
    except Exception:
        data = {"version": "1.0", "updated_at": now, "pitfalls": []}
else:
    data = {"version": "1.0", "updated_at": now, "pitfalls": []}

pitfalls = data.setdefault("pitfalls", [])
match = None
for item in pitfalls:
    if (
        item.get("feature") == feature
        and item.get("test_case") == case_id
        and item.get("signature") == signature
    ):
        match = item
        break

if match:
    match["count"] = int(match.get("count", 1)) + 1
    match["last_seen"] = now
    match["version"] = version
    match["tool"] = tool
    match["test_type"] = test_type
    match["suggestion"] = suggestion
    match["snippet"] = snippet
else:
    pitfalls.append(
        {
            "feature": feature,
            "version": version,
            "test_type": test_type,
            "test_case": case_id,
            "tool": tool,
            "signature": signature,
            "suggestion": suggestion,
            "snippet": snippet,
            "count": 1,
            "first_seen": now,
            "last_seen": now,
        }
    )

# keep newest 300 records
pitfalls.sort(key=lambda x: x.get("last_seen", ""), reverse=True)
data["pitfalls"] = pitfalls[:300]
data["updated_at"] = now

p.parent.mkdir(parents=True, exist_ok=True)
p.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
PY
}

run_agent_browser_cmd() {
  local case_log="$1"
  shift
  local -a cmd=(agent-browser)
  if [[ "$BROWSER_HEADED" == true ]]; then
    cmd+=(--headed)
  fi
  cmd+=("$@")
  "${cmd[@]}" >>"$case_log" 2>&1
}

run_agent_browser_case() {
  local case_id="$1"
  local target_url="$2"
  local case_log="$3"
  local safe_case="$4"
  local iteration="$5"

  # Alignment with compound-engineering test-browser guidance:
  # open -> snapshot -> screenshot -> errors (CLI-first verification loop)
  local screenshot_path="$EVIDENCE_DIR/$VERSION/$FEATURE/screenshots/${safe_case}-iter${iteration}.png"
  local snapshot_json="$EVIDENCE_DIR/$VERSION/$FEATURE/snapshot-${safe_case}-iter${iteration}.json"
  local errors_log="$EVIDENCE_DIR/$VERSION/$FEATURE/errors-${safe_case}-iter${iteration}.log"

  run_agent_browser_cmd "$case_log" errors --clear || true
  run_agent_browser_cmd "$case_log" open "$target_url" || return 1

  if [[ "$BROWSER_HEADED" == true ]]; then
    run_agent_browser_cmd "$case_log" wait 500 || true
  fi

  if [[ "$BROWSER_HEADED" == true ]]; then
    agent-browser --headed snapshot -i --json >"$snapshot_json" 2>>"$case_log" || return 1
  else
    agent-browser snapshot -i --json >"$snapshot_json" 2>>"$case_log" || return 1
  fi

  python3 - "$snapshot_json" >>"$case_log" 2>&1 <<'PY'
import json, sys
from pathlib import Path

p = Path(sys.argv[1])
data = json.loads(p.read_text(encoding="utf-8"))
if not data.get("success", True):
    print("snapshot failed:", data.get("error"))
    raise SystemExit(1)
refs = (data.get("data") or {}).get("refs") or {}
print(f"snapshot refs: {len(refs)}")
PY

  run_agent_browser_cmd "$case_log" screenshot "$screenshot_path" || true
  run_agent_browser_cmd "$case_log" errors >"$errors_log" 2>&1 || true

  if grep -Eiq 'ERR_CONNECTION|ReferenceError|TypeError|SyntaxError|Unhandled|Failed to load resource|net::ERR_|status of 5[0-9]{2}' "$errors_log"; then
    echo "Detected critical browser errors in $errors_log" >>"$case_log"
    return 1
  fi

  return 0
}

run_browser_use_case() {
  local case_id="$1"
  local target_url="$2"
  local case_log="$3"
  local safe_case="$4"
  local iteration="$5"

  local screenshot_path="$EVIDENCE_DIR/$VERSION/$FEATURE/screenshots/${safe_case}-iter${iteration}.png"
  local state_file="$EVIDENCE_DIR/$VERSION/$FEATURE/state-${safe_case}-iter${iteration}.txt"

  local -a bu
  if command_exists browser-use; then
    bu=(browser-use)
  else
    bu=(npx -y browser-use)
  fi

  if [[ "$BROWSER_HEADED" == true ]]; then
    bu+=(--headed)
  fi

  "${bu[@]}" open "$target_url" >>"$case_log" 2>&1 || return 1
  "${bu[@]}" state >"$state_file" 2>>"$case_log" || return 1
  "${bu[@]}" screenshot "$screenshot_path" >>"$case_log" 2>&1 || true
  return 0
}

run_with_tool() {
  local case_id="$1"
  local target_url="$2"
  local case_log="$3"
  local safe_case="$4"
  local iteration="$5"

  case "$SELECTED_TOOL" in
    agent-browser)
      run_agent_browser_case "$case_id" "$target_url" "$case_log" "$safe_case" "$iteration"
      ;;
    browser-use)
      run_browser_use_case "$case_id" "$target_url" "$case_log" "$safe_case" "$iteration"
      ;;
    *)
      echo "Unsupported tool: $SELECTED_TOOL" >"$case_log"
      return 1
      ;;
  esac
}

run_single_case() {
  local case_id="$1"
  local iteration="$2"

  local safe_case
  safe_case="$(sanitize_name "$case_id")"
  local case_log="$EVIDENCE_DIR/$VERSION/$FEATURE/${safe_case}-iter${iteration}.log"
  local target_url
  target_url="$(resolve_case_target_url "$case_id")"

  echo -e "${CYAN}Running case:${NC} $case_id (iteration ${iteration}/${MAX_ITERATIONS})"
  echo -e "${CYAN}Target URL:${NC} $target_url"

  if [[ "$DRY_RUN" == true ]]; then
    echo "[DRY RUN] Tool=$SELECTED_TOOL Case=$case_id URL=$target_url" | tee "$case_log"
    printf "%s\t%s\t%s\t%s\n" "$case_id" "$target_url" "passed" "dry-run" >>"$RESULTS_FILE"
    return 0
  fi

  if run_with_tool "$case_id" "$target_url" "$case_log" "$safe_case" "$iteration"; then
    echo -e "${GREEN}✓ ${case_id} PASSED${NC}"
    printf "%s\t%s\t%s\t%s\n" "$case_id" "$target_url" "passed" "ok" >>"$RESULTS_FILE"
    return 0
  fi

  echo -e "${RED}✗ ${case_id} FAILED${NC}"
  printf "%s\t%s\t%s\t%s\n" "$case_id" "$target_url" "failed" "see ${safe_case}-iter${iteration}.log" >>"$RESULTS_FILE"
  upsert_test_memory "$case_id" "failed" "$case_log"
  return 1
}

LAST_BATCH_PASSED=0
LAST_BATCH_FAILED=0

run_case_batch() {
  local iteration="$1"
  LAST_BATCH_PASSED=0
  LAST_BATCH_FAILED=0

  local case_ids=()
  while IFS= read -r cid; do
    [[ -n "$cid" ]] && case_ids+=("$cid")
  done < <(extract_case_ids "$TEST_TYPE")

  if [[ ${#case_ids[@]} -eq 0 ]]; then
    echo -e "${YELLOW}Warning: no test cases found for type '$TEST_TYPE' in $TEST_FILE${NC}"
    return 0
  fi

  for case_id in "${case_ids[@]}"; do
    if run_single_case "$case_id" "$iteration"; then
      ((LAST_BATCH_PASSED += 1))
    else
      ((LAST_BATCH_FAILED += 1))
    fi
  done

  echo
  echo "Batch Result: ${LAST_BATCH_PASSED} passed, ${LAST_BATCH_FAILED} failed"

  [[ $LAST_BATCH_FAILED -eq 0 ]]
}

update_test_progress() {
  local status="$1"
  local passed="$2"
  local failed="$3"

  local progress_file="$STATE_DIR/test-progress.json"
  local now
  now="$(iso_now)"

  python3 - "$progress_file" "$VERSION" "$FEATURE" "$status" "$passed" "$failed" "$TEST_TYPE" "$SELECTED_TOOL" "$now" <<'PY'
import json, sys
from pathlib import Path

(progress_file, version, feature, status, passed, failed, test_type, tool, now) = sys.argv[1:]
passed = int(passed)
failed = int(failed)

p = Path(progress_file)
if p.exists():
    try:
        data = json.loads(p.read_text(encoding="utf-8"))
    except Exception:
        data = {"project": "product-toolkit", "versions": []}
else:
    data = {"project": "product-toolkit", "versions": []}

versions = data.setdefault("versions", [])
version_obj = next((v for v in versions if v.get("version") == version), None)
if version_obj is None:
    version_obj = {"version": version, "test_cases": []}
    versions.append(version_obj)

version_obj.setdefault("test_cases", []).append(
    {
        "feature": feature,
        "status": status,
        "passed": passed,
        "failed": failed,
        "test_type": test_type,
        "tool": tool,
        "timestamp": now,
    }
)

runs = version_obj["test_cases"]
summary = {
    "total_runs": len(runs),
    "passed_runs": sum(1 for r in runs if r.get("status") == "passed"),
    "failed_runs": sum(1 for r in runs if r.get("status") == "failed"),
    "updated_at": now,
}
version_obj["summary"] = summary

p.parent.mkdir(parents=True, exist_ok=True)
p.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
PY

  echo -e "${CYAN}Test progress updated:${NC} $progress_file"
}

generate_report() {
  local final_status="$1"
  local passed="$2"
  local failed="$3"
  local total
  total=$((passed + failed))

  local coverage=0
  if (( total > 0 )); then
    coverage=$((passed * 100 / total))
  fi

  cat <<REPORT

========================================
Test Report: $VERSION - $FEATURE
========================================
Tool:          $SELECTED_TOOL
Test Type:     $TEST_TYPE
Total Cases:   $total
Passed:        $passed
Failed:        $failed
Coverage:      ${coverage}%
Status:        $final_status
Evidence Dir:  $EVIDENCE_DIR/$VERSION/$FEATURE/
Memory File:   $TEST_MEMORY_FILE
REPORT

  if [[ -s "$RESULTS_FILE" ]]; then
    echo
    echo "Case Results:"
    printf "%-18s %-45s %-8s %s\n" "CASE" "URL" "STATUS" "NOTES"
    printf "%-18s %-45s %-8s %s\n" "------------------" "---------------------------------------------" "--------" "-----"
    while IFS=$'\t' read -r cid curl cstatus cnote; do
      printf "%-18s %-45s %-8s %s\n" "$cid" "$curl" "$cstatus" "$cnote"
    done < "$RESULTS_FILE"
  fi

  if [[ "$final_status" == "passed" ]]; then
    echo -e "${GREEN}✓ ALL TESTS PASSED${NC}"
  else
    echo -e "${RED}✗ TESTS FAILED${NC}"
    echo -e "${YELLOW}已记录失败记忆，后续执行会自动提示历史踩坑。${NC}"
  fi
}

validate_args() {
  [[ -n "$VERSION" ]] || { echo -e "${RED}Error: --version is required${NC}"; usage; }
  [[ -n "$FEATURE" ]] || { echo -e "${RED}Error: --feature is required${NC}"; usage; }

  case "$TEST_TYPE" in
    smoke|regression|full) ;;
    *)
      echo -e "${RED}Error: invalid --type '$TEST_TYPE' (expected smoke|regression|full)${NC}"
      exit 1
      ;;
  esac

  if ! [[ "$MAX_ITERATIONS" =~ ^[0-9]+$ ]] || (( MAX_ITERATIONS < 1 )); then
    echo -e "${RED}Error: --iterations must be a positive integer${NC}"
    exit 1
  fi

  if ! [[ "$FRONTEND_TIMEOUT" =~ ^[0-9]+$ ]] || (( FRONTEND_TIMEOUT < 1 )); then
    echo -e "${RED}Error: --frontend-timeout must be a positive integer${NC}"
    exit 1
  fi

  if [[ -n "$FRONTEND_CMD" && ! -d "$FRONTEND_DIR" ]]; then
    echo -e "${RED}Error: frontend dir not found: $FRONTEND_DIR${NC}"
    exit 1
  fi

  case "$TOOL_MODE" in
    auto|agent-browser|browser-use) ;;
    *)
      echo -e "${RED}Error: invalid --tool '$TOOL_MODE'${NC}"
      exit 1
      ;;
  esac
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -v|--version)
        require_value "$1" "${2:-}"
        VERSION="$2"
        shift 2
        ;;
      -f|--feature)
        require_value "$1" "${2:-}"
        FEATURE="$2"
        shift 2
        ;;
      -t|--type)
        require_value "$1" "${2:-}"
        TEST_TYPE="$2"
        shift 2
        ;;
      -i|--iterations)
        require_value "$1" "${2:-}"
        MAX_ITERATIONS="$2"
        shift 2
        ;;
      --test-file)
        require_value "$1" "${2:-}"
        TEST_FILE="$2"
        shift 2
        ;;
      --tool)
        require_value "$1" "${2:-}"
        TOOL_MODE="$2"
        shift 2
        ;;
      --tool-priority)
        require_value "$1" "${2:-}"
        TOOL_PRIORITY="$2"
        shift 2
        ;;
      --headed)
        BROWSER_HEADED=true
        shift
        ;;
      --frontend-cmd)
        require_value "$1" "${2:-}"
        FRONTEND_CMD="$2"
        shift 2
        ;;
      --frontend-dir)
        require_value "$1" "${2:-}"
        FRONTEND_DIR="$2"
        shift 2
        ;;
      --frontend-url)
        require_value "$1" "${2:-}"
        FRONTEND_URL="$2"
        shift 2
        ;;
      --frontend-timeout)
        require_value "$1" "${2:-}"
        FRONTEND_TIMEOUT="$2"
        shift 2
        ;;
      --no-frontend-auto-detect)
        FRONTEND_AUTO_DETECT=false
        shift
        ;;
      --no-frontend-start)
        START_FRONTEND=false
        shift
        ;;
      --memory-file)
        require_value "$1" "${2:-}"
        TEST_MEMORY_FILE="$2"
        shift 2
        ;;
      --dry-run)
        DRY_RUN=true
        shift
        ;;
      -h|--help)
        usage
        ;;
      *)
        echo -e "${RED}Unknown option: $1${NC}"
        usage
        ;;
    esac
  done
}

main() {
  parse_args "$@"
  auto_detect_frontend_if_needed
  validate_args

  normalize_base_url
  create_dirs
  ensure_memory_file
  resolve_test_file
  select_tool

  trap cleanup EXIT INT TERM

  print_header
  show_known_pitfalls
  echo

  start_frontend_if_needed
  if ! verify_server_with_tool; then
    echo -e "${RED}Server verification failed for ${BASE_URL}${NC}"
    echo "Please ensure frontend is running and reachable, then retry."
    exit 1
  fi

  local iteration=1
  local final_status="failed"
  local final_passed=0
  local final_failed=0

  while (( iteration <= MAX_ITERATIONS )); do
    echo
    echo -e "${BLUE}=== Iteration ${iteration}/${MAX_ITERATIONS} ===${NC}"

    if run_case_batch "$iteration"; then
      final_status="passed"
      final_passed="$LAST_BATCH_PASSED"
      final_failed="$LAST_BATCH_FAILED"
      break
    fi

    final_status="failed"
    final_passed="$LAST_BATCH_PASSED"
    final_failed="$LAST_BATCH_FAILED"

    if (( iteration < MAX_ITERATIONS )); then
      echo -e "${YELLOW}Iteration failed. Retrying...${NC}"
    fi

    ((iteration += 1))
  done

  update_test_progress "$final_status" "$final_passed" "$final_failed"
  generate_report "$final_status" "$final_passed" "$final_failed"

  if [[ "$final_status" != "passed" ]]; then
    exit 1
  fi
}

main "$@"
