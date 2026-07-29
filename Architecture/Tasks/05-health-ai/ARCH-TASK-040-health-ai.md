---
id: ARCH-TASK-040
title: Health, objectives, and enemy AI architecture
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
contract_prerequisites:
  - ARCH-SUBTASK-001A
  - ARCH-SUBTASK-010A
feature_tasks:
  - TASK-030
  - TASK-050
updated: 2026-07-29
tags:
  - architecture/task
  - health
  - ai
---

# ARCH-TASK-040 — Health, Objectives, and Enemy AI Architecture

[Architecture task board](../README.md) ·
[Health & Objectives](../../Modules/ARC-MOD-040-health-objectives.md) ·
[Enemy AI](../../Modules/ARC-MOD-070-enemy-ai.md)

## Goal

Provide reusable health/objective contracts and prove an enemy can receive an assigned
objective, attack blockers, die once, and report completion without knowing GameMode,
HUD, or wave internals.

## Asset Scope

- `/Game/RisbackaJam26/Core/Health/**`
- `/Game/RisbackaJam26/Home/**`
- `/Game/RisbackaJam26/Enemies/**`
- `/Game/RisbackaJam26/Tests/Home/**`
- `/Game/RisbackaJam26/Tests/Enemies/**`
- No Combat template edits or final Fab model work

## Subtasks

| Subtask | Status |
|---|---|
| [ARCH-SUBTASK-040A](subtasks/ARCH-SUBTASK-040A-shell.md) — health/objective/AI shells | `BLOCKED` |
| [ARCH-SUBTASK-040B](subtasks/ARCH-SUBTASK-040B-red-tests.md) — damage/navigation red tests | `BLOCKED` |
| [ARCH-SUBTASK-040C](subtasks/ARCH-SUBTASK-040C-review.md) — home/health review after TASK-030 | `BLOCKED` |
| [ARCH-SUBTASK-040D](subtasks/ARCH-SUBTASK-040D-enemy-ai-review.md) — enemy AI review after TASK-050 | `BLOCKED` |

## Completion Gate

- One health owner per actor and one-shot destruction.
- Home reports destruction without failing the run directly.
- AI receives an objective explicitly and searches no world classes.
- Blocker/resume/death behavior passes focused tests.
- Fresh-context reviews independently approve TASK-030 and TASK-050.
