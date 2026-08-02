# Git History Strategy

This repository keeps implementation review auditable without allowing
task-level work to overwhelm the `master` branch history.

## Goals

- A reviewer examines the exact implementation commit that reaches `master`.
- Workers may use small operational commits while investigating and iterating.
- The `master` branch history emphasizes completed tasks rather than every local step.
- Shared coordination state remains visible when parallel workers depend on it.
- Published and reviewed history is never rewritten.

## Commit Layers

Task work has four distinct commit layers:

1. **Coordination** — specification repair, claim, lease, or scheduling state
   that another worker or computer must observe.
2. **Operational** — intermediate implementation, test, experiment, or
   correction commits on the task branch.
3. **Review candidate** — the compact immutable implementation commit submitted
   to independent review.
4. **Completion** — approval evidence, claim release, final status, and summary
   board updates made by the coordinator.

Operational commits are useful on a task branch but are not automatically
entitled to appear individually on `master`.

## Pre-review Normalization

Before a task enters `REVIEW_READY`, normalize its implementation into a clean
candidate whenever the branch contains avoidable operational churn.

- Create the candidate from the declared task base or latest authorized
  coordinator baseline.
- Consolidate the claimed implementation into one logical commit when practical.
- Keep a separate coordination/specification commit only when its history is
  independently meaningful or was already shared for scheduling.
- Verify the candidate contains only claimed paths.
- Re-run focused and regression checks on the candidate.
- Record the candidate SHA in the implementation handoff.

Normalization must finish **before** review begins. It may use a new candidate
branch or another non-destructive reconstruction method. Do not rewrite a
shared branch that another worker has fetched or based work on.

A typical completed task should produce this first-parent story:

```text
Claim/specification (only when required)
Implement <TASK-ID>
Complete <TASK-ID> after approval
```

Additional coordination commits are acceptable when their intermediate state
was required by parallel workers or multiple computers.

## Review Immutability

- The reviewer reviews one exact candidate SHA.
- Never amend, rebase, squash, or force-push that candidate while it is under
  review.
- Approval applies only to that SHA.
- The approved candidate must remain an ancestor of the integrated `master`
  history.
- A post-review squash creates a different commit and therefore requires fresh
  independent review.

When review returns `CHANGES_REQUESTED`, keep the reviewed commit immutable.
Apply corrections separately, normalize a replacement candidate if useful, and
review the new exact SHA.

## Integration Strategy

Use one of these integration modes:

- **Normalized candidate:** prefer fast-forward integration when it preserves
  the intended compact history.
- **Intentionally granular task branch:** use `git merge --no-ff` so one merge
  commit represents the task on the `master` branch while the detailed audit trail
  remains reachable.

Use `git log --first-parent` for the task-oriented `master`-branch view.

Do not use `git merge --squash` after approval unless the resulting squashed
commit is treated as a new review candidate and independently reviewed.

## Published History

- Never rewrite `master`, another shared coordinator branch, or any pushed commit
  that another task may reference.
- Do not retroactively compact a completed task merely for aesthetics.
- Prefer the cleaner process on the next task rather than force-pushing history.
- Tags, task evidence, claims, and review handoffs must continue to resolve to
  the recorded reviewed commit.
