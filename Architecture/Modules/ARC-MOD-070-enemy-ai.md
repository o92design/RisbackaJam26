---
id: ARC-MOD-070
type: architecture-module
status: proposed
depends_on:
  - ARC-MOD-000
  - ARC-MOD-040
updated: 2026-07-29
tags:
  - architecture/module
  - ai
---

# ARC-MOD-070 — Enemy AI

[Module catalog](README.md) ·
[Objective Targeting](../Contracts/ARC-CON-030-objective-targeting.md) ·
[Wave Accounting](../Contracts/ARC-CON-070-wave-accounting.md)

## Responsibility

Own placeholder boar movement, objective selection from supplied references, blocker
attacks, player damage reception, and one completion report.

## Proposed Assets

```text
/Game/RisbackaJam26/Enemies/
├── BP_BoarPlaceholder
├── BP_AIController_Boar
├── ST_BoarObjective
└── StateTreeTasks/
```

Assets may be duplicated from the Combat template, but template originals remain
unchanged.

## Public API

- [Health & Damage](../Contracts/ARC-CON-020-health-damage.md)
- [Objective Targeting](../Contracts/ARC-CON-030-objective-targeting.md)
- [Wave Accounting](../Contracts/ARC-CON-070-wave-accounting.md)
- `AssignPrimaryObjective(Objective)` during spawn/configuration

## Dependencies and Consumers

- Depends on shared contracts and reusable health.
- WaveDirector supplies spawn configuration but does not control AI decisions.
- Objective and blockers know nothing about boar classes.
- AI does not call GameMode, HUD, cycle, or world searches for targets.

## Quality/Test Seam

Dedicated navmesh fixtures cover open route, blocked route, destroyed target, missing
target, five repeated attempts, player axe death, and exactly one wave-completion
report.

## Feature Requirements

- [TASK-050](../../Tasks/06-boar-ai/TASK-050-boar-ai.md)
