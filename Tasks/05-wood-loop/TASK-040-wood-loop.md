---
id: TASK-040
title: Axe, wood pickups, and shared storage
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: [TASK-001]
architecture_gates: [ARCH-TASK-050]
updated: 2026-07-29
---

# TASK-040 — Axe, Wood Pickups, and Shared Storage

[Tasks overview](../README.md) · [TASK-001](../01-foundation/TASK-001-foundation.md)

## Architecture Gate

- Module:
  [Resources & Interaction](../../Architecture/Modules/ARC-MOD-050-resources-interaction.md)
- Contracts:
  [Resource Store](../../Architecture/Contracts/ARC-CON-040-resource-store.md) and
  [Carry Interaction](../../Architecture/Contracts/ARC-CON-050-carry-interaction.md)
- Gate:
  [ARCH-TASK-050](../../Architecture/Tasks/06-resources-building/ARCH-TASK-050-resources-building.md)
- Begin after component/store shells and red tests; `DONE` requires independent review.

## Goal

Complete the Phase 1 gathering loop: axe a marked source, carry a wood pickup, drop it
inside storage, and increase a shared stockpile.

## Exclusive Ownership

- `/Game/RisbackaJam26/Resources/**`
- `/Game/RisbackaJam26/Tests/Resources/**`
- `/Game/RisbackaJam26/Characters/BP_Player_Risbacka` for axe/carry hookup

## Deliverables

- `BP_WoodSource`
- `BP_WoodPickup`
- `BP_WoodStorage`
- Axe damage from the existing melee flow
- Carry, drop, deposit, shared count, and `OnStoredWoodChanged`

## Subtasks

| Subtask | Status |
|---|---|
| [SUBTASK-040A](subtasks/SUBTASK-040A-axe-and-pickups.md) | `BLOCKED` |
| [SUBTASK-040B](subtasks/SUBTASK-040B-storage.md) | `BLOCKED` |

## Out of Scope

- Full tree destruction
- Axe final art/animation
- Fence placement or spending
- Economy other than stored wood

## Acceptance Criteria

- Only valid axe hits deplete a marked wood source.
- A depleted source drops the configured pickup quantity once.
- Either player can carry only the documented number of pickups.
- Dropping a pickup inside storage consumes it and increments shared wood exactly once.

## Verification

- Complete the loop with player one and player two.
- Test dropping outside storage and repeated overlap events.
- Compile the player and all resource Blueprints.

## Handoff

- Changed assets:
- Input/actions used:
- Tests run:
- Commit:
