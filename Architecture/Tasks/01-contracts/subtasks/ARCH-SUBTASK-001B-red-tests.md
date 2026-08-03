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
| `BP_TD_Initializable` | Actor | Created; interface not yet implemented |
| `BP_TD_Damageable` | Actor | Created; interface not yet implemented |
| `BP_TD_ResourceStore` | Actor | Created; interface not yet implemented |
| `BP_TD_WaveParticipant` | Actor | Created; interface not yet implemented |
| `BP_ContractShellTests` | `FunctionalTest` | Created; no assertions yet |
| `L_ContractShells` | Level | Created and lit; hosts the test actor and one of each double |

The level has a directional light, sky light, sky atmosphere, height fog, a
floor, and a player start, so the scene is visible when opened or played. Its
path maps to the automation test
`Project.Functional Tests.RisbackaJam26.Tests.Architecture.Contracts.L_ContractShells.BP_ContractShellTests`,
which is inside the filter CI already uses.

## Harness verified, but not yet a valid red test

`AutomationTestToolset.ListTests` discovers both tests, and `RunTests`
executed them:

| Test | Result | Duration |
|---|---|---|
| `Project.Functional Tests.RisbackaJam26.Tests.L_AutomationSmoke.BP_AutomationSmoke` | `Success` | 0.68 s |
| `Project.Functional Tests.RisbackaJam26.Tests.Architecture.Contracts.L_ContractShells.BP_ContractShellTests` | `Fail` | 60.44 s |

This confirms the scaffolding: the new level is discovered at the expected
automation path, loads, runs as a functional test, and reports back.

The failure is **not** the red result this subtask requires. Its only error is
`FinishTest TestResult=Failed. Time's Up.. Test timed out in 60,008 seconds` —
`BP_ContractShellTests` has no assertions and no `Finish Test` node, so it ran
until the timeout. The acceptance criteria require a behavior assertion that
fails for the documented missing implementation, with a message naming expected
and actual results. A timeout satisfies neither.

Lower the actor's test timeout once real assertions exist, so a genuine hang
does not cost 60 s per run.

## Blocked on a manual editor step

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

TAPython does not close this gap. Its libraries were enumerated in full —
`PythonBPLib`, `PythonBPAssetLib` (K2 nodes and schemas), `PythonScriptLibrary`,
`PythonWidgetLib` — and none expose interface implementation. TAPython grants
arbitrary editor Python, but `FBlueprintEditorUtils::ImplementNewInterface` is a
C++ static rather than a `UFunction`, so neither Python glue nor
`call_method` reflection can reach it. Everything else in this task graph should
continue to go through TAPython.

Required, once per double, in Class Settings → Interfaces → Add:

| Double | Interface |
|---|---|
| `BP_TD_Initializable` | `BPI_RisbackaInitializable` |
| `BP_TD_Damageable` | `BPI_RisbackaDamageable` |
| `BP_TD_ResourceStore` | `BPI_RisbackaResourceStore` |
| `BP_TD_WaveParticipant` | `BPI_RisbackaWaveParticipant` |

After that, the remaining work is scriptable: add the interface function
overrides returning explicit unimplemented/invalid defaults, write the focused
assertions in `BP_ContractShellTests`, and record the red run.

## Known gap

The `Marker` cube on each double is set on the placed level instances, not on
the Blueprint component template — `add_cube` created the template component but
the mesh assignment did not stick to the CDO. A double placed in a *new* level
would render invisible until its template mesh is set.

## Handoff

- Test assets:
- Expected red result:
- Actual result/log:
- Feature task unblocked:
- Commit:
