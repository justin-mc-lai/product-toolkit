#!/usr/bin/env python3
"""Validate v3.6.0 evidence-first terminal artifacts.

Includes architecture governance + integrity checks:
- required architecture files under docs/product/{version}/architecture
- ownership boundaries / api drift / nfr proof fields
- raw command log validation
- sha256 manifest coverage + hash verification
- gate consistency cross-check (terminal vs architecture docs)

Usage:
  python3 scripts/validate_terminal_artifacts.py --version v3.6.0
  python3 scripts/validate_terminal_artifacts.py --version v3.6.0 --terminal docs/product/v3.6.0/execution/terminal.release-sample.json

Exit codes:
  0 => Pass
  2 => Blocked (one or more checks failed)
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

from evidence_integrity_common import (
    collect_evidence_refs,
    compute_gate_consistency,
    display_path,
    load_json,
    normalize_ref,
    parse_raw_command_log,
    resolve_ref,
    sha256_file,
    unique_refs,
)


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def _add_reason(reasons: list[str], code: str) -> None:
    if code not in reasons:
        reasons.append(code)


def _validate_boundaries(path: Path, reasons: list[str], details: dict[str, Any]) -> None:
    if not path.exists():
        _add_reason(reasons, "boundaries_missing")
        details["boundaries_exists"] = False
        return

    details["boundaries_exists"] = True
    txt = path.read_text(encoding="utf-8")
    required_markers = [
        "## 2. In Scope",
        "## 3. Out of Scope",
        "## 5. Done 边界",
        "## 6. Blocked 条件",
        "## 8. 输出产物",
    ]
    missing = [m for m in required_markers if m not in txt]
    details["boundaries_missing_markers"] = missing
    if missing:
        _add_reason(reasons, "boundaries_schema_invalid")


def _validate_architecture_artifacts(version: str, root: Path, reasons: list[str], details: dict[str, Any]) -> None:
    arch_base = root / "docs" / "product" / version / "architecture"
    required_files = [
        "system-context.md",
        "responsibility-boundaries.md",
        "api-contracts.md",
        "nfr-budgets.md",
        "adr-index.md",
    ]

    missing: list[str] = []
    for name in required_files:
        p = arch_base / name
        if not p.exists():
            missing.append(display_path(p, root))

    details["architecture_base_path"] = display_path(arch_base, root)
    details["architecture_required_files"] = required_files
    details["missing_architecture_artifacts"] = missing
    if missing:
        _add_reason(reasons, "arch_artifact_missing")


def _validate_terminal_schema(path: Path, root: Path, reasons: list[str], details: dict[str, Any]) -> dict[str, Any] | None:
    if not path.exists():
        _add_reason(reasons, "terminal_artifact_missing")
        details["terminal_exists"] = False
        return None

    details["terminal_exists"] = True
    data, err = load_json(path)
    if err:
        _add_reason(reasons, "terminal_schema_invalid")
        details["terminal_json_error"] = err
        return None

    assert data is not None

    terminal = data.get("terminal")
    if not isinstance(terminal, dict):
        _add_reason(reasons, "terminal_schema_invalid")
        details["terminal_object"] = False
        return None

    status = terminal.get("status")
    details["terminal_status"] = status
    if status not in {"Pass", "Blocked", "Cancelled"}:
        _add_reason(reasons, "terminal_schema_invalid")
        _add_reason(reasons, "terminal_status_invalid")

    if "traceability" in terminal:
        _add_reason(reasons, "terminal_schema_invalid")
        details["traceability_location_error"] = "traceability must be top-level, not terminal.traceability"

    reason_codes = terminal.get("reason_codes")
    if not isinstance(reason_codes, list):
        _add_reason(reasons, "terminal_schema_invalid")
        details["reason_codes_type"] = str(type(reason_codes).__name__)
    else:
        invalid = [str(code) for code in reason_codes if not isinstance(code, str) or not code.strip()]
        if invalid:
            _add_reason(reasons, "terminal_schema_invalid")
            details["reason_codes_invalid_items"] = invalid

    next_round = data.get("next_round")
    if isinstance(next_round, dict):
        open_questions = next_round.get("new_open_questions")
        if isinstance(open_questions, list):
            blocking_open: list[str] = []
            for item in open_questions:
                if not isinstance(item, dict):
                    continue
                if item.get("blocking") is True and str(item.get("status", "open")).lower() != "closed":
                    blocking_open.append(str(item.get("id", "<unknown>")))
            if blocking_open:
                _add_reason(reasons, "blocking_open_question_exists")
                details["blocking_open_question_ids"] = blocking_open

    architecture_governance = data.get("architecture_governance")
    if not isinstance(architecture_governance, dict):
        _add_reason(reasons, "terminal_schema_invalid")
        details["architecture_governance_type"] = str(type(architecture_governance).__name__)
    else:
        ownership_confirmed = architecture_governance.get("ownership_boundaries_confirmed")
        if not isinstance(ownership_confirmed, bool):
            _add_reason(reasons, "terminal_schema_invalid")
            details["ownership_boundaries_confirmed_type"] = str(type(ownership_confirmed).__name__)
        elif ownership_confirmed is not True:
            _add_reason(reasons, "ownership_boundary_unclear")

        api_contract_drift = architecture_governance.get("api_contract_drift")
        if not isinstance(api_contract_drift, list):
            _add_reason(reasons, "terminal_schema_invalid")
            details["api_contract_drift_type"] = str(type(api_contract_drift).__name__)
        else:
            unresolved_ids: list[str] = []
            for item in api_contract_drift:
                if isinstance(item, dict):
                    item_status = str(item.get("status", "open")).lower()
                    if item_status != "resolved":
                        unresolved_ids.append(str(item.get("id", "<unknown>")))
                else:
                    unresolved_ids.append(str(item))
            if unresolved_ids:
                _add_reason(reasons, "api_contract_drift")
                details["open_api_contract_drift_ids"] = unresolved_ids

        nfr_budget_unproven = architecture_governance.get("nfr_budget_unproven")
        if not isinstance(nfr_budget_unproven, list):
            _add_reason(reasons, "terminal_schema_invalid")
            details["nfr_budget_unproven_type"] = str(type(nfr_budget_unproven).__name__)
        elif nfr_budget_unproven:
            _add_reason(reasons, "nfr_budget_unproven")
            details["nfr_budget_unproven_items"] = [str(item) for item in nfr_budget_unproven]

    trace = data.get("traceability")
    if not isinstance(trace, list):
        _add_reason(reasons, "terminal_schema_invalid")
        details["traceability_type"] = str(type(trace).__name__)
        details["traceability_expected_location"] = "top-level traceability"
    else:
        empty_tc_ac_ids: list[str] = []
        malformed_traceability: list[str] = []
        for item in trace:
            if not isinstance(item, dict):
                _add_reason(reasons, "terminal_schema_invalid")
                continue

            ac_id = item.get("ac_id")
            if not isinstance(ac_id, str) or not ac_id.strip():
                malformed_traceability.append("missing_ac_id")

            result = item.get("result")
            if result not in {"Pass", "Blocked", "Cancelled"}:
                malformed_traceability.append(f"invalid_result:{ac_id or '<unknown>'}")

            tc_ids = item.get("tc_ids")
            if not isinstance(tc_ids, list):
                _add_reason(reasons, "terminal_schema_invalid")
                continue
            if len(tc_ids) == 0:
                empty_tc_ac_ids.append(str(item.get("ac_id", "<unknown>")))

            evidence_refs = item.get("evidence_refs")
            if not isinstance(evidence_refs, list):
                malformed_traceability.append(f"invalid_evidence_refs:{ac_id or '<unknown>'}")

        if malformed_traceability:
            _add_reason(reasons, "terminal_schema_invalid")
            details["traceability_schema_issues"] = malformed_traceability

        if empty_tc_ac_ids:
            _add_reason(reasons, "ac_tc_mapping_gap")
            details["ac_ids_with_empty_tc"] = empty_tc_ac_ids

    evidence = data.get("evidence")
    if not isinstance(evidence, dict):
        _add_reason(reasons, "terminal_schema_invalid")

    refs = collect_evidence_refs(data)
    details["evidence_ref_count"] = len(refs)

    style_inconsistent = [r for r in refs if str(r).startswith("product-toolkit/")]
    if style_inconsistent:
        _add_reason(reasons, "evidence_ref_path_style_inconsistent")
        details["style_inconsistent_refs"] = style_inconsistent

    missing_refs: list[str] = []
    for ref in refs:
        p = resolve_ref(ref, root)
        if not p.exists():
            missing_refs.append(ref)
    if missing_refs:
        _add_reason(reasons, "terminal_evidence_missing")
        details["missing_evidence_refs"] = missing_refs

    return data


def _validate_evidence_integrity(
    data: dict[str, Any],
    terminal_path: Path,
    root: Path,
    reasons: list[str],
    details: dict[str, Any],
    consistency: dict[str, Any],
) -> None:
    integrity = data.get("evidence_integrity")
    if not isinstance(integrity, dict):
        _add_reason(reasons, "evidence_integrity_missing")
        details["evidence_integrity_exists"] = False
        return

    details["evidence_integrity_exists"] = True

    raw_ref = integrity.get("raw_command_log")
    manifest_ref = integrity.get("sha256_manifest")
    consistency_ref = integrity.get("gate_consistency_report")

    if not isinstance(raw_ref, str) or not raw_ref.strip():
        _add_reason(reasons, "raw_command_log_missing")
        details["raw_command_log_ref"] = raw_ref
        raw_path = None
    else:
        raw_path = resolve_ref(raw_ref, root)
        details["raw_command_log_path"] = display_path(raw_path, root)
        raw_info = parse_raw_command_log(raw_path)
        details["raw_command_log"] = raw_info
        if not raw_path.exists():
            _add_reason(reasons, "raw_command_log_missing")
        elif not raw_info.get("valid"):
            _add_reason(reasons, "raw_command_log_invalid")

    report_path = None
    if not isinstance(consistency_ref, str) or not consistency_ref.strip():
        _add_reason(reasons, "gate_consistency_report_missing")
        details["gate_consistency_report_ref"] = consistency_ref
    else:
        report_path = resolve_ref(consistency_ref, root)
        details["gate_consistency_report_path"] = display_path(report_path, root)
        if not report_path.exists():
            _add_reason(reasons, "gate_consistency_report_missing")
        else:
            report_data, report_err = load_json(report_path)
            if report_err or not isinstance(report_data, dict):
                _add_reason(reasons, "gate_consistency_report_invalid")
                details["gate_consistency_report_error"] = report_err or "not_object"
            else:
                report_status = report_data.get("status")
                report_conflicts = report_data.get("conflicts")
                if report_status not in {"Pass", "Blocked"} or not isinstance(report_conflicts, list):
                    _add_reason(reasons, "gate_consistency_report_invalid")
                    details["gate_consistency_report_schema"] = "invalid_status_or_conflicts"
                else:
                    if report_status != consistency.get("status") or len(report_conflicts) != len(consistency.get("conflicts", [])):
                        _add_reason(reasons, "gate_consistency_report_mismatch")
                        details["gate_consistency_report_mismatch"] = {
                            "expected_status": consistency.get("status"),
                            "actual_status": report_status,
                            "expected_conflict_count": len(consistency.get("conflicts", [])),
                            "actual_conflict_count": len(report_conflicts),
                        }

    manifest_path = None
    if not isinstance(manifest_ref, str) or not manifest_ref.strip():
        _add_reason(reasons, "evidence_sha256_manifest_missing")
        details["sha256_manifest_ref"] = manifest_ref
    else:
        manifest_path = resolve_ref(manifest_ref, root)
        details["sha256_manifest_path"] = display_path(manifest_path, root)
        if not manifest_path.exists():
            _add_reason(reasons, "evidence_sha256_manifest_missing")
        else:
            manifest_data, manifest_err = load_json(manifest_path)
            if manifest_err or not isinstance(manifest_data, dict):
                _add_reason(reasons, "evidence_sha256_manifest_invalid")
                details["sha256_manifest_error"] = manifest_err or "not_object"
                return

            items = manifest_data.get("items")
            if not isinstance(items, list):
                _add_reason(reasons, "evidence_sha256_manifest_invalid")
                details["sha256_manifest_schema"] = "items_not_list"
                return

            manifest_map: dict[str, dict[str, Any]] = {}
            manifest_invalid_items: list[str] = []
            for item in items:
                if not isinstance(item, dict):
                    manifest_invalid_items.append("not_object")
                    continue

                ref = item.get("path")
                digest = item.get("sha256")
                if not isinstance(ref, str) or not ref.strip() or not isinstance(digest, str) or not digest.strip():
                    manifest_invalid_items.append(str(ref))
                    continue

                normalized = normalize_ref(ref, root)
                manifest_map[normalized] = item

            if manifest_invalid_items:
                _add_reason(reasons, "evidence_sha256_manifest_invalid")
                details["sha256_manifest_invalid_items"] = manifest_invalid_items

            required_refs = collect_evidence_refs(data)
            if isinstance(raw_ref, str) and raw_ref.strip():
                required_refs.append(raw_ref)
            if isinstance(consistency_ref, str) and consistency_ref.strip():
                required_refs.append(consistency_ref)
            required_refs.append(display_path(terminal_path, root))

            normalized_required = unique_refs([normalize_ref(ref, root) for ref in required_refs])
            details["sha256_manifest_required_ref_count"] = len(normalized_required)

            missing_in_manifest = [ref for ref in normalized_required if ref not in manifest_map]
            if missing_in_manifest:
                _add_reason(reasons, "evidence_sha256_manifest_incomplete")
                details["sha256_manifest_missing_refs"] = missing_in_manifest

            mismatched_refs: list[str] = []
            missing_files: list[str] = []
            for normalized_ref, item in manifest_map.items():
                ref_path = resolve_ref(normalized_ref, root)
                if not ref_path.exists():
                    missing_files.append(normalized_ref)
                    continue

                expected = str(item.get("sha256", "")).lower()
                actual = sha256_file(ref_path)
                if expected != actual:
                    mismatched_refs.append(normalized_ref)

            if missing_files:
                _add_reason(reasons, "evidence_sha256_manifest_invalid")
                details["sha256_manifest_missing_files"] = missing_files

            if mismatched_refs:
                _add_reason(reasons, "evidence_sha256_manifest_mismatch")
                details["sha256_manifest_mismatched_refs"] = mismatched_refs


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate PTK v3.6.0 terminal evidence artifacts")
    parser.add_argument("--version", required=True, help="version folder, e.g. v3.6.0")
    parser.add_argument("--terminal", default="", help="override terminal json path (repo-relative)")
    parser.add_argument("--boundaries", default="", help="override boundaries path (repo-relative)")
    parser.add_argument("--pretty", action="store_true", help="pretty-print json")
    args = parser.parse_args()

    root = _repo_root()
    default_exec = root / "docs" / "product" / args.version / "execution"

    terminal_path = root / args.terminal if args.terminal else default_exec / "terminal.json"
    boundaries_path = root / args.boundaries if args.boundaries else default_exec / "boundaries.md"

    reasons: list[str] = []
    details: dict[str, Any] = {
        "version": args.version,
        "terminal_path": display_path(terminal_path, root),
        "boundaries_path": display_path(boundaries_path, root),
    }

    _validate_boundaries(boundaries_path, reasons, details)
    _validate_architecture_artifacts(args.version, root, reasons, details)
    data = _validate_terminal_schema(terminal_path, root, reasons, details)

    if data is not None:
        consistency = compute_gate_consistency(data, root, args.version)
        details["gate_consistency"] = consistency
        if consistency.get("status") != "Pass":
            _add_reason(reasons, "gate_consistency_conflict")

        _validate_evidence_integrity(data, terminal_path, root, reasons, details, consistency)

    status = "Pass" if not reasons else "Blocked"
    payload = {
        "status": status,
        "reason_codes": reasons,
        "details": details,
    }

    if args.pretty:
        print(json.dumps(payload, ensure_ascii=False, indent=2))
    else:
        print(json.dumps(payload, ensure_ascii=False))

    return 0 if status == "Pass" else 2


if __name__ == "__main__":
    raise SystemExit(main())
