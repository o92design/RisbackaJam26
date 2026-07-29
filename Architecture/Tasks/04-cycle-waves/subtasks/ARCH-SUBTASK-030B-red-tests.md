---
id: ARCH-SUBTASK-030B
parent: ARCH-TASK-030
stage: red-test
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-030A
updated: 2026-07-29
tags:
  - architecture/task
  - testing
---

# ARCH-SUBTASK-030B — Cycle and Wave Red Tests

Parent: [ARCH-TASK-030](../ARCH-TASK-030-cycle-waves.md) ·
[TDD workflow](../../../Plans/TDD-Workflow.md)

## Work

- Test accelerated 06:00/18:00 boundaries and exact event counts.
- Test three configured waves with a disposable participant.
- Test failed spawn, duplicate completion, cancel, and reset.
- Record expected red behavior separately for TASK-020 and TASK-060.

## Acceptance Criteria

- Test setup succeeds without the prototype map or real boar.
- Boundary and accounting assertions fail for expected missing behavior.
- Tests use injected durations/classes and public APIs.

## Handoff

- Test assets:
- Cycle red evidence:
- Wave red evidence:
- Feature tasks unblocked:
- Commit:
