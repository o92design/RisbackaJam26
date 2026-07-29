---
id: ARC-SYSTEM-MAP
type: architecture-map
status: proposed
updated: 2026-07-29
tags:
  - architecture
  - architecture/map
---

# System and Dependency Map

[Architecture home](README.md) · [Actor matrix](Actor-Module-Matrix.md) ·
[Feature crosswalk](Feature-Task-Crosswalk.md)

## Runtime Dependency Direction

Arrows mean “depends on.” Modules may depend downward but should not create a reverse
dependency.

```mermaid
flowchart TD
    Composition["ARC-MOD-100 World Composition"]
    Runtime["ARC-MOD-010 Runtime Coordination"]
    Camera["ARC-MOD-020 Camera & Local Co-op"]
    Cycle["ARC-MOD-030 Day/Night Cycle"]
    Health["ARC-MOD-040 Health & Objectives"]
    Resources["ARC-MOD-050 Resources & Interaction"]
    Building["ARC-MOD-060 Building"]
    Enemy["ARC-MOD-070 Enemy AI"]
    Waves["ARC-MOD-080 Waves"]
    UI["ARC-MOD-090 Shared HUD"]
    Contracts["ARC-MOD-000 Shared Contracts"]
    Verification["ARC-MOD-110 Verification"]

    Composition --> Runtime
    Composition --> Camera
    Composition --> Cycle
    Composition --> Health
    Composition --> Resources
    Composition --> Building
    Composition --> Enemy
    Composition --> Waves
    Composition --> UI

    Runtime --> Cycle
    Runtime --> Health
    Runtime --> Waves
    Building --> Resources
    Building --> Health
    Enemy --> Health
    Enemy --> Contracts
    Waves --> Enemy
    UI --> Runtime
    UI --> Cycle
    UI --> Health
    UI --> Resources
    UI --> Waves

    Runtime --> Contracts
    Camera --> Contracts
    Cycle --> Contracts
    Health --> Contracts
    Resources --> Contracts
    Building --> Contracts
    Waves --> Contracts
    UI --> Contracts

    Verification -. tests .-> Composition
    Verification -. tests .-> Runtime
    Verification -. tests .-> Camera
    Verification -. tests .-> Cycle
    Verification -. tests .-> Health
    Verification -. tests .-> Resources
    Verification -. tests .-> Building
    Verification -. tests .-> Enemy
    Verification -. tests .-> Waves
    Verification -. tests .-> UI
```

## Allowed Dependency Table

| Consumer | Allowed providers | Forbidden direct knowledge |
|---|---|---|
| [Runtime](Modules/ARC-MOD-010-runtime.md) | Contracts, cycle, objective/player/wave signals | HUD widgets, AI graphs, storage internals |
| [Camera](Modules/ARC-MOD-020-camera-coop.md) | Camera participant contract | Resources, waves, health |
| [Cycle](Modules/ARC-MOD-030-cycle.md) | Shared contracts | Wave implementation, HUD |
| [Health](Modules/ARC-MOD-040-health-objectives.md) | Shared contracts | Run coordinator and HUD |
| [Resources](Modules/ARC-MOD-050-resources-interaction.md) | Health/damage and carry contracts | Building preview and HUD |
| [Building](Modules/ARC-MOD-060-building.md) | Resource store, health/damage | Concrete wood-storage graph |
| [Enemy AI](Modules/ARC-MOD-070-enemy-ai.md) | Objective and damage contracts | Run coordinator, wave schedule, HUD |
| [Waves](Modules/ARC-MOD-080-waves.md) | Wave accounting, configurable enemy class | Concrete boar behavior, cycle clock internals |
| [HUD](Modules/ARC-MOD-090-ui.md) | Read-only functions and dispatchers | Gameplay mutation and Tick polling |
| [Composition](Modules/ARC-MOD-100-composition.md) | Concrete top-level system references | Feature business logic |

## Event Flow for One Run

```mermaid
sequenceDiagram
    participant Bootstrap as BP_RisbackaWorldBootstrap
    participant Run as BP_RunCoordinator
    participant Cycle as BP_DayNightManager
    participant Waves as BP_WaveDirector
    participant Home as BP_HomeStructure
    participant HUD as WBP_RisbackaHUD

    Bootstrap->>Run: Initialize(context)
    Bootstrap->>Cycle: Initialize(config)
    Bootstrap->>Waves: Initialize(spawn points, enemy class)
    Bootstrap->>HUD: Initialize(read sources)
    Bootstrap->>Run: StartRun()
    Run->>Cycle: StartCycle()
    Cycle-->>Run: OnPhaseChanged(Day)
    Cycle-->>Waves: OnPhaseChanged(Night)
    Waves-->>Run: OnAllWavesCleared()
    Home-->>Run: OnObjectiveDestroyed()
    Run-->>HUD: OnRunStateChanged()
```

Only one terminal signal wins. `BP_RunCoordinator` ignores later success/failure
requests after entering a terminal state.

## Circular-Dependency Check

The following are architecture failures:

- Home calls GameMode to fail the run.
- Boar calls WaveDirector by searching the world.
- Fence casts to `BP_WoodStorage` instead of using the resource-store contract.
- HUD calls commands that mutate gameplay state.
- DayNightManager directly starts concrete boar spawns.
- Feature actors discover each other independently after composition.
