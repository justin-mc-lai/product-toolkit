#!/usr/bin/env python3
"""Common helpers for PTK evidence integrity and gate consistency checks."""

from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Any

PASS_STATUS_WORDS = {
    "pass",
    "passed",
    "ok",
    "done",
    "proved",
    "proven",
    "达标",
    "通过",
}


def load_json(path: Path) -> tuple[dict[str, Any] | None, str | None]:
    try:
        return json.loads(path.read_text(encoding="utf-8")), None
    except Exception as exc:  # noqa: BLE001
        return None, str(exc)


def resolve_ref(ref: str, root: Path) -> Path:
    ref = str(ref).strip()
    if ref.startswith("/"):
        return Path(ref)
    if ref.startswith("./"):
        ref = ref[2:]
    return root / ref


def display_path(path: Path, root: Path) -> str:
    try:
        return str(path.relative_to(root))
    except ValueError:
        return str(path)


def normalize_ref(ref: str, root: Path) -> str:
    return display_path(resolve_ref(ref, root), root)


def unique_refs(refs: list[str]) -> list[str]:
    out: list[str] = []
    seen: set[str] = set()
    for ref in refs:
        item = str(ref).strip()
        if not item or item in seen:
            continue
        seen.add(item)
        out.append(item)
    return out


def collect_evidence_refs(data: dict[str, Any]) -> list[str]:
    refs: list[str] = []

    evidence = data.get("evidence") if isinstance(data, dict) else None
    if isinstance(evidence, dict):
        for key in ("reports", "logs", "screenshots"):
            items = evidence.get(key)
            if isinstance(items, list):
                refs.extend(str(x) for x in items)

    trace = data.get("traceability") if isinstance(data, dict) else None
    if isinstance(trace, list):
        for item in trace:
            if not isinstance(item, dict):
                continue
            items = item.get("evidence_refs")
            if isinstance(items, list):
                refs.extend(str(x) for x in items)

    return refs


def sha256_file(path: Path) -> str:
    hasher = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            hasher.update(chunk)
    return hasher.hexdigest()


def parse_raw_command_log(path: Path) -> dict[str, Any]:
    result: dict[str, Any] = {
        "exists": path.exists(),
        "entry_count": 0,
        "invalid_lines": [],
        "errors": [],
    }
    if not path.exists():
        result["errors"].append("missing")
        return result

    lines = path.read_text(encoding="utf-8").splitlines()
    if not lines:
        result["errors"].append("empty")
        return result

    required = {"cmd", "cwd", "started_at", "ended_at", "exit_code"}

    for idx, line in enumerate(lines, start=1):
        row = line.strip()
        if not row:
            result["invalid_lines"].append({"line": idx, "reason": "blank_line"})
            continue

        try:
            payload = json.loads(row)
        except Exception as exc:  # noqa: BLE001
            result["invalid_lines"].append({"line": idx, "reason": f"json_error:{exc}"})
            continue

        if not isinstance(payload, dict):
            result["invalid_lines"].append({"line": idx, "reason": "not_object"})
            continue

        missing = [key for key in required if key not in payload]
        if missing:
            result["invalid_lines"].append({"line": idx, "reason": f"missing_keys:{','.join(missing)}"})
            continue

        cmd = payload.get("cmd")
        cwd = payload.get("cwd")
        started_at = payload.get("started_at")
        ended_at = payload.get("ended_at")
        exit_code = payload.get("exit_code")

        if not isinstance(cmd, str) or not cmd.strip():
            result["invalid_lines"].append({"line": idx, "reason": "invalid_cmd"})
            continue
        if not isinstance(cwd, str) or not cwd.strip():
            result["invalid_lines"].append({"line": idx, "reason": "invalid_cwd"})
            continue
        if not isinstance(started_at, str) or not started_at.strip():
            result["invalid_lines"].append({"line": idx, "reason": "invalid_started_at"})
            continue
        if not isinstance(ended_at, str) or not ended_at.strip():
            result["invalid_lines"].append({"line": idx, "reason": "invalid_ended_at"})
            continue
        if not isinstance(exit_code, int):
            result["invalid_lines"].append({"line": idx, "reason": "invalid_exit_code"})
            continue

        result["entry_count"] += 1

    if result["entry_count"] == 0 and not result["invalid_lines"]:
        result["errors"].append("no_valid_entries")

    result["valid"] = result["entry_count"] > 0 and not result["invalid_lines"] and not result["errors"]
    return result


def unresolved_api_drift_ids(data: dict[str, Any]) -> list[str]:
    architecture_governance = data.get("architecture_governance")
    if not isinstance(architecture_governance, dict):
        return []

    api_contract_drift = architecture_governance.get("api_contract_drift")
    if not isinstance(api_contract_drift, list):
        return []

    unresolved: list[str] = []
    for item in api_contract_drift:
        if isinstance(item, dict):
            status = str(item.get("status", "open")).strip().lower()
            if status != "resolved":
                unresolved.append(str(item.get("id", "<unknown>")))
        else:
            unresolved.append(str(item))

    return unresolved


def unproven_nfr_items(data: dict[str, Any]) -> list[str]:
    architecture_governance = data.get("architecture_governance")
    if not isinstance(architecture_governance, dict):
        return []

    nfr_budget_unproven = architecture_governance.get("nfr_budget_unproven")
    if not isinstance(nfr_budget_unproven, list):
        return []

    return [str(item) for item in nfr_budget_unproven]


def blocking_open_question_ids(data: dict[str, Any]) -> list[str]:
    next_round = data.get("next_round")
    if not isinstance(next_round, dict):
        return []

    open_questions = next_round.get("new_open_questions")
    if not isinstance(open_questions, list):
        return []

    blocking_ids: list[str] = []
    for item in open_questions:
        if not isinstance(item, dict):
            continue
        if item.get("blocking") is True and str(item.get("status", "open")).strip().lower() != "closed":
            blocking_ids.append(str(item.get("id", "<unknown>")))

    return blocking_ids


def _is_template_markdown(text: str) -> bool:
    if not text.strip():
        return True

    markers = [
        "<feature-name>",
        "<nfr_id>",
        "<change>",
        "vX.Y.Z",
        "YYYY-MM-DD",
    ]
    if any(marker in text for marker in markers):
        return True

    placeholder_count = len(re.findall(r"<[^>]+>", text))
    return placeholder_count >= 3


def _extract_md_section(text: str, heading_pattern: str) -> str:
    lines = text.splitlines()
    start_idx = -1
    heading_regex = re.compile(heading_pattern, flags=re.IGNORECASE)

    for idx, line in enumerate(lines):
        if heading_regex.search(line.strip()):
            start_idx = idx + 1
            break

    if start_idx < 0:
        return ""

    buf: list[str] = []
    for line in lines[start_idx:]:
        if line.strip().startswith("## "):
            break
        buf.append(line)
    return "\n".join(buf).strip()


def parse_api_contracts_doc(path: Path) -> dict[str, Any]:
    result: dict[str, Any] = {
        "path": str(path),
        "exists": path.exists(),
        "known": False,
        "template": False,
        "open_count": 0,
        "resolved_count": 0,
        "declared_no_open": False,
        "open_lines": [],
    }
    if not path.exists():
        return result

    text = path.read_text(encoding="utf-8")
    if _is_template_markdown(text):
        result["template"] = True
        return result

    section = _extract_md_section(text, r"^##\s+.*(drift|变更记录)") or text
    lines = [line.strip() for line in section.splitlines() if line.strip()]

    open_lines: list[str] = []
    resolved = 0
    declared_no_open = False

    for line in lines:
        low = line.lower()
        if "无 open drift" in line or "no open drift" in low:
            declared_no_open = True
            continue
        if not line.startswith("-") and not line.startswith("|"):
            continue

        if "resolved" in low or "closed" in low or "已关闭" in line:
            resolved += 1
            continue

        if line.startswith("|"):
            cells = [cell.strip().lower() for cell in line.strip().strip("|").split("|")]
            if any("open" == cell for cell in cells):
                open_lines.append(line)
            continue

        open_lines.append(line)

    result["known"] = True
    result["declared_no_open"] = declared_no_open
    result["resolved_count"] = resolved
    result["open_lines"] = open_lines
    result["open_count"] = len(open_lines)
    return result


def parse_nfr_budgets_doc(path: Path) -> dict[str, Any]:
    result: dict[str, Any] = {
        "path": str(path),
        "exists": path.exists(),
        "known": False,
        "template": False,
        "statuses": [],
        "non_pass_statuses": [],
        "non_pass_count": 0,
    }
    if not path.exists():
        return result

    text = path.read_text(encoding="utf-8")
    if _is_template_markdown(text):
        result["template"] = True
        return result

    statuses: list[str] = []
    for line in text.splitlines():
        stripped = line.strip()
        if not stripped.startswith("|"):
            continue
        compact = stripped.replace(" ", "")
        if compact.startswith("|---"):
            continue

        cells = [cell.strip().strip("`") for cell in stripped.strip("|").split("|")]
        if len(cells) < 4:
            continue

        # Only count rows in the NFR budget table (first cell like NFR-xxxx).
        first_cell = cells[0].lower()
        if not (first_cell.startswith("nfr-") or first_cell == "nfr_id"):
            continue

        status = cells[-1].strip().lower()
        if status in {"", "状态", "状态（pass/blocked/unproven）"}:
            continue
        statuses.append(status)

    non_pass = [status for status in statuses if status not in PASS_STATUS_WORDS]

    result["known"] = True
    result["statuses"] = statuses
    result["non_pass_statuses"] = non_pass
    result["non_pass_count"] = len(non_pass)
    return result


