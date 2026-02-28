# 测试用例：PTK v3.7.0 - CLI 统一入口 + Scope Guard + 双模式报告

**状态**: Ready  
**范围**: 覆盖 US-3701 ~ US-3710 与 PRD FR-3701 ~ FR-3717

---

## 1. 测试目标

验证 v3.7.0 是否实现：

1. `ptk` 统一 CLI 入口
2. Scope Guard（AC 解析、偏差监控、人类确认）
3. 双模式报告（human/machine）
4. 开发模式切换（normal/debug/strict/dry-run/replay）
5. 全阶段证据链与防伪校验

---

## 2. 测试前置

- 仓库：`product-toolkit/`
- 版本目录：`docs/product/v3.7.0/`
- 输入产物已存在：
  - PRD：`docs/product/v3.7.0/prd/ptk-cli-scope-guard.md`
  - User Story：`docs/product/v3.7.0/user-story/ptk-cli-scope-guard.md`
  - Boundaries：`docs/product/v3.7.0/execution/boundaries.md`

---

## 3. 测试用例清单

### TC-3701 CLI 子命令可用性
- 类型：Smoke
- 覆盖：FR-3701 / US-3701
- 步骤：
  1. 执行 `ptk status`
  2. 执行 `ptk run workflow --mode normal`
  3. 执行 `ptk doctor`
- 期望：
  - 命令可解析
  - 返回结构化输出
  - 无未捕获异常

### TC-3702 CLI 错误处理与帮助
- 类型：Regression
- 覆盖：US3701-AC03/AC04
- 步骤：
  1. 执行 `ptk unknown-cmd`
  2. 执行 `ptk help`
- 期望：
  - 未知命令返回候选命令
  - help 输出完整命令索引

### TC-3703 AC 解析与绑定
- 类型：New
- 覆盖：FR-3702 / US-3702
- 步骤：
  1. 以 `user-story/ptk-cli-scope-guard.md` 为输入运行 AC 解析
  2. 检查 `ac_scope.json`
- 期望：
  - 生成 `acceptance_criteria/core_scope/enhancement_scope`
  - 解析失败时有明确错误信息

### TC-3704 Scope 偏差监控
- 类型：New
- 覆盖：FR-3703 / US-3703
- 步骤：
  1. 构造超范围实现建议
  2. 触发范围监控
- 期望：
  - 低风险偏差标记 `enhancement-proposal`
  - 高风险偏差标记 `out-of-scope`
  - 偏差写入 `.ptk/memory/scope/deviations.json`

### TC-3705 人类确认流程
- 类型：New
- 覆盖：FR-3704 / US-3704
- 步骤：
  1. 触发高风险 out-of-scope 建议
  2. 输出 A/B/C 确认选项
  3. 选择 A 或 C
- 期望：
  - 未确认前流程暂停
  - 确认后状态流转
  - 记录写入 `confirmations.json`

### TC-3706 人类友好报告
- 类型：Smoke
- 覆盖：FR-3705 / US-3705
- 步骤：
  1. 执行 `ptk report --human <run_id>`
  2. 打开 `summary.md`
- 期望：
  - 不含 token/tool/prompt 原始调试信息
  - 仅保留结果、产物、待确认项

### TC-3707 机器完整报告
- 类型：Smoke
- 覆盖：FR-3706 / US-3706
- 步骤：
  1. 执行 `ptk report --machine <run_id>`
  2. 校验 JSON schema
- 期望：
  - 包含 `events/llm_prompts/token_usage/tool_calls`
  - JSON 可被下游工具解析

### TC-3708 运行模式切换
- 类型：Regression
- 覆盖：FR-3707 / US-3707
- 步骤：
  1. 分别执行 5 种模式
  2. 对比输出行为
- 期望：
  - normal：标准输出
  - debug：事件级日志
  - strict：触发 Scope Guard + 强门禁
  - dry-run：不执行写操作
  - replay：可复盘历史 run

