---
id: ARCH-SUBTASK-040B
parent: ARCH-TASK-040
stage: red-test
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-040A
updated: 2026-07-29
tags:
  - architecture/task
  - testing
---

# ARCH-SUBTASK-040B — Health and AI Red Tests

Parent: [ARCH-TASK-040](../ARCH-TASK-040-health-ai.md) ·
[TDD workflow](../../../Plans/TDD-Workflow.md)

## Work

- Test valid/invalid/overkill/repeated damage and one destruction event.
- Test home objective availability.
- Build open and blocked navmesh fixtures with an assigned objective.
- Test missing/destroyed target, blocker attack/resume, axe death, and one completion.
- Record separate expected red evidence for TASK-030 and TASK-050.

## Acceptance Criteria

- Setup succeeds and public APIs are callable.
- Behavior assertions fail for expected missing implementation.
- Tests do not depend on the prototype map or final animal model.

## Handoff

- Test assets:
- Health red result:
- AI red result:
- Feature tasks unblocked:
- Commit:
