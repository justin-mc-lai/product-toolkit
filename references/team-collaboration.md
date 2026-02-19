# 多代理协作指南

本文档提供 Claude Team 多代理协作的完整指南，包括工作流、任务分配和协调机制。

## 1. 多代理工作流概述

### 1.1 核心流程

```
用户输入 (功能需求)
    │
    ▼
Team Lead (协调者)
    │
    ├─▶ Product PM: 需求分析 → 用户故事
    │
    ├─▶ UI Designer: UI设计 → 草稿图/规范
    │
    ├─▶ QA Engineer: 测试用例 → 测试计划
    │
    └─▶ Tech Lead: 技术方案 → API/数据模型
    │
    ▼
Verifier: 验证整合
    │
    ▼
输出: 完整产品包 (需求+设计+测试+技术)
```

### 1.2 协作阶段

| 阶段 | 角色 | 任务 | 输出 |
|------|------|------|------|
| Phase 1 | Team Lead | 需求理解与任务分解 | 任务清单 |
| Phase 2 | 各专业代理 | 并行执行专业任务 | 专业输出 |
| Phase 3 | Team Lead | 结果整合与验证 | 完整产品包 |
| Phase 4 | Verifier | 质量验证 | 验证报告 |

## 2. 任务分配策略

### 2.1 依赖关系图

```
[Product PM]
      │
      ├─(依赖)─▶ [UI Designer]
      ├─(依赖)─▶ [QA Engineer]
      └─(依赖)─▶ [Tech Lead]
            │
            └─(可选依赖)─▶ [UI Designer]
```

### 2.2 并行与串行

| 任务类型 | 执行方式 | 说明 |
|---------|---------|------|
| 需求分析 | 串行 | 首先执行，为其他任务提供输入 |
| UI 设计 | 并行 | 与 QA、Tech Lead 并行 |
| 测试用例 | 并行 | 与 UI、Tech Lead 并行 |
| 技术方案 | 并行 | 与 UI、QA 并行 |
| 结果整合 | 串行 | 所有任务完成后执行 |

## 3. 协调机制

### 3.1 消息传递

代理之间通过消息传递进行协调：

```markdown
### 消息类型

| 类型 | 发送方 | 接收方 | 用途 |
|------|--------|--------|------|
| TASK_ASSIGNED | Team Lead | 代理 | 分配新任务 |
| TASK_COMPLETE | 代理 | Team Lead | 任务完成报告 |
| TASK_BLOCKED | 代理 | Team Lead | 任务受阻 |
| DEPENDENCY_READY | Team Lead | 代理 | 依赖已满足 |
| REQUEST_CLARIFICATION | 代理 | Team Lead | 请求澄清 |
```

### 3.2 状态同步

| 状态 | 说明 |
|------|------|
| PENDING | 等待分配 |
| IN_PROGRESS | 执行中 |
| BLOCKED | 被阻塞 |
| COMPLETED | 已完成 |
| FAILED | 失败 |

## 4. 整合验证

### 4.1 验证清单

```markdown
## 整合验证清单

### 需求一致性
- [ ] 用户故事与 UI 设计一致
- [ ] 用户故事与测试用例覆盖一致
- [ ] 用户故事与技术方案一致

### 完整性检查
- [ ] 所有用户故事有对应测试用例
- [ ] 所有用户故事有对应 API 设计
- [ ] 所有用户故事有对应数据模型

### 质量检查
- [ ] 验收标准可测试
- [ ] 边界条件已覆盖
- [ ] 错误处理已考虑
```

### 4.2 冲突解决

| 冲突类型 | 解决策略 |
|---------|---------|
| 需求冲突 | 以 Product PM 为准 |
| 设计冲突 | 以 UI Designer 为准 |
| 测试冲突 | 以 QA Engineer 为准 |
| 技术冲突 | 以 Tech Lead 为准 |

## 5. 输出产物

### 5.1 目录结构

```
docs/
├── product/
│   ├── user-stories/
│   │   └── {feature}.md
│   └── prd/
│       └── {feature}.md
├── design/
│   ├── wireframe/
│   │   └── {feature}.md
│   └── spec/
│       └── {feature}.md
├── qa/
│   └── test-cases/
│       └── {feature}.md
└── tech/
    └── api/
        └── {feature}.md
```

### 5.2 整合报告模板

```markdown
# 产品包整合报告

## 功能: {featureName}

### 需求 (Product PM)
- 用户故事数: X
- 优先级分布: Must X, Should X, Could X

### 设计 (UI Designer)
- 页面数: X
- 组件数: X

### 测试 (QA Engineer)
- 用例数: X
- 覆盖率: X%

### 技术 (Tech Lead)
- API 端点数: X
- 数据模型数: X

### 验证结果
- [ ] 需求一致性: 通过
- [ ] 完整性: 通过
- [ ] 质量: 通过
```

---

**版本**: 1.0
**更新日期**: 2026-02-19
