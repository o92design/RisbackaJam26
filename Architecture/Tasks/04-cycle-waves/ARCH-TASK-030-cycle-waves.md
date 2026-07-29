---
id: ARCH-TASK-030
title: Cycle and wave architecture
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
contract_prerequisites:
  - ARCH-SUBTASK-001A
  - ARCH-SUBTASK-010A
feature_tasks:
  - TASK-020
  - TASK-060
updated: 2026-07-29
tags:
  - architecture/task
  - time
  - waves
---

# ARCH-TASK-030 — Cycle and Wave Architecture

[Architecture task board](../README.md) ·
[Cycle](../../Modules/ARC-MOD-030-cycle.md) ·
[Waves](../../Modules/ARC-MOD-080-waves.md)

## Goal

Keep the authoritative clock separate from generic wave scheduling while joining them
through events and explicit configuration.

## Asset Scope

- `/Game/RisbackaJam26/Cycle/**`
- `/Game/RisbackaJam26/Waves/**`
- `/Game/RisbackaJam26/Tests/Cycle/**`
- `/Game/RisbackaJam26/Tests/Waves/**`
- No concrete boar implementation or HUD

## Subtasks

| Subtask | Status |
|---|---|
| [ARCH-SUBTASK-030A](subtasks/ARCH-SUBTASK-030A-shell.md) — cycle/wave shells | `BLOCKED` |
| [ARCH-SUBTASK-030B](subtasks/ARCH-SUBTASK-030B-red-tests.md) — boundary/accounting red tests | `BLOCKED` |
| [ARCH-SUBTASK-030C](subtasks/ARCH-SUBTASK-030C-review.md) — cycle review after TASK-020 | `BLOCKED` |
| [ARCH-SUBTASK-030D](subtasks/ARCH-SUBTASK-030D-wave-review.md) — wave review after TASK-060 | `BLOCKED` |

## Completion Gate

- Cycle owns phase/time; director owns waves/living set.
- Coupling is event/configuration based.
- Durations and enemy class are test-injectable.
- Exact boundary, spawn, duplicate-report, and completion tests pass.
- Fresh-context reviews independently approve each linked feature commit.
