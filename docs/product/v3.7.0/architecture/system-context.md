# system-context.md（v3.7.0 / ptk-cli-scope-guard）

## 0. 元信息
- version: `v3.7.0`
- feature: `ptk-cli-scope-guard`
- owner: `PTK Core Team`
- updated_at: `2026-02-28`

## 1. 业务上下文
- 目标用户：产品经理、研发负责人、交付/QA
- 核心目标：统一入口、减少溢出、提升可审计性
- 关键约束：不破坏 v3.6.1 workflow 主路径

## 2. 系统边界
### 2.1 In Boundary
- PTK 命令路由层（ptk CLI）
- Scope Guard（AC 解析 + 偏差监控 + 人类确认）
- 报告层（human/machine）
- 证据层（terminal + manifest + consistency）

### 2.2 Out Boundary
- OMC/OMX 内部引擎实现
- 外部 CI/CD 平台的专有能力

## 3. 组件与职责

| 组件 | 主要职责 | owner |
|---|---|---|
| Command Router | 子命令解析、模式切换 | PTK Core |
| Scope Guard | AC 绑定、偏差检测、确认流转 | PTK Core |
| Report Builder | summary.md / summary.json 输出 | PTK Core |
| Evidence Validator | 证据清单与终态校验 | PTK Core + QA |

## 4. 关键交互流
1. 用户执行 `ptk run workflow --mode strict`
2. 读取 PRD/US/TC，解析 AC 范围
3. 执行过程中监控 out-of-scope
4. 触发人类确认并记录
5. 生成双模式报告与 terminal 终态

## 5. 依赖与风险

| 依赖项 | 类型 | 风险等级 | 兜底策略 |
|---|---|---|---|
| user-story 结构稳定性 | 内部 | 中 | 解析失败时回退手工 AC scope |
| evidence 脚本链路 | 内部 | 中 | 失败时输出 blocked_unknown + 修复建议 |
| 人类确认响应时效 | 外部 | 低 | 超时默认暂停 |
