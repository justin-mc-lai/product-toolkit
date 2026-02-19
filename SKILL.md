---
name: product-toolkit
description: This skill should be used when the user asks to "create a user story", "write a PRD", "generate test cases", "prioritize requirements", "analyze competitors", "create a product roadmap", "do a product retrospective", "release checklist", "create backlog", "write acceptance criteria", "break down features", "analyze requirements", "create persona", "do user research", "version planning", "requirement review", "design API", "create data dictionary", or "feature breakdown". Provides comprehensive product management templates and workflows. Also supports product thinking with subcommands.
argument-hint: "<command> [args]"
---

# Product Toolkit

提供产品经理工作流工具集，包含用户故事、PRD、测试用例、需求池、用户画像、路线图、上线检查、竞品分析、复盘等功能。支持子命令调用。

## 子命令

| 子命令 | 说明 | 示例 |
|--------|------|------|
| `/product-toolkit:init` | 初始化项目配置 | `/product-toolkit:init` |
| `/product-toolkit:think [问题]` | 产品思考 - 苏格拉底式追问 | `/product-toolkit:think 我想做社区点赞功能` |
| `/product-toolkit:brainstorm [主题]` | 发散思维 - 网状思维 | `/product-toolkit:brainstorm 在线教育平台` |
| `/product-toolkit:design [主题]` | Design Thinking 设计思维 | `/product-toolkit:design 支付功能` |
| `/product-toolkit:jtbd [主题]` | JTBD 用户任务分析 | `/product-toolkit:jtbd 外卖订餐` |
| `/product-toolkit:version [主题]` | 版本规划 - 迭代管理 | `/product-toolkit:version 电商收藏` |
| `/product-toolkit:wireframe [主题]` | 生成草稿图/线框图 | `/product-toolkit:wireframe 登录页面` |
| `/product-toolkit:ui-spec [主题]` | 生成 UI 设计规范 | `/product-toolkit:ui-spec 详情页` |
| `/product-toolkit:user-story` | 生成用户故事 | `/product-toolkit:user-story 电商收藏功能` |
| `/product-toolkit:prd` | 生成 PRD | `/product-toolkit:prd 用户登录模块` |
| `/product-toolkit:test-case` | 生成测试用例 | `/product-toolkit:test-case 登录功能` |
| `/product-toolkit:moscow` | MoSCoW 优先级排序 | `/product-toolkit:moscow` |
| `/product-toolkit:kano` | KANO 模型分析 | `/product-toolkit:kano 社区功能` |
| `/product-toolkit:persona` | 生成用户画像 | `/product-toolkit:persona 00后大学生` |
| `/product-toolkit:roadmap` | 生成产品路线图 | `/product-toolkit:roadmap` |
| `/product-toolkit:release` | 上线检查清单 | `/product-toolkit:release v1.0.0` |
| `/product-toolkit:analyze` | 竞品分析 | `/product-toolkit:analyze 抖音` |
| `/product-toolkit:team` | 多代理团队协作 | `/product-toolkit:team 电商详情页` |

## 完整工作流

### 产品思考 → 用户故事 → QA 用例

```
/product-toolkit:think [功能描述]
    ↓
回答 5 轮追问（24 个问题，每次 3-8 个）
    ↓
生成用户故事（含边界答案）
    ↓
/product-toolkit:user-story [功能]
    ↓
生成 QA 测试用例（完整覆盖）
```

### 完整版本迭代工作流

```
/product-toolkit:design [功能] (可选第0轮)
    ↓
/product-toolkit:jtbd [功能] (可选)
    ↓
/product-toolkit:think [功能]
    ↓
5 轮产品思考追问
    ↓
/product-toolkit:version [功能]
    ↓
版本规划 + 用户故事（版本化）
    ↓
/product-toolkit:user-story [功能]
    ↓
/product-toolkit:test-case [功能]
    ↓
测试用例（版本化，含新增/回归状态）
```

### UI 设计工作流

```
/product-toolkit:think [功能]
    ↓
产品思考 (5轮追问)
    ↓
/product-toolkit:wireframe [功能]
    ↓
生成草稿图 + 线框图描述
    ↓
/product-toolkit:ui-spec [功能]
    ↓
生成 UI 设计规范
```

### 多代理团队协作工作流

```
/product-toolkit:team [功能]
    ↓
Team Lead 分析需求，分解任务
    ↓
并行执行:
├─ Product PM: 用户故事
├─ UI Designer: 草稿图+规范
├─ QA Engineer: 测试用例
└─ Tech Lead: 技术方案
    ↓
Team Lead 整合验证
    ↓
输出完整产品包
```

**子命令**: `/product-toolkit:team [功能]`

**团队角色**:
| 角色 | 任务 | 输出 |
|------|------|------|
| Team Lead | 协调、整合、验证 | 整合报告 |
| Product PM | 需求分析、用户故事 | docs/product/user-stories/ |
| UI Designer | 草稿图、线框图、UI规范 | docs/design/ |
| QA Engineer | 测试用例、测试计划 | docs/qa/test-cases/ |
| Tech Lead | API设计、数据模型 | docs/tech/ |

