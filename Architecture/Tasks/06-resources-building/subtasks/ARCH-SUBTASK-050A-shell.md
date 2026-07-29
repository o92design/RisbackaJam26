---
id: ARCH-SUBTASK-050A
parent: ARCH-TASK-050
stage: shell
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-001A
  - ARCH-SUBTASK-040A
updated: 2026-07-29
tags:
  - architecture/task
---

# ARCH-SUBTASK-050A — Create Resource and Building Shells

Parent: [ARCH-TASK-050](../ARCH-TASK-050-resources-building.md) ·
[Resource Store](../../../Contracts/ARC-CON-040-resource-store.md) ·
[Building Contract](../../../Contracts/ARC-CON-060-building.md)

## Work

- Create wood source/pickup/storage and carry-component shells.
- Create build-component, preview, fence, and build-data shells.
- Expose atomic store and placement APIs with explicit results.
- Do not implement player hookup, gathering, or placement behavior.

## Acceptance Criteria

- Shells compile.
- Building references the store interface, not concrete storage.
- Player behavior lives in components by design.
- Preview creation spends no resource.

## Handoff

- Changed assets:
- Public APIs:
- Compile result:
- Commit:
