---
id: ARC-ACTOR-MATRIX
type: architecture-map
status: proposed
updated: 2026-07-29
tags:
  - architecture
  - architecture/map
---

# Actor-to-Module Matrix

[Architecture home](README.md) · [System map](System-Map.md) ·
[Contract catalog](Contracts/README.md)

“Uses” means the actor may call the linked module's public contract. It does not grant
permission to edit that module's private assets.

| Actor / asset | Owned by | Uses | Required contracts/components |
|---|---|---|---|
| `BP_GM_Risbacka` | [Runtime](Modules/ARC-MOD-010-runtime.md) | [Composition](Modules/ARC-MOD-100-composition.md), [Camera](Modules/ARC-MOD-020-camera-coop.md) | [Initialization](Contracts/ARC-CON-001-initialization.md) |
| `BP_RunCoordinator` | [Runtime](Modules/ARC-MOD-010-runtime.md) | Cycle, health/objectives, waves | [Run State](Contracts/ARC-CON-010-run-state.md) |
| `BP_PC_Risbacka` | [Camera](Modules/ARC-MOD-020-camera-coop.md) | Camera, UI | Camera participant registration; creates shared HUD only for local player 0 |
| `BP_Player_Risbacka` | Runtime/Characters shell | Camera, resources, building, health | `BPC_CarryInteractor`, `BPC_BuildMode`, camera participant, player-life signal |
| `BP_SharedGameplayCamera` | [Camera](Modules/ARC-MOD-020-camera-coop.md) | Camera participants | [Camera Participant](Contracts/ARC-CON-080-camera-participant.md) |
| `BP_CameraBounds` | [Camera](Modules/ARC-MOD-020-camera-coop.md) | None | Defines the complete Phase 1 play area |
| `BP_DayNightManager` | [Cycle](Modules/ARC-MOD-030-cycle.md) | Shared contracts | [Run State](Contracts/ARC-CON-010-run-state.md) phase events |
| `BPC_Health` | [Health](Modules/ARC-MOD-040-health-objectives.md) | Shared contracts | [Health & Damage](Contracts/ARC-CON-020-health-damage.md) |
| `BP_HomeStructure` | [Health](Modules/ARC-MOD-040-health-objectives.md) | `BPC_Health` | Health/damage and [Objective](Contracts/ARC-CON-030-objective-targeting.md) |
| `BP_WoodSource` | [Resources](Modules/ARC-MOD-050-resources-interaction.md) | Health/damage | Accepts axe damage; produces configured pickups once |
| `BP_WoodPickup` | [Resources](Modules/ARC-MOD-050-resources-interaction.md) | Carry interaction | [Carry](Contracts/ARC-CON-050-carry-interaction.md) |
| `BP_WoodStorage` | [Resources](Modules/ARC-MOD-050-resources-interaction.md) | Carry interaction | [Resource Store](Contracts/ARC-CON-040-resource-store.md) |
| `BPC_CarryInteractor` | [Resources](Modules/ARC-MOD-050-resources-interaction.md) | Carryable actors | [Carry](Contracts/ARC-CON-050-carry-interaction.md) |
| `BPC_BuildMode` | [Building](Modules/ARC-MOD-060-building.md) | Resource store, fence class | [Building](Contracts/ARC-CON-060-building.md) |
| `BP_FenceBase` | [Building](Modules/ARC-MOD-060-building.md) | Health | Health/damage and objective/blocker semantics |
| `BP_BoarPlaceholder` | [Enemy AI](Modules/ARC-MOD-070-enemy-ai.md) | Health, objective, wave accounting | Damage, objective, wave contracts |
| `BP_AIController_Boar` | [Enemy AI](Modules/ARC-MOD-070-enemy-ai.md) | Explicit assigned target | [Objective Targeting](Contracts/ARC-CON-030-objective-targeting.md) |
| `ST_BoarObjective` | [Enemy AI](Modules/ARC-MOD-070-enemy-ai.md) | Controller context | No world searches; acts on supplied target |
| `BP_WaveDirector` | [Waves](Modules/ARC-MOD-080-waves.md) | Spawn points and wave participants | [Wave Accounting](Contracts/ARC-CON-070-wave-accounting.md) |
| `BP_WaveSpawnPoint` | [Waves](Modules/ARC-MOD-080-waves.md) | Configured enemy class | Spawn request/result contract |
| `WBP_RisbackaHUD` | [UI](Modules/ARC-MOD-090-ui.md) | Runtime, cycle, health, resource, wave sources | [UI Read Model](Contracts/ARC-CON-090-ui-read-model.md) |
| `BP_RisbackaWorldBootstrap` | [Composition](Modules/ARC-MOD-100-composition.md) | All top-level systems | [Initialization](Contracts/ARC-CON-001-initialization.md) |
| `BP_FT_*` / `L_FT_*` | [Verification](Modules/ARC-MOD-110-verification.md) | Module public APIs | Test-only configuration and observation |

## Component Rule for Shared Player Asset

The player Blueprint is a merge hotspot. Feature behavior belongs in components:

```text
BP_Player_Risbacka
├── existing movement and melee shell
├── BPC_Health or an adapter to the retained Combat health path
├── BPC_CarryInteractor
└── BPC_BuildMode
```

The player graph should only forward input and lifecycle events. Components own the
feature state and can be tested outside the final player Blueprint.
