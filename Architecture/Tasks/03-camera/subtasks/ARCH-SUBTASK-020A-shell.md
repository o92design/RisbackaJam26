---
id: ARCH-SUBTASK-020A
parent: ARCH-TASK-020
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

# ARCH-SUBTASK-020A — Create Camera Shell

Parent: [ARCH-TASK-020](../ARCH-TASK-020-camera.md) ·
[Camera Contract](../../../Contracts/ARC-CON-080-camera-participant.md)

## Work

- Create participant interface, camera actor, bounds actor, and config shell.
- Add explicit register/unregister and activate-shared-view APIs.
- Use a safe fixed fallback with no dynamic implementation.
- Compile without modifying GameMode or split-screen configuration.

## Acceptance Criteria

- Shells compile.
- Camera stores only registered participants.
- No Tick world searches exist.
- No dependency on feature systems exists.

## Handoff

- Changed assets:
- Public APIs:
- Compile result:
- Commit:
