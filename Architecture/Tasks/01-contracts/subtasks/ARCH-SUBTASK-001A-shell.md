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

Each item below is now also written into its contract note, per the subtask
rule that a signature change is recorded before consumers exist. Items that
merely make an already-documented signature concrete are not listed.

Added API not named in the contract notes:

- `ConfigureWaveParticipant` returns `Configured: bool` and
  `ReportWaveParticipantFinished` returns `Accepted: bool`, so a duplicate
  configuration or a duplicate completion report is observable to a test
  instead of silently absorbed. (ARC-CON-070)
- `BPC_BuildMode` exposes an `OnPlacementCommitted` dispatcher so a committed
  placement is a completed-state event rather than a polled result.
  (ARC-CON-060)
- `BPC_CarryInteractor`'s whole API is new: `TryBeginCarry`, `TryEndCarry`,
  `GetCarriedActor`, the `CarriedActor` / `AttachTarget` variables, and the
  `OnCarryStarted` / `OnCarryEnded` dispatchers. ARC-CON-050 described the
  component only in prose. (ARC-CON-050)

Type choices the contract notes left open:

- `WaveToken` is a `Guid`, matching `FST_RisbackaSpawnResult.WaveToken`.
- `ReportWaveParticipantFinished` takes `Reason: Name`, consistent with the
  existing `FST_RisbackaResourceChange.Reason` and
  `FST_RisbackaDamageRequest.DamagePurpose`. No new enum was introduced.
- `CanBeginCarry`'s "reason" output is typed `E_RisbackaCarryResult`, reusing
  the command result vocabulary.
- `BeginCarry`'s "attach target" is typed `SceneComponent`.
- `BPC_BuildMode.BeginPlacement(Store)` and
  `BPI_RisbackaCarryable.ConsumeAfterDeposit(Storage)` are typed as raw `Actor`
  in this shell. They become interface-typed pins once a Blueprint implements
  `BPI_RisbackaResourceStore`; see the known limitation below.
- `BPC_BuildMode` returns the bare `E_RisbackaPlacementResult` from
  `BeginPlacement` / `UpdatePlacement` but the full
  `FST_RisbackaPlacementResult` from `TryCommitPlacement` /
  `GetPlacementResult`, because only validity matters while previewing.

Naming:

- Boolean pins drop the `b` prefix because Blueprint pin names are display
  names. The pre-existing structs keep `bWasDestroyed` / `bSucceeded`, so the
  two conventions coexist by layer: `b`-prefixed struct fields, unprefixed
  pins.
- `ResetHealthForTest` lives on `BPC_Health` only, not on
  `BPI_RisbackaDamageable`, to keep the test seam off the production contract.
  An adapter that implements the interface without the component therefore has
  no scripted reset seam; ARCH-SUBTASK-001B must account for that.

### Compile result

All ten Blueprints report `BS_UP_TO_DATE` after an explicit recompile. No
errors and no warnings were raised.

### Verification

- The seven `BPI_` assets are true Blueprint Interfaces. The saved `.uasset`
  bytes contain `BPTYPE_Interface` and no `EventGraph`, matching the template's
  working `/Game/Variant_Combat/Blueprints/BPI_Damageable`. The three `BPC_`
  assets are `BPTYPE_Normal` with an `ActorComponent` parent, as intended.
  This check replaces `get_asset_class`, which returns a `_C` name for any
  Blueprint and cannot distinguish an interface.
- `AssetTools.find_assets` on `/Game/RisbackaJam26/Core/Contracts` returns all
  27 contract assets.
- Every function graph was re-read through `BlueprintGraphEditor` and each
  entry/result pin name, type, direction, and order was compared against the
  contract notes. No duplicate or numerically suffixed parameter remains.
- `E_RisbackaPhase` contains exactly `Day` and `Night`; run outcome uses
  `E_RisbackaRunState`.
- No contract asset references a concrete home, player, boar, fence, storage,
  widget, or map type. The only object/class references are `Actor`,
  `SceneComponent`, and engine structs.

### Known limitation

The editor exposes no scripted way to make a Blueprint *implement* an
interface: `UBlueprint.ImplementedInterfaces` is not script-visible,
`FBPInterfaceDescription` is not exposed to Python, and neither
`BlueprintEditorLibrary`, `BlueprintGraphEditor`, `PythonBPLib`, nor the MCP
`BlueprintTools` exposes any matching call. Implementation must be added by
hand in Class Settings → Implemented Interfaces.

That manual step is viable because these are real `BPTYPE_Interface` assets and
therefore appear in the Class Settings picker. An earlier revision of this
subtask created them as ordinary Blueprints parented to `UInterface`, which
looked correct by name and generated-class but could not be implemented at all;
independent review caught it and the seven assets were rebuilt with
`BlueprintInterfaceFactory`.

ARCH-SUBTASK-001B must budget for one manual interface assignment per test
double before its functions can be overridden.

### Not verifiable with current tooling

- Function-level Category and Tooltip metadata. `K2Node_FunctionEntry.MetaData`
  is protected in Python and no reader exists. Variable categories *were* set
  and verified (`Risbacka|Health`, `Risbacka|Carry`, `Risbacka|Building`),
  including on dispatchers.
- Function purity. `BlueprintGraphEditor.set_is_pure_function` was called for
  `GetHealthSnapshot`, `GetCarriedActor`, and `GetPlacementResult`, but there
  is no read API to confirm it, so no claim is made.

- Commit:
