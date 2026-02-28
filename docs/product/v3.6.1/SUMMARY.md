# Product Toolkit v3.6.1 Hotfix Summary

## Hotfix 目标

在 v3.6.0 的 evidence-first 基础上，补齐两项遗漏：

1. `ralph-bridge` 技能口径升级到 v3.6.x（兼容路径，不再保持 v3.5.0 旧叙事）。
2. `workflow` 默认收口自动化：终态写入后自动触发 gate 一致性 + manifest + terminal 校验。

## 主要变更

- 新增脚本：`scripts/workflow_gate_autorun.sh`
  - 顺序执行：
    1) `check_gate_consistency.py`
    2) `build_evidence_manifest.py`
    3) `validate_terminal_artifacts.py`
- 更新：`skills/ralph-bridge/SKILL.md`
  - 升级为 v3.6.1 兼容说明
  - 增加证据闭环收口要求
- 更新：`skills/workflow/SKILL.md` / `skills/work/SKILL.md`
  - 明确 workflow 默认自动 Gate 收口
- 更新：`commands/product-toolkit.md` / `README.md`
  - 增加 v3.6.1 热修说明与执行命令

## 标准用法

```bash
./scripts/workflow_gate_autorun.sh \
  --version v3.6.0 \
  --terminal docs/product/v3.6.0/execution/terminal.json
```

## 版本信息

- 版本：`v3.6.1`
- 类型：`Hotfix`
- 日期：`2026-02-27`
