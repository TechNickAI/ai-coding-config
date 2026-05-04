# Hooks

Lifecycle hooks that fire during Claude Code sessions. Each hook is a small bash
script registered in `hooks.json` against a Claude Code event.

## Conventions

- Bash scripts (`.sh`), executable, with a `#!/bin/bash` shebang.
- Read JSON payload from stdin via `cat`, parse fields with `jq -r '.field // empty'`.
- Write any guidance for the model to stdout — Claude Code surfaces stdout as
  context. Scripts that have nothing to say print nothing.
- Always `exit 0` unless the hook contract specifically supports blocking. A
  failing hook that returns non-zero can disrupt the harness.
- Defensive parsing: handle missing fields, empty input, malformed JSON gracefully.
  Fail open.
- Match registration in `hooks.json`. Use `${CLAUDE_PLUGIN_ROOT}/hooks/<file>` for
  the command path.

## Installed Hooks

### `session-multiplexing.sh` — `SessionStart`

Counts recently-touched session marker files. When 3+ Claude Code sessions are
active, prints a reminder that the user is juggling windows so the assistant
includes explicit context (repo, branch, current task) in every status update.

### `todo-persist.sh` — `PostToolUse` (TodoWrite)

Mirrors the model's todo list to a human-readable `todos.md` in the project
directory each time `TodoWrite` runs. Survives compaction and lets the user see
in-flight work without the harness UI.

### `verify-deliverables.sh` — `SubagentStop`

Cross-references a subagent's recent activity against its completion claims.
Surfaces a structured advisory back to the parent agent when the tool-call record
or filesystem disagrees with what the subagent said it did. Always advisory,
never blocking.

**What it checks:**

- **Completion claim with zero mutations.** If the subagent's final message
  contains strong completion language ("done.", "implemented X", "all tests pass",
  ✅) and a file-path-shaped token, but the recent transcript has zero
  `Write`/`Edit`/`MultiEdit`/`NotebookEdit` calls — flagged as a likely lie.
- **Tool call recorded but artifact missing.** For each path the subagent's
  tool calls claim to have written, verifies the file exists on disk now. A
  missing file means the tool failed silently, was deleted, or the call was
  fabricated.

**What it doesn't do:**

- Doesn't verify *correctness* — only existence. Use `verify-fix` for behavioral
  validation.
- Doesn't block the subagent from stopping. Output is added to
  `hookSpecificOutput.additionalContext` so the parent agent sees the
  discrepancy and decides what to do.
- Doesn't parse natural-language claims aggressively. Patterns are conservative
  to keep false-positive rate low; we'd rather miss a few lies than nag on
  honest analytical responses.

**Escape hatches:**

- Set `VERIFY_DELIVERABLES_DISABLED=1` in the environment to bypass entirely.
- The hook respects `stop_hook_active=true` and exits silently when the harness
  signals it has already fired once this stop cycle, so it cannot loop.
- Any internal error or unreadable transcript causes a silent pass — a broken
  hook never breaks the harness.

**Why this exists:**

The `<epistemic-honesty>` block in `CLAUDE.md`, the `verify-fix` skill, and the
`verification-before-completion` superpower all try to prevent subagents from
claiming work they haven't done. Prompts are advisory; this hook is structural.
See [issue #51](https://github.com/TechNickAI/ai-coding-config/issues/51) for
the design discussion.

## Running Tests

```bash
bash plugins/core/hooks/tests/test-verify-deliverables.sh
```

Test fixtures generate synthetic transcript JSONL and pipe synthetic stdin
payloads to the hook. No live Claude Code session required.
