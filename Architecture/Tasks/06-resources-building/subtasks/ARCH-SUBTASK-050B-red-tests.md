---
id: ARCH-SUBTASK-050B
parent: ARCH-TASK-050
stage: red-test
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-050A
updated: 2026-07-29
tags:
  - architecture/task
  - testing
---

# ARCH-SUBTASK-050B — Resource and Placement Red Tests

Parent: [ARCH-TASK-050](../ARCH-TASK-050-resources-building.md) ·
[TDD workflow](../../../Plans/TDD-Workflow.md)

## Work

- Test source depletion/pickup count, carry ownership, drop, and one-time deposit.
- Test deposit and exact/insufficient/invalid atomic spending.
- Test valid/blocked/out-of-bounds preview and cancel.
- Test same-frame two-player spend and spawn-failure consistency.
- Record expected red evidence for TASK-040 and TASK-070.

## Acceptance Criteria

- Test doubles avoid the shared player Blueprint and final map.
- Behavior assertions fail for expected missing implementation.
- Balance and event counts are explicit in failure messages.

## Handoff

- Test assets:
- Resource red result:
- Building red result:
- Feature tasks unblocked:
- Commit:
