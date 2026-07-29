---
id: ARCH-SUBTASK-030D
parent: ARCH-TASK-030
stage: independent-review
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - TASK-060:review_ready
updated: 2026-07-29
tags:
  - architecture/task
  - architecture/review
  - waves
---

# ARCH-SUBTASK-030D — Independent Wave Review

Parent: [ARCH-TASK-030](../ARCH-TASK-030-cycle-waves.md) ·
[Review protocol](../../../Plans/Independent-Review.md) ·
[TASK-060](../../../../Tasks/07-wave-director/TASK-060-wave-director.md)

## Inspection

In a fresh context, inspect generic wave scheduling, living-enemy set
accounting, duplicate death/despawn reports, configurable classes/counts, timer
cleanup, success signaling, graph quality, and focused/regression tests.

## Acceptance Criteria

- Exact spawn, living-count, and wave-completion event counts are verified.
- The director has no concrete boar or clock reverse dependency.
- Outcome and reviewed commit are recorded.
