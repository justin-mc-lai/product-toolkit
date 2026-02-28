# responsibility-boundaries.md（v3.7.0 / ptk-cli-scope-guard）

## 1) 目标
明确 CLI、Scope Guard、执行引擎、QA 的职责边界，避免越权与误判。

## 2) 角色定义

| 角色 | 职责 |
|---|---|
| PTK workflow/gate | 生命周期编排、范围治理、终态判定 |
| Scope Guard Owner | AC 范围定义、偏差分级、确认策略 |
| 执行引擎（OMC/OMX，可选） | 按边界执行并回填证据 |
| QA/交付负责人 | AC→TC→Evidence 审核、放行建议 |

## 3) 非入侵规则
1. 执行引擎不得绕过 Scope Guard。
2. 未经确认不得把 out-of-scope 需求并入本轮交付。
3. PTK 文档层定义优先于执行层“临时优化”。

## 4) RACI

| 活动 | PTK | Scope Guard Owner | OMC/OMX | QA |
|---|---|---|---|---|
| CLI 路由定义 | A/R | C | I | C |
| AC scope 建立 | A | A/R | I | C |
| 偏差检测与确认 | A | R | C | C |
| 实现执行 | C | C | A/R | I |
| 证据校验与终态 | A/R | C | C | A/R |
