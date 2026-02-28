---
name: workflow
description: "Run v3.6.1 evidence-first workflow (core outputs: PRD/User Story/Test Cases) and auto-close with gate validation"
---

# 一键工作流（v3.6.1）

## 默认主路径（核心产物链）

`think → user-story → prd → test-case`

> 说明：v3.6.1 延续 workflow 主路径聚焦在产品产物生成，不新增用户命令。
> 新增：workflow 默认补齐 architecture 标准模板，用于统一架构职责边界与 gate 治理。

## 固定下一步（执行建议）

workflow 完成后必须给出下一步模板（不要求用户学习新命令）：

1. OMC 固化执行提示词模板
2. OMX 固化执行提示词模板
3. `boundaries.md` 与 `terminal.json` 引用路径
4. 证据加固产物：`raw-command-log.jsonl` + `evidence-manifest.json` + `gate-consistency-report.json`

参考：`docs/product/v3.6.0/execution/next-step-prompts.md`（3.6.1 继续沿用模板）

## 默认自动收口（v3.6.1 Hotfix）

当执行引擎写出 `terminal.json` 后，workflow 默认要执行一次 Gate 自动收口：

```bash
./scripts/workflow_gate_autorun.sh \
  --version <version> \
  --terminal docs/product/<version>/execution/terminal.json
```

收口输出：

1. `gate-consistency-report.json`
2. `evidence-manifest.json`
3. `validate_terminal_artifacts.py` 最终判定（Pass/Blocked）

## strict 默认

- gate 默认阻断
- `--force` 可继续，但必须落风险记录
- 最终态仅：`Pass` / `Blocked`（执行层可补充 `Cancelled`）

## 必备输入

进入执行层前，至少应具备：

1. `docs/product/{version}/prd/{feature}.md`
2. `docs/product/{version}/user-story/{feature}.md`
3. `docs/product/{version}/qa/test-cases/{feature}.md`
4. `docs/product/{version}/execution/boundaries.md`
5. `docs/product/{version}/architecture/system-context.md`
6. `docs/product/{version}/architecture/responsibility-boundaries.md`
7. `docs/product/{version}/architecture/api-contracts.md`
8. `docs/product/{version}/architecture/nfr-budgets.md`
9. `docs/product/{version}/architecture/adr-index.md`

## 阻塞规则

任一成立即 `Blocked`：

1. `open_question.blocking=true` 且未关闭
2. critical/high 冲突未关闭
3. AC→TC 映射缺失
4. `boundaries.md` 或 `terminal.json` 关键字段缺失
5. 架构关键产物缺失或职责边界不清
6. 高风险契约漂移未解决
7. Must 范围 NFR 预算无证据

## 兼容说明

- `ralph-bridge` 仍可使用，但属于兼容/高级路径，不再作为 workflow 默认主路径。

## Gate 联动（v3.6.1）

建议在交付前执行：

```bash
./scripts/workflow_gate_autorun.sh \
  --version <version> \
  --terminal docs/product/<version>/execution/terminal.json
```

若结果为 `Blocked`，必须先清零 reason codes 再判定 `Pass`。
