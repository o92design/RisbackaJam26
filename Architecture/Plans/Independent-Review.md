---
id: ARC-PLAN-REVIEW
type: architecture-plan
status: proposed
updated: 2026-07-29
tags:
  - architecture
  - architecture/plan
  - review
---

# Independent Fresh-Context Review

[Architecture home](../README.md) · [TDD Workflow](TDD-Workflow.md) ·
[Review template](../Tasks/templates/ARCH-REVIEW-TEMPLATE.md) ·
[Agent orchestration](../../Agent-Orchestration/README.md)

## Independence Requirement

The reviewer must use a fresh AI context with no inherited implementation
conversation, or a human who did not implement the change. Do not fork or
provide the implementation conversation, intermediate
reasoning, or self-evaluation. The reviewer may receive:

- architecture module and contract notes;
- linked feature/architecture tasks and acceptance criteria;
- repository state or exact commit/diff;
- red/green test evidence;
- known limitations recorded by the implementer.

This reduces anchoring while preserving the evidence needed to reproduce the work.

## Review Procedure

1. Confirm the reviewed commit and exact asset scope.
2. Read the requirements before inspecting implementation.
3. Inspect public APIs, asset references, graph structure, and module dependencies.
4. Compile every changed Blueprint.
5. Run focused tests and `.\\Test.ps1`.
6. Exercise named failure/re-entry cases.
7. Apply the quality rubric below.
8. Record `APPROVED` or `CHANGES_REQUESTED` with reproducible findings.

The reviewer does not silently fix production code. Findings return to the
implementation task so ownership and evidence remain clear. A test-only diagnostic
may be proposed, but changes require normal task ownership.

## Quality Rubric

### Correctness

- Every acceptance criterion has evidence.
- Failure, repeated-call, reset, and terminal cases behave deterministically.
- Events fire the documented number of times.
- Tests fail when the behavior is intentionally broken or disabled.

### Architecture

- Mutable state has one owner.
- Dependencies match [System Map](../System-Map.md).
- Cross-module calls use documented contracts.
- Composition is explicit; no scattered actor searches or Level Blueprint logic.
- No circular references are introduced.
- Template/vendor assets remain unchanged.

### Blueprint Quality

- Shared GameMode/player/map assets stay thin.
- Functions have narrow responsibilities and meaningful names.
- Public fields/functions have categories and tooltips.
- No new compile warnings.
- Tick is justified and disabled while inactive.
- Dispatchers bind once and unbind safely.
- No hard-coded test-only production behavior.
- Graph layout and comments communicate intent.

### Test Quality

- A meaningful red result was recorded before implementation.
- Tests use public behavior rather than private state.
- Deterministic settings are injected.
- Focused and regression suites pass from a clean Editor session.
- Manual evidence is used only where automation cannot prove the requirement.

### Maintainability

- A future agent can find the state owner and API from these notes.
- Adding another implementation of an interface would not require editing consumers.
- Configuration values are data/defaults, not scattered literals.
- Known tradeoffs are documented rather than hidden.

## Outcome Rules

`APPROVED` requires every must-have criterion and no unresolved high-impact finding.

`CHANGES_REQUESTED` must include:

- severity;
- module and task ID;
- exact asset/function/graph;
- reproduction or inspection evidence;
- violated requirement or principle;
- expected correction.

After corrections, rerun the affected focused test plus regression. Approval records
the reviewed commit SHA so later changes do not inherit approval automatically.

History normalization must happen before review. If a coordinator squashes,
amends, rebases, or otherwise creates a different implementation commit after
approval, that new commit has no inherited approval and requires fresh
independent review. The approved commit must remain an ancestor of the
integrated `master`-branch history.
