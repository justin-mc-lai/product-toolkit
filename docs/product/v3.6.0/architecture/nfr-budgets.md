# nfr-budgets.md（标准模板）

## 0. 元信息

- version: `vX.Y.Z`
- feature: `<feature-name>`
- owner: `<tech-lead-or-sre>`
- updated_at: `YYYY-MM-DD`

## 1. NFR 预算表

| nfr_id | 指标 | 预算阈值 | 测量方式 | 证据路径 | 状态（pass/blocked/unproven） |
|---|---|---|---|---|---|
| `NFR-001` | API 延迟 P95 | `<= 300ms` | `<tool/query>` | `<evidence-path>` | `unproven` |
| `NFR-002` | 错误率 | `<= 0.5%` | `<tool/query>` | `<evidence-path>` | `unproven` |
| `NFR-003` | 可用性 | `>= 99.9%` | `<tool/query>` | `<evidence-path>` | `unproven` |

## 2. 阻塞规则

任一关键 NFR 为 `blocked` 或 `unproven` 且属本轮 Must 范围，则终态不得为 Pass。

## 3. 例外审批

| nfr_id | 例外原因 | 批准人 | 有效期 | 风险补偿措施 |
|---|---|---|---|---|
| `<nfr_id>` | `<reason>` | `<owner>` | `<date>` | `<mitigation>` |

