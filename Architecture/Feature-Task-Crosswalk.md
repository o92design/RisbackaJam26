---
id: ARC-FEATURE-CROSSWALK
type: architecture-map
status: proposed
updated: 2026-07-29
tags:
  - architecture
  - architecture/map
  - tasks
---

# Feature Task to Architecture Crosswalk

[Architecture home](README.md) · [Feature task board](../Tasks/README.md) ·
[Architecture task board](Tasks/README.md)

The current feature tasks remain the source of player-visible acceptance criteria.
This table adds architecture prerequisites and review gates. A feature task starts
implementation only after its architecture shell and red-test subtasks are complete.
It becomes `DONE` only after the linked fresh-context review approves it.

| Feature task | Requirements | Modules | Architecture gate |
|---|---|---|---|
| [TASK-001](../Tasks/01-foundation/TASK-001-foundation.md) | Game-owned baseline, enums, thin shared assets | [Contracts](Modules/ARC-MOD-000-contracts.md), [Runtime](Modules/ARC-MOD-010-runtime.md) | [ARCH-TASK-001](Tasks/01-contracts/ARCH-TASK-001-contracts.md), [ARCH-TASK-010](Tasks/02-runtime-composition/ARCH-TASK-010-runtime-composition.md) |
| [TASK-010](../Tasks/02-shared-camera/TASK-010-shared-camera.md) | Two local players, one view, bounded arena | [Camera](Modules/ARC-MOD-020-camera-coop.md), [Composition](Modules/ARC-MOD-100-composition.md) | [ARCH-TASK-020](Tasks/03-camera/ARCH-TASK-020-camera.md) |
| [TASK-020](../Tasks/03-day-night/TASK-020-day-night.md) | Authoritative tunable phase clock | [Cycle](Modules/ARC-MOD-030-cycle.md), [Run State](Contracts/ARC-CON-010-run-state.md) | [ARCH-TASK-030](Tasks/04-cycle-waves/ARCH-TASK-030-cycle-waves.md) |
| [TASK-030](../Tasks/04-home-failure/TASK-030-home-failure.md) | Damageable home and one-shot objective failure | [Health](Modules/ARC-MOD-040-health-objectives.md), [Runtime](Modules/ARC-MOD-010-runtime.md) | [ARCH-TASK-040](Tasks/05-health-ai/ARCH-TASK-040-health-ai.md) |
| [TASK-040](../Tasks/05-wood-loop/TASK-040-wood-loop.md) | Axe, pickup, carry, deposit, shared balance | [Resources](Modules/ARC-MOD-050-resources-interaction.md) | [ARCH-TASK-050](Tasks/06-resources-building/ARCH-TASK-050-resources-building.md) |
| [TASK-050](../Tasks/06-boar-ai/TASK-050-boar-ai.md) | Objective-driven boar, blocker attack, death signal | [Enemy AI](Modules/ARC-MOD-070-enemy-ai.md), [Health](Modules/ARC-MOD-040-health-objectives.md) | [ARCH-TASK-040](Tasks/05-health-ai/ARCH-TASK-040-health-ai.md) |
| [TASK-060](../Tasks/07-wave-director/TASK-060-wave-director.md) | Three waves, generic enemy class, exact living count | [Waves](Modules/ARC-MOD-080-waves.md), [Cycle](Modules/ARC-MOD-030-cycle.md) | [ARCH-TASK-030](Tasks/04-cycle-waves/ARCH-TASK-030-cycle-waves.md) |
| [TASK-070](../Tasks/08-fence-building/TASK-070-fence-building.md) | Preview, validation, atomic spend, damageable blocker | [Building](Modules/ARC-MOD-060-building.md), [Resources](Modules/ARC-MOD-050-resources-interaction.md), [Health](Modules/ARC-MOD-040-health-objectives.md) | [ARCH-TASK-050](Tasks/06-resources-building/ARCH-TASK-050-resources-building.md) |
| [TASK-080](../Tasks/09-hud/TASK-080-hud.md) | One event-driven shared HUD | [UI](Modules/ARC-MOD-090-ui.md) plus read contracts from runtime modules | [ARCH-TASK-060](Tasks/07-ui/ARCH-TASK-060-ui.md) |
| [TASK-090](../Tasks/10-integration/TASK-090-integration.md) | Explicit map wiring and complete run | [Composition](Modules/ARC-MOD-100-composition.md), [Runtime](Modules/ARC-MOD-010-runtime.md) | [ARCH-TASK-010](Tasks/02-runtime-composition/ARCH-TASK-010-runtime-composition.md), [ARCH-TASK-070](Tasks/08-integration-review/ARCH-TASK-070-integration-review.md) |
| [TASK-100](../Tasks/11-verification/TASK-100-verification.md) | Automated regression and two-player evidence | [Verification](Modules/ARC-MOD-110-verification.md) | [ARCH-TASK-070](Tasks/08-integration-review/ARCH-TASK-070-integration-review.md) |

## Requirement Trace Rule

Every new acceptance criterion added to a feature task must identify:

1. its owning module;
2. any public contract it changes;
3. the automated or manual test proving it;
4. the independent review task that closes it.

If no module clearly owns the requirement, stop and update this architecture before
placing behavior in a convenient shared Blueprint.