**使用场景**:
- 复杂功能需要多领域专家并行工作
- 需要完整产品包（需求+设计+测试+技术）
- 大型功能需要任务分解和协调

**参考文档**:
- `references/team-collaboration.md` - 多代理协作指南
- `references/team-roles.md` - 角色定义与Prompt模板
- `templates/team-task.md` - 任务分解模板

---

## 核心工作流

### 0. Design Thinking 设计思维（可选第0轮）

**子命令**: `/product-toolkit:design [功能]`

**触发条件**（满足任一即可）：
- 新产品/新功能方向探索
- 用户需求不明确场景
- 用户主动调用

**5 阶段**：
| 阶段 | 问题 | 输出 |
|------|------|------|
| Empathize | 目标用户核心痛点是什么？ | Persona, 痛点列表 |
| Define | 真正的问题是什么？ | Problem Statement |
| Ideation | 可能的解决方案？ | 创意清单, MoSCoW |
| Prototype | 如何快速验证？ | 原型方案 |
| Test | 如何验证假设？ | 测试反馈 |

**与产品思考关系**：第0轮为可选扩展，输出作为第1轮输入

---

### 1. 苏格拉底式产品构建（产品思考）

**子命令**: `/product-toolkit:think [问题]`

**核心原则**：
- 每次追问 **3-8 个问题**
- 支持 **选择选项** 或 **自定义回答**
- 追问细化到影响 **用户故事边界**

**工作流**：澄清 → 假设 → 边界 → 验收 → 影响

#### 第一轮：澄清问题（4-5 个问题）

请回答以下问题（可选择选项或自定义回答）：

| # | 问题 | 选项 |
|---|------|------|
| Q1 | 这个功能解决什么问题？ | A.效率 B.认知 C.情感 D.痛点 E.新机会 |
| Q2 | 目标用户是谁？ | A.消费者 B.创作者 C.商家 D.管理员 E.混合 |
| Q3 | 用户在什么场景下使用？ | A.碎片 B.专注 C.工作 D.生活 |
| Q4 | 用户现在怎么解决？ | A.竞品 B.替代 C.线下 D.凑合 E.无方案 |
| Q5 | 为什么现在做？ | A.时机 B.压力 C.呼声 D.需求 |

---

#### 第二轮：探索假设（3-4 个问题）

| # | 问题 | 选项 |
|---|------|------|
| Q6 | 不做这个功能会怎样？ | A.流失 B.不完整 C.受损 D.影响 E.无影响 |
| Q7 | 我们假设了什么？ | [多选]用户愿用/需求真实/竞品没做好/技术可行 |
| Q8 | 最大的风险是什么？ | A.技术 B.市场 C.运营 D.竞争 |
| Q9 | 做这个功能的目标是什么？ | 自定义回答 |

---

#### 第三轮：用户故事边界（5-6 个问题）

> **关键**：直接影响用户故事的验收标准

| # | 问题 | 选项 | 影响用户故事 |
|---|------|------|-------------|
| Q10 | 哪些角色可以使用？ | A.所有登录 B.指定角色 C.特定条件 D.付费 | Actor |
| Q11 | 什么情况下不能用？ | A.未登录 B.异常 C.限制 D.频次 | 前置条件 |
| Q12 | 操作有次数限制吗？ | A.无 B.每日N次 C.每周N次 D.总计N次 | 边界校验 |
| Q13 | 数据从哪里来？到哪里去？ | 自定义回答 | 功能范围 |
| Q14 | 需要权限控制吗？ | A.不需要 B.登录 C.角色 D.权限 | 权限验收 |
| Q15 | 操作可以撤销/回退吗？ | A.可撤销 B.不可 C.有时效 | 逆向流程 |

---

#### 第四轮：验收标准（4-5 个问题）

> **关键**：直接影响 QA 测试用例生成

| # | 问题 | 选项 | QA 用例 |
|---|------|------|---------|
| Q16 | 成功是什么样子？ | 自定义回答 | 功能测试 |
| Q17 | 失败是什么样子？ | A.提示 B.静默 C.阻断 | 异常测试 |
| Q18 | 边界在哪里？ | 自定义回答 | 边界测试 |
| Q19 | 用户怎么知道成功了？ | A.跳转 B.状态 C.Toast D.通知 | UI测试 |
| Q20 | 响应时间要求？ | A.<1秒 B.<3秒 C.异步 D.无要求 | 性能测试 |

---

#### 第五轮：评估影响（3-4 个问题）

| # | 问题 | 内容 |
|---|------|------|
| Q21 | 对其他功能有什么影响？ | 依赖/冲突/辅助 |
| Q22 | 上线后怎么看效果？ | 衡量指标 |
| Q23 | 数据从哪里获取？ | 已有/埋点/问卷 |
| Q24 | 回滚方案是什么？ | 回滚方案 |

---

### 2. 生成用户故事

**子命令**: `/product-toolkit:user-story [功能]`

**基于产品思考答案自动生成**：

