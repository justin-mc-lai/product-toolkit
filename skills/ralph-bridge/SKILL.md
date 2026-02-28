---
name: ralph-bridge
description: Bridge OMX/OMC long-task runtime with PTK evidence-first acceptance loop (compatibility path)
---

# Ralph Bridge（v3.7.0 兼容路径）

> 说明：`ralph-bridge` 保留用于兼容/高级场景。
> v3.7.0 默认主路径仍是 `/product-toolkit:workflow`。

## 命令入口

```bash
./scripts/ralph_bridge.sh start --team <name> --runtime omx|omc|auto --task "..."
./scripts/ralph_bridge.sh resume --team <name> --version <v> --feature <feature> --test-file <path> [--manual-results <json>]
./scripts/ralph_bridge.sh status --team <name>
./scripts/ralph_bridge.sh finalize --team <name> --terminal-status Pass|Blocked|Cancelled
```

## 必备输入（与 v3.7.0 evidence-first 对齐）

- `docs/product/{version}/prd/{feature}.md`
- `docs/product/{version}/user-story/{feature}.md`
- `docs/product/{version}/qa/test-cases/{feature}.md`
- `docs/product/{version}/execution/boundaries.md`
- `docs/product/{version}/execution/terminal.json`
- `docs/product/{version}/architecture/system-context.md`
- `docs/product/{version}/architecture/responsibility-boundaries.md`
- `docs/product/{version}/architecture/api-contracts.md`
- `docs/product/{version}/architecture/nfr-budgets.md`
- `docs/product/{version}/architecture/adr-index.md`

## 关键行为

1. 运行时自动解析：`auto` 按 `PTK_BRIDGE_RUNTIME_PREFERENCE` 或默认 `omx -> omc`。
2. verify 阶段强制编排：`auto_test.sh` + `review_gate.sh evaluate` + `team_report.sh`。
3. bridge 状态落盘：`.ptk/state/bridge/<team>/ralph-link.json`（并同步 latest 快照）。
4. 终态写入后，必须执行 v3.7.0 自动 Gate 收口：

```bash
./scripts/workflow_gate_autorun.sh \
  --version <vX.Y.Z> \
  --terminal docs/product/<vX.Y.Z>/execution/terminal.json
```

## 验收建议（v3.7.0）

```bash
# 1) 启动
./scripts/ralph_bridge.sh start --team rb-v370 --runtime auto --team-runtime file --task "v3.7.0 bridge"

# 2) 推进阶段
./scripts/ralph_bridge.sh resume --team rb-v370 --version v3.7.0 --feature ptk-cli-scope-guard \
  --test-file docs/product/v3.7.0/qa/test-cases/ptk-cli-scope-guard.md

# 3) 终态收口（Pass/Blocked/Cancelled）
./scripts/ralph_bridge.sh finalize --team rb-v370 --terminal-status Pass
./scripts/workflow_gate_autorun.sh --version v3.7.0 --terminal docs/product/v3.7.0/execution/terminal.json
```

期望：`terminal.json` 与架构文档一致，且 evidence_integrity 三件套齐全。
