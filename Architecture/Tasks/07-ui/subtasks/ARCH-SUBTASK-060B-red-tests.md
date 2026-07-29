---
id: ARCH-SUBTASK-060B
parent: ARCH-TASK-060
stage: red-test
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-060A
updated: 2026-07-29
tags:
  - architecture/task
  - testing
---

# ARCH-SUBTASK-060B — HUD Binding and Update Red Tests

Parent: [ARCH-TASK-060](../ARCH-TASK-060-ui.md) ·
[TDD workflow](../../../Plans/TDD-Workflow.md)

## Work

- Inject fake runtime, cycle, health, storage, wave, and player sources.
- Assert initial values and one update per emitted event.
- Assert repeated initialization does not duplicate updates.
- Remove/recreate the widget and verify cleanup.
- Record expected red behavior before TASK-080.

## Acceptance Criteria

- Tests run without the prototype map.
- Binding/update assertion is red for expected missing behavior.
- Missing optional sources produce a controlled state.

## Handoff

- Test assets:
- Expected red result:
- Actual result:
- TASK-080 unblocked:
- Commit:
