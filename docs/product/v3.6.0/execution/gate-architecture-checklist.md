# Gate 新增检查项清单（架构治理）

> 目的：在不新增用户命令的前提下，把“架构一致性”纳入 v3.6.0 交付 gate。

## 1) 文档存在性（Artifact Presence）

- [ ] `docs/product/{version}/architecture/system-context.md` 存在
- [ ] `docs/product/{version}/architecture/responsibility-boundaries.md` 存在
- [ ] `docs/product/{version}/architecture/api-contracts.md` 存在
- [ ] `docs/product/{version}/architecture/nfr-budgets.md` 存在
- [ ] `docs/product/{version}/architecture/adr-index.md` 存在

## 2) 职责边界（Ownership Boundary）

- [ ] `responsibility-boundaries.md` 明确 PTK / 架构负责人 / OMC/OMX / QA 分工
- [ ] 存在 RACI 矩阵
- [ ] 非入侵规则明确（执行器不改写 PTK 规划边界）

## 3) 契约一致性（Contract Consistency）

- [ ] `api-contracts.md` 有契约清单
- [ ] 漂移项（drift）均有状态与证据
- [ ] open 的 high-risk drift 不得判 Pass

## 4) NFR 预算（Budget Proof）

- [ ] `nfr-budgets.md` 明确关键指标预算
- [ ] 每项 NFR 有测量方式与证据路径
- [ ] Must 范围内不存在 `unproven/blocked` 的关键 NFR

## 5) 终态联动（terminal.json）

- [ ] `architecture_governance.ownership_boundaries_confirmed = true`
- [ ] `architecture_governance.api_contract_drift` 无未解决高风险项
- [ ] `architecture_governance.nfr_budget_unproven` 为空

## 6) 推荐 reason codes

- `arch_artifact_missing`
- `ownership_boundary_unclear`
- `api_contract_drift`
- `nfr_budget_unproven`

