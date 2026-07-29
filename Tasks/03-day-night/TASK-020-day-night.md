---
id: TASK-020
title: Day and night cycle manager
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: [TASK-001]
architecture_gates: [ARCH-TASK-030]
updated: 2026-07-29
---

# TASK-020 — Day and Night Cycle Manager

[Tasks overview](../README.md) · [TASK-001](../01-foundation/TASK-001-foundation.md)

## Architecture Gate

- Module: [Day/Night Cycle](../../Architecture/Modules/ARC-MOD-030-cycle.md)
- Contract: [Run State](../../Architecture/Contracts/ARC-CON-010-run-state.md)
- Gate:
  [ARCH-TASK-030](../../Architecture/Tasks/04-cycle-waves/ARCH-TASK-030-cycle-waves.md)
- The cycle owns phase/time only. Begin after its shell/red test; `DONE` requires the
  independent cycle/wave review.

## Goal

Provide an authoritative, event-driven 24-hour cycle with a three-minute day and a
five-minute night.

## Exclusive Ownership

- `/Game/RisbackaJam26/Cycle/**`
- `/Game/RisbackaJam26/Tests/Cycle/**`

## Deliverables

- `BP_DayNightManager`
- Configurable day and night real-time durations
- Current phase, normalized phase progress, and display clock
- Phase-changed and clock-updated event dispatchers
- A cycle-only verification level or functional test

## Subtasks

| Subtask | Status |
|---|---|
| [SUBTASK-020A](subtasks/SUBTASK-020A-cycle-manager.md) | `BLOCKED` |
| [SUBTASK-020B](subtasks/SUBTASK-020B-cycle-verification.md) | `BLOCKED` |

## Out of Scope

- Lighting/art direction
- Wave spawning
- HUD widgets
- Saving progress between sessions

## Acceptance Criteria

- Day begins at 06:00 and reaches 18:00 in 180 seconds.
- Night begins at 18:00 and reaches 06:00 in 300 seconds.
- Exactly one phase-change event fires at each boundary.
- Durations can be shortened for automated verification without changing graph logic.

## Verification

- Compile the Blueprint.
- Run an accelerated full cycle and record phase events/timestamps.
- Run the default-duration boundary test where practical.

## Handoff

- Changed assets:
- Public events/properties:
- Tests run:
- Commit:
