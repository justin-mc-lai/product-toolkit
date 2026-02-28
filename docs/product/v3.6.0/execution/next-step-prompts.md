# OMC / OMX 下一步固定提示词模板

> 说明：以下是 workflow 完成后可直接复制的“下一步提示词”。
> 不新增用户命令，只是标准化输入内容。

---

## 1) OMX 模板（长任务自迭代）

```text
请基于以下 PTK workflow 产物执行长任务自迭代，直到形成可审计终态：

- PRD: {PRD_PATH}
- User Story: {USER_STORY_PATH}
- Test Cases: {TEST_CASE_PATH}
- Boundaries: {BOUNDARIES_PATH}
- Architecture/System: {ARCH_SYSTEM_CONTEXT_PATH}
- Responsibility Boundaries: {ARCH_RESPONSIBILITY_PATH}
- API Contracts: {ARCH_CONTRACT_PATH}
- NFR Budgets: {ARCH_NFR_PATH}
- Terminal 输出路径: {TERMINAL_JSON_PATH}

执行要求：
1) 严格按 boundaries.md 判定 In/Out Scope。
2) 以 AC→TC→Evidence 追溯为核心，缺证据不得判 Pass。
3) 若命中 Blocked 条件，terminal.status=Blocked，并写入 reason_codes。
4) 完成时必须输出 terminal.json（含 traceability 与 evidence 引用）。
5) 不新增任务范围，不改写用户未授权需求。
6) OMC/OMX 是可选执行器，不得覆盖 PTK 已定义的职责边界。
7) 必须留存 raw command log（jsonl），记录 cmd/cwd/started_at/ended_at/exit_code。
8) 必须输出 sha256 manifest，覆盖 terminal 引用的关键证据文件。
9) 必须输出 gate consistency report，确保 terminal 与 architecture 文档结论一致。
10) terminal 写入后必须执行：
    `./scripts/workflow_gate_autorun.sh --version {VERSION} --terminal {TERMINAL_JSON_PATH}`
```

---

## 2) OMC 模板（长任务自迭代）

```text
请读取以下 PTK workflow 产物，进入长任务循环执行，直到测试用例验证结束并输出终态证据：

- PRD: {PRD_PATH}
- User Story: {USER_STORY_PATH}
- Test Cases: {TEST_CASE_PATH}
- Boundaries: {BOUNDARIES_PATH}
- Architecture/System: {ARCH_SYSTEM_CONTEXT_PATH}
- Responsibility Boundaries: {ARCH_RESPONSIBILITY_PATH}
- API Contracts: {ARCH_CONTRACT_PATH}
- NFR Budgets: {ARCH_NFR_PATH}
- Terminal 输出路径: {TERMINAL_JSON_PATH}

循环规则：
1) 先校验输入完整性；缺关键物料直接 Blocked。
2) 每轮聚焦“未通过 AC 对应 TC”，补齐证据后再推进。
3) 达到迭代上限仍未满足 Done 边界，输出 Blocked。
4) 最终只允许 Pass / Blocked / Cancelled。
5) 结束前写出 terminal.json，确保可追溯。
6) 执行引擎为可选项，不能改变 PTK 的生命周期规划与架构治理规则。
7) 同步写出 raw command log（jsonl）并回填到 terminal.evidence_integrity。
8) 使用 sha256 manifest 固定证据哈希，避免执行结果可篡改。
9) 执行 gate consistency 校验并输出报告后再判定终态。
10) terminal 写入后必须执行：
    `./scripts/workflow_gate_autorun.sh --version {VERSION} --terminal {TERMINAL_JSON_PATH}`
```

---

## 3) 变量替换建议

- `{PRD_PATH}`: `docs/product/{version}/prd/{feature}.md`
- `{VERSION}`: `vX.Y.Z`
- `{USER_STORY_PATH}`: `docs/product/{version}/user-story/{feature}.md`
- `{TEST_CASE_PATH}`: `docs/product/{version}/qa/test-cases/{feature}.md`
- `{BOUNDARIES_PATH}`: `docs/product/{version}/execution/boundaries.md`
- `{ARCH_SYSTEM_CONTEXT_PATH}`: `docs/product/{version}/architecture/system-context.md`
- `{ARCH_RESPONSIBILITY_PATH}`: `docs/product/{version}/architecture/responsibility-boundaries.md`
- `{ARCH_CONTRACT_PATH}`: `docs/product/{version}/architecture/api-contracts.md`
- `{ARCH_NFR_PATH}`: `docs/product/{version}/architecture/nfr-budgets.md`
- `{TERMINAL_JSON_PATH}`: `docs/product/{version}/execution/terminal.json`
- `{RAW_COMMAND_LOG_PATH}`: `docs/product/{version}/execution/raw-command-log.jsonl`
- `{EVIDENCE_MANIFEST_PATH}`: `docs/product/{version}/execution/evidence-manifest.json`
- `{GATE_CONSISTENCY_REPORT_PATH}`: `docs/product/{version}/execution/gate-consistency-report.json`
