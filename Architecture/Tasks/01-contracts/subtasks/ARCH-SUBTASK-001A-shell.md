---
id: ARCH-SUBTASK-001A
parent: ARCH-TASK-001
stage: shell
status: REVIEW_READY
owner: root_implementer
computer: DESKTOP-2KFO48U
context: /root
branch: codex/arch-001a-contract-shells-v2
worktree: .cache/worktrees/arch-001a-v2
base_sha: 6a5c8149f4751d6a283fd1b81375d6be09396dd9
implementation_commit: 528d035ec7152fc0fdd62a152e4833a50bf59ecc
updated: 2026-08-01
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

- Changed assets: the final contract root contains exactly 24 assets in the
  claimed `Enums`, `Structs`, and `Interfaces` folders: eight user-defined
  enums, nine user-defined structs, and seven Blueprint interfaces. The 17
  pre-existing flat enum/struct assets were removed after their normalized
  contract-folder versions were added. No component, dispatcher, test,
  consumer, map, GameMode, or concrete feature asset was created.
- Signature deviations: under-specified references use generic `Actor`,
  `Object`, actor-class, `Name`, `Transform`, and primitive types. Invalid,
  rejected, or non-operational enum values are first where applicable.
  `E_RisbackaPhase` is exactly `Day` and `Night`; run outcomes remain in
  `E_RisbackaRunState`. `ResetHealthForTest` is intentionally reserved for the
  later health component. Store/change dispatchers remain on later concrete
  owners rather than Blueprint interfaces.
- Compile result: the UE 5.8 `CompileAllBlueprints` commandlet returned result
  zero. All seven contract interfaces compiled successfully and the log
  contained zero Blueprint compile failures. A separate reload verifier
  checked all 24 asset classes, enum values, struct fields/descriptions,
  expected interface function names, old-path absence, and package
  dependencies; it returned
  `RISBACKA_CONTRACT_VERIFY_SUCCESS assets=24 failures=0`. No contract package
  references a `/Game` package outside the contract root. Headless startup
  emitted the known worktree-local TAPython configuration/path warnings; the
  contract compiler emitted no new warning.
- Validation: `Scripts/Test-AgentTaskGraph.ps1` passed with 40 nodes and 120
  milestone vertices. `Scripts/CI/Test-Project.ps1` completed successfully.
  This shell-only task adds no runtime behavior, so no behavioral red/green
  test applies; `ARCH-SUBTASK-001B` owns the contract red tests.
- Git/LFS: the final scope diff contains only the 24 claimed final assets and
  removal of the 17 claimed flat duplicates. `git lfs locks` reports one
  existing lock owned by `o92design` on the old flat
  `E_RisbackaCarryResult.uasset`; no other contract lock was reported.
- Commit: `528d035ec7152fc0fdd62a152e4833a50bf59ecc`
