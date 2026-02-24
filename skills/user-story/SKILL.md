---
name: user-story
description: Use when user wants to generate user stories from product thinking answers - provides structured user story with acceptance criteria
argument-hint: "<feature>"
---

# 用户故事

基于产品思考答案生成结构化的用户故事。

## 使用方式

```
/product-toolkit:user-story [功能]
```

例如：`/product-toolkit:user-story 电商收藏功能`

## 生成规则

### 输入：产品思考答案

从以下问题自动映射：
- Q10 → Actor (角色)
- Q11 → 前置条件
- Q12 → 边界校验
- Q14 → 权限控制
- Q15 → 撤销处理
- Q16 → 正向流程
- Q17 → 错误处理
- Q18 → 边界值
- Q19 → 成功反馈
- Q20 → 性能要求

---

### 输出模板

```markdown
### US-{storyId}: {featureName}

**用户故事**: 作为 [{actor}]，我希望 [{feature}]，以便 [{value}]。

**优先级**: {Must|Should|Could|Won't}
**版本**: {version}
**状态**: {New|Regression|Enhanced}

---

## 概述
{一句话描述这个用户故事}

## 前置条件
| 条件 | 描述 |
|------|------|
| 登录状态 | 用户已登录 |
| 权限 | 用户有 {permission} 权限 |
| 数据 | {data prerequisite} |

---

## 验收标准

### 1. 正向流程
- [ ] **场景1**: {来自 Q16}
- [ ] **场景2**: {additional}

### 2. 边界校验
- [ ] **边界1**: {来自 Q12, Q18}
- [ ] **边界2**: {additional}

### 3. 错误处理
- [ ] **异常1**: {来自 Q17}
- [ ] **异常2**: {additional}

### 4. 成功反馈
- [ ] **反馈1**: {来自 Q19}

### 5. 性能要求
- [ ] **指标1**: {来自 Q20}

### 6. 权限控制
- [ ] **权限1**: {来自 Q14}

### 7. 撤销处理
- [ ] **撤销1**: {来自 Q15}

---

## 技术备注

### API 设计
```
POST /api/{resource}
Request: { fields }
Response: { result }
```

### 数据模型
```
Table: {table_name}
- id: UUID
- {fields}
```

### 依赖
- 前置依赖: {dependencies}
- 被依赖: {dependents}
```

---

## 测试要点

### 功能测试
- 正向流程覆盖
- 分支流程覆盖

### 边界测试
- 最大值/最小值
- 空值处理
- 格式校验

### 异常测试
- 网络异常
- 服务异常
- 权限异常
```

---

## 示例

```markdown
### US-001: 收藏商品

**用户故事**: 作为电商平台的用户，我希望能够收藏商品，以便日后快速找到喜欢的商品。

**优先级**: Must
**版本**: v1.0.0
**状态**: New

---

## 概述
用户可以在商品详情页收藏商品，并在收藏夹中查看和管理已收藏的商品。

---

## 前置条件
| 条件 | 描述 |
|------|------|
| 登录状态 | 用户已登录 |
| 商品状态 | 商品已上架 |

---

## 验收标准

### 1. 正向流程
- [ ] 用户点击收藏按钮，商品被收藏
- [ ] 收藏成功后显示 toast 提示
- [ ] 收藏按钮状态变为已收藏

### 2. 边界校验
- [ ] 重复收藏显示"已收藏"提示
- [ ] 收藏数达到上限提示用户

### 3. 错误处理
- [ ] 网络错误显示重试提示
- [ ] 服务异常显示友好错误信息

### 4. 成功反馈
- [ ] Toast 提示"收藏成功"
- [ ] 按钮图标变化

### 5. 性能要求
- [ ] 收藏操作 < 1秒

### 6. 权限控制
- [ ] 未登录引导登录

### 7. 撤销处理
- [ ] 支持取消收藏
```

---

## 输出目录

默认模式（单命令调用）:
```
docs/product/user-stories/{feature}.md
```

工作流模式（/product-toolkit:workflow）:
```
docs/product/{version}/user-story/{feature}.md
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

- `../../references/acceptance-criteria.md` - 验收标准模板
