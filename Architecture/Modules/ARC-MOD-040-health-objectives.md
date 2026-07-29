---
id: ARC-MOD-040
type: architecture-module
status: proposed
depends_on:
  - ARC-MOD-000
updated: 2026-07-29
tags:
  - architecture/module
  - health
  - objectives
---

# ARC-MOD-040 — Health and Objectives

[Module catalog](README.md) ·
[Health Contract](../Contracts/ARC-CON-020-health-damage.md) ·
[Objective Contract](../Contracts/ARC-CON-030-objective-targeting.md)

## Responsibility

Own reusable health/damage behavior and the main-objective signal. It reports
destruction; it does not decide the run screen or AI schedule.

## Proposed Assets

```text
/Game/RisbackaJam26/Core/Health/BPC_Health
/Game/RisbackaJam26/Home/BP_HomeStructure
```

Feature actors in Building and Enemies adopt the component or a reviewed adapter.

## Public API

- [Health & Damage](../Contracts/ARC-CON-020-health-damage.md)
- [Objective Targeting](../Contracts/ARC-CON-030-objective-targeting.md)
- `OnObjectiveDestroyed(Objective)` on the home, fired once

## Dependencies and Consumers

- Depends only on shared contracts.
- Runtime observes home destruction.
- Enemy AI sees an objective interface and damageable blockers.
- UI observes health snapshots/events.
- Home has no references to Runtime, AI, Waves, or UI.

## Quality/Test Seam

Dedicated tests apply controlled damage to reusable component hosts and the home.
Threshold visuals are presentation layered on health state; visual state must not own
health. Tests cover overkill, repeated damage, reset, and one-shot destruction.

## Feature Requirements

- [TASK-030](../../Tasks/04-home-failure/TASK-030-home-failure.md)
- Adopted by [TASK-050](../../Tasks/06-boar-ai/TASK-050-boar-ai.md) and
  [TASK-070](../../Tasks/08-fence-building/TASK-070-fence-building.md)
