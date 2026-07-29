---
id: ARC-MOD-020
type: architecture-module
status: proposed
depends_on:
  - ARC-MOD-000
  - ARC-MOD-010
updated: 2026-07-29
tags:
  - architecture/module
  - camera
  - local-coop
---

# ARC-MOD-020 — Camera and Local Co-op

[Module catalog](README.md) ·
[Camera Participant Contract](../Contracts/ARC-CON-080-camera-participant.md) ·
[TASK-010](../../Tasks/02-shared-camera/TASK-010-shared-camera.md)

## Responsibility

Create and register two local players, assign one shared view target to both
controllers, and frame the complete defined play area.

## Proposed Assets

```text
/Game/RisbackaJam26/Camera/
├── BP_SharedGameplayCamera
├── BP_CameraBounds
└── DA_SharedCameraConfig
/Game/RisbackaJam26/Core/BP_PC_Risbacka
```

## Public API

- `RegisterCameraParticipant(Participant)`
- `UnregisterCameraParticipant(Participant)`
- `SetCameraBounds(Bounds)`
- `ActivateSharedView(LocalControllers)`
- [Camera Participant](../Contracts/ARC-CON-080-camera-participant.md)

## Dependencies and Consumers

- Depends on contracts and local-player references supplied by Runtime/Composition.
- Player implements the participant interface.
- No dependency on resources, health, enemies, waves, or HUD state.

## Quality/Test Seam

The fixed-camera configuration is the Phase 1 baseline. Dynamic interpolation may be
tested later without changing the participant contract. A dedicated map verifies zero,
one, and two participants; opposite-corner visibility; stable controller assignment;
and split-screen disabled only after the shared view succeeds.

## Feature Requirements

- [TASK-010](../../Tasks/02-shared-camera/TASK-010-shared-camera.md)
- Integration placement in [TASK-090](../../Tasks/10-integration/TASK-090-integration.md)
