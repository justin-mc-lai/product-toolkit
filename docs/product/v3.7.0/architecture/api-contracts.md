# api-contracts.md（v3.7.0 / ptk-cli-scope-guard）

## 0. 元信息
- version: `v3.7.0`
- feature: `ptk-cli-scope-guard`
- owner: `PTK Core Team`
- updated_at: `2026-02-28`

## 1. 契约总览

| contract_id | 类型 | 接口/事件 | owner | 版本 |
|---|---|---|---|---|
| `CON-3701` | CLI | `ptk run` | PTK Core | v1 |
| `CON-3702` | Event | `scope.deviation.detected` | PTK Core | v1 |
| `CON-3703` | Report | `summary.human` / `summary.machine` | PTK Core | v1 |

## 2. 契约详情

### CON-3701 `ptk run`
- 输入：workflow 名称 + mode
- 输出：run_id + 执行状态
- 错误：未知 mode/缺失输入
- 兼容：保留 v3.6.1 入口语义

### CON-3702 `scope.deviation.detected`
- 输入：AC scope、候选实现、风险等级
- 输出：`enhancement-proposal` / `out-of-scope`
- 规则：high 风险必须进入人类确认

### CON-3703 dual-mode report
- human：隐藏 prompts/tokens/toolcalls
- machine：保留完整结构化事件流

## 3. Drift Log

| drift_id | contract_id | 变更说明 | 风险 | 状态 | 证据 |
|---|---|---|---|---|---|
| `DRIFT-3701` | `CON-3701` | 新增 `replay` mode | medium | resolved | `docs/product/v3.7.0/prd/ptk-cli-scope-guard.md` |

## 4. 验证要求
- 每个 contract 至少对应 1 条 TC
- 所有 drift 必须标注 resolved 或 blocking
