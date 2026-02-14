# Product Toolkit

> 通用产品经理工具集 - 集成在 Claude Code 中使用

## 功能概览

Product Toolkit 是一个完整的互联网产品经理工作流工具集，支持：

| 功能 | 说明 |
|------|------|
| 用户故事 | 标准 5 维度验收标准模板 |
| PRD | 完整结构 + 快速模板 |
| 测试用例 | 从验收标准自动生成 |
| 需求池 | MoSCoW 优先级管理 |
| 用户画像 | 完整模板 + 用户旅程 |
| 产品路线图 | 季度/月度规划 |
| 上线检查 | 上线前后检查清单 |
| 产品复盘 | 目标回顾 + 数据分析 |
| 竞品分析 | 功能矩阵 + SWOT |

## 快速开始

### 斜杠命令

```bash
# 主工具集
/product-toolkit

# 初始化项目配置
/product-toolkit:init

# 生成 PRD
/product-toolkit:prd 用户登录

# 生成测试用例
/product-toolkit:qa 用户登录

# 需求池管理
/product-toolkit:backlog

# 用户画像
/product-toolkit:persona 年轻妈妈

# 产品路线图
/product-toolkit:roadmap

# 上线检查
/product-toolkit:release

# 产品复盘
/product-toolkit:retro

# 竞品分析
/product-toolkit:analyze 竞品名称
```

### 魔法指令

当表达以下意图时自动触发：

- "创建用户故事"
- "编写 PRD"
- "生成测试用例"
- "需求排序"
- "竞品分析"
- "产品复盘"
- "上线检查"

## 输出目录

所有内容统一输出到 `docs/product/`：

```
docs/product/
├── README.md
├── config.yaml           # 项目配置
├── user-stories.md     # 用户故事汇总
├── backlog.md          # 需求池
├── roadmap.md          # 产品路线图
├── prd/                # PRD 文档
│   └── {feature}.md
├── test-cases/         # 测试用例
│   └── {feature}.md
├── personas/           # 用户画像
│   └── {name}.md
├── release/            # 上线检查
│   └── v{version}.md
├── retros/             # 复盘报告
│   └── {date}.md
└── competitors/        # 竞品分析
    └── {name}.md
```

## 子命令详解

### :init - 初始化配置

根据项目信息自动生成 `docs/product/config.yaml`：

```bash
/product-toolkit:init
```

- 自动检测项目信息（从 CLAUDE.md、package.json）
- 支持手动输入项目配置
- 根据项目类型推荐场景模板

### :prd - PRD 生成

生成标准化的产品需求文档：

```bash
/product-toolkit:prd 用户登录功能
```

输出：`docs/product/prd/用户登录.md`

包含：
- 完整 PRD 结构（10 个章节）
- 功能详情模板
- 验收标准模板

### :qa - 测试用例生成

从验收标准自动生成测试用例：

```bash
/product-toolkit:qa 用户登录
```

输出：`docs/product/test-cases/用户登录.md`

覆盖：
- 正向流程测试
- 边界值测试
- 异常场景测试
- 性能测试

### :backlog - 需求池

管理产品需求列表：

```bash
/product-toolkit:backlog
```

输出：`docs/product/backlog.md`

包含：
- 需求列表
- MoSCoW 优先级
- 状态管理

### :persona - 用户画像

生成用户画像：

```bash
/product-toolkit:persona 年轻妈妈
```

输出：`docs/product/personas/年轻妈妈.md`

包含：
- 基本信息
- 用户特征
- 用户旅程

### :roadmap - 产品路线图

生成产品路线图：

```bash
/product-toolkit:roadmap
```

输出：`docs/product/roadmap.md`

包含：
- 季度规划
- 版本规划
- 里程碑

### :release - 上线检查

生成上线检查清单：

```bash
/product-toolkit:release v1.0.0
```

输出：`docs/product/release/v1.0.0.md`

包含：
- 功能检查
- 环境检查
- 监控检查
- 应急检查

### :retro - 产品复盘

生成复盘报告：

```bash
/product-toolkit:retro
```

输出：`docs/product/retros/2026-02-14.md`

包含：
- 目标回顾
- 数据分析
- 经验总结

### :analyze - 竞品分析

生成竞品分析报告：

```bash
/product-toolkit:analyze 竞品名称
```

输出：`docs/product/competitors/竞品名称.md`

包含：
- 功能对比矩阵
- SWOT 分析
- 差异化策略

## 配置示例

### 项目配置 (config.yaml)

```yaml
project:
  name: "我的产品"
  type: "web"

scenarios:
  - id: "core"
    name: "核心功能"
    priority: 1
  - id: "extended"
    name: "扩展功能"
    priority: 2

roles:
  - id: "user"
    name: "用户"
  - id: "admin"
    name: "管理员"

output:
  user_stories: "docs/product/user-stories.md"
  prd: "docs/product/prd"
  test_cases: "docs/product/test-cases"
```

## 版本历史

| 版本 | 日期 | 变更 |
|------|------|------|
| v2.0.0 | 2026-02-14 | 完整功能集 |

## 模板文件

| 文件 | 说明 |
|------|------|
| `config/examples/bmtop.yaml` | 羽毛球小程序配置示例 |
| `config/examples/ecommerce.yaml` | 电商平台配置示例 |
| `config/examples/saas.yaml` | SaaS 管理后台配置示例 |
| `templates/test-case.md.tmpl` | 测试用例模板 |
| `docs/MOSCOW.md` | MoSCoW 优先级详解 |
| `docs/KANO.md` | KANO 模型详解 |
| `docs/RICE.md` | RICE 评分法详解 |

---

*持续迭代更新，统一输出到 docs/product/ 目录*
