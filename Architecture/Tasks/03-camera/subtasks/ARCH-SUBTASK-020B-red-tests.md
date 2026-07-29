---
id: ARCH-SUBTASK-020B
parent: ARCH-TASK-020
stage: red-test
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-020A
updated: 2026-07-29
tags:
  - architecture/task
  - testing
---

# ARCH-SUBTASK-020B — Shared-View Red Tests

Parent: [ARCH-TASK-020](../ARCH-TASK-020-camera.md) ·
[TDD workflow](../../../Plans/TDD-Workflow.md)

## Work

- Create two disposable participant actors and tagged starts in a focused map.
- Assert registration, opposite-corner visibility, and controller view targets.
- Cover zero/one participant fallbacks and repeated PIE setup.
- Record the expected failure before TASK-010 framing/hookup.

## Acceptance Criteria

- Test setup loads and participants register.
- Framing/view-target assertion is red for the documented shell behavior.
- The test does not depend on wood, home, waves, boars, or final map.

## Handoff

- Test assets:
- Expected red result:
- Actual result:
- TASK-010 unblocked:
- Commit:
