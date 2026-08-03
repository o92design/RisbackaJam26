---
id: ARCH-SUBTASK-001A
parent: ARCH-TASK-001
stage: shell
status: REVIEW_READY
owner: claude-coordinator
computer: BIGBOSS
branch: master
base_commit: 11e717d
updated: 2026-08-03
tags:
  - architecture/task
---

# ARCH-SUBTASK-001A — Create Contract Shells

Parent: [ARCH-TASK-001](../ARCH-TASK-001-contracts.md) ·
[Contract catalog](../../../Contracts/README.md)

## Work

- Create the contract folder structure.
- Create every proposed interface, enum, and struct with documented names/signatures.
- Keep defaults explicit and nonfunctional.
- Add Blueprint categories/tooltips and compile each asset.
- Record any signature change in the linked contract note before consumers exist.

## Acceptance Criteria

- All contract assets compile without new warnings.
- `E_RisbackaPhase` contains only `Day` and `Night`.
- Run outcome uses `E_RisbackaRunState`.
- No contract references a concrete home, player, boar, fence, storage, widget, or map.

## Handoff

### Changed assets

All under `/Game/RisbackaJam26/Core/Contracts/`. The eight enums and nine structs
were already present at base commit `11e717d`; this subtask added the seven
interfaces and three components:

| Asset | Parent | Contract |
|---|---|---|
| `BPI_RisbackaInitializable` | `Interface` | ARC-CON-001 |
| `BPI_RisbackaDamageable` | `Interface` | ARC-CON-020 |
| `BPI_RisbackaObjective` | `Interface` | ARC-CON-030 |
| `BPI_RisbackaResourceStore` | `Interface` | ARC-CON-040 |
| `BPI_RisbackaCarryable` | `Interface` | ARC-CON-050 |
| `BPI_RisbackaWaveParticipant` | `Interface` | ARC-CON-070 |
| `BPI_RisbackaCameraParticipant` | `Interface` | ARC-CON-080 |
| `BPC_Health` | `ActorComponent` | ARC-CON-020 |
| `BPC_CarryInteractor` | `ActorComponent` | ARC-CON-050 |
| `BPC_BuildMode` | `ActorComponent` | ARC-CON-060 |

No other path was touched. ARC-CON-010 and ARC-CON-090 declare no new assets at
this stage: the run-state enums already exist, and the UI read model is a set of
read functions on producers created by later tasks.

### Signature deviations

Recorded here before any consumer exists, per the subtask rules.

- `ValidateRisbackaConfiguration` returns `IsValid: bool` and
  `Errors: string[]`.
- `GetHealthSnapshot` returns three outputs (`Current`, `Max`, `IsDestroyed`)
  rather than a snapshot struct.
- `CanBeginCarry` returns `CanBeginCarry: bool` plus
  `Reason: E_RisbackaCarryResult`.
- `BeginCarry` takes `AttachTarget: SceneComponent`.
- `ConfigureWaveParticipant` and `GetWaveToken` use `Guid` for `WaveToken`,
  matching `FST_RisbackaSpawnResult.WaveToken`.
- `ConfigureWaveParticipant` returns `Configured: bool` so a duplicate
  configuration is observable instead of silent.
- `ReportWaveParticipantFinished` takes `Reason: Name`, consistent with the
  existing `FST_RisbackaResourceChange.Reason` and
  `FST_RisbackaDamageRequest.DamagePurpose`. No new enum was introduced.
- Boolean outputs drop the `b` prefix because Blueprint pin names are display
  names.
- `BPC_BuildMode` exposes an `OnPlacementCommitted` dispatcher so a committed
  placement is a completed-state event rather than a polled result.

### Compile result

All ten Blueprints report `BS_UP_TO_DATE` after an explicit recompile. No
errors and no warnings were raised.

### Verification

- `AssetTools.find_assets` on `/Game/RisbackaJam26/Core/Contracts` returns all
  27 contract assets.
- `AssetTools.get_asset_class` returns `BPI_RisbackaInitializable_C`,
  `BPI_RisbackaCarryable_C`, and `BPC_Health_C`.
- Every function graph was re-read through `BlueprintGraphEditor` and each
  entry/result pin name and type was compared against the contract notes. No
  duplicate or misnamed parameter remains.
- `E_RisbackaPhase` contains exactly `Day` and `Night`; run outcome uses
  `E_RisbackaRunState`.
- No contract asset references a concrete home, player, boar, fence, storage,
  widget, or map type. The only object/class references are `Actor`,
  `SceneComponent`, and engine structs.

### Known limitation

The editor exposes no scripted way to make a Blueprint *implement* a Blueprint
interface: `UBlueprint.ImplementedInterfaces` is not script-visible and
`FBPInterfaceDescription` is not exposed to Python, so neither the MCP
`BlueprintTools` nor `BlueprintEditorLibrary` can add one. The interface shells
themselves are complete and correct, but any Blueprint that must implement one —
including the ARCH-SUBTASK-001B test doubles — needs the interface added by hand
in the Class Settings panel before its functions can be overridden.

- Commit:
