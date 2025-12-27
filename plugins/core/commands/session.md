---
description: "Save and resume development sessions across conversations"
argument-hint: "save|resume|list [name]"
version: 1.0.0
---

<objective>
Maintain continuity across Claude Code sessions. Save your current context, decisions,
and progress so you can resume exactly where you left off - even in a new conversation.
</objective>

<session-structure>
Sessions are stored in `.claude/sessions/` with this structure:

```
.claude/sessions/
├── active.json           # Current session pointer
└── <session-id>/
    ├── metadata.json     # Session info (name, created, branch, task)
    ├── context.md        # Decisions, architecture, key context
    ├── progress.json     # Completed steps, current step, blockers
    └── files.json        # Key files being worked on
```
</session-structure>

<commands>
## /session save [name]

Save current session state for later resumption.

1. Create session directory with timestamp ID
2. Capture metadata:
   - Session name (from argument or auto-generate from task)
   - Current git branch
   - Timestamp
   - Brief task description

3. Write context.md with:
   - What we're building and why
   - Key architectural decisions made
   - Important constraints or requirements
   - Current approach and alternatives considered

4. Write progress.json with:
   - Completed steps
   - Current step in progress
   - Known blockers or open questions
   - Next steps planned

5. Write files.json with:
   - Key files being modified
   - Files to review on resume

6. Update active.json to point to this session

Example:
```bash
/session save "auth-refactor"
```

## /session resume [name|id]

Resume a saved session.

1. Load session from `.claude/sessions/<id>/`
2. Read and present context.md summary
3. Show progress status
4. List key files for quick orientation
5. Ask if ready to continue from last step

If no name/id provided, resume the active session (from active.json).

Example:
```bash
/session resume auth-refactor
/session resume      # Resume active session
```

## /session list

Show all saved sessions with:
- Session name and ID
- Creation date
- Branch
- Brief task description
- Progress status (X of Y steps)

Sort by most recently modified.
</commands>

<context-capture>
When saving context, capture decisions that matter for resumption:

Good context entries:
- "Using event-driven architecture for loose coupling between services"
- "Chose PostgreSQL over MongoDB for ACID compliance requirements"
- "Auth flow: JWT with refresh tokens, 15min access / 7day refresh"

Skip transient details:
- Specific error messages (they'll be different on resume)
- File contents (read them fresh)
- Conversation history (that's what context.md replaces)
</context-capture>

<progress-tracking>
Progress entries should be actionable:

```json
{
  "completed": [
    "Set up database schema",
    "Implement user model",
    "Add authentication middleware"
  ],
  "current": "Writing login endpoint tests",
  "blockers": [
    "Need to decide on rate limiting strategy"
  ],
  "next": [
    "Implement password reset flow",
    "Add email verification"
  ]
}
```
</progress-tracking>

<auto-save>
Consider auto-saving sessions:
- Before long-running operations
- When switching branches
- At natural breakpoints (commit, PR creation)
- When context window gets full (before compaction)

Ask before auto-saving: "Save session before [action]? (y/n)"
</auto-save>

<resumption-flow>
When resuming a session:

1. **Orient**: "Resuming session 'auth-refactor' from 2 hours ago"
2. **Context**: Brief summary of what we were doing and key decisions
3. **Progress**: "Completed 3 of 7 steps. Currently on: Writing login tests"
4. **Blockers**: Any open questions or blockers noted
5. **Ready check**: "Ready to continue with [current step]?"

This gets the user (and Claude) back up to speed quickly without re-explaining everything.
</resumption-flow>

<privacy-notice>
Session files may contain sensitive information including architectural decisions, code
context, and file paths. The `.claude/sessions/` directory is gitignored by default.

Never commit session data to version control. Review session contents before sharing
with team members.
</privacy-notice>

<best-practices>
Save sessions when:
- Ending a work session (lunch, EOD, context switch)
- Before risky operations
- At major milestones
- When you'd want to remember "where was I?"

Resume sessions when:
- Starting a new Claude Code conversation
- Returning to a task after a break
- Handing off to another developer
- Context got compacted and you lost state
</best-practices>
