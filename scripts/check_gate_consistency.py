#!/usr/bin/env python3
"""Run PTK gate consistency checks and optionally write report file."""

from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from evidence_integrity_common import compute_gate_consistency, display_path, load_json


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def main() -> int:
    parser = argparse.ArgumentParser(description="Check terminal gate consistency")
    parser.add_argument("--version", required=True, help="version folder, e.g. v3.6.0")
    parser.add_argument("--terminal", required=True, help="terminal path (repo-relative)")
    parser.add_argument("--output", default="", help="output report path (repo-relative)")
    parser.add_argument("--pretty", action="store_true", help="pretty-print json")
    args = parser.parse_args()

    root = _repo_root()
    terminal_path = root / args.terminal

    payload, err = load_json(terminal_path)
    if err or not isinstance(payload, dict):
        report = {
            "status": "Blocked",
            "checked_at": datetime.now(timezone.utc).isoformat(),
            "terminal": display_path(terminal_path, root),
            "conflicts": [
                {
                    "id": "CONSISTENCY-INPUT-001",
                    "severity": "high",
                    "note": f"terminal 读取失败: {err or 'not_object'}",
                }
            ],
            "metrics": {},
        }
        output = json.dumps(report, ensure_ascii=False, indent=2 if args.pretty else None)
        print(output)
        if args.output:
            out_path = root / args.output
            out_path.parent.mkdir(parents=True, exist_ok=True)
            out_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        return 2

    report: dict[str, Any] = compute_gate_consistency(payload, root, args.version)
    report["checked_at"] = datetime.now(timezone.utc).isoformat()
    report["terminal"] = display_path(terminal_path, root)

    if args.output:
        out_path = root / args.output
        out_path.parent.mkdir(parents=True, exist_ok=True)
        out_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(report, ensure_ascii=False, indent=2 if args.pretty else None))
    return 0 if report.get("status") == "Pass" else 2


if __name__ == "__main__":
    raise SystemExit(main())
