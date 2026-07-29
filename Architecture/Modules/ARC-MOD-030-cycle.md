---
id: ARC-MOD-030
type: architecture-module
status: proposed
depends_on:
  - ARC-MOD-000
updated: 2026-07-29
tags:
  - architecture/module
  - time
---

# ARC-MOD-030 — Day/Night Cycle

[Module catalog](README.md) · [Run State Contract](../Contracts/ARC-CON-010-run-state.md) ·
[TASK-020](../../Tasks/03-day-night/TASK-020-day-night.md)

## Responsibility

Own the authoritative 24-hour display clock and the Day/Night phase boundary. It does
not spawn enemies, decide run success, or update widgets directly.

## Proposed Assets

```text
/Game/RisbackaJam26/Cycle/
├── BP_DayNightManager
└── DA_DayNightConfig
```

## Public API

- `InitializeCycle(Config)`
- `StartCycle()`, `PauseCycle()`, `ResetCycle()`
- `SetTimeScaleForTest(Scale)`
- `GetPhaseSnapshot()`
- `OnPhaseChanged(Previous, Current)`
- `OnClockUpdated(DisplayHour, NormalizedPhaseProgress)`

## Dependencies and Consumers

- Depends only on shared types and initialization.
- Runtime observes phase facts.
- Waves observes Night start through an injected binding.
- HUD observes read functions/events.
- It has no concrete references to WaveDirector or widgets.

## Quality/Test Seam

Use duration injection rather than graph edits. Tests cover 06:00 → 18:00 in configured
day duration, 18:00 → 06:00 in configured night duration, one event per boundary,
pause/resume, and accelerated reset.

## Feature Requirements

- [TASK-020](../../Tasks/03-day-night/TASK-020-day-night.md)
- Consumed by [TASK-060](../../Tasks/07-wave-director/TASK-060-wave-director.md),
  [TASK-080](../../Tasks/09-hud/TASK-080-hud.md), and
  [TASK-090](../../Tasks/10-integration/TASK-090-integration.md)
