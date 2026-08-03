---
id: ARCH-SUBTASK-040A
parent: ARCH-TASK-040
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

# ARCH-SUBTASK-040A — Create Health, Objective, and AI Shells

Parent: [ARCH-TASK-040](../ARCH-TASK-040-health-ai.md) ·
[Health Contract](../../../Contracts/ARC-CON-020-health-damage.md) ·
[Objective Contract](../../../Contracts/ARC-CON-030-objective-targeting.md)

## Work

- Create `BPC_Health` and home shell with public events.
- Create boar/controller/StateTree shells owned by Risbacka.
- Add explicit objective assignment and wave-participant APIs.
- If Combat health is retained, create one adapter plan and prevent duplicate health.

## Acceptance Criteria

- Shells compile without new warnings.
- Home has no Runtime/GameMode reference.
- AI has no concrete home/player search.
- Boar contains only shell behavior and safe invalid-target handling.

## Handoff

- Changed assets:
- Adapter decision:
- Public APIs:
- Commit:
