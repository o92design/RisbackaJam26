---
id: TASK-040
title: Axe, wood pickups, and shared storage
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: [TASK-001]
updated: 2026-07-29
---

# TASK-040 — Axe, Wood Pickups, and Shared Storage

[Tasks overview](../README.md) · [TASK-001](../01-foundation/TASK-001-foundation.md)

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
