# boundaries.md（标准模板）

> 用途：定义长任务执行边界。该文件是 OMC/OMX 执行前置输入。
> 说明：OMC/OMX 为可选执行引擎，不改变 PTK 生命周期治理主流程。

---

## 0. 元信息

- version: `vX.Y.Z`
- feature: `<feature-name>`
- owner: `<pm/tech-lead>`
- generated_by: `/product-toolkit:workflow`
- updated_at: `YYYY-MM-DD`

---

## 1. 任务目标（Goal）

一句话目标：

> `<要达成的业务/交付目标>`

---

## 2. In Scope（必须做）

- [ ] `<scope-1>`
- [ ] `<scope-2>`
- [ ] `<scope-3>`

---

## 3. Out of Scope（本轮不做）

- [ ] `<out-1>`
- [ ] `<out-2>`

---

## 4. 输入物料（Input Artifacts）

- PRD: `docs/product/{version}/prd/{feature}.md`
- User Story: `docs/product/{version}/user-story/{feature}.md`
- Test Cases: `docs/product/{version}/qa/test-cases/{feature}.md`
- Architecture Context: `docs/product/{version}/architecture/system-context.md`
- Responsibility Boundaries: `docs/product/{version}/architecture/responsibility-boundaries.md`
- API Contracts: `docs/product/{version}/architecture/api-contracts.md`
- NFR Budgets: `docs/product/{version}/architecture/nfr-budgets.md`
- ADR Index: `docs/product/{version}/architecture/adr-index.md`
- 其他依赖: `<path-or-none>`

---

## 5. Done 边界（全部满足才可 Pass）

### 5.1 需求一致性

- [ ] PRD、User Story、Test Cases 三者无关键冲突
- [ ] blocking open questions = 0

### 5.2 测试与验收

- [ ] AC→TC 覆盖矩阵完整
- [ ] critical/high 风险项已关闭或有明确阻断结论
- [ ] 所有阻塞项具备 reason code

### 5.3 证据落盘

- [ ] 输出 `terminal.json`
- [ ] `terminal.status` 已明确（Pass/Blocked/Cancelled）
- [ ] 顶层 `traceability` 可追溯 AC→TC→Evidence

### 5.4 架构治理一致性

- [ ] 职责边界已确认（PTK/架构负责人/执行引擎/QA）
- [ ] 无未处理的高风险接口契约漂移
- [ ] Must 范围 NFR 预算全部有证据

---

## 6. Blocked 条件（任一命中即 Blocked）

- [ ] 缺失关键输入物料（PRD/US/QA）
- [ ] 缺失架构关键物料（system-context / responsibility / contracts / nfr / adr）
- [ ] blocking open question 未关闭
- [ ] AC→TC 映射缺失或无法验证
- [ ] 必需证据文件不存在或不可读
- [ ] 职责边界不清 / 契约漂移未解 / 关键 NFR 无证据

---

## 7. 执行约束（Execution Constraints）

- 最大迭代次数：`<N>`
- 时限：`<date/time>`
- 环境约束：`<env constraints>`
- 合规/安全要求：`<security/privacy constraints>`

---

## 8. 输出产物（Output Artifacts）

- terminal: `docs/product/{version}/execution/terminal.json`
- 报告: `<report paths>`
- 补充证据: `<screenshots/logs/api-results paths>`
- raw command log: `docs/product/{version}/execution/raw-command-log.jsonl`
- sha256 manifest: `docs/product/{version}/execution/evidence-manifest.json`
- gate consistency report: `docs/product/{version}/execution/gate-consistency-report.json`

---

## 9. 终态规则

- `Pass`：Done 边界全部满足。
- `Blocked`：命中任一 Blocked 条件，或到达迭代上限仍未满足 Done。
- `Cancelled`：人为中止或外部前置条件取消。

---

## 10. 签署（可选）

- PM: `<name/date>`
- Tech Lead: `<name/date>`
- QA: `<name/date>`
