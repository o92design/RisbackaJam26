---
id: SUBTASK-090A
parent: TASK-090
status: BLOCKED
owner: unassigned
depends_on: [TASK-010, TASK-020, TASK-030, TASK-040, TASK-050, TASK-060, TASK-070, TASK-080]
updated: 2026-07-29
---

# SUBTASK-090A — Prototype Level Assembly

[Parent task](../TASK-090-integration.md) · [Tasks overview](../../README.md)

## Objective

Build a readable graybox arena containing every completed system while preserving the
whole-area shared-camera requirement.

## Work

- Create `Maps/L_Risbacka_Prototype`; do not modify `Lvl_Combat`.
- Place two tagged PlayerStarts, shared camera, home, storage, wood sources, build
  space, boar spawn points, managers, and navmesh.
- Arrange clear routes and at least one meaningful fence chokepoint.
- Configure the map override to `BP_GM_Risbacka`.
- Keep every actor organized in named Outliner folders.

## Acceptance Criteria

- Every required actor is visible/discoverable and has valid references.
- Both players, resources, home, and spawn routes remain inside camera framing.
- Navmesh connects spawn points to the home with and without the fence.
- Saving the World Partition map produces only expected external actors/objects.

## Verification and Handoff

- Changed map/external assets:
- Viewport capture:
- Navmesh checks:
- Notes:
