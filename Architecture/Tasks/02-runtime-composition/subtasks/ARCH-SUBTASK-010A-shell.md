---
id: ARCH-SUBTASK-010A
parent: ARCH-TASK-010
stage: shell
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-001A
updated: 2026-07-29
tags:
  - architecture/task
---

# ARCH-SUBTASK-010A — Create Runtime and Composition Shell

Parent: [ARCH-TASK-010](../ARCH-TASK-010-runtime-composition.md) ·
[Run State](../../../Contracts/ARC-CON-010-run-state.md) ·
[Initialization](../../../Contracts/ARC-CON-001-initialization.md)

## Work

- Create compileable coordinator, player-life aggregator, and bootstrap shells.
- Expose documented functions/events and editable dependency references.
- Return controlled invalid/not-ready results without starting gameplay.
- Document initialization order in the bootstrap asset.

## Acceptance Criteria

- Shells compile with no new warnings.
- No timers, waves, UI, or feature behavior starts.
- Bootstrap contains references/wiring only.
- Coordinator owns the sole run-state value.

## Handoff

- Changed assets:
- Public APIs:
- Compile result:
- Commit:
