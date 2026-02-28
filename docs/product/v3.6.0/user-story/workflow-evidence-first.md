# 用户故事：Workflow Evidence-First（v3.6.0）

**状态**: Ready  
**优先级**: P0  
**来源**: v3.6.0 PRD（workflow 产物驱动 + 证据闭环）

---

## US-3601：主入口不变，零新增用户操作

**用户故事**：作为 PM/交付负责人，我希望继续只用 `/product-toolkit:workflow`（`/product-toolkit:work` 别名）推进任务，以便降低学习成本并稳定执行习惯。

### 范围
- In Scope：保留 workflow/work 双入口；不新增用户级命令。
- Out of Scope：要求用户学习 bridge shell 编排细节。

### 验收标准（7维）
- [ ] US3601-AC01 正向：`workflow` 仍可产出 PRD、User Story、QA Test Cases。
- [ ] US3601-AC02 边界：`work` 与 `workflow` 行为等价。
- [ ] US3601-AC03 错误：当输入不完整时返回 `Blocked` 并提示缺失项。
- [ ] US3601-AC04 反馈：输出包含“下一步 OMC/OMX 固化提示词”链接或正文。
- [ ] US3601-AC05 性能：不引入额外必填交互步骤。
- [ ] US3601-AC06 权限：流程输出不记录明文凭据。
- [ ] US3601-AC07 回退：兼容保留 `ralph-bridge` 作为非主路径。

## US-3602：workflow 核心产物链聚焦（PRD/US/QA）

**用户故事**：作为产品团队，我希望 workflow 明确以 PRD、用户故事、测试用例作为核心产物，以便让长任务执行输入稳定、可复用。

### 范围
- In Scope：PRD/User Story/QA Test Cases 三件套标准化。
- Out of Scope：把 auto-test 或 bridge 脚本作为 workflow 主体定义。

### 验收标准（7维）
- [ ] US3602-AC01 正向：workflow 产物路径明确落盘到版本目录。
- [ ] US3602-AC02 边界：核心产物与“执行验证链”在文档中分层说明。
- [ ] US3602-AC03 错误：任一核心产物缺失时流程结论为 `Blocked`。
- [ ] US3602-AC04 反馈：SUMMARY/README 可追踪到三类产物链接。
- [ ] US3602-AC05 性能：产物结构简化，不增加重复文件。
- [ ] US3602-AC06 权限：文档仅链接敏感文件，不内嵌凭据。
- [ ] US3602-AC07 回退：可兼容读取 v3.5.x 目录中的同类产物。

## US-3603：自动提供 OMC/OMX 下一步固定提示词

**用户故事**：作为执行者，我希望 workflow 完成后直接拿到 OMC/OMX 可复制提示词，以便无桥接脚本也能进入长任务自迭代。

### 范围
- In Scope：输出 OMC/OMX 两套固定模板与变量替换说明。
- Out of Scope：新增用户命令或强制绑定某个运行时。

### 验收标准（7维）
- [ ] US3603-AC01 正向：模板包含 PRD/US/QA/Boundaries/Terminal 路径占位符。
- [ ] US3603-AC02 边界：同一模板可用于 OMC 与 OMX，仅变量替换。
- [ ] US3603-AC03 错误：关键路径变量缺失时必须提示并阻断 `Pass`。
- [ ] US3603-AC04 反馈：模板明确循环规则与终态输出要求。
- [ ] US3603-AC05 性能：模板可直接复制执行，无二次改写。
- [ ] US3603-AC06 权限：模板不要求输出敏感配置。
- [ ] US3603-AC07 回退：若用户仍用 bridge，模板不冲突。

## US-3604：边界文件先行（boundaries.md）

**用户故事**：作为 QA/Tech Lead，我希望在长任务执行前先定义 `boundaries.md`，以便统一 Done 与 Blocked 判定口径。

### 范围
- In Scope：In Scope/Out of Scope、Done、Blocked、Evidence 清单。
- Out of Scope：仅靠口头标准判断完成。

### 验收标准（7维）
- [ ] US3604-AC01 正向：执行前必须存在 `boundaries.md`。
- [ ] US3604-AC02 边界：Done 与 Blocked 条件互斥且可判定。
- [ ] US3604-AC03 错误：边界缺失关键字段时终态只能是 `Blocked`。
- [ ] US3604-AC04 反馈：边界文件可引用到 terminal.json 的判定字段。
- [ ] US3604-AC05 性能：模板填写成本可控（单页可完成）。
- [ ] US3604-AC06 权限：边界文档不包含敏感密钥。
- [ ] US3604-AC07 回退：允许沿用旧项目边界文件并增量补齐。

## US-3605：终态证据闭环（terminal.json）

**用户故事**：作为交付负责人，我希望最终结果以 `terminal.json` 机器可读落盘，以便审计“为何 Pass/Blocked/Cancelled”。

### 范围
- In Scope：`terminal.status`、`reason_codes`、顶层 `traceability`（AC→TC→Evidence）。
- Out of Scope：仅凭日志片段或口头描述给终态。

### 验收标准（7维）
- [ ] US3605-AC01 正向：完成后输出 `terminal.json` 且字段完整。
- [ ] US3605-AC02 边界：终态仅允许 `Pass/Blocked/Cancelled`。
- [ ] US3605-AC03 错误：证据缺失或不可追溯时必须 `Blocked`。
- [ ] US3605-AC04 反馈：`reason_codes` 可映射到阻塞原因分类。
- [ ] US3605-AC05 性能：单次任务可在收尾阶段自动生成终态文件。
- [ ] US3605-AC06 权限：审计字段可共享，敏感信息默认脱敏。
- [ ] US3605-AC07 回退：若终态冲突，可人工复核并重新落盘。

## US-3606：Bridge 降级为兼容路径（文档减法）

**用户故事**：作为新用户，我希望文档默认推荐 workflow 产物驱动路径，以便减少“应该先学 bridge 还是先跑 workflow”的认知负担。

### 范围
- In Scope：README/SKILL/commands 主叙事切到 evidence-first。
- Out of Scope：删除 bridge 能力本身。

### 验收标准（7维）
- [ ] US3606-AC01 正向：入口文档将 workflow 标记为默认主路径。
- [ ] US3606-AC02 边界：bridge 标记为兼容/高级路径。
- [ ] US3606-AC03 错误：版本描述冲突（如 v3.5.2 与 v3.4.0 混写）可被检出。
- [ ] US3606-AC04 反馈：README 仅做索引并链接详细文档。
- [ ] US3606-AC05 性能：入口文档长度显著下降，检索更快。
- [ ] US3606-AC06 权限：文档示例不含真实凭据。
- [ ] US3606-AC07 回退：保留历史版本文档链接，支持对照迁移。

## US-3607：架构设计与职责边界标准化（非入侵）

**用户故事**：作为架构负责人/交付负责人，我希望 workflow 默认产出架构上下文与职责边界物料，以便在 OMC/OMX 作为可选执行器时仍保持 PTK 生命周期治理的一致性。

### 范围
- In Scope：`system-context` / `responsibility-boundaries` / `api-contracts` / `nfr-budgets` / `adr-index` 产物与 gate 对齐。
- Out of Scope：新增用户命令或将 OMC/OMX 绑定为必选执行器。

### 验收标准（7维）
- [ ] US3607-AC01 正向：v3.6.0 提供 architecture 标准目录与模板文件。
- [ ] US3607-AC02 边界：职责边界明确 PTK 与执行引擎（OMC/OMX）分工，执行器非入侵。
- [ ] US3607-AC03 错误：缺少架构关键产物时 gate 结论为 `Blocked`。
- [ ] US3607-AC04 反馈：next-step 提示词可引用 architecture 路径变量。
- [ ] US3607-AC05 性能：不新增用户操作命令，仍由 workflow 主路径驱动。
- [ ] US3607-AC06 权限：架构文档不记录敏感密钥与真实凭据。
- [ ] US3607-AC07 回退：可兼容旧版本，仅对 v3.6.0+ 按新标准执行。

---

## 交叉引用

- PRD：`docs/product/v3.6.0/prd/workflow-evidence-first.md`
- 测试用例：`docs/product/v3.6.0/qa/test-cases/workflow-evidence-first.md`
- 执行边界：`docs/product/v3.6.0/execution/boundaries.md`
- 架构索引：`docs/product/v3.6.0/architecture/README.md`

---

## 冲突与未决问题

- 冲突：无 `critical/high` 未解决冲突。
- 未决（非阻塞）：
  - OQ-3602：旧版 `docs/product/{version}` 若无 `execution/` 目录，是否由 workflow 自动补齐。

## 交付语义

- Blocked 原因：当前无阻塞项。
- Warn 风险：存在 1 项非阻塞未决，需要在实施排期中确认。
