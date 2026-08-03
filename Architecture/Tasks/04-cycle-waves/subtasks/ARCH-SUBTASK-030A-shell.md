---
id: ARCH-SUBTASK-030A
parent: ARCH-TASK-030
stage: shell
status: READY
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-001A
  - ARCH-SUBTASK-010A
updated: 2026-07-29
tags:
  - architecture/task
---

# ARCH-SUBTASK-030A — Create Cycle and Wave Shells

Parent: [ARCH-TASK-030](../ARCH-TASK-030-cycle-waves.md) ·
[Run State](../../../Contracts/ARC-CON-010-run-state.md) ·
[Wave Accounting](../../../Contracts/ARC-CON-070-wave-accounting.md)

## Work

- Create cycle manager/config shells and documented clock events.
- Create wave director, spawn point, definition, and participant shells.
- Provide explicit initialization/reset/configuration APIs.
- Do not start timers or spawn actors in shell behavior.

## Acceptance Criteria

- All shells compile.
- Cycle has no concrete WaveDirector reference.
- WaveDirector has no concrete boar or clock reference.
- Run outcome is not stored in either module.

## Handoff

- Changed assets:
- Public APIs:
- Compile result:
- Commit:
