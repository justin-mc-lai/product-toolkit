---
name: product-toolkit
description: 通用产品经理工具集 - 支持产品思考、PRD/用户故事/测试用例、UI/技术方案与一键工作流
---

# Product Toolkit v3.0.0

[PRODUCT TOOLKIT ACTIVATED]

## 子命令

| 命令 | 功能 | 输出文件 |
|------|------|---------|
| `/product-toolkit` | 主工具集 | - |
| `/product-toolkit:init` | 初始化配置 | `docs/product/config.yaml` |
| `/product-toolkit:workflow` | 一键产品工作流 | `docs/product/{version}/` |
| `/product-toolkit:think` | 产品思考（5轮追问） | 作为后续命令输入 |
| `/product-toolkit:brainstorm` | 发散思维 | `docs/product/{version}/SUMMARY.md` |
| `/product-toolkit:design` | Design Thinking | `docs/product/{version}/design/` |
| `/product-toolkit:jtbd` | JTBD 分析 | `docs/product/{version}/SUMMARY.md` |
| `/product-toolkit:version` | 版本规划 | `docs/product/{version}/SUMMARY.md` |
| `/product-toolkit:wireframe` | 草稿图/线框图 | `docs/product/{version}/design/wireframe/{feature}.md` |
| `/product-toolkit:ui-spec` | UI 设计规范 | `docs/product/{version}/design/spec/{feature}.md` |
| `/product-toolkit:user-story` | 生成用户故事 | `docs/product/{version}/user-story/{feature}.md` |
| `/product-toolkit:prd` | 生成 PRD | `docs/product/prd/{feature}.md` |
| `/product-toolkit:test-case` | 生成测试用例（含 UI 可视化测试门槛） | `docs/product/{version}/qa/test-cases/{feature}.md` |
| `/product-toolkit:api-design` | API 设计 | `docs/product/{version}/tech/api/{feature}.md` |
| `/product-toolkit:data-dictionary` | 数据字典 | `docs/product/{version}/tech/data-model/{feature}.md` |
| `/product-toolkit:moscow` | MoSCoW 优先级 | `docs/product/{version}/SUMMARY.md` |
| `/product-toolkit:kano` | KANO 模型分析 | `docs/product/{version}/SUMMARY.md` |
| `/product-toolkit:persona` | 用户画像 | `docs/product/personas/{name}.md` |
| `/product-toolkit:roadmap` | 产品路线图 | `docs/product/roadmap.md` |
| `/product-toolkit:release` | 上线检查 | `docs/product/release/v{version}.md` |
| `/product-toolkit:analyze` | 竞品分析 | `docs/product/competitors/{name}.md` |
| `/product-toolkit:team` | 多代理协作 | `docs/product/{version}/` |

## 输出目录

工作流模式输出到 `docs/product/{version}/`：

```
docs/product/{version}/
├── SUMMARY.md
├── prd/
├── user-story/
├── design/wireframe/
├── design/spec/
├── qa/test-cases/
├── tech/api/
└── tech/data-model/
```

## 功能概览

- 一键工作流（场景路由 + 自动编排）
- 用户故事生成（7维度验收标准，含权限与逆向流程）
- PRD 编写（完整/快速模板）
- 测试用例生成（自动从验收标准产出）
- Web UI 可视化测试门槛（agent-browser/browser-use + 登录 + 截图 + Console + API 200）
- 技术方案（API + 数据字典）
- 需求优先级（MoSCoW / KANO）
- 用户画像生成
- 产品路线图
- 上线检查清单
- 竞品分析
- 多代理协作

## UI 可视化测试强制要求（适用于 Web 前端）

- 使用 `agent-browser` 或 `browser-use` 执行浏览器测试。
- 从登录流程开始验证，并记录所用测试账号/角色（仅可由用户提供）。
- 对关键步骤截图，验证数据绑定和页面排版。
- 检查 Console 无未处理错误。
- 检查关键接口请求状态为 HTTP 200。
- 输出 AC→TC 覆盖矩阵，确认用户故事验收标准全覆盖。
- 凭据仅可由用户提供并脱敏记录，禁止在仓库中写入明文账号密码。

> 任一项缺失时，测试结论必须标记为 `Blocked` 或不可交付。

## 快速开始

```
/product-toolkit:workflow 用户登录功能
/product-toolkit:prd 用户登录
/product-toolkit:test-case 用户登录
```

---

*持续迭代更新，统一输出到 docs/product/{version}/ 目录*
