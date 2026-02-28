#!/usr/bin/env python3
"""Run a shell command and append immutable raw-command-log JSONL evidence."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from datetime import datetime, timezone
from pathlib import Path

from evidence_integrity_common import sha256_file


def _slug(text: str) -> str:
    cleaned = re.sub(r"[^a-zA-Z0-9._-]+", "-", text.strip())
    cleaned = cleaned.strip("-")
    if not cleaned:
        return "cmd"
    return cleaned[:48]


def main() -> int:
    parser = argparse.ArgumentParser(description="Run command and capture raw evidence")
    parser.add_argument("--log", required=True, help="raw command log jsonl path")
    parser.add_argument("--cmd", required=True, help="command string")
    parser.add_argument("--cwd", default=".", help="working directory")
    parser.add_argument("--output-dir", default="", help="output log directory")
    args = parser.parse_args()

    cwd = Path(args.cwd).resolve()
    log_path = Path(args.log).resolve()
    output_dir = Path(args.output_dir).resolve() if args.output_dir else log_path.parent / "raw-command-outputs"

    output_dir.mkdir(parents=True, exist_ok=True)
    log_path.parent.mkdir(parents=True, exist_ok=True)

    started = datetime.now(timezone.utc)
    proc = subprocess.run(args.cmd, shell=True, cwd=str(cwd), capture_output=True, text=True)
    ended = datetime.now(timezone.utc)

    stamp = started.strftime("%Y%m%dT%H%M%SZ")
    out_file = output_dir / f"{stamp}-{_slug(args.cmd)}.log"
    merged = (proc.stdout or "") + (proc.stderr or "")
    out_file.write_text(merged, encoding="utf-8")

    record = {
        "cmd": args.cmd,
        "cwd": str(cwd),
        "started_at": started.isoformat(),
        "ended_at": ended.isoformat(),
        "duration_ms": int((ended - started).total_seconds() * 1000),
        "exit_code": int(proc.returncode),
        "output_file": str(out_file),
        "output_sha256": sha256_file(out_file),
    }

    with log_path.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(record, ensure_ascii=False) + "\n")

    if proc.stdout:
        print(proc.stdout, end="")
    if proc.stderr:
        print(proc.stderr, end="")

    return int(proc.returncode)


if __name__ == "__main__":
    raise SystemExit(main())
