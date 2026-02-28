#!/usr/bin/env python3
"""Build sha256 manifest for terminal evidence refs."""

from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from evidence_integrity_common import (
    collect_evidence_refs,
    display_path,
    load_json,
    resolve_ref,
    sha256_file,
    unique_refs,
)


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def main() -> int:
    parser = argparse.ArgumentParser(description="Build sha256 manifest from terminal evidence refs")
    parser.add_argument("--terminal", required=True, help="terminal path (repo-relative)")
    parser.add_argument("--output", required=True, help="manifest output path (repo-relative)")
    parser.add_argument("--pretty", action="store_true", help="pretty-print json to stdout")
    args = parser.parse_args()

    root = _repo_root()
    terminal_path = root / args.terminal
    output_path = root / args.output

    terminal_data, err = load_json(terminal_path)
    if err or not isinstance(terminal_data, dict):
        raise SystemExit(f"failed to read terminal json: {err or 'not_object'}")

    refs = collect_evidence_refs(terminal_data)
    integrity = terminal_data.get("evidence_integrity")
    if isinstance(integrity, dict):
        for key in ("raw_command_log", "gate_consistency_report"):
            val = integrity.get(key)
            if isinstance(val, str) and val.strip():
                refs.append(val)

    refs.append(args.terminal)
    refs = unique_refs(refs)

    items: list[dict[str, Any]] = []
    missing: list[str] = []

    for ref in refs:
        ref_path = resolve_ref(ref, root)
        if not ref_path.exists():
            missing.append(ref)
            continue

        stat = ref_path.stat()
        items.append(
            {
                "path": ref,
                "sha256": sha256_file(ref_path),
                "size_bytes": stat.st_size,
                "mtime": datetime.fromtimestamp(stat.st_mtime, tz=timezone.utc).isoformat(),
            }
        )

    manifest = {
        "schema_version": "1.0",
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "terminal": display_path(terminal_path, root),
        "summary": {
            "item_count": len(items),
            "missing_count": len(missing),
        },
        "items": items,
        "missing": missing,
    }

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(manifest, ensure_ascii=False, indent=2 if args.pretty else None))
    return 0 if not missing else 2


if __name__ == "__main__":
    raise SystemExit(main())
