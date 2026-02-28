# api-contracts.md（标准模板）

## 0. 元信息

- version: `vX.Y.Z`
- feature: `<feature-name>`
- owner: `<api-owner>`
- updated_at: `YYYY-MM-DD`

## 1. 契约总览

| contract_id | 类型 | 接口/事件 | owner | 版本 |
|---|---|---|---|---|
| `CON-001` | REST/GraphQL/Event | `<name>` | `<team>` | `v1` |

## 2. 契约详情

### CON-001

- 描述：
- 请求/输入：
- 响应/输出：
- 错误码：
- 幂等性与重试策略：
- 向后兼容策略：

## 3. 变更记录（Contract Drift Log）

| drift_id | contract_id | 变更说明 | 风险等级 | 状态（open/resolved） | 证据 |
|---|---|---|---|---|---|
| `DRIFT-001` | `CON-001` | `<change>` | `<high/medium/low>` | `open` | `<link>` |

## 4. 验证要求

- 每个契约必须至少有 1 条测试用例映射（TC）
- 每个 drift 必须有“接受/修复”决策与证据

