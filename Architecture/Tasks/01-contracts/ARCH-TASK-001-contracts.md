---
id: ARCH-TASK-001
title: Shared contract foundation
status: READY
owner: unassigned
computer: unassigned
branch: unassigned
contract_prerequisites: []
feature_tasks:
  - TASK-001
updated: 2026-07-29
tags:
  - architecture/task
  - contracts
---

# ARCH-TASK-001 — Shared Contract Foundation

[Architecture task board](../README.md) ·
[Shared Contracts](../../Modules/ARC-MOD-000-contracts.md) ·
[TASK-001](../../../Tasks/01-foundation/TASK-001-foundation.md)

## Goal

Create stable, game-owned Blueprint contract shells and prove their default behavior
before feature graphs depend on them.

## Asset Scope

- `/Game/RisbackaJam26/Core/Contracts/**`
- `/Game/RisbackaJam26/Tests/Architecture/Contracts/**`
- No Combat template assets
- No GameMode, player, map, or feature implementation

## Required Contracts

- [Initialization](../../Contracts/ARC-CON-001-initialization.md)
- [Run State](../../Contracts/ARC-CON-010-run-state.md)
- [Health & Damage](../../Contracts/ARC-CON-020-health-damage.md)
- [Objective Targeting](../../Contracts/ARC-CON-030-objective-targeting.md)
- [Resource Store](../../Contracts/ARC-CON-040-resource-store.md)
- [Carry](../../Contracts/ARC-CON-050-carry-interaction.md)
- [Building](../../Contracts/ARC-CON-060-building.md)
- [Wave Accounting](../../Contracts/ARC-CON-070-wave-accounting.md)
- [Camera Participant](../../Contracts/ARC-CON-080-camera-participant.md)
- [UI Read Model](../../Contracts/ARC-CON-090-ui-read-model.md)

## Subtasks

| Subtask | Status |
|---|---|
| [ARCH-SUBTASK-001A](subtasks/ARCH-SUBTASK-001A-shell.md) — contract shell | `REVIEW_READY` |
| [ARCH-SUBTASK-001B](subtasks/ARCH-SUBTASK-001B-red-tests.md) — red contract tests | `REVIEW_READY` |
| [ARCH-SUBTASK-001C](subtasks/ARCH-SUBTASK-001C-review.md) — independent review | `BLOCKED` |

## Feature Handoff

After 001A and 001B, TASK-001 may create the runtime baseline against these types.
Contract behavior made green by TASK-001 is then inspected by 001C.

## Completion Gate

- Contract assets compile with no new warnings.
- Types contain no concrete feature-class references.
- Test doubles prove interface substitution.
- Focused and regression tests pass after TASK-001.
- Fresh-context review approves a named commit.
