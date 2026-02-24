---
name: think
description: Use when user wants to do product thinking, socratic questioning, or analyze requirements - provides structured 5-round questioning framework for deep requirements discovery
argument-hint: "<feature or problem>"
---

# 产品思考 - 苏格拉底式追问

通过 5 轮结构化追问，深入挖掘需求本质，发现遗漏和假设。

## 使用方式

```
/product-toolkit:think [功能或问题描述]
```

例如：`/product-toolkit:think 我想做社区点赞功能`

## 追问框架

### 第一轮：澄清问题 (4-5 个问题)

请回答以下问题（可选择选项或自定义回答）：

| # | 问题 | 选项 |
|---|------|------|
| Q1 | 这个功能解决什么问题？ | A.效率 B.认知 C.情感 D.痛点 E.新机会 |
| Q2 | 目标用户是谁？ | A.消费者 B.创作者 C.商家 D.管理员 E.混合 |
| Q3 | 用户在什么场景下使用？ | A.碎片 B.专注 C.工作 D.生活 |
| Q4 | 用户现在怎么解决？ | A.竞品 B.替代 C.线下 D.凑合 E.无方案 |
| Q5 | 为什么现在做？ | A.时机 B.压力 C.呼声 D.需求 |

### 第二轮：探索假设 (3-4 个问题)

| # | 问题 | 选项 |
|---|------|------|
| Q6 | 不做这个功能会怎样？ | A.流失 B.不完整 C.受损 D.影响 E.无影响 |
| Q7 | 我们假设了什么？ | [多选]用户愿用/需求真实/竞品没做好/技术可行 |
| Q8 | 最大的风险是什么？ | A.技术 B.市场 C.运营 D.竞争 |
| Q9 | 做这个功能的目标是什么？ | 自定义回答 |

### 第三轮：用户故事边界 (5-6 个问题)

> **关键**：直接影响用户故事的验收标准

| # | 问题 | 选项 | 影响用户故事 |
|---|------|------|-------------|
| Q10 | 哪些角色可以使用？ | A.所有登录 B.指定角色 C.特定条件 D.付费 | Actor |
| Q11 | 什么情况下不能用？ | A.未登录 B.异常 C.限制 D.频次 | 前置条件 |
| Q12 | 操作有次数限制吗？ | A.无 B.每日N次 C.每周N次 D.总计N次 | 边界校验 |
| Q13 | 数据从哪里来？到哪里去？ | 自定义回答 | 功能范围 |
| Q14 | 需要权限控制吗？ | A.不需要 B.登录 C.角色 D.权限 | 权限验收 |
| Q15 | 操作可以撤销/回退吗？ | A.可撤销 B.不可 C.有时效 | 逆向流程 |

### 第四轮：验收标准 (4-5 个问题)

> **关键**：直接影响 QA 测试用例生成

| # | 问题 | 选项 | QA 用例 |
|---|------|------|---------|
| Q16 | 成功是什么样子？ | 自定义回答 | 功能测试 |
| Q17 | 失败是什么样子？ | A.提示 B.静默 C.阻断 | 异常测试 |
| Q18 | 边界在哪里？ | 自定义回答 | 边界测试 |
| Q19 | 用户怎么知道成功了？ | A.跳转 B.状态 C.Toast D.通知 | UI测试 |
| Q20 | 响应时间要求？ | A.<1秒 B.<3秒 C.异步 D.无要求 | 性能测试 |

### 第五轮：评估影响 (3-4 个问题)

| # | 问题 | 内容 |
|---|------|------|
| Q21 | 对其他功能有什么影响？ | 依赖/冲突/辅助 |
| Q22 | 上线后怎么看效果？ | 衡量指标 |
| Q23 | 数据从哪里获取？ | 已有/埋点/问卷 |
| Q24 | 回滚方案是什么？ | 回滚方案 |

## 输出

产品思考答案将作为后续命令的输入：
- `/product-toolkit:user-story` - 生成用户故事
- `/product-toolkit:test-case` - 生成测试用例
- `/product-toolkit:prd` - 生成 PRD

## 参考

- `../../references/socratic-questioning.md` - 完整追问框架

---

## 输出目录

工作流模式下输出到: `docs/product/{version}/{category}/{feature}.md`

- 用户故事: `docs/product/{version}/user-story/`
- PRD: `docs/product/{version}/prd/`
- UI设计: `docs/product/{version}/design/`
- 测试用例: `docs/product/{version}/qa/test-cases/`
- 技术方案: `docs/product/{version}/tech/`
