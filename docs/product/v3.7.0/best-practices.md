# Product Toolkit v3.7.0 最佳实践指南

> 本文档整合 skills-best-practices 和 skill-creator 最佳实践，指导 PTK v3.7.0 的使用与开发。

---

## 1. Skill 开发规范（强制）

### 1.1 目录结构

```
product-toolkit/
├── SKILL.md                          # 主入口（<500行）
├── config/                           # 配置文件
├── scripts/                          # 公共脚本（Python/Bash）
├── references/                      # 公共参考文档
├── skills/
│   ├── workflow/
│   │   ├── SKILL.md                 # <300行，导航+步骤
│   │   ├── scripts/                 # 专用脚本
│   │   ├── references/             # 专用参考
│   │   └── assets/                  # 模板
│   ├── think/
│   ├── scope-guard/                 # v3.7.0 新增
│   │   ├── SKILL.md
│   │   ├── scripts/
│   │   │   ├── ac_parser.py
│   │   │   └── deviation_detector.py
│   │   ├── references/
│   │   │   └── ac-schema.md
│   │   └── assets/
│   │       ├── ac_scope.json.tmpl
│   │       └── confirmation_prompt.md
│   └── ... (其他 skills)
└── docs/
    └── product/
        └── v3.7.0/                  # 版本文档
```

### 1.2 Progressive Disclosure 原则

| 层级 | 内容 | 加载方式 |
|------|------|----------|
| **Metadata** | name + description (~100 words) | 始终在上下文 |
| **SKILL.md** | 核心流程 (<500 lines) | skill 触发时加载 |
| **Bundled Resources** | 详细内容（无限） | 按需加载 |

**关键规则**：
- SKILL.md 保持在 500 行以下
- 详细内容移至 `references/` 或 `assets/`
- 从 SKILL.md 明确引用文件，附上"何时读取"的指导

### 1.3 Frontmatter 优化

```yaml
---
name: workflow
description: "Run evidence-first product workflow (think→user-story→prd→test-case) with gate validation.
  Use when user wants to generate PRD, user stories, test cases, or run full product lifecycle.
  Don't use for code implementation, deployment, or technical architecture decisions."
---
```

**描述优化要点**：
- 使用第三人称
- 包含 **negative triggers**（明确何时不用）
- 1-64 字符 name（仅小写字母、数字、连字符）
- name 必须与父目录名完全匹配

---

## 2. 使用最佳实践

### 2.1 主入口选择

| 场景 | 推荐入口 | 说明 |
|------|----------|------|
| 完整产品工作流 | `/product-toolkit:workflow` | 产出 PRD/US/QA |
| 仅需求澄清 | `/product-toolkit:think` | vNext 批量问答 |
| 自动化测试 | `/product-toolkit:auto-test` | Web 端测试 |
| 门禁检查 | `/product-toolkit:gate` | 证据校验 |

### 2.2 CLI 统一入口（v3.7.0 新增）

```bash
# 状态查看
ptk status
ptk status --board

# 运行工作流
ptk run workflow
ptk run workflow --mode strict    # 启用 Scope Guard

# 调试
ptk debug watch <run_id>
ptk doctor

# 报告
ptk report --human <run_id>      # 人类友好
ptk report --machine <run_id>     # 机器完整

# 恢复
ptk resume <run_id>
```

### 2.3 Scope Guard 使用

**strict 模式**（推荐生产使用）：
```bash
ptk run workflow --mode strict
```

Scope Guard 会：
1. 执行前解析 user-story.md 的 AC
2. 监控 LLM 实现是否超出 AC 范围
3. 低风险优化自动标记到总结
4. 高风险/大改动暂停并请求确认

### 2.4 双模式报告

**人类友好**（默认）：
```bash
ptk report --human latest
```
输出：`summary.md`（简洁、屏蔽机器信息）

**机器完整**：
```bash
ptk report --machine latest
```
输出：`summary.json`（完整事件流、调试信息）

### 2.5 LLM 预测下一步多选（v3.7.0 核心）

**每个 skill/阶段完成后，LLM 必须预测下一步并提供多选**：

```markdown
## 👆 下一步建议（LLM 预测）

基于当前状态，推荐以下操作：

[A] 继续生成测试用例（推荐）
[B] 先执行 gate 检查
[C] 调整用户故事范围
[D] 直接进入实现阶段

请选择 [A/B/C/D] 或输入其他指令
```

**多选原则**：
1. 至少 2-3 个选项
2. 标注推荐选项
3. 最后允许用户自定义
4. 按相关性排序

**阶段推荐示例**：

| 当前阶段 | 推荐选项 |
|----------|----------|
| think 完成后 | [A] 生成用户故事 / [B] 补充更多问题 / [C] 直接进入 PRD |
| user-story 完成后 | [A] 生成 PRD / [B] 调整故事范围 / [C] 生成测试用例 |
| test-case 完成后 | [A] 执行 gate 检查 / [B] 运行自动化测试 / [C] 直接进入实现 |
| gate Blocked 后 | [A] 查看阻塞原因 / [B] 调整需求 / [C] 申请人工审批 |

### 2.6 工作生命周期

```
用户需求 → think → version → user-story → prd → test-case → implementation → gate → release
                                              ↑                              ↓
                                        版本规划                      热修复/迭代
```

**用户介入点**：think/version/user-story/gate/release 各阶段可调整

### 2.7 证据链规范（v3.7.0 核心）

**基于现有实现**：
- `scripts/evidence_integrity_common.py` - SHA256、模板检测
- `scripts/build_evidence_manifest.py` - 证据清单
- `scripts/validate_terminal_artifacts.py` - 终端校验

**全阶段证据**：

| 阶段 | 必需证据 | 校验 |
|------|----------|------|
| think | 对话记录.json、问题清单.json | 格式校验 |
| version | 版本分析.md、version.json | 版本链校验 |
| user-story | user-story.md、ac_scope.json | AC 完整性 |
| prd | prd.md、boundaries.md | 冲突检测 |
| test-case | test-cases.md、AC映射.json | TC 覆盖 |
| implementation | 代码、单元测试 | 测试通过 |
| gate | terminal.json、evidence-manifest.json | 证据完整 |

**证据防伪校验**（v3.7.0 新增）：
- 占位符检测：`<placeholder>` 未替换 → 警告
- 重复率检测：Ctrl+C/V 复制 → 警告
- 长度检测：内容过短 → 警告

**证据质量预测**：
```markdown
## 证据质量评估

| 指标 | 得分 | 置信度 |
|------|------|--------|
| 完整性 | 85% | 高 |
| 一致性 | 90% | 高 |
| 可验证性 | 70% | 中 |

⚠️ 风险提示：...
```

---

## 3. Skill 创建流程（参考 skill-creator）

### 3.1 捕获意图

在创建新 skill 前，明确：
1. 这个 skill 让 Claude 做什么？
2. 何时触发？（用户短语/上下文）
3. 期望的输出格式是什么？
4. 是否需要测试用例？

### 3.2 编写 SKILL.md

**模板**：
```markdown
---
name: <skill-name>
description: "<trigger description with negative triggers>"
---

# <Skill Title>

## When to Use

Use this skill when [specific contexts]. Don't use for [edge cases].

## Steps

1. [Step 1]
2. [Step 2]
3. ...

## Output Format

Always use this template:
# [Title]
## Summary
## Details
```

### 3.3 测试与评估

1. **创建测试用例**（保存至 `evals/evals.json`）：
```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "User's task prompt",
      "expected_output": "Description of expected result",
      "files": []
    }
  ]
}
```

2. **运行测试**：
   - 带 skill 运行 vs 不带 skill 运行（baseline）
   - 记录 tokens、duration

3. **评估改进**：
   - 定性：用户反馈
   - 定量：通过率、耗时、token 消耗

---

## 4. Skill 描述优化（Trigger Eval）

### 4.1 生成测试查询

创建 20 个测试查询（8-10 should-trigger, 8-10 should-not-trigger）：

**should-trigger 示例**：
- `"帮我生成电商收藏功能的用户故事和测试用例"`

**should-not-trigger 示例**：
- `"帮我写一个 Python 爬虫"`（不应触发 workflow）

### 4.2 优化描述

使用 skill-creator 的 `run_loop.py` 优化触发准确率：
```bash
python -m scripts.run_loop \
  --eval-set trigger-eval.json \
  --skill-path skills/workflow \
  --model claude-opus-4-6 \
  --max-iterations 5
```

---

## 5. 常见模式

### 5.1 固定下一步（workflow 产物）

workflow 完成后，提供固定提示词模板：

**OMC 模板**：
```markdown
请根据以下产物执行：
- PRD: docs/product/v1.0.0/prd/xxx.md
- User Story: docs/product/v1.0.0/user-story/xxx.md
- Test Cases: docs/product/v1.0.0/qa/test-cases/xxx.md
- Boundaries: docs/product/v1.0.0/execution/boundaries.md
```

### 5.2 Gate 验证

使用 strict 模式确保质量：
```bash
./scripts/workflow_gate_autorun.sh \
  --version v1.0.0 \
  --terminal docs/product/v1.0.0/execution/terminal.json
```

### 5.3 记忆体使用

| 类型 | 路径 | 用途 |
|------|------|------|
| project-memory | `.ptk/memory/project-memory.json` | 长期约束 |
| session-memory | `.ptk/memory/sessions/<id>.json` | 本轮上下文 |
| failure-memory | `.ptk/memory/failures/` | 失败记录 |
| scope-memory | `.ptk/memory/scope/` | v3.7.0 范围偏差 |

---

## 6. 目录速查

| 路径 | 说明 |
|------|------|
| `skills/workflow/SKILL.md` | 主工作流 |
| `skills/think/SKILL.md` | 产品思考 |
| `skills/auto-test/SKILL.md` | 自动化测试 |
| `skills/gate/SKILL.md` | 门禁检查 |
| `scripts/ptk_cli.py` | v3.7.0 CLI 入口 |
| `scripts/scope_guard/` | Scope Guard 模块 |
| `config/scope-guard.yaml` | Scope Guard 配置 |
| `docs/product/v3.7.0/` | v3.7.0 版本文档 |

---

## 7. 参考资料

- **Skill 开发规范**：`skills-best-practices/README.md`
- **Skill 创建流程**：`skills/skills/skill-creator/SKILL.md`
- **v3.7.0 规划**：`docs/plans/2026-02-28-ptk-cli-debug-reference-synthesis-v3.7.0.md`
- **v3.7.0 PRD**：`docs/product/v3.7.0/prd/ptk-cli-scope-guard.md`
- **v3.7.0 用户故事**：`docs/product/v3.7.0/user-story/ptk-cli-scope-guard.md`
