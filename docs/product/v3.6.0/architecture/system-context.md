# system-context.md（标准模板）

## 0. 元信息

- version: `vX.Y.Z`
- feature: `<feature-name>`
- owner: `<architect-or-tech-lead>`
- updated_at: `YYYY-MM-DD`

## 1. 业务上下文

- 目标用户：
- 核心业务目标：
- 关键业务约束：

## 2. 系统边界（Context Boundary）

### 2.1 In Boundary（系统内）

- `<模块A>`
- `<模块B>`

### 2.2 Out Boundary（系统外）

- `<外部系统X>`
- `<第三方依赖Y>`

## 3. 组件与职责

| 组件 | 主要职责 | 所属域 | owner |
|---|---|---|---|
| `<component>` | `<responsibility>` | `<domain>` | `<team/role>` |

## 4. 关键交互流

### 4.1 核心时序（高层）

1. `<step-1>`
2. `<step-2>`
3. `<step-3>`

### 4.2 数据流与控制流

- 输入：
- 输出：
- 状态变更：

## 5. 依赖与风险

| 依赖项 | 类型（内部/外部） | 风险等级 | 兜底策略 |
|---|---|---|---|
| `<dependency>` | `<type>` | `<high/medium/low>` | `<fallback>` |

## 6. 设计约束

- 安全约束：
- 合规约束：
- 可用性约束：

