---
id: TASK-070
title: Wooden fence placement
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: [TASK-040]
updated: 2026-07-29
---

# TASK-070 — Wooden Fence Placement

[Tasks overview](../README.md) · [TASK-040](../05-wood-loop/TASK-040-wood-loop.md)

## Goal

Allow either player to preview and place one wooden fence type by spending wood from
the shared storage stockpile.

## Exclusive Ownership

- `/Game/RisbackaJam26/Building/**`
- `/Game/RisbackaJam26/Tests/Building/**`
- `/Game/RisbackaJam26/Characters/BP_Player_Risbacka` for build-mode hookup

## Deliverables

- `BP_FenceBase`
- Valid/invalid placement preview
- Configurable wood cost
- Shared-storage spend request with no negative balance
- Damageable fence that blocks boar navigation

## Subtasks

| Subtask | Status |
|---|---|
| [SUBTASK-070A](subtasks/SUBTASK-070A-fence-actor.md) | `BLOCKED` |
| [SUBTASK-070B](subtasks/SUBTASK-070B-placement.md) | `BLOCKED` |

## Out of Scope

- Stone/electric fence tiers
- Grid editing tools or save/load
- Repairing fences
- Final fence art

## Acceptance Criteria

- Preview clearly indicates valid and invalid placement.
- Placement cannot overlap players, the home, or another fence.
- Successful placement subtracts the exact configured cost once.
- Insufficient wood leaves storage unchanged and creates no fence.
- The placed fence takes damage and affects the boar route.

## Verification

- Test both players entering/exiting build mode.
- Test simultaneous placement requests.
- Compile all building assets and the player Blueprint.

## Handoff

- Changed assets:
- Input/actions used:
- Tests run:
- Commit:
