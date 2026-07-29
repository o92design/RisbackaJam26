---
id: ARCH-SUBTASK-040D
parent: ARCH-TASK-040
stage: independent-review
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - TASK-050:review_ready
updated: 2026-07-29
tags:
  - architecture/task
  - architecture/review
  - enemy-ai
---

# ARCH-SUBTASK-040D — Independent Enemy AI Review

Parent: [ARCH-TASK-040](../ARCH-TASK-040-health-ai.md) ·
[Review protocol](../../../Plans/Independent-Review.md) ·
[TASK-050](../../../../Tasks/06-boar-ai/TASK-050-boar-ai.md)

## Inspection

In a new context, inspect objective injection, StateTree/controller ownership,
blocker detection and resume behavior, one-shot death reporting, lack of
GameMode/UI/wave knowledge, graph quality, and focused/regression tests.

Use the AI task's generic damage contract/test double for focused verification.
The real axe-to-boar and fence-routing proof belongs to TASK-090.

## Acceptance Criteria

- No actor search is used for objective discovery.
- Five repeated test-double spawn-to-objective attempts pass.
- Outcome and exact reviewed commit are recorded.
