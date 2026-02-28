# nfr-budgets.md（v3.7.0 / ptk-cli-scope-guard）

## 0. 元信息
- version: `v3.7.0`
- feature: `ptk-cli-scope-guard`
- owner: `PTK Core Team + QA`
- updated_at: `2026-02-28`

## 1. NFR 预算表

| nfr_id | 指标 | 预算阈值 | 测量方式 | 证据路径 | 状态 |
|---|---|---|---|---|---|
| `NFR-3701` | CLI 响应延迟 P95 | `<= 1s` | 命令基准测试 | `execution/benchmarks/cli-latency.json` | pass |
| `NFR-3702` | 报告生成耗时 | human `<=3s` / machine `<=5s` | 集成测试 | `execution/benchmarks/report-latency.json` | pass |
| `NFR-3703` | 误报率（Scope Guard） | `<= 10%` | 偏差标注回放 | `execution/benchmarks/scope-precision.json` | pass |
| `NFR-3704` | 数据安全 | 明文凭据泄露=0 | 扫描 + review | `execution/security/redaction-report.json` | pass |

## 2. 阻塞规则
- Must 范围 NFR 为 blocked/unproven 且未豁免 → 终态不得 Pass。

## 3. 例外审批

- 当前无例外审批项。
