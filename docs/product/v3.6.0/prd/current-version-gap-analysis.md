# v3.5.2 → v3.6.0 差距分析（现状梳理）

**分析日期**: 2026-02-27  
**目标**: 对齐“workflow 产物驱动 + 证据闭环”主路径

---

## A. 关键结论

当前 PTK（标称 v3.5.2）已具备 strict / gate / team / bridge 基础，但与 v3.6.0 目标仍有 7 个核心差距：

1. 主叙事仍偏 bridge 驱动，非 workflow 产物驱动。
2. workflow 定义仍包含 auto-test/feedback 全链，不是“PRD/US/QA 聚焦”。
3. README 不是索引型，信息密度过高。
4. 版本元信息存在不一致（文档头尾版本不统一）。
5. 缺少标准 `boundaries.md` 与 `terminal.json` 模板。
6. 运行日志显示“Pass 后循环未自然收口”的操作性缺口。
7. 缺少统一架构设计与职责边界产物，执行阶段容易出现边界漂移。

---

## B. 逐项对照

| 目标能力（v3.6.0） | 当前状态（v3.5.2） | 差距判断 |
|---|---|---|
| 用户只走 workflow 主入口 | `SKILL.md` 与 `commands/product-toolkit.md` 仍将 `ralph-bridge` 作为核心能力展示 | 需要降级 bridge 到兼容路径 |
| workflow 聚焦 PRD/US/QA | `skills/workflow/SKILL.md` 当前链路：`think → user-story → prd → test-case → auto-test → feedback → next-think` | 需要将“核心产物链”与“执行验证链”分层 |
| README 仅索引 | `README.md` 承载大量执行细节与脚本说明 | 需要拆分为 index + 专题文档 |
| 版本信息一致 | `SKILL.md` 顶部为 `v3.5.2`，底部版本段仍是 `v3.4.0` | 需要统一版本声明 |
| 证据终态标准化 | 当前存在 bridge schema（`ralph-link.schema.json`），但缺少 workflow 级统一 `terminal.json` 模板 | 需要新增终态模板并纳入 Gate |
| 闭环天然收口 | `docs/dev/debug.log`（2026-02-26）出现“已 Pass 但 stop hook 持续提示 Work is NOT done，需要额外 cancel/清理” | 需要从脚本状态闭环升级到证据闭环 |
| 架构职责边界统一 | 缺少 architecture 专项产物与 RACI 约束 | 需要新增 `architecture/*.md` 并纳入 gate |

---

## C. 影响评估

### 1) 用户体验

- 当前：功能强，但路径多，易混淆“该用 workflow 还是 bridge”。
- 目标：用户只管 workflow；下一步模板自动给出。

### 2) 交付一致性

- 当前：存在“执行成功 ≠ 闭环完成”的认知偏差。
- 目标：以 `terminal.json` 证据字段定义最终完成。

### 3) 文档可维护性

- 当前：入口文档承担过多细节，版本同步成本高。
- 目标：README 仅索引，细节分文件治理。

---

## D. v3.6.0 优先修复清单

### P0

1. 提供 `boundaries.md` 标准模板。
2. 提供 `terminal.json` 标准模板。
3. 在 workflow 结果中固定输出 OMC/OMX 下一步提示词模板。

### P1

1. 将 bridge 从“主路径文案”调整为“兼容路径文案”。
2. workflow 文档明确“核心产物链”与“可选执行验证链”边界。
3. 统一 `SKILL.md / README / commands` 版本号与版本说明。
4. 引入 architecture 标准模板并纳入 next-step prompts 变量。

### P2

1. 补充迁移指南：v3.5.x 团队如何平滑过渡到 evidence-first。
2. 为 terminal reason code 建立推荐字典（便于统计与追踪）。

---

## E. 建议的落地顺序

1. 先文档契约（本目录）
2. 再 workflow 输出模板化
3. 再入口文档减法与 bridge 降权
4. 最后 Gate 接入 terminal.json 字段校验 + architecture 治理校验
