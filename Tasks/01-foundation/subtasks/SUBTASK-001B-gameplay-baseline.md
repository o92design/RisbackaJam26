---
id: SUBTASK-001B
parent: TASK-001
status: BLOCKED
owner: unassigned
depends_on: [SUBTASK-001A]
updated: 2026-07-29
---

# SUBTASK-001B — GameMode, Controller, Player, and Phase Baseline

[Parent task](../TASK-001-foundation.md) · [Tasks overview](../../README.md)

## Objective

Create compilable Risbacka-owned gameplay classes that preserve the useful Combat
template behavior.

## Work

- Duplicate or derive `BP_CombatGameMode` as `Core/BP_GM_Risbacka`.
- Duplicate or derive `BP_CombatPlayerController` as `Core/BP_PC_Risbacka`.
- Duplicate or derive `BP_CombatCharacter` as `Characters/BP_Player_Risbacka`.
- Create `Core/E_RisbackaPhase`: `Day`, `Night`.
- Create `Core/E_RisbackaRunState`: `Bootstrapping`, `Ready`, `Playing`, `Success`,
  `Failure`.
- Repoint Risbacka-owned class defaults to other Risbacka-owned classes.
- Record inherited/template dependencies that remain.

## Acceptance Criteria

- All four assets compile.
- Movement, melee attack, local-player creation, and tagged PlayerStart selection are
  preserved.
- `git status` shows no modified Combat template asset.

## Verification and Handoff

- Run the existing smoke test without modifying it.
- Changed assets:
- Template dependencies:
- Notes:
