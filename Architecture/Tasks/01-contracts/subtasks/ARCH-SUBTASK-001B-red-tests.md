---
id: ARCH-SUBTASK-001B
parent: ARCH-TASK-001
stage: red-test
status: IN_PROGRESS
owner: claude-coordinator
computer: BIGBOSS
branch: task/arch-subtask-001a-contract-shells
depends_on:
  - ARCH-SUBTASK-001A
updated: 2026-07-29
tags:
  - architecture/task
  - testing
---

# ARCH-SUBTASK-001B — Prove Contract Tests Red

Parent: [ARCH-TASK-001](../ARCH-TASK-001-contracts.md) ·
[TDD workflow](../../../Plans/TDD-Workflow.md)

## Work

- Create small test doubles for damage, resource, wave, and initialization contracts.
- Create focused tests that call public APIs only.
- Assert default shell results are explicitly unimplemented/invalid.
- Record at least one expected behavior failure that TASK-001 must make green.

## Acceptance Criteria

- Test setup and asset loading succeed.
- The behavior assertion fails for the documented missing implementation.
- Failure messages name expected and actual results.
- Tests do not inspect private Blueprint variables.

## Progress

Scaffolding is in place under `/Game/RisbackaJam26/Tests/Architecture/Contracts/`:

| Asset | Kind | State |
|---|---|---|
| `BP_TD_Initializable` | Actor | Implements `BPI_RisbackaInitializable` |
| `BP_TD_Damageable` | Actor | Implements `BPI_RisbackaDamageable` |
| `BP_TD_ResourceStore` | Actor | Implements `BPI_RisbackaResourceStore` |
| `BP_TD_WaveParticipant` | Actor | Implements `BPI_RisbackaWaveParticipant` |
| `BP_ContractShellTests` | `FunctionalTest` | Four red assertions; 15 s time limit |
| `L_ContractShells` | Level | Created and lit; hosts the test actor and one of each double |

The level has a directional light, sky light, sky atmosphere, height fog, a
floor, and a player start, so the scene is visible when opened or played. Its
path maps to the automation test
`Project.Functional Tests.RisbackaJam26.Tests.Architecture.Contracts.L_ContractShells.BP_ContractShellTests`,
which is inside the filter CI already uses.

## Red test achieved

`BP_ContractShellTests` runs four focused assertions, one per contract named by
this subtask, and every one fails today for the documented missing
implementation. Run time is 0.67 s, not a timeout.

| Test | Result | Duration |
|---|---|---|
| `Project.Functional Tests.RisbackaJam26.Tests.Architecture.Contracts.L_ContractShells.BP_ContractShellTests` | `Fail` | 0.67 s |
| `Project.Functional Tests.RisbackaJam26.Tests.L_AutomationSmoke.BP_AutomationSmoke` | `Success` | 0.78 s |

Expected red output, verbatim:

```text
Expected 'ARC-CON-040 DepositWood(10) must report the new balance'
  to be {10}, but it was {0}
Expected 'ARC-CON-001 IsRisbackaInitialized must be true after InitializeRisbacka'
  to be {1}, but it was {0}
Expected 'ARC-CON-020 GetHealthSnapshot must report a configured Max health'
  to be {100.000000}, but it was {0.000000} within tolerance {0.010000}
Expected 'ARC-CON-070 ConfigureWaveParticipant must accept its first configuration'
  to be {1}, but it was {0}
```

Every message names both the expectation and the actual value. `AssertTrue` was
deliberately replaced with `AssertEqual(Bool)` for the two boolean cases,
because `AssertTrue` reports only the expectation.

The pre-existing smoke test still passes, so this changed no existing behavior.

TASK-001 must make all four green.

### Acceptance criteria

| Criterion | State |
|---|---|
| Test setup and asset loading succeed | Met — the level loads and all four doubles spawn |
| The behavior assertion fails for the documented missing implementation | Met — four failures, each naming its contract |
| Failure messages name expected and actual results | Met — see the verbatim output above |
| Tests do not inspect private Blueprint variables | Met — every call goes through a contract function; no variable reads |

### Substitution caveat

The assertions call the contract functions, but two of them resolve to the
*concrete* class rather than dispatching through the interface:
`Class|BPTDInitializable|InitializeRisbacka` and
`Class|BPTDDamageable|GetHealthSnapshot`. `SpawnActor from Class` returns a
concretely-typed reference, so Blueprint binds the call directly.

That satisfies this subtask's criteria, which require public-API calls rather
than interface dispatch specifically. It does not yet fully discharge
ARCH-TASK-001's completion gate, "test doubles prove interface substitution".
Routing the calls through an interface-typed reference is the remaining work for
that gate, and it belongs with TASK-001, when a second implementer exists to
substitute against.

