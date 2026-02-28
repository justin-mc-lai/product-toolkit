# Blocked 回归演练执行结果（v3.6.0）

- 执行时间: `2026-02-27T03:05:52Z`
- 样例文件: `docs/product/v3.6.0/execution/terminal.blocked-sample.json`
- 演练结论: **PASS**

## 1) 准备
- [x] `docs/product/v3.6.0/execution/boundaries.md`
- [x] `docs/product/v3.6.0/execution/terminal.json`
- [x] `docs/product/v3.6.0/execution/terminal.blocked-sample.json`
- [x] `docs/product/v3.6.0/architecture/system-context.md`
- [x] `docs/product/v3.6.0/architecture/responsibility-boundaries.md`
- [x] `docs/product/v3.6.0/architecture/api-contracts.md`
- [x] `docs/product/v3.6.0/architecture/nfr-budgets.md`
- [x] `docs/product/v3.6.0/architecture/adr-index.md`
- [x] `docs/product/v3.6.0/qa/test-cases/workflow-evidence-first.md`

## 2) 注入阻塞场景
- [x] 场景A：blocking 未决项（blocking=true, status!=closed）
- [x] 场景B：关键证据引用缺失
  - 缺失引用: `docs/product/v3.6.0/execution/missing-terminal-proof.md`
- [x] 场景C：AC→TC 映射缺口（空 tc_ids）
  - 缺口 AC: US3602
- [x] 场景D：职责边界未确认（`ownership_boundaries_confirmed=false`）
- [x] 场景E：高风险契约漂移未关闭（`DRIFT-001`）
- [x] 场景F：关键 NFR 未证明（`NFR-001/NFR-003`）

## 3) 执行检查
- [x] 结论非 Pass: `Blocked`
- [x] reason_codes: `blocking_open_question_exists, ownership_boundary_unclear, api_contract_drift, nfr_budget_unproven, ac_tc_mapping_gap, terminal_evidence_missing`

## 4) 终态核验
- [x] `terminal.status = Blocked`
- [x] `reason_codes` 非空
- [x] `acceptance.ac_blocked > 0` (当前 `4`)
- [x] 顶层 `traceability` 至少 1 条 Blocked (当前 `4`)
- [x] `next_round.recommended_action` 非空

## 5) 归档
- [x] `docs/product/v3.6.0/execution/terminal.blocked-sample.json`
- [x] `docs/product/v3.6.0/execution/delivery-report.md`
- [x] `docs/product/v3.6.0/execution/team-run-log.md`
- [x] 结果明细: `docs/product/v3.6.0/execution/blocked-drill-result.json`

## 6) 退出准则
- [x] 至少 1 个阻塞条件被稳定识别
- [x] terminal 输出结构完整且可解析
- [x] reason codes 与阻塞事实一致
- [x] 能给出下一轮修复建议
