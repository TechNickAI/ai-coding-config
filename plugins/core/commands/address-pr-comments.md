---
description: Triage and address PR comments from code review bots intelligently
argument-hint: [pr-number]
model: sonnet
version: 1.1.0
---

# Address PR Comments

<objective>
Get a PR to "ready to merge" by intelligently triaging bot feedback. You have context
bots lack - use judgment, not compliance. Declining feedback is as valid as accepting
it. The goal is "ready to merge," not "zero comments."

Read @rules/code-review-standards.mdc for triage principles:

- Fix critical bugs, ensure security, validate core behavior
- Skip theoretical edge cases, minor polish, over-engineering suggestions
- Trust runtime validation over compile-time perfection
- Constants for DRY, not to avoid "magic strings"
- Target 90% coverage, not 100%
- Optimize when metrics show problems, not preemptively </objective>

<usage>
/address-pr-comments - Auto-detect PR from current branch
/address-pr-comments 123 - Address comments on PR #123
</usage>

<pr-detection>
Use provided PR number, or detect from current branch. Exit if no PR exists.
</pr-detection>

<hotfix-mode>
If the branch name starts with `hotfix/`, switch to expedited review mode:

- Only address security vulnerabilities and actual bugs
- Decline all style, refactoring, and "improvement" suggestions
- Skip theoretical concerns - focus on "will this break production?"
- One pass only - don't wait for bot re-reviews after fixes
- Speed over polish - this is an emergency

Announce hotfix mode at start, explaining that you're running expedited review and will
only address security issues and bugs while declining all other feedback. </hotfix-mode>

<comment-sources>
Code review bots comment in different places. Fetch both:
- PR comments (general feedback on the PR itself)
- Review comments (inline on specific code lines)
- Reviews (approval status with body text)

Identify bot comments by author - automated usernames like cursor-bot,
claude-code-review, greptile-bot. Human comments require different handling.

Different bots behave differently:

- Claude Code Review: Posts one top-level PR comment per review. Only address the most
  recent review - it's the only one that matters for current code state.

- Cursor Bug Bot: Comments inline on specific code lines. Address all inline comments -
  each one flags a specific location. Bot username is `cursor[bot]`.

The structure difference helps you fetch efficiently: Claude reviews show up as PR-level
comments, Cursor reviews show up as line-level review comments. </comment-sources>

<execution-model>
This command runs autonomously as a single-threaded state machine. Execute one phase at
a time, never in parallel. No user prompts needed.

Phase 1 - POLL: Run `gh pr checks --json name,state,bucket` to get current check status.
Identify which checks are review bots (claude-review, Cursor Bugbot, greptile).

Phase 2 - PROCESS: For each review bot that has completed:
- If you haven't processed this bot's comments yet, fetch and triage them now
- Track which bots you've already processed to avoid re-processing

Phase 3 - WAIT: If any review bot checks are still pending:
- Run `sleep 30` to wait (a single sleep command, not a loop)
- After sleep completes, return to Phase 1

Phase 4 - EXIT: When all review bots have completed and you've addressed their comments:
- If you made any fixes, push and return to Phase 1 (bots will re-analyze)
- If no new actionable feedback, you're done

Key constraint: Process bots incrementally. If Claude review completes in 2 minutes but
Cursor Bugbot takes 15 minutes, address Claude's comments immediately - don't wait for
Cursor. This keeps fast bots from blocking on slow ones.

Never use `gh pr checks --watch`. It's designed for human terminals, not LLM execution,
and causes unpredictable behavior.
</execution-model>

<narration>
While working through the phases, share interesting findings:

- "Cursor Bot found a real bug - null pointer if session expires mid-request. Good
  catch, fixing."
- "Claude wants magic string extraction for a one-time value. Declining."
- "SQL injection risk in search query - legit security issue, addressing."

Keep narration brief and informative.
</narration>

<triage-process>
For each bot comment, evaluate against code-review-standards.mdc:

Address immediately:

- Security vulnerabilities
- Actual bugs that could cause runtime failures
- Core functionality issues
- Clear improvements to maintainability

Decline with explanation:

- Theoretical race conditions without demonstrated impact
- Magic number/string extraction for single-use values
- Accessibility improvements (not current priority)
- Minor type safety refinements when runtime handles it
- Edge case tests for unlikely scenarios
- Performance micro-optimizations without profiling data
- Documentation enhancements beyond core docs

Show triage summary, then proceed autonomously. </triage-process>

<addressing-comments>
For addressable items: make the fix, commit, reply acknowledging the change.

For declined items: reply with brief, professional explanation referencing project
standards. Thumbs down for incorrect suggestions. </addressing-comments>

<human-comments>
Human reviewer comments get flagged for user attention, not auto-handled. Present
separately from bot comments.
</human-comments>

<completion>
When all review bot checks have completed and no new actionable feedback remains:

Display prominently:
- PR URL (most important - user may have multiple sessions)
- PR title
- Summary of what was addressed vs declined

Celebrate that the PR is ready to merge. A well-triaged PR is a beautiful thing.
</completion>
