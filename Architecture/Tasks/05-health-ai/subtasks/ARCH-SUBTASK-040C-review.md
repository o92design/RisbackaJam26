---
id: ARCH-SUBTASK-040C
parent: ARCH-TASK-040
stage: independent-review
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - TASK-030:review_ready
updated: 2026-07-29
tags:
  - architecture/task
  - architecture/review
---

# ARCH-SUBTASK-040C — Independent Home and Health Review

Parent: [ARCH-TASK-040](../ARCH-TASK-040-health-ai.md) ·
[Review protocol](../../../Plans/Independent-Review.md)

## Inspection

In a new context, inspect single health ownership, Combat adapter behavior,
one-shot events, home destruction signaling, player-death aggregation, graph
quality, and focused/regression tests.

## Acceptance Criteria

- No GameMode/UI/wave scheduling knowledge leaks into home/health actors.
- No duplicate health owner remains.
- Review records the exact commit and reproducible findings/outcome.
