---
id: ARCH-SUBTASK-001B
parent: ARCH-TASK-001
stage: red-test
status: READY
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-001A
updated: 2026-08-01
tags:
  - architecture/task
  - testing
---

# ARCH-SUBTASK-001B — Prove Contract Tests Red

Parent: [ARCH-TASK-001](../ARCH-TASK-001-contracts.md) ·
[TDD workflow](../../../Plans/TDD-Workflow.md)

## Work

- Create small test doubles for damage, resource, wave, and initialization contracts.
- Create focused tests that call public APIs only.
- Assert default shell results are explicitly unimplemented/invalid.
- Record at least one expected behavior failure that TASK-001 must make green.

## Acceptance Criteria

- Test setup and asset loading succeed.
- The behavior assertion fails for the documented missing implementation.
- Failure messages name expected and actual results.
- Tests do not inspect private Blueprint variables.

## Handoff

- Test assets:
- Expected red result:
- Actual result/log:
- Feature task unblocked:
- Commit:
