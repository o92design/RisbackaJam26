---
id: ARCH-TASK-050
title: Resources and building architecture
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
contract_prerequisites:
  - ARCH-SUBTASK-001A
  - ARCH-SUBTASK-040A
feature_tasks:
  - TASK-040
  - TASK-070
updated: 2026-07-29
tags:
  - architecture/task
  - resources
  - building
---

# ARCH-TASK-050 — Resources and Building Architecture

[Architecture task board](../README.md) ·
[Resources](../../Modules/ARC-MOD-050-resources-interaction.md) ·
[Building](../../Modules/ARC-MOD-060-building.md)

## Goal

Make carrying and building component-driven, keep wood balance in one store, and make
placement spending atomic for two local players.

## Asset Scope

- `/Game/RisbackaJam26/Resources/**`
- `/Game/RisbackaJam26/Building/**`
- `/Game/RisbackaJam26/Tests/Resources/**`
- `/Game/RisbackaJam26/Tests/Building/**`
- Player hookup only through TASK-040 then TASK-070 lease

## Subtasks

| Subtask | Status |
|---|---|
| [ARCH-SUBTASK-050A](subtasks/ARCH-SUBTASK-050A-shell.md) — resource/build shells | `BLOCKED` |
| [ARCH-SUBTASK-050B](subtasks/ARCH-SUBTASK-050B-red-tests.md) — transaction red tests | `BLOCKED` |
| [ARCH-SUBTASK-050C](subtasks/ARCH-SUBTASK-050C-review.md) — resources review after TASK-040 | `BLOCKED` |
| [ARCH-SUBTASK-050D](subtasks/ARCH-SUBTASK-050D-building-review.md) — building review after TASK-070 | `BLOCKED` |

## Completion Gate

- Player only forwards input to carry/build components.
- Storage owns balance and exposes atomic `TrySpendWood`.
- Pickup/deposit and preview/commit lifecycles are deterministic.
- Concurrent placement cannot overspend.
- Fresh-context reviews independently approve TASK-040 and TASK-070.
