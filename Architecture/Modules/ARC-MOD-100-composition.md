---
id: ARC-MOD-100
type: architecture-module
status: proposed
depends_on:
  - ARC-MOD-000
  - ARC-MOD-010
updated: 2026-07-29
tags:
  - architecture/module
  - composition
---

# ARC-MOD-100 — World Composition

[Module catalog](README.md) ·
[Initialization Contract](../Contracts/ARC-CON-001-initialization.md) ·
[TASK-090](../../Tasks/10-integration/TASK-090-integration.md)

## Responsibility

Own the explicit references and initialization order that join independently tested
modules in the prototype map.

## Proposed Asset

```text
/Game/RisbackaJam26/Core/BP_RisbackaWorldBootstrap
```

The actor is placed exactly once in `L_Risbacka_Prototype` and has editable references
to the run coordinator, camera/bounds, cycle manager, home, storage, wave director,
spawn points, and any required HUD source owner.

## Initialization Order

1. Validate exactly one bootstrap and every required reference.
2. Initialize contracts and passive state owners.
3. Initialize camera and register local players.
4. Initialize cycle, resources, health/objective, and waves.
5. Bind cross-module events once.
6. Initialize the shared HUD.
7. Mark Runtime `Ready`; only then allow `StartRun`.

## Dependency Rules

- This is the only module allowed concrete top-level references to all modules.
- It contains wiring and validation, not feature calculations.
- The Level Blueprint stays empty of gameplay logic.
- A single GameMode lookup for the bootstrap is allowed and tested.

## Quality/Test Seam

A composition test uses valid and intentionally incomplete fixtures. It verifies named
validation errors, initialization order, no duplicate bindings, and clean reset.

## Feature Requirements

- [TASK-090](../../Tasks/10-integration/TASK-090-integration.md)
