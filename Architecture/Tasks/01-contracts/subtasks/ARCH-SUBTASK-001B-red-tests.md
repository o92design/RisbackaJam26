---
id: ARCH-SUBTASK-001B
parent: ARCH-TASK-001
stage: test-fixture
status: READY
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-001A
updated: 2026-08-01
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

- Test assets:
- Focused result:
- Regression result:
- Behavioral red delegated to: ARCH-SUBTASK-010B
- Feature task unblocked:
- Commit:
