# v3.6.0 文档索引（Index Only）

> 本文件仅做索引，不承载详细正文。

## 1) 版本总览

- [SUMMARY.md](./SUMMARY.md)
- [v3.6.1 Hotfix Summary](../v3.6.1/SUMMARY.md)

## 2) PRD 与版本分析

- [workflow-evidence-first.md](./prd/workflow-evidence-first.md)
- [workflow-evidence-first（用户故事）](./user-story/workflow-evidence-first.md)
- [current-version-gap-analysis.md](./prd/current-version-gap-analysis.md)

## 3) 执行边界与终态模板

- [boundaries.md](./execution/boundaries.md)
- [terminal.json](./execution/terminal.json)
- [terminal.release-sample.json](./execution/terminal.release-sample.json)
- [terminal.blocked-sample.json](./execution/terminal.blocked-sample.json)
- [raw-command-log.release-sample.jsonl](./execution/raw-command-log.release-sample.jsonl)
- [raw-command-log.blocked-sample.jsonl](./execution/raw-command-log.blocked-sample.jsonl)
- [evidence-manifest.release-sample.json](./execution/evidence-manifest.release-sample.json)
- [evidence-manifest.blocked-sample.json](./execution/evidence-manifest.blocked-sample.json)
- [gate-consistency.release-sample.json](./execution/gate-consistency.release-sample.json)
- [gate-consistency.blocked-sample.json](./execution/gate-consistency.blocked-sample.json)
- [blocked-drill-checklist.md](./execution/blocked-drill-checklist.md)
- [blocked-drill-result.md](./execution/blocked-drill-result.md)
- [blocked-drill-result.json](./execution/blocked-drill-result.json)
- [team-run-log.md](./execution/team-run-log.md)

## 4) 架构设计与职责边界（新增）

- [README.md（架构索引）](./architecture/README.md)
- [system-context.md](./architecture/system-context.md)
- [responsibility-boundaries.md](./architecture/responsibility-boundaries.md)
- [api-contracts.md](./architecture/api-contracts.md)
- [nfr-budgets.md](./architecture/nfr-budgets.md)
- [adr-index.md](./architecture/adr-index.md)

## 5) QA 测试用例

- [workflow-evidence-first（测试用例）](./qa/test-cases/workflow-evidence-first.md)

## 6) OMC / OMX 固化执行模板

- [next-step-prompts.md](./execution/next-step-prompts.md)

## 7) Gate 增强检查（架构治理）

- [gate-architecture-checklist.md](./execution/gate-architecture-checklist.md)

## 8) 交付报告

- [delivery-report.md](./execution/delivery-report.md)
- [review-v3.6.0-fix-report.md](./execution/review-v3.6.0-fix-report.md)

## 9) 验证脚本（仓库级）

- `scripts/validate_terminal_artifacts.py`
- `scripts/check_terminal_artifacts.sh`
- `scripts/run_command_with_evidence.py`
- `scripts/build_evidence_manifest.py`
- `scripts/check_gate_consistency.py`

## 10) workflow 标准产物落点（约定）

- PRD：`docs/product/{version}/prd/{feature}.md`
- 用户故事：`docs/product/{version}/user-story/{feature}.md`
- 测试用例：`docs/product/{version}/qa/test-cases/{feature}.md`
- 架构治理：`docs/product/{version}/architecture/*.md`
- 终态结论：`docs/product/{version}/execution/terminal.json`（或等价路径）
