---
id: ARC-CON-080
type: architecture-contract
status: proposed
depends_on:
  - ARC-CON-001
updated: 2026-07-29
tags:
  - architecture/contract
  - camera
---

# ARC-CON-080 — Camera Participant

[Contract catalog](README.md) ·
[Camera & Local Co-op](../Modules/ARC-MOD-020-camera-coop.md)

## Purpose

Let the shared camera frame active players without depending on a specific player
Blueprint or querying all pawns every frame.

## Proposed Asset

- `BPI_RisbackaCameraParticipant`

## Interface Functions

| Function | Outputs | Rule |
|---|---|---|
| `GetCameraFocusLocation` | Vector | Stable world-space focus point |
| `IsCameraParticipantActive` | Boolean | False for dead/despawned/inactive players |
| `GetCameraFocusWeight` | Float | Defaults to `1.0`; optional future tuning |

Participants register and unregister explicitly. The camera may Tick to interpolate
and calculate framing from its small registered set. It must not use a world-wide
actor search on Tick.

## Test Obligations

- Two registered players are included.
- Removing or killing one participant updates framing safely.
- Zero participants uses a documented fallback.
- The full defined camera bounds remain visible in the fixed Phase 1 mode.
