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

## Blocked on a manual editor step

Each test double must implement its contract interface before its functions can
be overridden, and interface implementation cannot be scripted — see the known
limitation in [ARCH-SUBTASK-001A](ARCH-SUBTASK-001A-shell.md). Verified again
here: `BlueprintEditorLibrary.add_function_override` returns `None` for an
unimplemented interface function, and
`PythonBPLib.set_object_property(bp, "ImplementedInterfaces", ...)` returns
`False`.

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
