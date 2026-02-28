# responsibility-boundaries.md（标准模板）

## 1) 目标

统一“谁定义、谁执行、谁验收”的边界，避免多代理长任务中的职责重叠与越权。

## 2) 角色定义

| 角色 | 职责定位 |
|---|---|
| PTK workflow/gate | 生命周期治理中枢：需求产物、架构约束、验收与终态判定 |
| 架构负责人（Tech Lead/Architect） | 架构方案、边界裁决、ADR 审批 |
| 执行引擎（OMC/OMX，可选） | 按 PTK 产物执行长任务并回填证据 |
| QA/交付负责人 | AC→TC→Evidence 审核，交付放行建议 |

## 3) 非入侵规则（必须）

1. OMC/OMX 不得改写 PTK 已确认的需求边界。
2. OMC/OMX 不得绕过 `boundaries.md` 与 `terminal.json` 判定流程。
3. 架构边界争议必须回到 ADR/边界文档，不以执行器默认行为替代。

## 4) RACI 矩阵

| 活动 | PTK | 架构负责人 | OMC/OMX（可选） | QA/交付 |
|---|---|---|---|---|
| 需求澄清（think） | A/R | C | I | C |
| 用户故事/PRD/测试用例产出 | A/R | C | I | C |
| 架构上下文与边界定义 | A | A/R | C | C |
| 实现与长任务迭代执行 | C | C | A/R | I |
| AC→TC→Evidence 回填 | C | C | R | A |
| Gate 判定与终态归档 | A/R | C | C | A/R |

> A=Accountable，R=Responsible，C=Consulted，I=Informed

## 5) 交付边界

- “可交付”必须同时满足：
  - 职责边界已确认（无越权争议）
  - 接口契约无未解决漂移
  - NFR 预算有证据支撑
  - gate 结果为 Pass

