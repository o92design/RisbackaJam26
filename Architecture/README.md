---
id: ARC-HOME
type: architecture-index
status: proposed
updated: 2026-07-29
tags:
  - architecture
  - phase-1
---

# Risbacka Architecture

This vault section describes how the Phase 1 game should be assembled. It is separate
from the player-facing [game design](../GAME_DESIGN.md) and the
[feature task board](../Tasks/README.md):

- **Game design** defines what the player experiences.
- **Feature tasks** define playable outcomes and asset ownership.
- **Architecture** defines module boundaries, public contracts, dependency direction,
  test seams, and quality gates.

The project is currently Blueprint-only. An architecture **module** therefore means a
cohesive group of Blueprint assets and responsibilities, not an Unreal C++ module.
Adding a project `Source/` directory requires a separate recorded decision.

## Start Here

1. [Architecture principles](Principles.md)
2. [System and dependency map](System-Map.md)
3. [Actor-to-module matrix](Actor-Module-Matrix.md)
4. [Feature-to-architecture crosswalk](Feature-Task-Crosswalk.md)
5. [Architecture implementation sequence](Plans/Implementation-Sequence.md)
6. [Test-driven workflow](Plans/TDD-Workflow.md)
7. [Independent review protocol](Plans/Independent-Review.md)
8. [Architecture task board](Tasks/README.md)

## Module Catalog

| ID | Module | Primary responsibility |
|---|---|---|
| [ARC-MOD-000](Modules/ARC-MOD-000-contracts.md) | Shared Contracts | Stable types, interfaces, and dependency rules |
| [ARC-MOD-010](Modules/ARC-MOD-010-runtime.md) | Runtime Coordination | Run-state transitions and terminal outcomes |
| [ARC-MOD-020](Modules/ARC-MOD-020-camera-coop.md) | Camera & Local Co-op | Local players and one shared view |
| [ARC-MOD-030](Modules/ARC-MOD-030-cycle.md) | Day/Night Cycle | Authoritative phase clock |
| [ARC-MOD-040](Modules/ARC-MOD-040-health-objectives.md) | Health & Objectives | Reusable health and objective signals |
| [ARC-MOD-050](Modules/ARC-MOD-050-resources-interaction.md) | Resources & Interaction | Wood production, carrying, and storage |
| [ARC-MOD-060](Modules/ARC-MOD-060-building.md) | Building | Placement validation and defense construction |
| [ARC-MOD-070](Modules/ARC-MOD-070-enemy-ai.md) | Enemy AI | Objective-driven boar behavior |
| [ARC-MOD-080](Modules/ARC-MOD-080-waves.md) | Waves | Spawn scheduling and living-enemy accounting |
| [ARC-MOD-090](Modules/ARC-MOD-090-ui.md) | Shared HUD | Event-driven presentation of read-only state |
| [ARC-MOD-100](Modules/ARC-MOD-100-composition.md) | World Composition | Explicit map references and initialization order |
| [ARC-MOD-110](Modules/ARC-MOD-110-verification.md) | Verification | Focused functional tests and regression gates |

## Contract Catalog

| ID | Contract | Main users |
|---|---|---|
| [ARC-CON-001](Contracts/ARC-CON-001-initialization.md) | Initialization | Composition root and every initialized module |
| [ARC-CON-010](Contracts/ARC-CON-010-run-state.md) | Run State | Coordinator, cycle, home, players, waves, HUD |
| [ARC-CON-020](Contracts/ARC-CON-020-health-damage.md) | Health & Damage | Home, fence, boar, player |
| [ARC-CON-030](Contracts/ARC-CON-030-objective-targeting.md) | Objective Targeting | Home, blockers, boar AI |
| [ARC-CON-040](Contracts/ARC-CON-040-resource-store.md) | Resource Store | Wood storage, building, HUD |
| [ARC-CON-050](Contracts/ARC-CON-050-carry-interaction.md) | Carry Interaction | Player interaction component and pickups |
| [ARC-CON-060](Contracts/ARC-CON-060-building.md) | Building | Player build component, storage, fence |
| [ARC-CON-070](Contracts/ARC-CON-070-wave-accounting.md) | Wave Accounting | Wave director, spawn points, boars |
| [ARC-CON-080](Contracts/ARC-CON-080-camera-participant.md) | Camera Participant | Players and shared camera |
| [ARC-CON-090](Contracts/ARC-CON-090-ui-read-model.md) | UI Read Model | Gameplay modules and shared HUD |

## Obsidian Conventions

- Every architecture note has a unique `id`, `type`, and `status` in frontmatter.
- Standard relative Markdown links are used because both Obsidian and GitHub resolve
  them and Obsidian includes them in the graph.
- Link to a module or contract instead of repeating its rules in another note.
- A dependency link points from the consumer to the provider.
- Task links connect architecture decisions to executable work and review evidence.
- Unreal asset paths use `/Game/...`; repository paths use relative Markdown links.

Useful graph filters:

```text
path:Architecture/Modules
path:Architecture/Contracts
path:Architecture/Tasks
tag:#architecture/module
tag:#architecture/contract
tag:#architecture/task
```
