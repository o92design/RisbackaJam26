---
id: ARCH-SUBTASK-070B
parent: ARCH-TASK-070
stage: red-test
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-070A
updated: 2026-07-29
tags:
  - architecture/task
  - testing
---

# ARCH-SUBTASK-070B — Cross-Module Red Tests

Parent: [ARCH-TASK-070](../ARCH-TASK-070-integration-review.md) ·
[TDD workflow](../../../Plans/TDD-Workflow.md)

## Work

- Test valid and invalid composition, one-time bindings, and ordered startup.
- Add accelerated happy-path integration test.
- Add home-destroyed, solo-death, and all-local-players-dead cases.
- Assert wave-clear success cannot override prior failure and vice versa.
- Record expected red results before TASK-090/TASK-100.

## Acceptance Criteria

- Fixtures load and validate public contracts.
- Each behavior fails for an expected missing integration, not setup failure.
- Tests name the module boundary when a signal is absent/duplicated.

## Handoff

- Test assets:
- Expected red results:
- Actual results:
- Feature tasks unblocked:
- Commit:
