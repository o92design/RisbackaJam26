---
id: ARCH-SUBTASK-060A
parent: ARCH-TASK-060
stage: shell
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-010A
  - ARCH-SUBTASK-030A
  - ARCH-SUBTASK-040A
  - ARCH-SUBTASK-050A
updated: 2026-07-29
tags:
  - architecture/task
---

# ARCH-SUBTASK-060A — Create HUD and Read-Source Shell

Parent: [ARCH-TASK-060](../ARCH-TASK-060-ui.md) ·
[UI Contract](../../../Contracts/ARC-CON-090-ui-read-model.md)

## Work

- Create HUD/container and status-widget shells.
- Create a read-source initialization struct or equivalent explicit inputs.
- Add initial-read, bind, unbind, and explicit setter functions.
- Create fake source shells for tests.

## Acceptance Criteria

- Widgets compile.
- No property binding polls gameplay state.
- No widget actor search or gameplay command exists.
- Reinitialization path can avoid duplicate binding.

## Handoff

- Changed assets:
- Required producer APIs:
- Compile result:
- Commit:
