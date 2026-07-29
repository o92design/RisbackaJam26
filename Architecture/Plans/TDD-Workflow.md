---
id: ARC-PLAN-TDD
type: architecture-plan
status: proposed
updated: 2026-07-29
tags:
  - architecture
  - architecture/plan
  - testing
---

# Blueprint Test-Driven Development Workflow

[Architecture home](../README.md) ·
[Verification Module](../Modules/ARC-MOD-110-verification.md) ·
[Independent Review](Independent-Review.md) ·
[Agent orchestration](../../Agent-Orchestration/README.md)

## Purpose

Use tests to define public behavior before filling in Blueprint graphs. The process is
adapted to Unreal Functional Tests, where an asset class must exist before a test can
hard-reference it.

## Gate 1 — Specify

Before opening Unreal:

- identify the owning module and linked feature requirement;
- list exact public functions, dispatchers, structs, and failure results;
- list allowed dependencies and forbidden casts/searches;
- write observable Given/When/Then cases;
- name the production and test assets to be created.

No graph implementation starts until the task contains those items.

## Gate 2 — Compileable Shell

Create the smallest production asset that:

- has the agreed parent class, components, public signatures, categories, and tooltips;
- compiles without new warnings;
- returns safe explicit defaults such as `NotImplemented` or `InvalidConfiguration`;
- does not contain the target gameplay behavior;
- can be instantiated by a focused Functional Test.

The shell is not a quick disposable graph. Its public surface is the first architecture
deliverable.

## Gate 3 — Red Test

Create a focused test actor/map that calls only the public surface.

A valid red result:

- fails an acceptance assertion, not asset loading or Blueprint compilation;
- fails for the expected missing behavior;
- prints a specific message naming expected and actual state;
- passes its setup/teardown checks;
- is recorded in the subtask handoff before implementation begins.

If the test passes against the shell, it does not prove the new requirement and must be
corrected.

## Gate 4 — Implement

Implement through the linked feature task:

- satisfy one failing case at a time;
- keep state in the documented owner;
- use injected references/contracts;
- add failure/re-entry handling;
- compile and save deliberately after each coherent change.

“Minimum implementation” means the least behavior that satisfies the complete
contract coherently. It does not permit hard-coded test values, private test switches,
Level Blueprint shortcuts, or duplicated state.

## Gate 5 — Green and Refactor

Run:

1. the focused test;
2. other tests in the same module;
3. the existing boot smoke test;
4. `.\\Test.ps1`.

Then refactor while keeping the suite green:

- extract named functions from oversized Event Graphs;
- remove duplicate branches/state;
- confirm dispatchers bind once and unbind safely;
- replace concrete cross-module casts with contracts;
- disable unnecessary Tick;
- add comments for decisions, not node-by-node narration;
- compile with no newly introduced warnings.

## Gate 6 — Handoff Evidence

Record:

- architecture task and feature task IDs;
- changed production and test assets;
- red result and reason;
- green focused and regression results;
- screenshots or logs where relevant;
- public API changes;
- known limitations;
- commit SHA.

## Gate 7 — Fresh-Context Review

The independent reviewer receives the evidence above and follows
[Independent Review](Independent-Review.md). A failed review reopens implementation;
the same reviewer may confirm corrections, but the original implementation context
does not self-approve.

## Test Shape Guidance

Prefer:

- one behavior cluster per Functional Test actor;
- small deterministic maps;
- injected short durations;
- disposable test doubles implementing the real interface;
- explicit counts and event assertions;
- two runs from a clean Editor session for lifecycle-sensitive tests.

Avoid:

- one enormous Phase 1 test for all details;
- latent waits when an event can complete the test;
- testing private variables;
- changing production defaults only to make tests faster;
- expanding `BP_AutomationSmoke` beyond boot-critical checks.
