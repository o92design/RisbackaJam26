---
id: ARCH-SUBTASK-001B
parent: ARCH-TASK-001
stage: test-fixture
status: IN_PROGRESS
owner: root_implementer
computer: DESKTOP-2KFO48U
context: /root
branch: codex/arch-001b-contract-fixtures
worktree: .cache/worktrees/arch-001b-contract-fixtures
base_sha: ce2af3e7f3d7d4e86e457c1839f19cbe6d1eb949
depends_on:
  - ARCH-SUBTASK-001A
updated: 2026-08-02
tags:
  - architecture/task
  - testing
---

# ARCH-SUBTASK-001B — Create Contract Test Fixtures

Parent: [ARCH-TASK-001](../ARCH-TASK-001-contracts.md) ·
[TDD workflow](../../../Plans/TDD-Workflow.md)

## Work

- Create small test doubles for damage, resource, wave, and initialization contracts.
- Create focused Functional Tests that call public APIs only.
- Assert the fixtures return explicit, deterministic invalid defaults.
- Prove interface substitution through generic object references without concrete casts.
- Keep the genuine TASK-001 behavior-red coverage in ARCH-SUBTASK-010B, after
  ARCH-SUBTASK-010A creates the runtime and composition shells.

## Test Content Layout

```text
/Game/RisbackaJam26/Tests/
├── BP_AutomationSmoke                 existing; do not modify
├── L_AutomationSmoke                  existing; do not modify
└── Architecture/
    ├── Contracts/
    │   ├── Doubles/
    │   │   ├── BP_TD_Initializable_DefaultInvalid
    │   │   ├── BP_TD_Damageable_DefaultRejected
    │   │   ├── BP_TD_ResourceStore_DefaultInvalid
    │   │   └── BP_TD_WaveParticipant_DefaultUnconfigured
    │   ├── Functional/
    │   │   ├── BP_FT_Contracts_InitializationDefaults
    │   │   ├── BP_FT_Contracts_DamageDefaults
    │   │   ├── BP_FT_Contracts_ResourceDefaults
    │   │   └── BP_FT_Contracts_WaveDefaults
    │   └── Maps/
    │       └── L_FT_Contracts_Defaults
    └── Runtime/                       reserved for ARCH-SUBTASK-010B
```

`Doubles` contains reusable interface implementations without assertions.
`Functional` contains the setup, public calls, assertions, cleanup, and finish
results. `Maps` contains discovery levels only. The dependency direction is:

```text
Maps -> Functional Tests -> Test Doubles -> Core/Contracts
```

No asset is stored directly in the `Contracts` folder. No fixture may reference a
feature implementation or `/Game/Variant_Combat`.

## Acceptance Criteria

- Test setup and asset loading succeed after an Editor restart.
- Four focused tests pass twice and exercise every function on their assigned interface.
- Invalid-default assertions name expected and actual results.
- Tests use generic object references and interface messages only; they do not inspect
  private Blueprint variables or cast to a concrete double.
- Existing smoke-test assets remain unchanged and the repository regression suite passes.

## Handoff

- Test assets: the four doubles, four Functional Tests, and discovery map listed
  in `Test Content Layout` above; no other Unreal asset changed.
- Exact focused tests:
  - `Project.Functional Tests.RisbackaJam26.Tests.Architecture.Contracts.Maps.L_FT_Contracts_Defaults.FT_Contracts_DamageDefaults`
  - `Project.Functional Tests.RisbackaJam26.Tests.Architecture.Contracts.Maps.L_FT_Contracts_Defaults.FT_Contracts_InitializationDefaults`
  - `Project.Functional Tests.RisbackaJam26.Tests.Architecture.Contracts.Maps.L_FT_Contracts_Defaults.FT_Contracts_ResourceDefaults`
  - `Project.Functional Tests.RisbackaJam26.Tests.Architecture.Contracts.Maps.L_FT_Contracts_Defaults.FT_Contracts_WaveDefaults`
- Focused result: clean-session run 1 passed 4/4 in 1.661109 seconds; run 2
  passed 4/4 in 1.256455 seconds, with no warnings or failures.
- Regression result: unchanged automation smoke passed 1/1; `.\Test.ps1`
  passed 5/5 Functional Tests with project validation successful.
- Blueprint verification: all eight Blueprints compiled with warnings treated as
  errors; all nine assets were independently found and class-checked before and
  after an Editor restart.
- Dependency inspection: `Maps -> Functional Tests -> Test Doubles ->
  Core/Contracts`, plus engine packages only; no feature implementation or
  `/Game/Variant_Combat` dependency.
- Graph/project validation: `Scripts/Test-AgentTaskGraph.ps1` passed with 40
  nodes and 120 milestones; `Scripts/CI/Test-Project.ps1` passed.
- Behavioral red intentionally delegated to ARCH-SUBTASK-010B.
- Feature task unblocked: `TASK-001` after the required independent review marks
  this subtask `DONE`.
- Immutable implementation commit:
  `d606a77a16490acdb82e15587cd333400a533c65`.

## Independent Review

- Outcome: `CHANGES_REQUESTED`
- Reviewed commit: `d606a77a16490acdb82e15587cd333400a533c65`
- Reviewer/context: `/root/review_arch_001b` in fresh detached worktree
  `.cache/worktrees/review-arch-001b-d606`
- Verification rerun: task graph, all-eight Blueprint compilation, two clean
  Editor focused runs at 4/4, `.\Test.ps1` at 5/5, asset scope, generic Object
  references, interface-message calls, map contents, and dependency direction.
- Medium finding: all four Functional Tests use fixed composite failure messages
  ending in `Actual=mismatch`; failure paths must report the exact observed enum,
  Boolean, numeric, array/string, token, and repeated-call values.
- Medium finding: overlapping Blueprint nodes obscure setup and invalid-default
  failure paths; switches and terminal results must be laid out distinctly with
  readable wiring.
- Production fixes made by reviewer: no
