---
name: auto-test
description: Run automated Web tests with frontend startup, prioritized tool selection (agent-browser/browser-use), and persistent test learnings
---

# 自动化测试 (auto-test)

运行 Web 端自动化测试，支持：

1. 启动前端项目并等待可访问
2. 按优先级选择浏览器工具（`agent-browser` → `browser-use`）
3. 保存失败踩坑记忆，避免重复踩坑
4. 优先使用 **agent-browser CLI 原生命令**（`open/snapshot/screenshot/errors`）做可验证测试

## 使用方式

```bash
/product-toolkit:auto-test v1.0.0 -f 电商收藏功能
/product-toolkit:auto-test --version v1.0.0 --feature 登录功能 --type smoke
```

## 参数

| 参数 | 简写 | 说明 | 必需 |
|------|------|------|------|
| `--version` | `-v` | 产品版本 | 是 |
| `--feature` | `-f` | 功能名称 | 是 |
| `--type` | `-t` | 测试类型: smoke/regression/full | 否 (默认: full) |
| `--iterations` | `-i` | 最大迭代次数 | 否 (默认: 3) |
| `--test-file` | - | 自定义测试用例文件路径 | 否 |
| `--tool` | - | 指定工具: auto/agent-browser/browser-use | 否 (默认: auto) |
| `--tool-priority` | - | 工具优先级列表（逗号分隔） | 否 (默认: agent-browser,browser-use) |
| `--headed` | - | 可视化浏览器窗口模式（主要用于 agent-browser） | 否 |
| `--frontend-cmd` | - | 测试前启动前端命令（如 `pnpm dev`） | 否 |
| `--frontend-dir` | - | 前端启动目录 | 否 (默认: 项目根目录) |
| `--frontend-url` | - | 启动后健康检查 URL / 测试基准 URL | 否 (默认: `http://localhost:3000`) |
| `--frontend-timeout` | - | 前端启动等待秒数 | 否 (默认: 120) |
| `--no-frontend-auto-detect` | - | 禁用 package.json 自动识别前端启动命令与端口 | 否 |
| `--no-frontend-start` | - | 禁止启动前端（仅测试已运行环境） | 否 |
| `--memory-file` | - | 自定义测试记忆文件路径 | 否 |
| `--dry-run` | - | 模拟运行，不执行实际测试 | 否 |

## 测试类型

| 类型 | 说明 | 用途 |
|------|------|------|
| smoke | 冒烟测试 | 核心路径，P0 级别，必须通过 |
| regression | 回归测试 | 已有功能验证 |
| full | 完整测试 | 全面测试 |

## 示例

```bash
# 运行完整测试
/product-toolkit:auto-test v1.0.0 -f 电商收藏功能

# 运行冒烟测试
/product-toolkit:auto-test v1.0.0 -f 登录功能 -t smoke

# 模拟运行查看执行计划
/product-toolkit:auto-test v1.0.0 -f 用户中心 --dry-run

# 自定义测试用例文件
/product-toolkit:auto-test v1.0.0 -f 支付功能 --test-file /path/to/test-cases.md

# 启动前端后再执行测试
/product-toolkit:auto-test v1.0.0 -f 登录功能 \
  --frontend-cmd "pnpm dev" \
  --frontend-dir ./apps/web \
  --frontend-url http://127.0.0.1:5173

# 自动识别 frontend 命令与端口（基于 package.json）
/product-toolkit:auto-test v1.0.0 -f 登录功能 \
  --frontend-dir ./apps/web

# 指定工具优先级
/product-toolkit:auto-test v1.0.0 -f 收藏功能 \
  --tool-priority agent-browser,browser-use
```

## 魔法关键词

使用 `ptk auto-test` 触发：

```bash
ptk auto-test v1.0.0 -f 电商收藏功能
ptk auto-test v1.0.0 -f 登录功能 -t smoke
```

## 测试流程

1. **读取历史踩坑记忆**：从 `.ptk/memory/test-learnings.json` 提示风险
2. **（可选）自动识别前端配置**：从 `package.json` 推断启动命令与端口
3. **（可选）启动前端**：执行 `--frontend-cmd`（显式或自动识别）并等待 `--frontend-url`
4. **选择自动化工具**：按 `--tool-priority` 选择首个可用工具
5. **服务可达性验证**：用选中的 CLI 工具先验证基准 URL 可访问
6. **解析测试用例**：从 test-case 文档提取 `SMK-/TC-` 用例并映射目标 URL
7. **执行测试并重试**：失败可按 `--iterations` 继续重跑
8. **收集证据**：按用例输出日志、截图、快照/错误信息
9. **写入进度与记忆**：更新 `.ptk/state/test-progress.json` + 失败记忆
10. **生成汇总报告**

## agent-browser CLI 执行基线（参考 test-browser 命令实践）

核心验证步骤（每个用例）：

```bash
agent-browser open http://localhost:3000/xxx
agent-browser snapshot -i --json
agent-browser screenshot out.png
agent-browser errors
```

> 该流程与 `compound-engineering` 的 `test-browser` 命令思路一致：直接使用 CLI 做浏览器验证，而非抽象伪命令。

并借鉴 `test-xcode` 的前置校验思路：在执行用例前先做“环境可用性检查”（服务可达、工具可用），失败即提前终止并提示修复动作。

## 测试用例位置

自动查找测试用例文件（按优先级）：

1. `docs/product/{version}/qa/test-cases/{feature}.md`
2. `docs/product/test-cases/{feature}.md`
3. `docs/product/{version}/test-cases/{feature}.md`
4. `--test-file` 指定的自定义路径

## 证据收集

测试执行后，证据保存在：

```
.ptk/evidence/{version}/{feature}/
├── screenshots/     # 测试截图
├── frontend-startup.log       # 前端启动日志（若启用）
├── snapshot-<case>-iter<n>.json # agent-browser 快照
├── errors-<case>-iter<n>.log    # 页面错误输出
├── state-<case>-iter<n>.txt     # browser-use 页面状态
└── <case>-iter<n>.log         # 每轮执行日志
```

测试记忆文件：

```
.ptk/memory/test-learnings.json
```

记录项包含：`feature`、`test_case`、`signature`、`suggestion`、`count`、`first_seen/last_seen`。

## 输出示例

```
========================================
Test Report: v1.0.0 - 电商收藏功能
========================================
Tool:          agent-browser
Test Type:     full
Total Cases:   10
Passed:        9
Failed:        1
Coverage:      90%
Status:        failed
Evidence Dir:  .ptk/evidence/v1.0.0/电商收藏功能/
Memory File:   .ptk/memory/test-learnings.json
```

## 依赖

- **agent-browser CLI**: 首选浏览器自动化命令行工具
- **browser-use CLI**: 备选命令行工具（按优先级降级）

## 相关技能

- `/product-toolkit:test-case` - 生成测试用例
- `/product-toolkit:test-progress` - 查看测试进度
- `/product-toolkit:gate` - 门控检查
