# Product Toolkit v3.6.0 文档总览

## 版本目标

v3.6.0 从“桥接脚本主导”升级为“**workflow 产物主导 + 证据闭环主导**”。

核心变化：

1. 用户入口保持不变：继续使用 `/product-toolkit:workflow`（`/product-toolkit:work` 别名）。
2. 不新增用户操作命令，降低心智负担。
3. `workflow` 聚焦产出：需求/用户故事/测试用例。
4. 通过“下一步固定提示词模板”把产物直接交给 OMX/OMC 做长任务自迭代。
5. 用 `boundaries.md + terminal.json` 统一定义“完成边界”与“证据终态”。
6. 新增架构治理产物（system-context / responsibility / contracts / nfr / adr），统一开发职责边界。

---

## 版本范围

### In Scope

- workflow 产物规范化（PRD / User Story / QA Test Cases）
- 架构设计与职责边界产物规范化（architecture/*.md）
- OMC / OMX 下一步固定执行提示词模板
- 终态证据模板（terminal.json）
- 完成边界模板（boundaries.md）
- 现有版本差距梳理与迁移建议

### Out of Scope

- 新增 PTK 用户命令
- 重写 OMC/OMX 内部运行时
- 依赖 shell bridge 脚本作为唯一闭环路径
- 让 OMC/OMX 侵入 PTK 生命周期治理职责

---

## 文档清单

- 索引：`README.md`
- 方案 PRD：`prd/workflow-evidence-first.md`
- 用户故事：`user-story/workflow-evidence-first.md`
- 测试用例：`qa/test-cases/workflow-evidence-first.md`
- 现状差距：`prd/current-version-gap-analysis.md`
- 边界模板：`execution/boundaries.md`
- 终态模板：`execution/terminal.json`
- 终态样例：`execution/terminal.release-sample.json`
- 阻塞样例：`execution/terminal.blocked-sample.json`
- 架构索引：`architecture/README.md`
- 系统上下文：`architecture/system-context.md`
- 职责边界：`architecture/responsibility-boundaries.md`
- 契约清单：`architecture/api-contracts.md`
- NFR 预算：`architecture/nfr-budgets.md`
- ADR 索引：`architecture/adr-index.md`
- 架构 gate 检查项：`execution/gate-architecture-checklist.md`
- 阻塞演练清单：`execution/blocked-drill-checklist.md`
- 阻塞演练结果：`execution/blocked-drill-result.md`、`execution/blocked-drill-result.json`
- 运行日志摘录：`execution/team-run-log.md`
- OMC/OMX 固化提示词：`execution/next-step-prompts.md`
- 交付报告：`execution/delivery-report.md`
- 复审报告：`execution/review-v3.6.0-fix-report.md`
- 验证脚本：`scripts/validate_terminal_artifacts.py`、`scripts/check_terminal_artifacts.sh`

---

## 版本信息

- 版本：`v3.6.0`
- 状态：`Delivered (Docs/Contracts Layer)`
- 语义：产物文档（PRD/US/QA）使用 `Ready`；版本级交付报告使用 `Delivered`
- 日期：`2026-02-27`
