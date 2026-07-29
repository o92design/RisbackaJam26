---
id: SUBTASK-020B
parent: TASK-020
status: BLOCKED
owner: unassigned
depends_on: [SUBTASK-020A]
updated: 2026-07-29
---

# SUBTASK-020B — Cycle Boundary Verification

[Parent task](../TASK-020-day-night.md) · [Tasks overview](../../README.md)

## Objective

Prove the manager's phase order, clock mapping, reset behavior, and event counts.

## Work

- Create a cycle test level or functional-test Blueprint below `Tests/Cycle`.
- Capture timestamps for Day→Night, Night→Day, and full-cycle completion.
- Test pause/resume and reset in both phases.
- Record expected tolerances for real-time timing.

## Acceptance Criteria

- Event order is Day, Night, Day/Complete.
- Each boundary dispatcher fires exactly once.
- Accelerated and default settings use identical logic.

## Verification and Handoff

- Test results:
- Changed assets:
- Timing tolerance:
- Notes:
