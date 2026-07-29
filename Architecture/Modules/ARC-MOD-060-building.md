---
id: ARC-MOD-060
type: architecture-module
status: proposed
depends_on:
  - ARC-MOD-000
  - ARC-MOD-040
  - ARC-MOD-050
updated: 2026-07-29
tags:
  - architecture/module
  - building
---

# ARC-MOD-060 — Building

[Module catalog](README.md) · [Building Contract](../Contracts/ARC-CON-060-building.md) ·
[TASK-070](../../Tasks/08-fence-building/TASK-070-fence-building.md)

## Responsibility

Own build-mode state, placement preview/validation, the atomic placement transaction,
and built-defense actors.

## Proposed Assets

```text
/Game/RisbackaJam26/Building/
├── BPC_BuildMode
├── BP_FenceBase
├── BP_FencePreview
└── DA_BuildableFence
```

## Public API

- [Building Contract](../Contracts/ARC-CON-060-building.md)
- [Resource Store](../Contracts/ARC-CON-040-resource-store.md)
- [Health & Damage](../Contracts/ARC-CON-020-health-damage.md) on placed fences

## Dependencies and Consumers

- Depends on contracts, resource store, and reusable health.
- Player forwards input to `BPC_BuildMode`.
- Enemy AI sees the fence only as a damageable blocker.
- Building must not cast to concrete wood storage or boar classes.

## Quality/Test Seam

Test the component on a disposable pawn with a fake store. Cover spatial rules,
preview teardown, exact/insufficient balance, two simultaneous requests, spawn failure,
and fence damage/navigation behavior.

## Feature Requirements

- [TASK-070](../../Tasks/08-fence-building/TASK-070-fence-building.md)
