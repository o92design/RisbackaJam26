---
id: CLAIM-<TASK-ID>
task: <TASK-ID>
status: IN_PROGRESS
owner: <agent-or-person>
computer: <computer-name>
context: <agent-context-id>
branch: <branch-name>
worktree: <absolute-or-repository-relative-path>
base_sha: <commit>
claimed_at: <ISO-8601>
lease_expires_at: <ISO-8601-or-none>
---

# Claim — <TASK-ID>

[Orchestration guide](README.md) · [Task](<relative-task-link>)

## Exact Claimed Paths

- `<exact source or asset path>`

Directory globs are not valid for shared binary assets. List each existing
`.uasset`, `.umap`, config, and shared Blueprint separately.

## Lease Keys

- `<lease key from task-graph.json>`

## Integration

- Expected handoff branch:
- Expected integration order:
- LFS locks:
- Coordinator approval commit:
