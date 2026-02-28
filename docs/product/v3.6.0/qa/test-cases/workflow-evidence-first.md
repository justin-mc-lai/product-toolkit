# 测试用例：Workflow Evidence-First（v3.6.0）

**状态**: Ready  
**范围**: v3.6.0 用户故事 US-3601 ~ US-3607

---

## 1. 测试目标

验证 v3.6.0 是否实现以下目标：

1. 用户仍只需使用 `/product-toolkit:workflow`（`/product-toolkit:work` 别名）
2. workflow 核心产物聚焦 PRD / User Story / QA Test Cases
3. workflow 结果给出 OMC/OMX 下一步固定提示词
4. `boundaries.md + terminal.json` 形成证据闭环判定
5. bridge 保留但降级为兼容路径（非默认）
6. 架构设计与职责边界标准化并纳入 gate

---

## 2. 测试前置

- 仓库根路径可访问（当前仓库）
- v3.6.0 文档目录存在：`docs/product/v3.6.0/`
- 入口文档可读：`SKILL.md`、`commands/product-toolkit.md`、`README.md`

## 2.1 交叉引用

- 来源用户故事：`docs/product/v3.6.0/user-story/workflow-evidence-first.md`
- 来源 PRD：`docs/product/v3.6.0/prd/workflow-evidence-first.md`
- 执行边界模板：`docs/product/v3.6.0/execution/boundaries.md`
- 终态模板：`docs/product/v3.6.0/execution/terminal.json`

---

## 3. 测试用例清单

### TC-3601（对应 US3601）主入口保持 workflow/work

- 类型：New
- 步骤：
  1. 检查 `SKILL.md` 与 `commands/product-toolkit.md` 对 `/product-toolkit:workflow` 与 `/product-toolkit:work` 的说明
  2. 检查是否存在新增用户命令要求
- 期望：
  - workflow/work 均可见且语义一致
  - 未引入必须学习的新用户命令

### TC-3602（对应 US3602）核心产物链聚焦

- 类型：New
- 步骤：
  1. 检查 `skills/workflow/SKILL.md` 是否定义核心产物链（PRD/US/QA）
  2. 检查 v3.6.0 README 是否只索引产物与模板链接
- 期望：
  - workflow 主叙事聚焦产物
  - 执行验证链与核心产物链分层

### TC-3603（对应 US3603）固定下一步提示词

- 类型：New
- 步骤：
  1. 打开 `docs/product/v3.6.0/execution/next-step-prompts.md`
  2. 检查 OMC 与 OMX 两套模板是否包含 5 个路径变量
- 期望：
  - 存在 OMC/OMX 模板
  - 包含 PRD/US/QA/Boundaries/Terminal 路径变量

### TC-3604（对应 US3604）边界模板完整性

- 类型：Regression
- 步骤：
  1. 打开 `docs/product/v3.6.0/execution/boundaries.md`
  2. 校验是否包含 In Scope / Out of Scope / Done / Blocked / Evidence
- 期望：
  - 边界模板字段齐全
  - Done 与 Blocked 可执行判定

### TC-3605（对应 US3605）终态模板完整性

- 类型：Regression
- 步骤：
  1. 打开 `docs/product/v3.6.0/execution/terminal.json`
  2. 校验 `terminal.status/reason_codes` 与顶层 `traceability/evidence` 字段存在
- 期望：
  - terminal 仅支持 Pass/Blocked/Cancelled
  - AC→TC→Evidence 可追溯

### TC-3606（对应 US3606）bridge 降级为兼容路径

- 类型：Regression
- 步骤：
  1. 检查入口文档对 bridge 的描述
  2. 检查是否仍可用但非默认推荐
- 期望：
  - workflow 为默认主路径
  - bridge 被标记为兼容/高级路径

### TC-3607（对应 US3607）架构治理产物与 gate 联动

- 类型：New
- 步骤：
  1. 检查 `docs/product/v3.6.0/architecture/` 是否存在标准模板文件
  2. 检查 `execution/next-step-prompts.md` 是否包含 architecture 路径变量
  3. 检查 gate 文档与校验器是否包含架构类 reason code
- 期望：
  - 架构治理模板齐全
  - OMC/OMX 仍为可选执行器（非入侵 PTK 规划）
  - 缺失架构产物可被 gate 识别为 Blocked

---

## 4. AC→TC 覆盖矩阵

| US | 核心验收点 | 覆盖 TC |
|---|---|---|
| US-3601 | workflow/work 默认且零新增命令 | TC-3601 |
| US-3602 | 核心产物链聚焦 PRD/US/QA | TC-3602 |
| US-3603 | OMC/OMX 固化下一步模板 | TC-3603 |
| US-3604 | boundaries 模板完整可判定 | TC-3604 |
| US-3605 | terminal 模板可追溯终态 | TC-3605 |
| US-3606 | bridge 降级为兼容路径 | TC-3606 |
| US-3607 | 架构治理产物与职责边界标准化 | TC-3607 |

覆盖率：`7/7 = 100%`

---

## 5. 阻塞规则

任一成立即 `Blocked`：

1. 任一 US 无映射 TC
2. `boundaries.md` 或 `terminal.json` 缺失
3. `architecture/*.md` 关键模板缺失
4. next-step 模板缺失 OMC/OMX 任一模板
5. 入口文档未体现 workflow 主路径

---

## 6. 执行结论位（待执行）

- Gate0 输入完整性：Pass/Blocked
- Gate1 文档契约一致性：Pass/Blocked
- Gate2 AC→TC 覆盖：Pass/Blocked
- 总结论：Pass/Fail/Blocked
