---
id: ARC-MOD-050
type: architecture-module
status: proposed
depends_on:
  - ARC-MOD-000
  - ARC-MOD-040
updated: 2026-07-29
tags:
  - architecture/module
  - resources
  - interaction
---

# ARC-MOD-050 — Resources and Interaction

[Module catalog](README.md) ·
[Resource Store](../Contracts/ARC-CON-040-resource-store.md) ·
[Carry Interaction](../Contracts/ARC-CON-050-carry-interaction.md)

## Responsibility

Own wood production, pickup lifecycle, one-carrier ownership, deposit, and the shared
wood balance.

## Proposed Assets

```text
/Game/RisbackaJam26/Resources/
├── BP_WoodSource
├── BP_WoodPickup
├── BP_WoodStorage
└── BPC_CarryInteractor
```

`BP_Player_Risbacka` contains the component and only forwards interaction input.

## Public API

- [Resource Store](../Contracts/ARC-CON-040-resource-store.md)
- [Carry Interaction](../Contracts/ARC-CON-050-carry-interaction.md)
- Health/damage adapter for valid axe hits on `BP_WoodSource`

## Dependencies and Consumers

- Depends on shared contracts and the damage contract.
- Building spends through the store interface.
- HUD observes the balance.
- Resources does not reference fence classes, WaveDirector, GameMode, or widgets.

## Quality/Test Seam

Use a disposable carrier actor to test the component independently of the shared
player asset. Verify source depletion once, pickup count, carrier ownership, outside
drop, repeated storage overlap, exact deposit, and teardown during carry.

## Feature Requirements

- [TASK-040](../../Tasks/05-wood-loop/TASK-040-wood-loop.md)
- Provides the store required by
  [TASK-070](../../Tasks/08-fence-building/TASK-070-fence-building.md)
