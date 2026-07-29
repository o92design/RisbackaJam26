# Risbacka Technical Implementation Plan

This document holds implementation architecture and Unreal workflow details. The
player-facing design remains in [GAME_DESIGN.md](../GAME_DESIGN.md). Agent ownership,
dependencies, and live task status are tracked in the
[Phase 1 task board](../Tasks/README.md).

## Current Baseline

- Unreal Engine 5.8, Blueprint-only Third Person Combat template
- Existing melee attacks, health, damage, death, enemy AI, StateTree/EQS, navigation,
  enemy spawning, damage interfaces, and damageable actors
- Existing local-player creation and tagged PlayerStart selection
- Horizontal split-screen is currently enabled and must be disabled when the shared
  camera implementation lands
- Game-specific content should live below `/Game/RisbackaJam26/`; template assets
  should be duplicated or extended rather than edited in place

## Phase 1 Runtime Structure

### Game and Cycle

- `BP_GM_Risbacka`
  - Owns game rules, local-player creation, player starts, victory, and failure
  - Reuses the useful local multiplayer logic from `BP_CombatGameMode`
- `BP_DayNightManager`
  - Represents a full 24-hour in-game cycle
  - Runs a 3-minute preparation day from 06:00 to 18:00
  - Runs a 5-minute defense night from 18:00 to 06:00
  - Broadcasts phase and clock changes to gameplay systems and UI
- `BP_WaveDirector`
  - Runs three escalating waves during the five-minute night
  - Tracks living enemies and signals night completion

### Shared Camera

- `BP_SharedGameplayCamera`
  - Uses one high-angle view framing the complete active playing area
  - Becomes the view target for both local player controllers
  - May remain fixed in Phase 1; dynamic framing is optional polish
- Change `bUseSplitscreen` to `False` only when the shared camera and two-player input
  have been verified together
- Keep neighbor homes outside the Phase 1 arena
- Later neighbor-interaction candidates:
  1. Bamse or Andreas visits the homestead
  2. Phone, radio, mailbox, or delivery interaction from the homestead
  3. A separate travel/cutaway state entered from the driveway

The recommended first implementation is visits or deliveries because it protects the
single-screen play area and does not require rendering geographically distant homes.

### Wood Loop and Building

- The axe is the Phase 1 player tool and weapon
- `BP_WoodSource`
  - A marked stump, log pile, or tree proxy that accepts axe hits
  - Drops one or more `BP_WoodPickup` actors when depleted
- `BP_WoodPickup`
  - Can be carried and physically dropped by either player
- `BP_WoodStorage`
  - Detects pickups dropped inside its storage volume
  - Converts them into a shared integer wood stockpile
- `BP_FenceBase`
  - Phase 1 supports one wooden fence
  - Placement spends wood from shared storage
  - Implements the existing damage interface

Using marked wood sources avoids making full tree destruction a Phase 1 dependency.

### Home, Enemies, and Failure

- `BP_HomeStructure`
  - Main objective with health and a temporary visible damage state
  - Base destruction immediately fails the run
- `BP_BoarPlaceholder`
  - Initially adapts or extends the Combat template enemy
  - Targets the home and blocking defenses rather than prioritizing players
  - Uses placeholder presentation until the selected Fab animal assets arrive
- Player death fails single-player
- Local co-op fails when both players are dead
- Final boar physics assets and slapstick ragdolls are a later integration step

### UI

- `WBP_DayNightHUD`: phase and clock
- `WBP_WaveCounter`: current wave and enemies remaining
- `WBP_HomeStatus`: home health
- `WBP_WoodStorage`: shared stored wood
- `WBP_CoopStatus`: both player states

## Suggested Build Order

1. Create the Risbacka GameMode and prototype level without altering template originals.
2. Implement and verify the shared camera with two local players.
3. Add the damageable home and explicit failure handling.
4. Adapt a placeholder enemy to attack the home.
5. Add the wave director and five-minute night.
6. Add axe-driven wood sources, pickups, and storage.
7. Add one wooden fence and placement cost.
8. Add the three-minute day, HUD, transitions, and full-cycle completion.
9. Integrate Fab boar models and ragdoll polish after the loop is stable.

## Unreal MCP Workflow Notes

Use the focused Unreal toolsets according to the asset being changed:

- `AssetTools` for asset discovery and folder organization
- `BlueprintTools` for Blueprint creation, inspection, graphs, and compilation
- `ObjectTools` for Blueprint defaults and component/property inspection
- `ActorTools` and `SceneTools` for level actors, transforms, and scene organization
- `MaterialTools` for later home-damage and environment presentation
- `EditorAppToolset` for editor state, viewport inspection, and Play-In-Editor
- `AutomationTestToolset` for discovering and running Unreal tests

MCP tool names stay here rather than in the game design because they describe the
current production workflow, not durable player-facing rules.
