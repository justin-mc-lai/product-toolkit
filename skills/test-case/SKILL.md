---
name: test-case
description: Use when user wants to generate QA test cases from user stories - provides comprehensive test case coverage
argument-hint: "<feature or module>"
---

# 测试用例

从用户故事生成完整的 QA 测试用例。

## 使用方式

```
/product-toolkit:test-case [功能]
```

例如：`/product-toolkit:test-case 登录功能`

## 测试用例模板

```markdown
# 测试用例: {featureName}

**版本**: {version}
**状态**: Draft/Reviewed/Approved
**测试工程师**: {QA name}
**创建日期**: {date}

---

## 用例分类汇总

| 类别 | 用例数 | 覆盖维度 |
|------|-------|---------|
| 功能测试 | X | 正向流程 |
| 边界测试 | X | 边界校验 |
| 异常测试 | X | 错误处理 |
| UI测试 | X | 成功反馈 |
| 性能测试 | X | 性能 |
| 权限测试 | X | 权限控制 |
| 逆向流程测试 | X | 撤销处理 |

---

## 1. 功能测试用例（正向流程）

### TC-{id}: {caseName}

| 字段 | 值 |
|------|------|
| 用例ID | TC-{id} |
| 用例名称 | {name} |
| 用例类型 | 功能测试 |
| 优先级 | P0/P1/P2 |
| 前置条件 | {prerequisite} |
| 测试步骤 | 1. {step 1}<br>2. {step 2}<br>3. {step 3} |
| 预期结果 | {expected result} |
| 测试数据 | {test data} |
| 实际结果 | - |
| 测试结论 | - |

---

## 2. 边界值测试用例

### TC-{id}: {caseName}

| 字段 | 值 |
|------|------|
| 用例ID | TC-{id} |
| 用例名称 | {name} |
| 用例类型 | 边界测试 |
| 优先级 | P1/P2 |
| 测试场景 | {scenario} |
| 输入值 | {input} |
| 边界值 | {boundary value} |
| 预期结果 | {expected} |

### 边界值矩阵

| 字段 | 最小值 | 最大值 | 边界内 | 边界外 |
|------|--------|--------|--------|--------|
| {field} | {min} | {max} | {valid} | {invalid} |

---

## 3. 异常场景测试用例

### TC-{id}: {caseName}

| 字段 | 值 |
|------|------|
| 用例ID | TC-{id} |
| 用例名称 | {name} |
| 用例类型 | 异常测试 |
| 优先级 | P1 |
| 异常场景 | {scenario} |
| 触发条件 | {trigger} |
| 预期结果 | {expected} |
| 错误码 | {error code} |

### 异常场景矩阵

| 场景 | 错误类型 | 用户提示 | 日志 |
|------|---------|---------|------|
| {scenario} | {type} | {message} | {log} |

---

## 4. UI/提示测试用例

### TC-{id}: {caseName}

| 字段 | 值 |
|------|------|
| 用例ID | TC-{id} |
| 用例名称 | {name} |
| 用例类型 | UI测试 |
| 优先级 | P2 |
| 测试场景 | {scenario} |
| 预期反馈 | {feedback} |
| 反馈形式 | Toast/弹窗/状态变化 |

---

## 5. 性能测试用例

### TC-{id}: {caseName}

| 字段 | 值 |
|------|------|
| 用例ID | TC-{id} |
| 用例名称 | {name} |
| 用例类型 | 性能测试 |
| 优先级 | P1 |
| 性能指标 | {metric} |
| 目标值 | < {value}ms |
| 测试方法 | {method} |

### 性能指标

| 指标 | 目标值 | 预警值 | 测试方法 |
|------|--------|--------|---------|
| 响应时间 | < 1000ms | < 2000ms | {method} |
| 并发数 | {N} QPS | - | {method} |
| 错误率 | < 0.1% | < 1% | {method} |

---

## 6. 权限测试用例

### TC-{id}: {caseName}

| 字段 | 值 |
|------|------|
| 用例ID | TC-{id} |
| 用例名称 | {name} |
| 用例类型 | 权限测试 |
| 优先级 | P0 |
| 测试角色 | {role} |
| 测试操作 | {operation} |
| 预期结果 | {expected} |

### 权限矩阵

| 角色 | 操作A | 操作B | 操作C |
|------|-------|-------|-------|
| 管理员 | ✓ | ✓ | ✓ |
| 普通用户 | ✓ | ✗ | ✓ |
| 游客 | ✗ | ✗ | ✗ |

---

## 7. 逆向流程测试用例

### TC-{id}: {caseName}

| 字段 | 值 |
|------|------|
| 用例ID | TC-{id} |
| 用例名称 | {name} |
| 用例类型 | 逆向流程 |
| 优先级 | P1 |
| 操作 | {operation} |
| 撤销条件 | {condition} |
| 预期结果 | {expected} |

---

## 测试数据准备

### 测试账号
| 角色 | 用户名 | 密码 | 权限 |
|------|--------|------|------|
| 管理员 | admin@test.com | {pwd} | 全部 |
| 普通用户 | user@test.com | {pwd} | 基础 |
| 游客 | - | - | 无 |

### 测试数据
| 数据类型 | 数量 | 准备方式 |
|---------|------|---------|
| {data type} | {count} | {method} |

---

## 测试环境

| 环境 | 地址 | 用途 |
|------|------|------|
| Dev | dev.example.com | 开发测试 |
| Test | test.example.com | 集成测试 |
| Staging | staging.example.com | 预发布 |

---

## 输出目录

默认模式（单命令调用）:
```
docs/product/test-cases/{feature}.md
```

工作流模式（/product-toolkit:workflow）:
```
docs/product/{version}/qa/test-cases/{feature}.md
```

---

## 工作流

```
/product-toolkit:think [功能]  (产品思考)
        ↓
/product-toolkit:user-story [功能]  (用户故事)
        ↓
/product-toolkit:test-case [功能]  (测试用例)
```

## 参考

- `../../references/acceptance-criteria.md` - 验收标准与 QA 用例模板
