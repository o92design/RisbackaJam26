---
id: ARC-MOD-000
type: architecture-module
status: proposed
depends_on: []
updated: 2026-07-29
tags:
  - architecture/module
  - contracts
---

# ARC-MOD-000 — Shared Contracts

[Module catalog](README.md) · [Contract catalog](../Contracts/README.md) ·
[ARCH-TASK-001](../Tasks/01-contracts/ARCH-TASK-001-contracts.md)

## Responsibility

Own the stable Blueprint types used across feature boundaries. It contains no game
loop, spawning, UI, or map behavior.

## Proposed Asset Area

```text
/Game/RisbackaJam26/Core/Contracts/
├── Interfaces/
├── Enums/
└── Structs/
```

## Owned Assets

- The interfaces, enums, and structs listed in
  [Public Contract Catalog](../Contracts/README.md).
- Contract-only test doubles below `/Game/RisbackaJam26/Tests/Architecture/Contracts`.

## Dependency Rules

- Depends on no gameplay module.
- Every other runtime module may depend on contracts.
- Contracts must not reference concrete home, boar, fence, storage, widget, or map
  classes.
- A changed contract requires search and verification of every linked consumer.

## Quality/Test Seam

Contract shells must compile before feature implementation. Test doubles prove that a
consumer accepts an interface implementation other than the production class.

## Feature Requirements

- [TASK-001](../../Tasks/01-foundation/TASK-001-foundation.md) creates the game-owned
  baseline after this module's shell and red-contract tests exist.
