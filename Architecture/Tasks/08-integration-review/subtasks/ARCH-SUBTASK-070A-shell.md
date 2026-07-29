---
id: ARCH-SUBTASK-070A
parent: ARCH-TASK-070
stage: shell
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-020A
  - ARCH-SUBTASK-030A
  - ARCH-SUBTASK-040A
  - ARCH-SUBTASK-050A
  - ARCH-SUBTASK-060A
updated: 2026-07-29
tags:
  - architecture/task
---

# ARCH-SUBTASK-070A — Create Integration Fixture and Composition Shell

Parent: [ARCH-TASK-070](../ARCH-TASK-070-integration-review.md) ·
[Composition Module](../../../Modules/ARC-MOD-100-composition.md)

## Work

- Complete bootstrap reference fields, validation, and ordered initialization shell.
- Create a small integration fixture using test doubles where feature assets are not
  yet green.
- Declare every cross-module binding in the task and bootstrap comments.
- Keep the final map and feature internals for TASK-090.

## Acceptance Criteria

- Shell compiles and reports named missing-reference errors.
- Initialization does not partially start.
- Bindings are visible in one composition asset.
- Level Blueprint business logic is unnecessary.

## Handoff

- Changed assets:
- Reference list:
- Initialization order:
- Commit:
