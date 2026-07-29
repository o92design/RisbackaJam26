---
id: TASK-001
title: Foundation and game-owned baseline
status: READY
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: []
updated: 2026-07-29
---

# TASK-001 — Foundation and Game-Owned Baseline

[Tasks overview](../README.md) · [Implementation plan](../../Docs/Implementation-Plan.md)

## Goal

Create an isolated Risbacka gameplay baseline so parallel agents never need to modify
the Combat template originals.

## Dependencies

None.

## Exclusive Ownership

- `/Game/RisbackaJam26/Core/**`
- `/Game/RisbackaJam26/Characters/**`
- `CONTRIBUTING.md` content-layout section only

Do not edit the existing Combat template assets; duplicate or derive from them.

## Deliverables

- Agreed game-owned content folders
- `BP_GM_Risbacka`, based on the useful local-player logic in `BP_CombatGameMode`
- `BP_PC_Risbacka`, based on `BP_CombatPlayerController`
- `BP_Player_Risbacka`, based on `BP_CombatCharacter`
- `E_RisbackaPhase` with `Day`, `Night`, `Success`, and `Failure`
- All new Blueprints compile without warnings introduced by this task

## Subtasks

| Subtask | Status |
|---|---|
| [SUBTASK-001A](subtasks/SUBTASK-001A-content-layout.md) | `READY` |
| [SUBTASK-001B](subtasks/SUBTASK-001B-gameplay-baseline.md) | `BLOCKED` |

## Out of Scope

- Shared-camera behavior
- Resource, enemy, wave, building, home, or UI implementation
- Changing the project default map or GameMode

## Acceptance Criteria

- Game-owned assets exist only below `/Game/RisbackaJam26/`.
- The new GameMode still creates the intended local players and chooses tagged starts.
- The new player preserves working movement and melee input.
- No Combat template `.uasset` is modified.

## Verification

- Compile all three Blueprints.
- Load each asset after an Editor restart.
- Run the existing automation smoke test without changing its asset.
- Record the exact source template paths used.

## Handoff

- Changed assets:
- Tests run:
- Known limitations:
- Commit:
