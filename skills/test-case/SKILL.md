---
name: test-case
description: Use when user wants to generate QA test cases from user stories - provides comprehensive test case coverage
argument-hint: "<feature or module>"
---

# 测试用例

从用户故事生成完整的 QA 测试用例。

当功能属于可视化 Web 前端 UI 时，测试用例必须升级为“可执行验证包”：通过 `agent-browser` / `browser-use` 实际运行，从登录开始、截图核验 UI、检查 Console 和 API 状态，并完成 AC→TC 全覆盖后方可交付。

## 使用方式

```
/product-toolkit:test-case [功能]
```

例如：`/product-toolkit:test-case 登录功能`

## UI 可视化测试前置补充（强制，Web 前端）

当用户故事包含可视化 Web UI 时，生成与执行测试用例时必须遵循：

1. 通过 `agent-browser` 或 `browser-use` 启动并运行 Web 测试。
2. 从登录页开始执行，账号/凭据/权限映射仅可由用户提供。
3. 对关键步骤进行截图，确认数据绑定正确、页面排版正常。
4. 打开浏览器 Console，确认无未处理错误。
5. 核查关键 API 请求状态码均为 HTTP 200。
6. 建立 AC→TC 覆盖矩阵，确保用户故事验收标准 100% 覆盖。
7. 任一项失败、缺失或账号不足时，结论必须标记为 `Blocked`（不可交付）。

## 测试用例模板

```markdown
# 测试用例: {featureName}

**版本**: {version}
**状态**: Draft/Reviewed/Approved
**测试工程师**: {QA name}
**创建日期**: {date}

## UI 可视化执行要求（仅 Web 前端 UI）

| 字段 | 值 |
|------|------|
| 执行框架 | agent-browser / browser-use |
| 环境入口 | {web login url} |
| 账号来源 | 仅可由用户提供（角色/权限映射） |
| 执行起点 | 从登录页开始 |
| 交付门槛 | 任一校验项失败 => Blocked/不可交付 |

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
| 执行框架 | agent-browser/browser-use |
| 登录起点 | 从登录页开始（使用仅可由用户提供的测试账号） |
| 截图证据 | {before/after screenshot paths} |
| 数据绑定核验 | {pass/fail + 证据} |
| 布局排版核验 | {pass/fail + 证据} |
| Console检查 | {error_count=0} |
| API状态检查 | {critical APIs: 200} |
| AC→TC映射 | {AC-ID list} |
| 交付结论 | Pass/Fail/Blocked |

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
| 角色 | 账号标识（脱敏） | 凭据引用（Secret/Vault） | 权限 |
|------|------------------|--------------------------|------|
| 管理员 | {provided_by_user_masked} | {secret_ref_admin} | 全部 |
| 普通用户 | {provided_by_user_masked} | {secret_ref_user} | 基础 |
| 受限用户 | {provided_by_user_masked} | {secret_ref_limited} | 受限 |

> 说明：测试账号、环境地址与权限映射仅可由用户提供。不要在仓库中存储明文凭据。
> 若缺少账号信息导致无法覆盖全部验收标准，测试结论应标记为 `Blocked`。

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
```
