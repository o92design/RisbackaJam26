---
id: TASK-070
title: Wooden fence placement
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: [TASK-040]
architecture_gates: [ARCH-TASK-050]
updated: 2026-07-29
---

# TASK-070 — Wooden Fence Placement

[Tasks overview](../README.md) · [TASK-040](../05-wood-loop/TASK-040-wood-loop.md)

## Architecture Gate

- Modules: [Building](../../Architecture/Modules/ARC-MOD-060-building.md),
  [Resources](../../Architecture/Modules/ARC-MOD-050-resources-interaction.md), and
  [Health](../../Architecture/Modules/ARC-MOD-040-health-objectives.md)
- Contracts:
  [Building](../../Architecture/Contracts/ARC-CON-060-building.md) and
  [Resource Store](../../Architecture/Contracts/ARC-CON-040-resource-store.md)
- Gate:
  [ARCH-TASK-050](../../Architecture/Tasks/06-resources-building/ARCH-TASK-050-resources-building.md)
- Begin after atomic-spend/placement red tests; `DONE` requires fresh-context review.

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
- Damageable fence that exposes the blocker contract and affects navigation

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
- The placed fence takes contract-level damage and affects a generic test
  attacker's route.
- TASK-090 proves the real boar attacks the placed fence and resumes toward home.

## Verification

- Test both players entering/exiting build mode.
- Test simultaneous placement requests.
- Test navigation blocking with a generic test attacker; defer real-boar routing
  to TASK-090.
- Compile all building assets and the player Blueprint.

## Handoff

- Changed assets:
- Input/actions used:
- Tests run:
- Commit:
