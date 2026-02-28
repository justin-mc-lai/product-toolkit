# v3.6.0 修复后复审报告

**日期**: 2026-02-27  
**范围**: v3.6.0 evidence-first 文档契约与 gate 证据校验能力

## 1) 复审结论

- CRITICAL: 0
- HIGH: 0
- MEDIUM: 0
- LOW: 2（非阻塞）

**推荐结论**: APPROVE（可交付）

## 2) 已完成热修复

1. 统一 terminal schema 字段命名：
   - 使用 `terminal.status`
   - 使用顶层 `traceability`
2. Gate 增加 evidence-first 校验规则与 reason codes 文档化。
3. 新增可执行校验器：
   - `scripts/validate_terminal_artifacts.py`
   - `scripts/check_terminal_artifacts.sh`
4. 样例证据路径统一为仓库相对路径（去除 `product-toolkit/` 前缀混用）。
5. 状态语义统一为 `Delivered (Docs/Contracts Layer)`。

## 3) 关键验证

- `python3 -m py_compile scripts/validate_terminal_artifacts.py` => Pass
- `./scripts/check_terminal_artifacts.sh --version v3.6.0` => Pass
  - release sample => Pass（exit 0）
  - blocked sample => Blocked（exit 2）
- architecture 产物存在性 => Pass（`missing_architecture_artifacts=[]`）
- blocked sample 架构阻塞项可识别 => Pass（`ownership_boundary_unclear/api_contract_drift/nfr_budget_unproven`）
- `rg -n "product-toolkit/" docs/product/v3.6.0 -S` => 无结果（路径风格一致）
- v3.6.0 JSON 文件校验 => 全部合法
- skills frontmatter YAML 校验 => 全部合法

## 4) 常见 reason code 对照（与 README 同步）

| reason_code | 常见原因 | 建议修复动作 |
|---|---|---|
| `boundaries_missing` | 缺少 `execution/boundaries.md` | 补齐边界模板并确认 In/Out Scope、Done、Blocked 条件 |
| `boundaries_schema_invalid` | boundaries 关键章节缺失 | 补齐章节：In Scope / Out of Scope / Done / Blocked / 输出产物 |
| `terminal_artifact_missing` | 缺少 `execution/terminal.json` 或指定终态文件 | 先生成终态文件，再执行 gate 校验 |
| `terminal_schema_invalid` | terminal 结构不合法（字段缺失/类型错误） | 按 `execution/terminal.json` 模板对齐字段与类型 |
| `terminal_status_invalid` | `terminal.status` 非 `Pass/Blocked/Cancelled` | 修正为合法终态值 |
| `blocking_open_question_exists` | 仍有 blocking 未决项未关闭 | 在 next_round 中关闭/降级该问题，再重跑校验 |
| `ac_tc_mapping_gap` | 存在 AC 未映射 TC（如 `tc_ids` 为空） | 补齐 AC→TC 映射并更新 traceability |
| `terminal_evidence_missing` | evidence 引用路径不存在 | 修正或补齐被引用的报告/日志/证据文件 |
| `evidence_ref_path_style_inconsistent` | 证据路径风格不一致 | 统一为仓库相对路径（推荐 `docs/...` 或项目根相对路径） |
| `arch_artifact_missing` | 缺少 architecture 关键文档 | 补齐 `architecture/system-context/responsibility/contracts/nfr/adr` |
| `ownership_boundary_unclear` | 职责边界未确认或越权 | 更新 `responsibility-boundaries.md` 并在 terminal 回填确认 |
| `api_contract_drift` | 存在未解决契约漂移 | 在 `api-contracts.md` 标记修复/接受，并补证据 |
| `nfr_budget_unproven` | 关键 NFR 无法证明达标 | 在 `nfr-budgets.md` 补齐测量证据或降级为 Blocked |

## 5) 非阻塞建议（LOW）

1. 将 `validate_terminal_artifacts.py` 在未来版本接入真实 `/product-toolkit:gate` 执行器默认流程（当前已提供可执行脚本与规范）。
2. 将 reason-code 字典进一步沉淀到独立 schema 文件，便于统计分析。
