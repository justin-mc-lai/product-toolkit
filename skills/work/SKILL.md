---
name: work
description: Alias for workflow; run the v3.6.1 evidence-first core workflow
---

# Work（workflow 别名）

当用户使用 `/product-toolkit:work` 时，按 `/product-toolkit:workflow` 执行。

执行语义（v3.6.1）：

- 核心产物链：`think → user-story → prd → test-case`
- 默认补齐架构治理模板：`architecture/system-context/responsibility/contracts/nfr/adr`
- workflow 完成后输出 OMC/OMX 下一步固定提示词模板
- 终态写入后默认执行 `./scripts/workflow_gate_autorun.sh --version <version> --terminal docs/product/<version>/execution/terminal.json`
- 终态证据建议加固：`raw-command-log.jsonl` + `evidence-manifest.json` + `gate-consistency-report.json`
- 用户侧不新增命令，保持低心智
- OMC/OMX 为可选执行器，非入侵 PTK 生命周期规划
- `ralph-bridge` 为兼容路径（非默认）
