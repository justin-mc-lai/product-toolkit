# Blocked 回归演练清单（v3.6.0）

> 目标：验证系统在阻塞条件下能稳定输出 `terminal.status=Blocked`，并给出可审计 reason codes。

## 1) 准备

- [ ] 基线文件存在：
  - `docs/product/v3.6.0/execution/boundaries.md`
  - `docs/product/v3.6.0/execution/terminal.json`
  - `docs/product/v3.6.0/execution/terminal.blocked-sample.json`
  - `docs/product/v3.6.0/architecture/system-context.md`
  - `docs/product/v3.6.0/architecture/responsibility-boundaries.md`
  - `docs/product/v3.6.0/architecture/api-contracts.md`
  - `docs/product/v3.6.0/architecture/nfr-budgets.md`
  - `docs/product/v3.6.0/architecture/adr-index.md`
- [ ] 测试用例存在：`docs/product/v3.6.0/qa/test-cases/workflow-evidence-first.md`

## 2) 注入阻塞场景（任选 1~3 个）

- [ ] 场景A：保留 `blocking=true` 未决项（不关闭）
- [ ] 场景B：移除或破坏关键终态证据引用
- [ ] 场景C：制造 AC→TC 映射缺口
- [ ] 场景D：将 `ownership_boundaries_confirmed` 置为 false
- [ ] 场景E：注入未解决高风险契约漂移
- [ ] 场景F：保留关键 NFR 为 `unproven`

## 3) 执行检查

- [ ] 运行 workflow/gate 验证（或等效检查流）
- [ ] 确认结论不是 Pass
- [ ] 记录触发的 reason codes

## 4) 终态核验（必须）

- [ ] `terminal.status = Blocked`
- [ ] `reason_codes` 非空
- [ ] `acceptance.ac_blocked > 0`
- [ ] 顶层 `traceability` 至少有 1 条 `result=Blocked`
- [ ] `next_round.recommended_action` 给出补救动作

## 5) 归档

- [ ] 保存终态文件：`docs/product/v3.6.0/execution/terminal.blocked-sample.json`
- [ ] 更新归档说明（可选）：`docs/product/v3.6.0/execution/delivery-report.md`
- [ ] 保留执行日志引用：`docs/product/v3.6.0/execution/team-run-log.md`

## 6) 退出准则

满足以下全部条件才算演练通过：

1. 至少 1 个阻塞条件被稳定识别
2. terminal 输出结构完整且可解析
3. reason codes 与阻塞事实一致
4. 能给出下一轮修复建议
