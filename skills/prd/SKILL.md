---
name: prd
description: Use when user wants to generate a Product Requirements Document - provides comprehensive PRD template with all sections
argument-hint: "<feature or module>"
---

# PRD 产品需求文档

生成完整的 PRD 文档。

## 使用方式

```
/product-toolkit:prd [功能或模块]
```

例如：`/product-toolkit:prd 用户登录模块`

## PRD 模板

```markdown
# PRD: {featureName}

**版本**: {version}
**状态**: Draft/In Review/Approved
**创建日期**: {date}
**更新日期**: {date}
**产品经理**: {PM name}

---

## 1. 概述

### 1.1 背景
{描述这个需求的背景和动机}

### 1.2 目标
- 目标1
- 目标2
- 目标3

### 1.3 成功指标
| 指标 | 目标值 | 测量方式 |
|------|-------|---------|
| {metric 1} | {target} | {method} |
| {metric 2} | {target} | {method} |

---

## 2. 用户分析

### 2.1 目标用户
{描述目标用户群体}

### 2.2 用户画像
{引用或创建用户画像}

### 2.3 用户需求
| 需求 | 优先级 | 来源 |
|------|--------|------|
| {need 1} | P0 | {source} |
| {need 2} | P1 | {source} |

---

## 3. 功能需求

### 3.1 功能列表

#### 功能 1: {featureName}
**描述**: {描述}
**优先级**: P0
**用户故事**: US-{id}

**需求详情**:
| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| {field} | {type} | Y/N | {desc} |

**业务流程**:
```
{流程描述}
```

#### 功能 2: {featureName}
...

---

### 3.2 功能矩阵

| 功能 | P0 | P1 | P2 | 备注 |
|------|----|----|----|------|
| {feature 1} | ✓ | | | |
| {feature 2} | | ✓ | | |
| {feature 3} | | | ✓ | |

---

## 4. 非功能需求

### 4.1 性能要求
- 响应时间: < {N}ms
- 并发数: {N} QPS

### 4.2 可用性
- 可用性: {N}%
- 降级策略: {strategy}

### 4.3 安全要求
- 认证: {method}
- 授权: {method}
- 敏感数据: {handling}

### 4.4 兼容性
- 浏览器: {list}
- 移动端: {list}
- 旧版本: {strategy}

---

## 5. UI/UX 需求

### 5.1 页面清单
| 页面 | 类型 | 优先级 |
|------|------|--------|
| {page} | {type} | P0 |

### 5.2 交互要求
{描述关键交互}

### 5.3 设计稿
- 设计稿链接: {link}
- 组件库: {library}

---

## 6. 技术需求

### 6.1 API 设计
| API | 方法 | 说明 |
|-----|------|------|
| /api/{endpoint} | POST | {desc} |

### 6.2 数据模型
```
Table: {table_name}
- id: UUID
- {fields}
```

### 6.3 第三方依赖
| 依赖 | 用途 | 替代方案 |
|------|------|---------|
| {dep} | {use} | {alt} |

---

## 7. 测试需求

### 7.1 测试策略
- 功能测试: {coverage}
- 性能测试: {scope}
- 安全测试: {scope}

### 7.2 验收标准
| 功能 | 验收条件 | 测试方式 |
|------|---------|---------|
| {feature} | {criteria} | {method} |

---

## 8. 风险与依赖

### 8.1 风险
| 风险 | 影响 | 应对措施 |
|------|------|---------|
| {risk} | {impact} | {mitigation} |

### 8.2 依赖
| 依赖项 | 依赖方 | 计划时间 |
|--------|-------|---------|
| {dep} | {party} | {date} |

---

## 9. 发布计划

### 9.1 里程碑
| 里程碑 | 日期 | 说明 |
|--------|------|------|
| M1 | {date} | {desc} |
| M2 | {date} | {desc} |

### 9.2 回滚方案
{描述回滚方案}
```

---

## 输出目录

默认模式（单命令调用）:
```
docs/product/prd/{feature}.md
```

工作流模式（/product-toolkit:workflow）:
```
docs/product/{version}/prd/{feature}.md
```

---

## 工作流

```
/product-toolkit:think [功能]  (产品思考)
        ↓
/product-toolkit:user-story [功能]  (用户故事)
        ↓
/product-toolkit:prd [功能]  (PRD)
        ↓
/product-toolkit:test-case [功能]  (测试用例)
```