## Interfaces implemented, fully scripted

All four doubles now implement their contract interface, with no manual step.
This was done through
`unreal.RisbackaBlueprintInterfaceLibrary.implement_interface`, added by the
`RisbackaEditorBridge` plugin — see
[the editor bridge guide](../../../../Docs/Risbacka-Editor-Bridge.md).

| Double | Interface | `does_class_implement_interface` |
|---|---|---|
| `BP_TD_Initializable` | `BPI_RisbackaInitializable` | `True` |
| `BP_TD_Damageable` | `BPI_RisbackaDamageable` | `True` |
| `BP_TD_ResourceStore` | `BPI_RisbackaResourceStore` | `True` |
| `BP_TD_WaveParticipant` | `BPI_RisbackaWaveParticipant` | `True` |

Verified with the engine's own `SystemLibrary.does_class_implement_interface`
rather than the plugin's return value. `add_function_override` now returns real
graphs for `RequestDamage`, `CanReceiveDamage`, and `GetHealthSnapshot`, where
it previously returned `None`.

## Superseded: the former manual editor step

Each test double must implement its contract interface before its functions can
be overridden, and interface implementation cannot be scripted — see the known
limitation in [ARCH-SUBTASK-001A](ARCH-SUBTASK-001A-shell.md).

Confirmed exhaustively rather than by spot check. A scan of all 11,304 classes
exposed by the editor's Python API found no way to implement a Blueprint
interface: every match on `interface` is a reader (`get_components_by_interface`,
`does_implement_interface`, `does_class_implement_interface`) or belongs to an
unrelated system (MetaSound, Niagara data interfaces). `FBPInterfaceDescription`
is not exposed, so `UBlueprint.ImplementedInterfaces` cannot be constructed
either. Directly retested: `BlueprintEditorLibrary.add_function_override`
returns `None` for an unimplemented interface function, and
`PythonBPLib.set_object_property(bp, "ImplementedInterfaces", ...)` returns
`False`.

TAPython does not close this gap either. Its libraries were enumerated in full -
`PythonBPLib`, `PythonBPAssetLib` (K2 nodes and schemas), `PythonScriptLibrary`,
`PythonWidgetLib` - and none expose interface implementation. TAPython grants
arbitrary editor Python, but `FBlueprintEditorUtils::ImplementNewInterface` is a
C++ static rather than a `UFUNCTION`, so neither Python glue nor `call_method`
reflection can reach it.

This is why the `RisbackaEditorBridge` plugin exists. Everything else in this
task graph continues to go through TAPython.

## Known gap

The `Marker` cube on each double is set on the placed level instances, not on
the Blueprint component template — `add_cube` created the template component but
the mesh assignment did not stick to the CDO. A double placed in a *new* level
would render invisible until its template mesh is set.

## Handoff

### Test assets

All under `/Game/RisbackaJam26/Tests/Architecture/Contracts/`:
`BP_TD_Initializable`, `BP_TD_Damageable`, `BP_TD_ResourceStore`,
`BP_TD_WaveParticipant`, `BP_ContractShellTests`, `L_ContractShells`.

### Expected red result

Four assertion failures, one per contract, each naming expected and actual.
See the verbatim block above.

### Actual result/log

Matches exactly. `BP_ContractShellTests` = `Fail` in 0.67 s with those four
errors and no warnings. `BP_AutomationSmoke` = `Success` in 0.78 s, unchanged.

### Contract change made during this subtask

Every result enum gained `Unset` at index 0. Blueprint returns the zero value
from an unimplemented function, and a struct field nobody filled in is also
zero, so the previous ordering made both silently report success — a
default-constructed `FST_RisbackaDamageResult` meant `Applied`. Verified at
runtime: `DepositWood` on a shell now returns `E_RisbackaResourceResult.UNSET`
where it previously returned `Succeeded`. This reopens ARCH-SUBTASK-001A for
re-review, since it changes assets that were already approved.

### Feature task unblocked

TASK-001, once this subtask is `DONE`. It must turn all four assertions green.

### Remaining risks

- The substitution caveat above: two calls bind to the concrete class rather
  than dispatching through the interface.
- The `Marker` mesh gap below.
- Editor crash risk: calling `LevelEditorSubsystem.load_level` from the Python
  bridge in the same script as other world work crashed the editor with
  `World Memory Leaks` (`EditorServer.cpp:2544`). Nothing was lost, but level
  switches should be their own bridge call.

### Commit
