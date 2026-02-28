---
name: gate
description: Check strict-by-default gate validation for current workflow phase; supports --force with risk logging
---

# Gate（strict 默认）

## 目标

在 `think / user-story / prd / test-case / release` 阶段执行门控检查，默认阻断不合格流转。  
v3.6.0 增加 evidence-first 校验：`boundaries.md + terminal.json`。
v3.6.1 增加 workflow 自动收口脚本：`workflow_gate_autorun.sh`。

## 默认策略

1. `strict_default=true`
2. 门控失败 => `Blocked`
3. 可使用 `--force`，但必须记录风险到 `.ptk/state/risks.json`（或等价下游风险记录）

## 用法

```bash
/product-toolkit:gate
/product-toolkit:gate think
/product-toolkit:gate --force

# workflow 默认收口（v3.6.1）
./scripts/workflow_gate_autorun.sh --version v3.6.0 --terminal docs/product/v3.6.0/execution/terminal.json

# evidence-first 终态校验（v3.6.0，示例）
./scripts/check_terminal_artifacts.sh --version v3.6.0

# 或直接调用 Python 校验器
python3 scripts/validate_terminal_artifacts.py \
  --version v3.6.0 \
  --terminal docs/product/v3.6.0/execution/terminal.release-sample.json \
  --pretty

# 证据加固（建议与 gate 联动）
python3 scripts/run_command_with_evidence.py --log docs/product/v3.6.0/execution/raw-command-log.jsonl --cmd "go test ./..."
python3 scripts/check_gate_consistency.py --version v3.6.0 --terminal docs/product/v3.6.0/execution/terminal.json --output docs/product/v3.6.0/execution/gate-consistency-report.json
python3 scripts/build_evidence_manifest.py --terminal docs/product/v3.6.0/execution/terminal.json --output docs/product/v3.6.0/execution/evidence-manifest.json
```

## 判定核心

- `blocking=true` 的 open question 未关闭 => Blocked
- critical/high 冲突未解决 => Blocked
- AC→TC 映射缺口 => Blocked
- strict 测试缺口（missing US/TC、strict guard 失败）=> Blocked
- `docs/product/{version}/execution/boundaries.md` 缺失 => Blocked
- `docs/product/{version}/execution/terminal.json` 缺失 => Blocked
- `docs/product/{version}/architecture/*.md` 关键架构产物缺失 => Blocked
- terminal schema 关键字段缺失或非法（`terminal.status` + 顶层 `traceability`）=> Blocked
- `architecture_governance.ownership_boundaries_confirmed != true` => Blocked
- `architecture_governance.api_contract_drift` 存在未解决高风险项 => Blocked
- `architecture_governance.nfr_budget_unproven` 非空（Must 范围）=> Blocked
- terminal 引用证据缺失 => Blocked

## 最小可执行校验脚本（v3.6.0）

- 脚本：`scripts/check_terminal_artifacts.sh`
- 目的：快速验证 gate 关键契约是否可执行
  - `terminal.release-sample.json` 必须返回 `Pass`（exit 0）
  - `terminal.blocked-sample.json` 必须返回 `Blocked`（exit 2）
- 底层校验器：`scripts/validate_terminal_artifacts.py`

## 标准 reason codes（v3.6.0）

- `blocking_open_question_exists`
- `boundaries_missing`
- `boundaries_schema_invalid`
- `terminal_artifact_missing`
- `terminal_schema_invalid`
- `terminal_status_invalid`
- `ac_tc_mapping_gap`
- `terminal_evidence_missing`
- `evidence_ref_path_style_inconsistent`
- `arch_artifact_missing`
- `ownership_boundary_unclear`
- `api_contract_drift`
- `nfr_budget_unproven`
- `evidence_integrity_missing`
- `raw_command_log_missing`
- `raw_command_log_invalid`
- `evidence_sha256_manifest_missing`
- `evidence_sha256_manifest_invalid`
- `evidence_sha256_manifest_incomplete`
- `evidence_sha256_manifest_mismatch`
- `gate_consistency_report_missing`
- `gate_consistency_report_invalid`
- `gate_consistency_report_mismatch`
- `gate_consistency_conflict`

## 配置

`config/persistence.yaml`

```yaml
gate:
  strict_default: true
  mode: soft
  warn_on_force: true
  log_risks: true
```

## 输出语义

- `Pass`
- `Blocked`
- `Pass + Risk`（仅在 `--force` 时）
