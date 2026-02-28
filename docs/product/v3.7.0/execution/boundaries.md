# boundaries.md（v3.7.0 / ptk-cli-scope-guard）

> 用途：约束 v3.7.0“CLI 统一入口 + Scope Guard + 双模式报告”实施边界。

---

## 0. 元信息

- version: `v3.7.0`
- feature: `ptk-cli-scope-guard`
- owner: `PTK Core Team`
- generated_by: `/product-toolkit:workflow`
- updated_at: `2026-02-28`

---

## 1. 任务目标（Goal）

在不破坏 v3.6.1 主路径的前提下，为 PTK 增加统一 CLI 入口、Scope Guard、双模式报告，并保持证据链可审计。

---

## 2. In Scope（必须做）

- [x] 统一 CLI 命令设计（status/run/debug/report/resume/doctor）
- [x] Scope Guard：AC 解析、偏差监控、人类确认
- [x] 双模式报告：`--human` 与 `--machine`
- [x] 模式切换：normal/debug/strict/dry-run/replay
- [x] scope-memory：deviations/confirmations
- [x] 全阶段证据链与防伪校验规则

---

## 3. Out of Scope（本轮不做）

- [x] 重写 OMC/OMX 执行引擎
- [x] 跨平台 converter/sync
- [x] 视频级 session replay
- [x] pass@k 全链路评估平台

---

## 4. 输入物料（Input Artifacts）

- PRD: `docs/product/v3.7.0/prd/ptk-cli-scope-guard.md`
- User Story: `docs/product/v3.7.0/user-story/ptk-cli-scope-guard.md`
- Test Cases: `docs/product/v3.7.0/qa/test-cases/ptk-cli-scope-guard.md`
- Architecture Context: `docs/product/v3.7.0/architecture/system-context.md`
- Responsibility Boundaries: `docs/product/v3.7.0/architecture/responsibility-boundaries.md`
- API Contracts: `docs/product/v3.7.0/architecture/api-contracts.md`
- NFR Budgets: `docs/product/v3.7.0/architecture/nfr-budgets.md`
- ADR Index: `docs/product/v3.7.0/architecture/adr-index.md`

---

## 5. Done 边界（全部满足才可 Pass）

### 5.1 需求一致性

- [ ] PRD / User Story / Test Cases 无 critical 冲突
- [ ] blocking open question = 0

### 5.2 功能与测试

- [ ] 统一 CLI 子命令可执行
- [ ] Scope Guard 能识别超范围并触发确认
- [ ] AC→TC 覆盖矩阵完整

### 5.3 报告与证据

- [ ] `summary.md`（human）不包含机器调试噪声
- [ ] `summary.json`（machine）包含完整事件流
- [ ] `terminal.json` 可追溯 AC→TC→Evidence

### 5.4 架构治理一致性

- [ ] 角色边界已确认（PTK / 执行引擎 / QA）
- [ ] 无未决 high 风险契约漂移
- [ ] Must 范围 NFR 预算均有证据

---

## 6. Blocked 条件（任一命中即 Blocked）

- [ ] 缺失关键输入物料（PRD/US/QA/Architecture）
- [ ] 存在 blocking open question 未关闭
- [ ] AC→TC 缺失或不可验证
- [ ] Scope Guard 未生效或无偏差记录
- [ ] 终态证据缺失（terminal / manifest / consistency）

---

## 7. 执行约束（Execution Constraints）

- 最大迭代次数：`3`
- 时间约束：`M0~M4 总计 9-15 天`
- 环境约束：本地 CLI + 文档仓库
- 合规约束：禁止明文凭据入库

---

## 8. 输出产物（Output Artifacts）

- terminal: `docs/product/v3.7.0/execution/terminal.json`
- next-step prompts: `docs/product/v3.7.0/execution/next-step-prompts.md`
- raw command log: `docs/product/v3.7.0/execution/raw-command-log.jsonl`
- sha256 manifest: `docs/product/v3.7.0/execution/evidence-manifest.json`
- gate consistency report: `docs/product/v3.7.0/execution/gate-consistency-report.json`

---

## 9. 终态规则

- `Pass`：Done 边界全部满足。
- `Blocked`：命中任一 Blocked 条件，或迭代上限后仍未满足 Done。
- `Cancelled`：人为中止。
