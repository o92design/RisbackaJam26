---
id: ARC-MOD-090
type: architecture-module
status: proposed
depends_on:
  - ARC-MOD-010
  - ARC-MOD-030
  - ARC-MOD-040
  - ARC-MOD-050
  - ARC-MOD-080
updated: 2026-07-29
tags:
  - architecture/module
  - ui
---

# ARC-MOD-090 — Shared HUD

[Module catalog](README.md) ·
[UI Read Model](../Contracts/ARC-CON-090-ui-read-model.md) ·
[TASK-080](../../Tasks/09-hud/TASK-080-hud.md)

## Responsibility

Present one shared-camera HUD from read-only snapshots and change events. It never owns
gameplay state.

## Proposed Assets

```text
/Game/RisbackaJam26/UI/
├── WBP_RisbackaHUD
├── WBP_DayNightStatus
├── WBP_WaveStatus
├── WBP_HomeStatus
├── WBP_WoodStatus
└── WBP_CoopStatus
```

## Public API

- `InitializeHUD(ReadSources)`
- Explicit setters local to each widget
- `UnbindHUDSources()`
- [UI Read Model](../Contracts/ARC-CON-090-ui-read-model.md)

## Dependencies and Consumers

- Reads Runtime, Cycle, Health, Resources, and Waves contracts.
- Local player 0's controller creates the HUD after composition is ready.
- Widgets must not cast to concrete source classes when an interface/read source is
  available and must not mutate gameplay.

## Quality/Test Seam

A test harness injects fake sources and representative values. Automated tests cover
binding count and updates; screenshot/manual review covers readability at target and
reduced resolutions.

## Feature Requirements

- [TASK-080](../../Tasks/09-hud/TASK-080-hud.md)
