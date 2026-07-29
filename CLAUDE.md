@AGENTS.md

# Claude entry point

Use the shared repository rules above as the authoritative development
instructions.

For implementation, prefer `.claude/agents/risbacka-worker.md`. For independent
review, start `.claude/agents/risbacka-reviewer.md` in a new context.

Claude's built-in Explore and Plan agents may not load `CLAUDE.md`. When using
them, restate the task ID, read-only scope, dependency status, and prohibition
on edits, staging, commits, and status changes in the delegation prompt.
