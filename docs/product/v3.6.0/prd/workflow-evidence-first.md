# PRD: Workflow Evidence-First（v3.6.0）

**状态**: Ready  
**目标版本**: v3.6.0  
**日期**: 2026-02-27

---

## 1. 背景

现状主路径仍偏“桥接脚本驱动”，导致：

1. 用户需要理解较多执行细节（runtime、bridge、finalize 等）。
2. 文档层与运行层的“完成定义”不够统一。
3. 长任务出现“结果已 Pass，但循环状态未自然收口”的边界问题。

v3.6.0 目标是：在不增加用户操作成本的前提下，把闭环重心从脚本编排转到“产物与证据”。

---

## 2. 产品目标

1. 用户只需继续使用 `/product-toolkit:workflow`（或 `/product-toolkit:work`）。
2. workflow 产物只覆盖：PRD、User Story、QA Test Cases。
3. workflow 自动给出“下一步 OMC/OMX 固化提示词模板”，直接接入长任务。
4. 用 `boundaries.md + terminal.json` 明确“何时完成、为何完成、证据是什么”。
5. 终态判断以证据为准，而非脚本阶段名或口头确认。

---

## 3. 范围定义

### In Scope

- workflow 产物打包规范（可直接喂给 OMC/OMX）
- 下一步提示词模板标准化
- 完成边界模板（boundaries.md）
- 终态证据模板（terminal.json）
- 与现有 v3.5.x 文档/命令的一致性修正建议

### Out of Scope

- 新增用户命令或要求用户记忆新指令
- 重写 OMC/OMX 引擎
- 强依赖 bridge shell 脚本作为唯一闭环

---

## 4. 功能需求（FR）

### FR-3601：零新增用户操作

- 保持 `/product-toolkit:workflow` 为主入口。
- `work` 继续作为 workflow 别名。
- v3.6.0 不引入新的用户层命令。

### FR-3602：workflow 产物标准化

workflow 必须输出可直接执行的三类核心文档：

- PRD
- User Story
- QA Test Cases

并在 SUMMARY/索引中给出产物路径。

### FR-3603：下一步执行模板（OMC/OMX）

workflow 完成后，必须给出可复制的 OMC/OMX 固化提示词模板，内容至少包括：

- 输入物料路径
- 执行目标
- 自迭代规则
- 完成边界引用（boundaries.md）
- 终态证据输出要求（terminal.json）

### FR-3604：边界先行

`boundaries.md` 成为长任务执行前置文件，必须定义：

- In Scope / Out of Scope
- Done 标准
- Blocked 条件
- 必备证据清单

### FR-3605：终态证据闭环

`terminal.json` 成为交付唯一终态摘要，至少包含：

- terminal.status（Pass/Blocked/Cancelled）
- reason_codes
- 顶层 `traceability`（AC→TC→Evidence）
- 阻塞项是否已清零
- 审计元数据（时间、会话、执行器）

### FR-3606：架构治理产物内建（非入侵）

workflow 必须补齐并索引以下架构产物：

- `architecture/system-context.md`
- `architecture/responsibility-boundaries.md`
- `architecture/api-contracts.md`
- `architecture/nfr-budgets.md`
- `architecture/adr-index.md`

要求：

1. OMC/OMX 为可选执行引擎，不改变 PTK 生命周期规划职责。
2. 架构产物作为 execution 前置输入，参与 gate 判定。

### FR-3607：架构治理 gate 强约束

gate 必须支持架构类阻塞原因：

- `arch_artifact_missing`
- `ownership_boundary_unclear`
- `api_contract_drift`
- `nfr_budget_unproven`

---

## 5. 非功能需求（NFR）

1. 易用性：用户操作复杂度不高于 v3.5.x。
2. 可审计性：终态可机器读取，可追溯到证据文件。
3. 一致性：README 仅做索引，详细内容分文件管理。
4. 可迁移性：兼容已有 v3.5.x 产物目录，不强制一次性重构。

---

## 6. 里程碑

### M1（文档契约）

- 完成 v3.6.0 PRD + 差距分析 + boundaries + terminal 模板
- 明确 workflow 输出与 OMC/OMX 输入映射

### M2（模板接入）

- 在 workflow 结果中内置下一步 OMC/OMX 固化提示词
- 统一模板字段与路径变量

### M3（证据闭环）

- terminal.json 成为 Gate 强校验输入（boundaries/terminal schema/reason codes）
- 支持 Pass/Blocked 的标准 reason code 归档

### M4（迁移与减法）

- 将 bridge 叙事从“主路径”降级为“兼容路径”
- 文档与命令描述统一为 evidence-first 主路径

---

## 7. 验收标准（DoD）

1. 新用户仅使用 `/product-toolkit:workflow` 即可拿到可执行下一步模板。
2. v3.6.0 README 为纯索引文件，无大段重复内容。
3. boundaries.md 与 terminal.json 模板可直接用于真实任务。
4. 与 v3.5.x 对比的差距清单明确、可执行。
5. 至少一条 OMC 与一条 OMX 固化提示词模板可复制使用。
6. architecture 目录模板完整，且可被 gate 检查逻辑消费。

---

## 8. 风险与缓解

1. **风险**：旧文档仍突出 bridge，造成路径混淆。  
   **缓解**：v3.6.0 文档声明主路径为 workflow 产物驱动。

2. **风险**：团队继续以“脚本执行完成”代替“证据完成”。  
   **缓解**：Gate 侧强校验 `terminal.status + 顶层 traceability + reason_codes`。

3. **风险**：模板过多反而增加负担。  
   **缓解**：README 只保留索引，正文分离。

---

## 9. 交叉引用

- 用户故事：`docs/product/v3.6.0/user-story/workflow-evidence-first.md`
- 测试用例：`docs/product/v3.6.0/qa/test-cases/workflow-evidence-first.md`
- 架构索引：`docs/product/v3.6.0/architecture/README.md`
- 执行边界：`docs/product/v3.6.0/execution/boundaries.md`
- 终态模板：`docs/product/v3.6.0/execution/terminal.json`
