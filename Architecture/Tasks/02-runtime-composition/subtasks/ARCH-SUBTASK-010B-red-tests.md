---
id: ARCH-SUBTASK-010B
parent: ARCH-TASK-010
stage: red-test
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-010A
updated: 2026-07-29
tags:
  - architecture/task
  - testing
---

# ARCH-SUBTASK-010B — Runtime and Initialization Red Tests

Parent: [ARCH-TASK-010](../ARCH-TASK-010-runtime-composition.md) ·
[TDD workflow](../../../Plans/TDD-Workflow.md)

## Work

- Test valid/invalid initialization and repeat calls.
- Drive competing success/failure requests through public commands.
- Simulate solo and two-player death facts with test emitters.
- Prove the shell fails the expected transition/initialization behavior.

## Acceptance Criteria

- Tests load and call only public contracts.
- At least one named behavior assertion is red for the expected reason.
- Duplicate binding/event counts are asserted.
- No prototype map is required.

## Handoff

- Test assets:
- Expected red result:
- Actual result:
- Linked feature tasks:
- Commit:
