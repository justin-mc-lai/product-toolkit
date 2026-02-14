---
name: product-toolkit
description: This skill should be used when the user asks to "create a user story", "write a PRD", "generate test cases", "prioritize requirements", "analyze competitors", "create a product roadmap", "do a product retrospective", "release checklist", "create backlog", "write acceptance criteria", "break down features", "analyze requirements", "create persona", "do user research", "version planning", "requirement review", "design API", "create data dictionary", or "feature breakdown". Provides comprehensive product management templates and workflows.
---

# Product Toolkit

提供产品经理工作流工具集，包含用户故事、PRD、测试用例、需求池、用户画像、路线图、上线检查、竞品分析、复盘等功能。

## 触发条件

用户表达以下意图时加载此 skill：
- "创建用户故事" / "编写用户故事" / "写用户故事"
- "编写 PRD" / "补充 PRD" / "功能文档" / "需求文档"
- "生成测试用例" / "产出测试用例" / "写测试用例"
- "需求排序" / "功能优先级" / "MoSCoW" / "KANO" / "RICE"
- "竞品分析" / "竞争对手分析"
- "产品复盘" / "复盘报告"
- "上线检查" / "发布检查"
- "需求池" / "Backlog" / "需求管理"
- "用户画像" / "Persona" / "用户调研"
- "产品路线图" / "Roadmap" / "版本规划"
- "功能拆解" / "需求拆解" / "功能拆分成用户故事"
- "需求评审" / "PRD 评审"
- "API 设计" / "接口设计"
- "数据字典" / "数据库设计"

## 核心工作流

### 1. 初始化项目配置

使用 `/product-toolkit:init` 初始化项目配置：
- 自动检测项目信息（从 CLAUDE.md、package.json）
- 支持手动输入项目配置
- 根据项目类型推荐场景模板
- 生成 `docs/product/config.yaml`

### 2. 生成用户故事

基于 5 维度验收标准模板：

```markdown
### US-{storyId}: {featureName}

**用户故事**: 作为 [{role}]，我希望 [{feature}]，以便 [{value}]。

**优先级**: {Must|Should|Could|Won't}
**前置条件**: {preconditions}

**验收标准**:
- [ ] **正向流程**: {feature} 核心流程可正常使用
- [ ] **边界校验**: {boundary_rules}
- [ ] **错误处理**: 异常输入/超限时提示友好
- [ ] **成功反馈**: 操作成功后反馈明确
- [ ] **性能**: {performance_target}
```

### 3. 生成 PRD

输出到 `docs/product/prd/{feature}.md`：

**完整结构（10 章节）**：
1. 文档信息
2. 背景与目标
3. 用户分析
4. 功能需求
5. 非功能需求
6. 上下线依赖
7. 风险与对策
8. 评审记录
9. 变更记录
10. 附录

**快速模板**：适用于简单功能

### 4. 生成测试用例

从验收标准自动映射到测试用例：

| 验收标准维度 | 测试用例类型 |
|-------------|-------------|
| 正向流程 | 功能测试用例 |
| 边界校验 | 边界值测试用例 |
| 错误处理 | 异常场景测试用例 |
| 成功反馈 | UI/提示测试用例 |
| 性能 | 性能测试用例 |

### 5. 需求管理

**MoSCoW 优先级**：
- **Must**: 上线阻塞，20-30%
- **Should**: 重要非阻塞，30-40%
- **Could**: 锦上添花，20-30%
- **Won't**: 本期不实现，10%

### 6. 用户画像

输出到 `docs/product/personas/{name}.md`：
- 基本信息
- 用户特征
- 用户旅程

### 7. 产品路线图

输出到 `docs/product/roadmap.md`：
- 季度规划
- 版本规划
- 里程碑

### 8. 上线检查

输出到 `docs/product/release/v{version}.md`：
- 功能检查
- 环境检查
- 监控检查
- 应急检查

### 9. 产品复盘

输出到 `docs/product/retros/{date}.md`：
- 目标回顾
- 数据分析
- 经验总结

### 10. 竞品分析

输出到 `docs/product/competitors/{name}.md`：
- 功能对比矩阵
- SWOT 分析
- 差异化策略

## 输出目录规范

所有内容统一输出到 `docs/product/`：

```
docs/product/
├── README.md              # 产品文档索引
├── config.yaml            # 项目配置
├── user-stories.md       # 用户故事汇总
├── backlog.md            # 需求池
├── roadmap.md            # 产品路线图
├── prd/
│   └── {feature}.md     # PRD 文档
├── test-cases/
│   └── {feature}.md     # 测试用例
├── personas/
│   └── {name}.md        # 用户画像
├── release/
│   └── v{version}.md   # 上线检查
├── retros/
│   └── {date}.md       # 复盘报告
└── competitors/
    └── {name}.md       # 竞品分析
```

## 配置示例

项目配置文件 `docs/product/config.yaml`：

```yaml
project:
  name: "产品名称"
  type: "miniapp" | "web" | "api" | "mobile"

scenarios:
  - id: "core"
    name: "核心功能"
    priority: 1

roles:
  - id: "user"
    name: "用户"

boundaries:
  field_name:
    min: 1
    max: 100
```

## 详细参考

### 优先级方法

- **MoSCoW**: `references/moscow.md` - 快速排序法则
- **KANO 模型**: `references/kano.md` - 用户满意度分析
- **RICE 评分**: `references/rice.md` - 多因素量化评分
- **版本管理**: `references/versioning.md` - 版本号规范

### API 与数据

- **API 设计**: `references/api-design.md` - RESTful API 规范
- **数据字典**: `references/data-dictionary.md` - 数据库设计模板

### 验收标准库

- `references/acceptance-criteria.md` - 各类功能验收标准模板

### 示例文件

- `examples/user-story-example.md` - 用户故事完整示例
- `examples/prd-example.md` - PRD 文档示例
- `examples/test-case-example.md` - 测试用例示例

### 配置模板

- `config/template.yaml` - 项目配置模板
- `config/examples/ecommerce.yaml` - 电商项目配置示例
- `config/examples/saas.yaml` - SaaS 项目配置示例
- `config/examples/bmtop.yaml` - 羽毛球小程序配置示例

---

**版本**: v2.0.0

**更新日志**:
- v2.0.0: 添加完整产品工作流
