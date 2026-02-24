---
name: workflow
description: Use when user wants to run complete product workflow - provides one-click workflow that automatically calls sub-commands to generate versioned complete product packages including PRD, user stories, UI design, test cases, and technical solutions. Supports multiple scenarios (new product, iteration, competitor analysis, MVP).
argument-hint: "<product concept or feature>"
---

# 一键产品完善工作流

通过智能路由按场景自动编排子命令（4-11 个步骤），输出版本化的完整产品包。

## 使用方式

```bash
# 启动工作流
/product-toolkit:workflow 电商收藏功能

# 指定场景
/product-toolkit:workflow --scenario=new_product 电商收藏功能

# 指定产品形态
/product-toolkit:workflow --platforms=web,mini-program 电商收藏功能

# 查看帮助
/product-toolkit:workflow --help
```

## 支持的场景

| 场景 | 命令 | 说明 |
|------|------|------|
| 全新产品 | --scenario=new_product | 从概念到完整产品包 |
| 功能迭代 | --scenario=iteration | 现有产品新增功能 |
| 竞品分析 | --scenario=competitor | 竞品分析后输出方案 |
| MVP验证 | --scenario=mvp | 最小可行产品 |

## 支持的产品形态

| 形态 | 说明 |
|------|------|
| web | Web应用 |
| mobile-app | 移动App (iOS + Android) |
| mini-program | 微信小程序 |
| cross-platform | 跨平台 |
| saas | SaaS产品 |
| baas | 全栈BaaS (Supabase/Firebase) |

## 工作流阶段

### Phase 1: 智能分析

分析用户输入，识别：
- 场景类型 (全新/迭代/竞品/MVP)
- 产品形态 (PC/小程序/App/BaaS)
- 目标用户群体
- 核心功能范围

### Phase 2: 需求采集 (交互确认)

通过对话确认关键信息：
- 产品形态选择
- 目标用户
- 核心功能
- 版本规划

### Phase 3: 子命令执行

根据场景自动执行相应子命令：

**全新产品场景**:
```
think → brainstorm → design → jtbd → version → wireframe → ui-spec → user-story → prd → test-case → team
```

**功能迭代场景**:
```
think → version → user-story → test-case → team
```

**竞品分析场景**:
```
analyze → think → prd
```

**MVP验证场景**:
```
think → user-story → prd → test-case
```

### Phase 4: 输出整合

自动整理输出到版本目录：
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

## 使用示例

### 示例 1: 全新产品

```bash
/product-toolkit:workflow 电商收藏功能
```

交互:
```
🤖 分析中...
✓ 识别为: 全新产品
✓ 产品形态: Web + 微信小程序
✓ 目标用户: 电商消费者

📋 请确认:
[1] 产品形态: Web + 微信小程序
[2] 目标用户: 电商消费者
[3] 核心功能: 商品收藏、收藏管理
[4] 版本号: v1.0.0

确认? (y/n)

> y

🚀 执行工作流...
[1/11] 产品思考...
[2/11] 发散思维...
...

✅ 完成! 输出: docs/product/v1.0.0/
```

### 示例 2: 指定场景和形态

```bash
/product-toolkit:workflow --scenario=mvp --platforms=baas 用户登录功能
```

## 配置文件

工作流配置: `../../config/workflow.yaml`
版本配置: `../../config/versions.yaml`

## 相关子命令

- `think` - 产品思考
- `brainstorm` - 发散思维
- `design` - Design Thinking
- `jtbd` - JTBD分析
- `version` - 版本规划
- `wireframe` - 线框图
- `ui-spec` - UI规范
- `user-story` - 用户故事
- `prd` - PRD文档
- `test-case` - 测试用例
- `api-design` - API设计
- `data-dictionary` - 数据字典
- `team` - 多代理整合