def compute_gate_consistency(data: dict[str, Any], root: Path, version: str) -> dict[str, Any]:
    source_artifacts = data.get("source_artifacts") if isinstance(data.get("source_artifacts"), dict) else {}

    api_ref = str(source_artifacts.get("architecture_contracts") or f"docs/product/{version}/architecture/api-contracts.md")
    nfr_ref = str(source_artifacts.get("architecture_nfr") or f"docs/product/{version}/architecture/nfr-budgets.md")

    api_path = resolve_ref(api_ref, root)
    nfr_path = resolve_ref(nfr_ref, root)

    unresolved_api = unresolved_api_drift_ids(data)
    unproven_nfr = unproven_nfr_items(data)
    blocking_ids = blocking_open_question_ids(data)

    conflicts: list[dict[str, Any]] = []

    terminal = data.get("terminal") if isinstance(data.get("terminal"), dict) else {}
    terminal_status = str(terminal.get("status", ""))
    terminal_reason_codes = terminal.get("reason_codes") if isinstance(terminal.get("reason_codes"), list) else []

    if terminal_status == "Pass" and terminal_reason_codes:
        conflicts.append(
            {
                "id": "CONSISTENCY-TERMINAL-001",
                "severity": "high",
                "note": "terminal.status=Pass 但 terminal.reason_codes 非空。",
            }
        )
    if terminal_status == "Blocked" and not terminal_reason_codes:
        conflicts.append(
            {
                "id": "CONSISTENCY-TERMINAL-002",
                "severity": "medium",
                "note": "terminal.status=Blocked 但 terminal.reason_codes 为空。",
            }
        )

    acceptance = data.get("acceptance") if isinstance(data.get("acceptance"), dict) else {}
    acceptance_blocking = acceptance.get("blocking_open_questions")
    if isinstance(acceptance_blocking, int) and acceptance_blocking != len(blocking_ids):
        conflicts.append(
            {
                "id": "CONSISTENCY-ACCEPTANCE-001",
                "severity": "medium",
                "note": f"acceptance.blocking_open_questions={acceptance_blocking} 与实际 blocking 数量={len(blocking_ids)} 不一致。",
            }
        )

    api_doc = parse_api_contracts_doc(api_path)
    if api_doc.get("known"):
        doc_open_count = int(api_doc.get("open_count", 0))
        if unresolved_api and doc_open_count == 0 and bool(api_doc.get("declared_no_open")):
            conflicts.append(
                {
                    "id": "CONSISTENCY-API-001",
                    "severity": "high",
                    "note": "terminal 声明存在未解决 API drift，但 api-contracts.md 声明无 open drift。",
                }
            )
        if not unresolved_api and doc_open_count > 0:
            conflicts.append(
                {
                    "id": "CONSISTENCY-API-002",
                    "severity": "high",
                    "note": "terminal 声明 API drift 已清零，但 api-contracts.md 仍有 open drift。",
                }
            )

    nfr_doc = parse_nfr_budgets_doc(nfr_path)
    if nfr_doc.get("known"):
        doc_non_pass_count = int(nfr_doc.get("non_pass_count", 0))
        if unproven_nfr and doc_non_pass_count == 0:
            conflicts.append(
                {
                    "id": "CONSISTENCY-NFR-001",
                    "severity": "high",
                    "note": "terminal 声明存在 nfr_budget_unproven，但 nfr-budgets.md 全部为 pass。",
                }
            )
        if not unproven_nfr and doc_non_pass_count > 0:
            conflicts.append(
                {
                    "id": "CONSISTENCY-NFR-002",
                    "severity": "high",
                    "note": "terminal 声明 NFR 已清零，但 nfr-budgets.md 仍存在 blocked/unproven。",
                }
            )

    return {
        "status": "Pass" if not conflicts else "Blocked",
        "conflicts": conflicts,
        "refs": {
            "api_contracts": display_path(api_path, root),
            "nfr_budgets": display_path(nfr_path, root),
        },
        "metrics": {
            "terminal_status": terminal_status,
            "terminal_reason_code_count": len(terminal_reason_codes),
            "blocking_open_question_count": len(blocking_ids),
            "blocking_open_question_ids": blocking_ids,
            "terminal_unresolved_api_drift_count": len(unresolved_api),
            "terminal_unresolved_api_drift_ids": unresolved_api,
            "terminal_unproven_nfr_count": len(unproven_nfr),
            "terminal_unproven_nfr_items": unproven_nfr,
            "api_doc_known": bool(api_doc.get("known")),
            "api_doc_template": bool(api_doc.get("template")),
            "api_doc_open_drift_count": int(api_doc.get("open_count", 0)),
            "nfr_doc_known": bool(nfr_doc.get("known")),
            "nfr_doc_template": bool(nfr_doc.get("template")),
            "nfr_doc_non_pass_count": int(nfr_doc.get("non_pass_count", 0)),
            "nfr_doc_non_pass_statuses": nfr_doc.get("non_pass_statuses", []),
        },
    }
