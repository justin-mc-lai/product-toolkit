# 用户故事：PTK v3.7.0 - CLI 统一入口 + Scope Guard + 双模式报告

**状态**: Draft
**优先级**: P0
**来源**: v3.7.0 PRD（CLI 统一 + Scope Guard + 双模式报告）

---

## US-3701：统一 CLI 入口

**用户故事**：作为 PTK 用户，我希望通过 `ptk` 一个命令访问所有功能，以便降低学习成本并统一运维入口。

### 范围
- In Scope：`ptk` 命令聚合 status/run/debug/report/resume/doctor
- Out of Scope：重写 OMC/OMX 执行引擎

### 验收标准（7维）
- [ ] US3701-AC01 正向：`ptk status` 可聚合 team/gate/bridge/test 状态
- [ ] US3701-AC02 边界：`ptk run workflow` 等价于直接调用 workflow skill
- [ ] US3701-AC03 错误：未知子命令返回可用命令列表
- [ ] US3701-AC04 反馈：`ptk help` 显示完整命令索引
- [ ] US3701-AC05 性能：CLI 响应时间 < 1s
- [ ] US3701-AC06 权限：CLI 不记录明文凭据
- [ ] US3701-AC07 回退：现有脚本保持可用

---

## US-3702：Scope Guard - AC 解析与绑定

**用户故事**：作为 PM/交付负责人，我希望 workflow 在执行前解析用户故事的验收标准（AC），以便明确功能边界。

### 范围
- In Scope：解析 user-story.md 生成 ac_scope.json
- Out of Scope：自动补充缺失的 AC

### 验收标准（7维）
- [ ] US3702-AC01 正向：执行前自动解析 user-story.md 中的 AC
- [ ] US3702-AC02 边界：输出 ac_scope.json 包含 core_scope 和 enhancement_scope
- [ ] US3702-AC03 错误：user-story.md 缺失时提示补充
- [ ] US3702-AC04 反馈：AC 解析结果可查看
- [ ] US3702-AC05 性能：解析时间 < 2s
- [ ] US3702-AC06 权限：解析过程不泄露敏感信息
- [ ] US3702-AC07 回退：可手动编辑 ac_scope.json 覆盖解析结果

---

## US-3703：Scope Guard - 范围监控

**用户故事**：作为执行者，我希望 LLM 实现的功能被监控是否超出 AC 范围，以便及时发现溢出风险。

### 范围
- In Scope：实现过程中检测范围偏差
- Out of Scope：自动阻止 LLM 实现（仅标记）

### 验收标准（7维）
- [ ] US3703-AC01 正向：LLM 实现超出 AC 范围时自动标记
- [ ] US3703-AC02 边界：区分 low/medium/high 风险溢出
- [ ] US3703-AC03 错误：无法判断范围时默认标记为 pending
- [ ] US3703-AC04 反馈：偏差记录写入 scope-deviation.json
- [ ] US3703-AC05 性能：监控不影响执行性能
- [ ] US3703-AC06 权限：偏差记录不包含敏感数据
- [ ] US3703-AC07 回退：可手动标记 false positive

---

## US-3704：Scope Guard - 人类确认流程

**用户故事**：作为用户，我希望优化建议和超范围功能由我确认是否采纳，以便保持对功能的控制。

### 范围
- In Scope：人类确认 UI/流程 + 确认后状态流转
- Out of Scope：自动批准或拒绝

### 验收标准（7维）
- [ ] US3704-AC01 正向：检测到优化建议时输出确认选项
- [ ] US3704-AC02 边界：提供 A/B/C 选择而非开放式问题
- [ ] US3704-AC03 错误：用户未确认时默认暂停执行
- [ ] US3704-AC04 反馈：确认后状态自动流转
- [ ] US3704-AC05 性能：确认流程不影响正常执行
- [ ] US3704-AC06 权限：确认记录可追溯
- [ ] US3704-AC07 回退：可撤销已确认的决定

---

## US-3705：双模式报告 - 人类友好

**用户故事**：作为 PM/管理者，我希望报告简洁易懂，只展示关键信息，以便快速决策。

### 范围
- In Scope：summary.md 屏蔽机器信息
- Out of Scope：自动生成 PPT/幻灯片

### 验收标准（7维）
- [ ] US3705-AC01 正向：`ptk report --human` 输出 markdown 报告
- [ ] US3705-AC02 边界：报告包含执行结果、产物清单、待确认事项
- [ ] US3705-AC03 错误：无 run_id 时使用 latest
- [ ] US3705-AC04 反馈：报告可读性评分 > 4/5
- [ ] US3705-AC05 性能：报告生成时间 < 3s
- [ ] US3705-AC06 权限：报告中不包含敏感信息
- [ ] US3705-AC07 回退：可自定义报告模板

---

## US-3706：双模式报告 - 机器完整

**用户故事**：作为开发者/运维，我希望报告包含完整数据，以便调试和审计。

### 范围
- In Scope：summary.json 包含完整事件流
- Out of Scope：实时流式输出

### 验收标准（7维）
- [ ] US3706-AC01 正向：`ptk report --machine` 输出 JSON 报告
- [ ] US3706-AC02 边界：包含 events、llm_prompts、token_usage、tool_calls
- [ ] US3706-AC03 错误：数据损坏时提示并提供修复建议
- [ ] US3706-AC04 反馈：JSON 符合 schema 规范
- [ ] US3706-AC05 性能：报告生成时间 < 5s
- [ ] US3706-AC06 权限：敏感字段可配置脱敏
- [ ] US3706-AC07 回退：可导出历史 run 的完整报告

---

## US-3707：开发模式切换

**用户故事**：作为开发者，我希望选择不同的运行模式，以便在调试/严格/演练场景使用合适的配置。

### 范围
- In Scope：normal/debug/strict/dry-run/replay 模式
- Out of Scope：云端远程调试

### 验收标准（7维）
- [ ] US3707-AC01 正向：`--mode normal` 标准执行生成基础报告
- [ ] US3707-AC02 边界：`--mode debug` 输出事件流可 tail
- [ ] US3707-AC03 错误：未知模式时提示可用模式列表
- [ ] US3707-AC04 反馈：模式切换即时生效
- [ ] US3707-AC05 性能：dry-run 跳过实际执行
- [ ] US3707-AC06 权限：replay 模式需确认权限
- [ ] US3707-AC07 回退：可中断并切换模式

---

## US-3708：记忆体增强 - scope-memory

**用户故事**：作为使用者，我希望范围偏差和确认状态被记录，以便追溯决策过程。

### 范围
- In Scope：deviations.json + confirmations.json
- Out of Scope：自动清理历史记录

### 验收标准（7维）
- [ ] US3708-AC01 正向：偏差记录自动写入 .ptk/memory/scope/
- [ ] US3708-AC02 边界：确认状态包含时间、选择、后续动作
- [ ] US3708-AC03 错误：写入失败时警告并提供手动修复
- [ ] US3708-AC04 反馈：可通过 `ptk recall` 查询
- [ ] US3708-AC05 性能：写入不影响执行性能
- [ ] US3708-AC06 权限：记录不包含敏感数据
- [ ] US3708-AC07 回退：可手动编辑记录

---

## US-3709：CLI 意图路由

**用户故事**：作为用户，我希望用自然语言表达意图时被准确路由到正确命令，以便减少命令行学习成本。

### 范围
- In Scope：关键词触发 + 置信度路由
- Out of Scope：完全语义理解

### 验收标准（7维）
- [ ] US3709-AC01 正向：`ptk 看看` 映射到 `ptk status --board`
- [ ] US3709-AC02 边界：置信度 < 0.45 时返回候选列表
- [ ] US3709-AC03 错误：无法解析时提示可用命令
- [ ] US3709-AC04 反馈：候选命令按置信度排序
- [ ] US3709-AC05 性能：路由决策 < 500ms
- [ ] US3709-AC06 权限：路由日志可选关闭
- [ ] US3709-AC07 回退：可禁用意图路由

---

## US-3710：ptk doctor 诊断

**用户故事**：作为运维人员，我希望运行环境问题能被自动诊断，以便快速定位修复。

### 范围
- In Scope：环境依赖、schema 一致性、事件完整性
- Out of Scope：自动修复

### 验收标准（7维）
- [ ] US3710-AC01 正向：`ptk doctor` 检测环境依赖
- [ ] US3710-AC02 边界：输出 PASS/WARN/FAIL 级别
- [ ] US3710-AC03 错误：无法诊断时明确标记为 UNKNOWN
- [ ] US3710-AC04 反馈：FAIL 时提供修复建议
- [ ] US3710-AC05 性能：完整诊断 < 10s
- [ ] US3710-AC06 权限：诊断日志可配置
- [ ] US3710-AC07 回退：可跳过非关键检查项

---

## 交叉引用

- PRD：`docs/product/v3.7.0/prd/ptk-cli-scope-guard.md`
- 测试用例：`docs/product/v3.7.0/qa/test-cases/ptk-cli-scope-guard.md`
- 执行边界：`docs/product/v3.7.0/execution/boundaries.md`
- 架构设计：`docs/product/v3.7.0/architecture/`
- 规划文档：`docs/plans/2026-02-28-ptk-cli-debug-reference-synthesis-v3.7.0.md`

---

## 冲突与未决问题

- 冲突：无 `critical/high` 未解决冲突
- 未决（非阻塞）：
  - OQ-3701：Scope Guard 的自动批准阈值是否可配置
  - OQ-3702：意图路由是否需要离线模型

## 交付语义

- Blocked 原因：当前无阻塞项
- Warn 风险：存在 2 项非阻塞未决，需要在实施排期中确认
