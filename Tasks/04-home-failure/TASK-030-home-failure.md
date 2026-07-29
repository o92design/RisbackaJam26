---
id: TASK-030
title: Home objective and failure signals
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: [TASK-001]
updated: 2026-07-29
---

# TASK-030 — Home Objective and Failure Signals

[Tasks overview](../README.md) · [TASK-001](../01-foundation/TASK-001-foundation.md)

## Goal

Create a damageable main base with observable health and clean failure events, without
coupling it directly to the integration GameMode.

## Exclusive Ownership

- `/Game/RisbackaJam26/Home/**`
- `/Game/RisbackaJam26/Tests/Home/**`

## Deliverables

- `BP_HomeStructure`
- Configurable max/current health
- Existing damage-interface compatibility
- Temporary visible healthy/damaged/critical/destroyed states
- `OnHomeHealthChanged` and `OnHomeDestroyed` dispatchers

## Subtasks

| Subtask | Status |
|---|---|
| [SUBTASK-030A](subtasks/SUBTASK-030A-home-structure.md) | `BLOCKED` |
| [SUBTASK-030B](subtasks/SUBTASK-030B-failure-contract.md) | `BLOCKED` |

## Out of Scope

- Final homestead art or persistent visual decay
- GameMode failure-screen implementation
- Repair mechanics

## Acceptance Criteria

- Valid damage reduces health once and never below zero.
- Health-state presentation changes at documented thresholds.
- Destruction fires once, disables further damage, and exposes a stable destroyed state.
- Tests can reset or respawn the home without editing the Blueprint.

## Verification

- Apply controlled damage in a dedicated test level.
- Verify dispatcher counts and state thresholds.
- Compile and reload the Blueprint.

## Handoff

- Changed assets:
- Public events/properties:
- Tests run:
- Commit:
