---
id: SUBTASK-020A
parent: TASK-020
status: BLOCKED
owner: unassigned
depends_on: [TASK-001]
updated: 2026-07-29
---

# SUBTASK-020A — Authoritative Cycle Manager

[Parent task](../TASK-020-day-night.md) · [Tasks overview](../../README.md)

## Objective

Implement the cycle state, timing, display clock, and public events without UI or
lighting dependencies.

## Work

- Create `Cycle/BP_DayNightManager`.
- Default day/night durations to 180/300 seconds.
- Map day progress from 06:00–18:00 and night progress from 18:00–06:00.
- Expose phase, progress, display time, pause/start/reset, and duration settings.
- Dispatch phase change, clock update, and full-cycle completion.

## Acceptance Criteria

- Phase boundaries are deterministic and do not double-fire.
- Reset returns to 06:00 Day.
- The cycle works with accelerated durations of a few seconds.

## Verification and Handoff

- Compile and run an accelerated cycle.
- Changed assets:
- Public API:
- Notes:
