# v3.6.0 交付报告（Evidence-First）

**日期**: 2026-02-27  
**状态**: Delivered (Docs/Contracts Layer)

## 1) 交付内容

### 1.1 核心入口与契约更新

- `SKILL.md`：升级到 v3.6.0，声明 workflow 默认主路径，bridge 兼容路径
- `commands/product-toolkit.md`：重写为 v3.6.0 命令契约
- `README.md`：补充项目整体说明（全局能力地图）+ v3.6.0 默认执行路径
- `skills/workflow/SKILL.md`：改为 evidence-first 核心产物链
- `skills/work/SKILL.md`：与 workflow 语义对齐
- `skills/gate/SKILL.md`：补充 evidence-first 强校验与标准 reason codes
- `scripts/validate_terminal_artifacts.py`：新增终态证据校验脚本（可执行）
- `scripts/check_terminal_artifacts.sh`：新增最小可执行回归脚本（release=Pass / blocked=Blocked）

### 1.2 v3.6.0 产品文档产物

- PRD: `docs/product/v3.6.0/prd/workflow-evidence-first.md`
- 用户故事: `docs/product/v3.6.0/user-story/workflow-evidence-first.md`
- 测试用例: `docs/product/v3.6.0/qa/test-cases/workflow-evidence-first.md`
- 边界模板: `docs/product/v3.6.0/execution/boundaries.md`
- 终态模板: `docs/product/v3.6.0/execution/terminal.json`
- 终态样例: `docs/product/v3.6.0/execution/terminal.release-sample.json`
- 阻塞样例: `docs/product/v3.6.0/execution/terminal.blocked-sample.json`
- 架构索引: `docs/product/v3.6.0/architecture/README.md`
- 系统上下文: `docs/product/v3.6.0/architecture/system-context.md`
- 职责边界: `docs/product/v3.6.0/architecture/responsibility-boundaries.md`
- 契约清单: `docs/product/v3.6.0/architecture/api-contracts.md`
- NFR 预算: `docs/product/v3.6.0/architecture/nfr-budgets.md`
- ADR 索引: `docs/product/v3.6.0/architecture/adr-index.md`
- 架构 gate 清单: `docs/product/v3.6.0/execution/gate-architecture-checklist.md`
- 阻塞演练清单: `docs/product/v3.6.0/execution/blocked-drill-checklist.md`
- 阻塞演练结果: `docs/product/v3.6.0/execution/blocked-drill-result.md` / `docs/product/v3.6.0/execution/blocked-drill-result.json`
- 修复复审报告: `docs/product/v3.6.0/execution/review-v3.6.0-fix-report.md`
- reason-code 对照（同步）：`README.md` + `docs/product/v3.6.0/execution/review-v3.6.0-fix-report.md`
- Team 运行日志摘录: `docs/product/v3.6.0/execution/team-run-log.md`
- 下一步模板: `docs/product/v3.6.0/execution/next-step-prompts.md`
- 差距分析: `docs/product/v3.6.0/prd/current-version-gap-analysis.md`

## 2) 验证证据（命令）

1. 核心文档关键词校验
   - `rg -n "Product Toolkit v3.6.0|\*\*版本\*\*: v3.6.0" SKILL.md`
2. workflow 主路径与兼容路径校验
   - `rg -n "核心产物链|兼容/高级路径|不新增用户命令" skills/workflow/SKILL.md`
3. 命令契约校验
   - `rg -n "v3.6.0|兼容保留|workflow 主路径聚焦" commands/product-toolkit.md`
4. 文档索引与产物路径校验
   - `find docs/product/v3.6.0 -maxdepth 4 -type f | sort`
5. 终态证据脚本校验
   - `python3 scripts/validate_terminal_artifacts.py --version v3.6.0 --terminal docs/product/v3.6.0/execution/terminal.release-sample.json --pretty`

## 3) 结论

- workflow 默认主路径：已落实
- 用户零新增命令：已落实
- bridge 降级为兼容路径：已落实
- v3.6.0 PRD/US/QA/Execution 产物：已落盘并交叉索引
- OMC/OMX 可选执行器且非入侵 PTK 生命周期规划：已落实
- 架构治理与职责边界标准模板 + gate 检查清单：已落实
