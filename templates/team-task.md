# 团队任务分解模板

本文档提供多代理团队任务分解的模板和示例。

## 1. 任务分解模板

### 1.1 任务结构

```markdown
## 任务分解: {功能名称}

### 项目信息
| 字段 | 值 |
|------|-----|
| 功能名称 | {featureName} |
| 版本 | {version} |
| 日期 | {date} |
| Team Lead | {leadName} |

### 任务总览
| # | 任务 | 代理 | 状态 | 依赖 | 输出 |
|---|------|------|------|------|------|
| 1 | 需求分析 | Product PM | Pending | - | 用户故事 |
| 2 | UI 设计 | UI Designer | Pending | 1 | 草稿图+规范 |
| 3 | 测试用例 | QA Engineer | Pending | 1 | 测试用例 |
| 4 | 技术方案 | Tech Lead | Pending | 2 | API+数据模型 |
| 5 | 结果整合 | Team Lead | Pending | 2,3,4 | 整合报告 |
```

### 1.2 任务详细说明

#### 任务 1: 需求分析

```markdown
### 任务 1: 需求分析

**代理**: Product PM
**依赖**: 无
**输出**: docs/product/user-stories/{feature}.md

#### 详细要求
1. 使用产品思考深入理解需求（/product-toolkit:think）
2. 编写用户故事（/product-toolkit:user-story）
3. 确定优先级（MoSCoW）
4. 制定验收标准

#### 验收标准
- [ ] 用户故事格式正确
- [ ] 优先级明确
- [ ] 验收标准可测试
- [ ] 覆盖所有用户场景
```

#### 任务 2: UI 设计

```markdown
### 任务 2: UI 设计

**代理**: UI Designer
**依赖**: 任务 1 (需求分析)
**输出**:
- docs/design/wireframe/{feature}.md
- docs/design/spec/{feature}.md

#### 详细要求
1. 阅读 Product PM 的用户故事
2. 创建页面布局草稿图（/product-toolkit:wireframe）
3. 描述线框图结构
4. 定义 UI 规范（/product-toolkit:ui-spec）

#### 验收标准
- [ ] 草稿图清晰可读
- [ ] 布局结构完整
- [ ] UI 规范覆盖所有组件
- [ ] 与用户故事一致
```

#### 任务 3: 测试用例

```markdown
### 任务 3: 测试用例

**代理**: QA Engineer
**依赖**: 任务 1 (需求分析)
**输出**: docs/qa/test-cases/{feature}.md

#### 详细要求
1. 阅读 Product PM 的用户故事和验收标准
2. 编写功能测试用例
3. 编写边界测试用例
4. 编写异常测试用例
5. 定义回归测试范围

#### 验收标准
- [ ] 正向流程 100% 覆盖
- [ ] 边界条件已覆盖
- [ ] 异常场景已覆盖
- [ ] 用例可独立执行
```

#### 任务 4: 技术方案

```markdown
### 任务 4: 技术方案

**代理**: Tech Lead
**依赖**: 任务 2 (UI 设计)
**输出**:
- docs/tech/api/{feature}.md
- docs/tech/data-model/{feature}.md

#### 详细要求
1. 阅读 UI Designer 的设计稿
2. 设计 API 端点（/product-toolkit:api-design）
3. 定义数据模型（/product-toolkit:data-dictionary）
4. 识别技术风险

#### 验收标准
- [ ] API 设计完整
- [ ] 数据模型清晰
- [ ] 技术风险已识别
- [ ] 支持所有功能
```

#### 任务 5: 结果整合

```markdown
### 任务 5: 结果整合

**代理**: Team Lead
**依赖**: 任务 2, 3, 4
**输出**: docs/product/package/{feature}-package.md

#### 详细要求
1. 收集所有代理的输出
2. 检查一致性
3. 检查完整性
4. 生成整合报告

#### 验收标准
- [ ] 需求一致性通过
- [ ] 完整性检查通过
- [ ] 质量检查通过
- [ ] 无冲突或遗漏
```

## 2. 任务状态追踪

### 2.1 状态定义

| 状态 | 说明 | 触发条件 |
|------|------|---------|
| PENDING | 等待开始 | 任务刚创建 |
| ASSIGNED | 已分配 | 任务分配给代理 |
| IN_PROGRESS | 执行中 | 代理开始处理 |
| BLOCKED | 被阻塞 | 等待依赖完成 |
| COMPLETED | 已完成 | 任务完成并通过验收 |
| FAILED | 失败 | 任务执行失败 |

### 2.2 状态更新规则

```
PENDING → ASSIGNED: Team Lead 分配任务
ASSIGNED → IN_PROGRESS: 代理开始处理
IN_PROGRESS → BLOCKED: 依赖未满足
BLOCKED → IN_PROGRESS: 依赖已满足
IN_PROGRESS → COMPLETED: 任务完成
IN_PROGRESS → FAILED: 执行失败
FAILED → IN_PROGRESS: 重新执行（可选）
```

## 3. 任务示例

### 3.1 电商详情页

```markdown
## 任务分解: 电商详情页

### 项目信息
| 字段 | 值 |
|------|-----|
| 功能名称 | 电商商品详情页 |
| 版本 | v1.0.0 |
| 日期 | 2026-02-19 |
| Team Lead | Auto |

### 任务总览
| # | 任务 | 代理 | 状态 |
|---|------|------|------|
| 1 | 需求分析 | Product PM | Pending |
| 2 | UI 设计 | UI Designer | Pending |
| 3 | 测试用例 | QA Engineer | Pending |
| 4 | 技术方案 | Tech Lead | Pending |
| 5 | 结果整合 | Team Lead | Pending |

### 任务 1 详情
**输出**: docs/product/user-stories/ecommerce-detail.md

#### 用户故事
- US-v1.0-1: 作为消费者，我希望查看商品详情，以便了解商品信息
- US-v1.0-2: 作为消费者，我希望加入购物车，以便后续购买
- US-v1.0-3: 作为消费者，我希望收藏商品，以便以后查看
- US-v1.0-4: 作为消费者，我希望查看评论，以便了解其他用户评价
```

---

**版本**: 1.0
**更新日期**: 2026-02-19
