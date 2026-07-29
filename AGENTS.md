# Risbacka Agent Operating Rules

These rules apply to Codex, Claude, and any other AI agent working in this
repository. The goal is reproducible development with explicit dependencies,
test-driven implementation, and independent review.

## Sources of truth

Use the documents in this order:

1. `Agent-Orchestration/task-graph.json` decides what may start and what may
   finish.
2. The claimed task Markdown file defines requirements, scope, acceptance
   criteria, and evidence.
3. `Architecture/` defines module boundaries, interfaces, ownership, and
   dependency direction.
4. `Tasks/TASKS.md` and `Architecture/Tasks/ARCHITECTURE-TASKS.md` are
   human-readable summaries, not scheduling authorities.
5. `GAME_DESIGN.md` defines game intent.

If these disagree, stop and report the conflict to the coordinator. Do not
silently choose one.

## Before starting work

1. Read this file, `Agent-Orchestration/README.md`, and the assigned task.
2. Run `Scripts/Test-AgentTaskGraph.ps1`.
3. Confirm that the task is ready in `Scripts/Get-AgentReadyTasks.ps1`.
4. Confirm an exclusive claim from the coordinator. Record the owner, computer,
   agent context, branch, worktree, base commit, and exact file/asset paths.
5. Verify that the checkout contains no unrelated changes in the claimed scope.

Only the coordinator may change a task from `BLOCKED` to `READY`, assign or
release a claim, update overview boards, or integrate completed work.

## Roles

### Coordinator

- Validates the graph and selects ready work.
- Prevents overlapping source, asset, config, map, and subsystem scopes.
- Creates one branch/worktree per mutating worker where possible.
- Commits and pushes claims before multiple computers begin work.
- Starts reviewers from a fresh context at an immutable implementation commit.
- Integrates only work that has passed its required review.

### Implementer

- Works on exactly one claimed task.
- Follows the task's architecture notes and acceptance criteria.
- Writes the smallest meaningful failing test before production behavior.
- Does not update global boards, claim other work, or expand scope.
- Hands off an immutable commit plus reproducible evidence.

### Reviewer

- Starts without the implementer's conversation history.
- Reviews the exact implementation commit against the task and architecture.
- Runs required tests and inspects maintainability, not only test success.
- Does not repair the implementation in the review context.
- Returns `APPROVED` or `CHANGES_REQUESTED` with concrete findings.

## Task lifecycle

Allowed states are:

`BLOCKED -> READY -> IN_PROGRESS -> REVIEW_READY -> IN_REVIEW -> DONE`

A reviewer may return:

`IN_REVIEW -> CHANGES_REQUESTED -> IN_PROGRESS`

An implementation may reach `REVIEW_READY` only when its focused tests pass and
its evidence is complete. It may reach `DONE` only after every `done_after`
milestone in the task graph is satisfied.

## Dependency rules

- `start_after` controls when work may be claimed.
- `done_after` controls what must be independently approved before the task is
  complete.
- A `review_ready` dependency is satisfied by `REVIEW_READY`, `IN_REVIEW`, or
  `DONE`.
- A `done` dependency is satisfied only by `DONE`.
- Never use prose or table order to infer a dependency.
- Never work around a cycle. Fix the graph or task design first.

## Parallel work

Parallel mutation is allowed only when:

- every task is ready;
- every worker has a separate worktree/checkout and branch;
- claimed source paths, Unreal assets, maps, configs, and lease keys do not
  overlap;
- every Unreal-mutating worker has its own Unreal Editor/MCP session; and
- integration order is declared when outputs converge.

Agents sharing one checkout may perform read-only analysis or review in
parallel. They must not independently edit, stage, commit, or change task
status.

At most three worker/reviewer agents should run concurrently so the primary
context remains the coordinator.

## Unreal assets and leases

- Treat `.uasset`, `.umap`, project settings, input configuration, GameMode,
  GameInstance, and subsystem ownership as exclusive resources.
- Claims for binary assets must list exact paths, not directory globs.
- Use Git LFS locks for shared existing binary assets when the remote supports
  them.
- Never create, rename, move, or save an asset outside the claimed paths.
- Prefer new assets over editing template originals unless the task explicitly
  requires the original.

## Test-driven implementation

For each implementation task:

1. Create the declared class/module/API shell without behavior.
2. Add or update a focused test that fails for the intended reason.
3. Record the red-test command and concise failure evidence.
4. Implement until the focused test passes.
5. Refactor while keeping the focused test green.
6. Run the task's regression and integration checks.
7. Inspect boundaries, naming, ownership, failure paths, and editor/runtime
   behavior.
8. Update task evidence and prepare the immutable review commit.

If behavior cannot be tested at the intended layer, document why and use the
closest deterministic automated seam. Manual-only verification requires
explicit task approval.

## Scope and Git safety

- Preserve all pre-existing and unrelated changes.
- Do not stage with broad pathspecs such as `git add .`.
- Do not amend, rebase, squash, or force-push a commit under review.
- Do not use destructive reset/checkout commands.
- Do not commit or push unless the task or coordinator explicitly authorizes it.
- Never modify another task's status or evidence.

## Required handoff

An implementation handoff must include:

- task ID and implementation commit;
- files and Unreal assets changed;
- red and green test commands with results;
- regression checks and manual/editor checks;
- remaining risks, warnings, or deferred work;
- confirmation that only claimed scope changed.

A review handoff must include:

- task ID, reviewed commit, reviewer identity, and fresh context ID;
- tests and inspections performed;
- findings with severity and file/asset references;
- `APPROVED` or `CHANGES_REQUESTED`;
- explicit confirmation that the reviewer made no production fix.