### TC-3709 scope-memory 记录
- 类型：New
- 覆盖：FR-3708 / US-3708
- 步骤：
  1. 触发一次偏差 + 一次人工确认
  2. 查询 scope memory 文件
- 期望：
  - `deviations.json` 与 `confirmations.json` 均有新记录
  - 记录可追溯 run_id、时间、决策

### TC-3710 下一步多选建议
- 类型：New
- 覆盖：FR-3709
- 步骤：
  1. 在 think/user-story/test-case 各阶段结束后观察输出
- 期望：
  - 每次输出 2-4 个建议
  - 标注推荐项
  - 支持“其他指令”输入

### TC-3711 生命周期流转与版本迭代
- 类型：Regression
- 覆盖：FR-3710
- 步骤：
  1. 走完 think→version→user-story→prd→test-case→gate
  2. 模拟 hotfix 递进
- 期望：
  - 生命周期顺序正确
  - hotfix 可继承父版本证据

### TC-3712 测试框架推荐准确性
- 类型：New
- 覆盖：FR-3711
- 步骤：
  1. 输入前后端项目
  2. 输入纯后端项目
- 期望：
  - 前后端推荐 `agent-browser` E2E
  - 纯后端推荐 `curl`/API E2E

### TC-3713 交付 Gate 判定
- 类型：Smoke
- 覆盖：FR-3712
- 步骤：
  1. 构造 AC→TC 缺失场景
  2. 执行 gate
- 期望：
  - 命中缺失时结论 `Blocked`
  - reason code 可定位

### TC-3714 全阶段证据链覆盖
- 类型：New
- 覆盖：FR-3713
- 步骤：
  1. 检查各阶段证据文件是否存在
  2. 校验证据清单
- 期望：
  - think/version/user-story/prd/test-case/implementation/gate 均有锚点

### TC-3715 防伪校验（真实性）
- 类型：New
- 覆盖：FR-3714
- 步骤：
  1. 注入占位符未替换文档
  2. 注入高重复率文档
- 期望：
  - 触发 `suspicious` 标记
  - 给出问题说明

### TC-3716 证据质量预测
- 类型：New
- 覆盖：FR-3715
- 步骤：
  1. 生成有缺口的证据包
  2. 执行质量预测
- 期望：
  - 输出 completeness/consistency/verifiability
  - 给出风险提示与建议动作

### TC-3717 测试证据整合
- 类型：New
- 覆盖：FR-3716
- 步骤：
  1. 执行单元测试与 E2E
  2. 收集报告到 evidence
- 期望：
  - 证据成功纳入 manifest
  - 可被 terminal 引用

### TC-3718 版本链追溯
- 类型：Regression
- 覆盖：FR-3717
- 步骤：
  1. 从 v1.0.0 递进到 v1.0.1（hotfix）
  2. 检查 diff_evidence
- 期望：
  - parent/current 关系正确
  - 变更证据可追溯

---

## 4. AC/FR 覆盖矩阵（摘要）

| 覆盖对象 | 覆盖用例 |
|----------|----------|
| US-3701 | TC-3701, TC-3702 |
| US-3702 | TC-3703 |
| US-3703 | TC-3704 |
| US-3704 | TC-3705 |
| US-3705 | TC-3706 |
| US-3706 | TC-3707 |
| US-3707 | TC-3708 |
| US-3708 | TC-3709 |
| US-3709 | TC-3710 |
| US-3710 | TC-3711 ~ TC-3718 |

覆盖率（计划）：`18/18 = 100%`

---

## 5. Blocked 判定

任一命中即 `Blocked`：

1. AC→TC 映射缺失
2. Scope Guard 未触发或不可记录
3. `--human` 报告泄露机器敏感信息
4. `--machine` 报告结构不完整
5. evidence 链不完整或不可验证

---

## 6. 执行结论位（待回填）

- Gate0 输入完整性：Pass / Blocked
- Gate1 功能正确性：Pass / Blocked
- Gate2 证据链完整性：Pass / Blocked
- 总结论：Pass / Blocked