```markdown
### US-{storyId}: {featureName}

**用户故事**: 作为 [{role}]，我希望 [{feature}]，以便 [{value}]。

**优先级**: {Must|Should|Could|Won't}
**前置条件**: {来自 Q11 答案}

**验收标准**:
- [ ] **正向流程**: {来自 Q16 答案}
- [ ] **边界校验**: {来自 Q12, Q18 答案}
- [ ] **错误处理**: {来自 Q17 答案}
- [ ] **成功反馈**: {来自 Q19 答案}
- [ ] **性能**: {来自 Q20 答案}
- [ ] **权限控制**: {来自 Q14 答案}
- [ ] **撤销处理**: {来自 Q15 答案}
```

### 3. 生成测试用例

**子命令**: `/product-toolkit:test-case [功能]`

**从用户故事自动映射到 QA 用例**：

| 用户故事要素 | QA 测试用例类型 |
|-------------|---------------|
| 正向流程 (Q16) | 功能测试用例 |
| 边界校验 (Q12, Q18) | 边界值测试用例 |
| 错误处理 (Q17) | 异常场景测试用例 |
| 成功反馈 (Q19) | UI/提示测试用例 |
| 性能 (Q20) | 性能测试用例 |
| 权限控制 (Q14) | 权限测试用例 |
| 撤销处理 (Q15) | 逆向流程测试用例 |

**输出模板**：

```markdown
## 测试用例：{功能名称}

### 用例分类汇总
| 类别 | 用例数 | 覆盖维度 |
|------|-------|---------|
| 功能测试 | X | 正向流程 |
| 边界测试 | X | 边界校验 |
| 异常测试 | X | 错误处理 |
| UI测试 | X | 成功反馈 |
| 性能测试 | X | 性能 |
| 权限测试 | X | 权限控制 |

### 1. 功能测试用例（正向流程）
| 用例ID | 用例名称 | 前置条件 | 测试步骤 | 预期结果 |
|--------|---------|---------|---------|---------|

### 2. 边界值测试用例
| 用例ID | 字段 | 边界值 | 预期结果 |

### 3. 异常场景测试用例
| 用例ID | 异常场景 | 触发条件 | 预期结果 |

### 4. UI/提示测试用例
| 用例ID | 场景 | 预期反馈 |

### 5. 性能测试用例
| 用例ID | 指标 | 目标值 | 测试方法 |

### 6. 权限测试用例
| 用例ID | 角色 | 操作 | 预期结果 |

### 7. 逆向流程测试用例
| 用例ID | 操作 | 撤销条件 | 预期结果 |
```

### 4. 生成 PRD

**子命令**: `/product-toolkit:prd [功能]`

输出到 `docs/product/prd/{feature}.md`

### 5. 需求管理

**MoSCoW**：
- Must: 上线阻塞，20-30%
- Should: 重要非阻塞，30-40%
- Could: 锦上添花，20-30%
- Won't: 本期不实现，10%

### 6-10. 其他功能

| 功能 | 输出 |
|------|------|
| 用户画像 | docs/product/personas/{name}.md |
| 产品路线图 | docs/product/roadmap.md |
| 上线检查 | docs/product/release/v{version}.md |
| 产品复盘 | docs/product/retros/{date}.md |
| 竞品分析 | docs/product/competitors/{name}.md |

---

## 输出目录

```
docs/product/
├── config.yaml
├── user-stories.md
├── backlog.md
├── roadmap.md
├── prd/{feature}.md
├── test-cases/{feature}.md
├── personas/{name}.md
├── release/v{version}.md
├── retros/{date}.md
└── competitors/{name}.md
```

---

## 参考文档

- `references/socratic-questioning.md` - 苏格拉底式追问完整框架
- `references/acceptance-criteria.md` - 验收标准与 QA 用例模板
- `references/sprint-planning.md` - Sprint 规划与敏捷管理
- `references/kpi-metrics.md` - KPI 与数据指标体系
- `references/user-story-mapping.md` - 用户故事地图
- `references/moscow.md` - MoSCoW 优先级详解
- `references/kano.md` - KANO 模型详解
- `references/product-versioning.md` - 产品版本迭代规划
- `references/design-thinking.md` - Design Thinking 设计思维
- `references/jtbd.md` - JTBD 用户任务理论
- `references/value-proposition.md` - 价值主张画布
- `references/ui-wireframe.md` - UI 草稿图与线框图
- `references/ui-spec.md` - UI 设计规范
- `references/product-to-ui.md` - 产品思考→UI 转换指南
- `references/team-collaboration.md` - 多代理协作指南
- `references/team-roles.md` - 角色定义与Prompt模板
- `templates/team-task.md` - 任务分解模板

---

**版本**: v2.6.0

**更新日志**:
- v2.6.0: 添加 Claude Team 多代理协作（team 命令）
- v2.5.0: 添加 UI 设计（草稿图、线框图、UI规范）
- v2.4.0: 添加版本迭代、Design Thinking、JTBD、价值主张画布
- v2.3.0: 产品思考5轮追问完善
- v2.2.0: 产品思考→用户故事→QA用例完整工作流
- v2.1.0: 添加产品思考和发散思维功能
- v2.0.0: 添加完整产品工作流
