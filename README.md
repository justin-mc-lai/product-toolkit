# Product Toolkit

> 通用产品经理工具集 - 集成在 Claude Code 中使用

## 功能概览

Product Toolkit 是一个完整的互联网产品经理工作流工具集，支持：

| 功能 | 说明 |
|------|------|
| 产品思考 | 苏格拉底式追问，深度需求澄清 |
| 发散思维 | 网状思维头脑风暴，多维分析 |
| Design Thinking | 设计思维五阶段，解决问题创新方法 |
| JTBD | 用户任务理论，深入理解用户动机 |
| 价值主张画布 | 产品价值与客户需求匹配分析 |
| 版本迭代 | 用户故事和测试用例版本化管理 |
| UI 设计 | 草稿图、线框图、设计规范 |
| 用户故事 | 标准 5 维度验收标准模板 |
| PRD | 完整结构 + 快速模板 |
| 测试用例 | 从验收标准自动生成（含版本化） |
| 需求池 | MoSCoW / KANO / RICE 优先级管理 |
| 用户画像 | 完整模板 + 用户旅程 |
| 产品路线图 | 季度/月度规划 |
| 上线检查 | 上线前后检查清单 |
| 竞品分析 | 功能矩阵 + SWOT |
| 多代理协作 | Product PM + UI + QA + Tech Lead 团队 |
| 一键工作流 | 智能路由自动执行完整产品包生成 |

---

## 一键产品工作流 (v3.0.0)

### 快速开始

```bash
/product-toolkit:workflow 你的产品概念
```

### 支持场景

- 全新产品 (new_product)
- 功能迭代 (iteration)
- 竞品分析 (competitor)
- MVP验证 (mvp)

### 支持产品形态

- Web应用 (web)
- 移动App (mobile-app)
- 微信小程序 (mini-program)
- 跨平台 (cross-platform)
- SaaS产品 (saas)
- 全栈BaaS (baas)

### 使用示例

```bash
# 全新产品
/product-toolkit:workflow 电商收藏功能

# 指定场景
/product-toolkit:workflow --scenario=mvp 用户登录功能

# 指定产品形态
/product-toolkit:workflow --platforms=baas,mini-program 社交分享功能
```

### 输出结构

```
docs/product/v1.0.0/
├── SUMMARY.md
├── prd/
├── user-story/
├── design/wireframe/
├── design/spec/
├── qa/test-cases/
├── tech/api/
└── tech/data-model/
```

### 配置文件

- `config/workflow.yaml` - 工作流配置
- `config/versions.yaml` - 版本管理
- `config/templates/platforms.yaml` - 产品形态模板

---

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
/product-toolkit:design [功能] (可选第0轮 - Design Thinking)
    ↓
/product-toolkit:jtbd [功能] (可选 - 用户任务分析)
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

---

## 快速开始

### 斜杠命令

```bash
# 产品思考 - 苏格拉底式追问（每次 3-8 个问题）
/product-toolkit:think 我想做社区点赞功能

# 发散思维 - 网状思维头脑风暴
/product-toolkit:brainstorm 在线教育平台

# Design Thinking - 设计思维五阶段
/product-toolkit:design 支付功能

# JTBD - 用户任务分析
/product-toolkit:jtbd 外卖订餐

# 版本规划 - 用户故事和测试用例版本化
/product-toolkit:version 电商收藏

# UI 设计 - 草稿图/线框图
/product-toolkit:wireframe 登录页面
/product-toolkit:ui-spec 详情页

# 生成用户故事
/product-toolkit:user-story 电商收藏功能

# 生成测试用例（完整覆盖，含版本化）
/product-toolkit:test-case 登录功能

# 生成 API 设计
/product-toolkit:api-design 登录认证

# 生成数据字典
/product-toolkit:data-dictionary 用户模块

# 多代理团队协作
/product-toolkit:team 电商详情页

# 生成 PRD
/product-toolkit:prd 用户登录

# 初始化配置
/product-toolkit:init
```

### 魔法指令

- "创建用户故事" / "写用户故事"
- "编写 PRD" / "功能文档"
- "生成测试用例"
- "需求排序" / "MoSCoW" / "KANO"
- "竞品分析" / "上线检查"
- **"产品思考" / "需求探讨"** - 苏格拉底式追问
- **"发散思维" / "头脑风暴"** - 网状思维

---

## 产品思考详解

### 苏格拉底式追问

使用 `/product-toolkit:think [功能]` 启动

**核心原则**：
- 每次追问 **3-8 个问题**
- 支持 **选择选项** 或 **自定义回答**
- 追问细化到影响 **用户故事边界**

**5 轮追问（24 个问题）**：

| 轮次 | 问题数 | 内容 | 影响 |
|------|--------|------|------|
| 第一轮 | 4-5 | 澄清问题 | 需求定义 |
| 第二轮 | 3-4 | 探索假设 | 风险识别 |
| 第三轮 | 5-6 | 用户故事边界 | 用户故事 |
| 第四轮 | 4-5 | 验收标准 | QA 用例 |
| 第五轮 | 3-4 | 评估影响 | 上线计划 |

**追问 → 用户故事映射**：

| 用户故事要素 | 对应问题 |
|-------------|---------|
| Actor（角色） | Q10, Q13 |
| 前置条件 | Q11 |
| 业务限制 | Q12 |
| 正向流程 | Q16 |
| 错误处理 | Q17 |
| 边界值 | Q18 |
| 成功反馈 | Q19 |
| 性能要求 | Q20 |
| 权限控制 | Q14 |
| 撤销处理 | Q15 |

---

## 用户故事 → QA 用例

### 映射关系

| 用户故事要素 | QA 测试用例类型 |
|-------------|---------------|
| 正向流程 | 功能测试用例 |
| 边界校验 | 边界值测试用例 |
| 错误处理 | 异常场景测试用例 |
| 成功反馈 | UI/提示测试用例 |
| 性能要求 | 性能测试用例 |
| 权限控制 | 权限测试用例 |
| 撤销处理 | 逆向流程测试用例 |

### 测试用例分类

| 类别 | 覆盖维度 |
|------|---------|
| 功能测试 | 正向流程 |
| 边界测试 | 边界校验 |
| 异常测试 | 错误处理 |
| UI测试 | 成功反馈 |
| 性能测试 | 性能 |
| 权限测试 | 权限控制 |
| 逆向测试 | 撤销/回退 |

---

## 输出目录

独立模式（单命令调用）:
```
docs/product/
├── prd/{feature}.md
├── test-cases/{feature}.md
├── personas/{name}.md
├── roadmap.md
├── release/v{version}.md
└── competitors/{name}.md
```

工作流模式（/product-toolkit:workflow）:
```
docs/product/{version}/
├── SUMMARY.md
├── prd/{feature}.md
├── user-story/{feature}.md
├── design/wireframe/{feature}.md
├── design/spec/{feature}.md
├── qa/test-cases/{feature}.md
├── tech/api/{feature}.md
└── tech/data-model/{feature}.md
```

---

## 版本历史

| 版本 | 日期 | 变更 |
|------|------|------|
| v3.0.0 | 2026-02-24 | 添加一键工作流、版本化输出配置、平台模板与版本配置 |
| v2.6.0 | 2026-02-19 | 添加 Claude Team 多代理协作（Product PM + UI + QA + Tech Lead） |
| v2.5.0 | 2026-02-19 | 添加 UI 设计（草稿图、线框图、UI规范） |
| v2.4.0 | 2026-02-19 | 添加版本迭代、Design Thinking、JTBD、价值主张画布 |
| v2.3.0 | 2026-02-19 | 添加 Sprint 规划、KPI指标、用户故事地图 |
| v2.2.0 | 2026-02-19 | 产品思考→用户故事→QA用例完整工作流 |
| v2.1.0 | 2026-02-14 | 添加产品思考和发散思维功能 |
| v2.0.0 | 2026-02-14 | 完整功能集 |

---

## 参考文档

- `references/socratic-questioning.md` - 苏格拉底式追问完整框架
- `references/acceptance-criteria.md` - 验收标准与 QA 用例模板
- `references/sprint-planning.md` - Sprint 规划与敏捷管理
- `references/kpi-metrics.md` - KPI 与数据指标体系
- `references/user-story-mapping.md` - 用户故事地图
- `references/MOSCOW.md` - MoSCoW 优先级详解
- `references/KANO.md` - KANO 模型详解
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

*持续迭代更新，统一输出到 docs/product/{version}/ 目录*
