# OMC / OMX 下一步固定提示词模板（v3.7.0）

## OMX 模板

```text
请基于以下 PTK v3.7.0 产物执行实现与验证：

- PRD: docs/product/v3.7.0/prd/ptk-cli-scope-guard.md
- User Story: docs/product/v3.7.0/user-story/ptk-cli-scope-guard.md
- Test Cases: docs/product/v3.7.0/qa/test-cases/ptk-cli-scope-guard.md
- Boundaries: docs/product/v3.7.0/execution/boundaries.md
- Terminal: docs/product/v3.7.0/execution/terminal.json

约束：
1) 严格遵守 In/Out Scope。
2) Scope Guard 触发后必须记录 deviations/confirmations。
3) 输出 dual-mode 报告：summary.md + summary.json。
4) 证据落盘：raw-command-log.jsonl、evidence-manifest.json、gate-consistency-report.json。
5) 完成后执行：
   ./scripts/workflow_gate_autorun.sh --version v3.7.0 --terminal docs/product/v3.7.0/execution/terminal.json
```

## OMC 模板

```text
请进入 PTK v3.7.0 长任务循环，直到满足 Done 边界：

输入：PRD / User Story / Test Cases / Boundaries / Architecture / Terminal。

循环规则：
1) 每轮只解决未通过 AC 对应 TC。
2) 超范围项一律走 Scope Guard + 人类确认。
3) 缺关键证据不得判 Pass。
4) 终态仅允许 Pass / Blocked / Cancelled。
5) 结束时回填 terminal.json 与 evidence_integrity。
```
