# 架构文档索引（v3.6.0）

> 目标：在不新增用户命令的前提下，把“架构设计 + 职责边界”纳入 PTK workflow 标准产物。

## 1) 非入侵原则（OMC/OMX 可选）

1. PTK 负责生命周期规划与治理规则（需求、架构、验收、gate）。
2. OMC/OMX 仅作为执行长任务的可选引擎，不改变 PTK 主流程。
3. 判定是否可交付，始终以 `boundaries.md + terminal.json + gate` 为准。

## 2) 标准架构产物

- `system-context.md`：系统上下文、模块边界、依赖关系
- `responsibility-boundaries.md`：职责边界与 RACI
- `api-contracts.md`：接口/事件契约
- `nfr-budgets.md`：NFR 预算与验证口径
- `adr-index.md`：关键架构决策记录（ADR）

## 3) 与 execution 目录联动

- `execution/boundaries.md` 必须引用架构约束（边界、契约、NFR）
- `execution/terminal.json` 必须记录架构治理结果（是否越权、契约漂移、NFR 证据）

