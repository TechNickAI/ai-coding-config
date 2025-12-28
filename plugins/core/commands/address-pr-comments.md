---
description: Triage and address PR comments from code review bots intelligently
argument-hint: [pr-number]
model: sonnet
version: 1.5.0
---

# Address PR Comments

<objective>
Get a PR to "ready to merge" by addressing valid feedback and declining incorrect
suggestions. You have context bots lack - use it to identify when a bot's analysis is
wrong, not to prioritize which valid issues to skip.

If a suggestion would genuinely improve the code, fix it. Only decline when you can
articulate why the bot is mistaken given context it lacks.

Read @rules/code-review-standards.mdc for patterns where bot suggestions typically don't
apply. Use these to identify incorrect suggestions - explain why the bot is wrong in
this specific case, not just that the issue is "minor" or "not blocking."
</objective>

<usage>
/address-pr-comments - Auto-detect PR from current branch
/address-pr-comments 123 - Address comments on PR #123
</usage>

<pr-detection>
Use provided PR number, or detect from current branch. Exit if no PR exists.
</pr-detection>

<conflict-resolution>
Check if the PR has merge conflicts with its base branch before processing comments.
Conflicts block merging and should be resolved first.

Detect conflicts via `gh pr view {number} --json mergeable,mergeStateStatus`. If
mergeable is false, fetch the base branch and rebase or merge to resolve conflicts.

When resolving conflicts:
- Preserve the intent of both sets of changes
- Keep bot comments in context - some may become obsolete after conflict resolution
- Push the resolved changes before continuing with comment review

If conflicts involve complex decisions (architectural changes, competing features),
flag for user attention rather than auto-resolving.
</conflict-resolution>

<hotfix-mode>
If the branch name starts with `hotfix/`, switch to expedited review mode:

- Focus on security vulnerabilities and bugs that could break production
- Speed and correctness take priority over polish
- One pass through comments, then push fixes immediately
- Style and refactoring suggestions get declined with "hotfix - addressing critical issues only"

Announce hotfix mode at start, explaining that this is an expedited review focusing on
security and correctness.
</hotfix-mode>

<comment-sources>
Code review bots comment at different API levels. Fetch from both endpoints:

PR-level comments (issues endpoint):
`gh api repos/{owner}/{repo}/issues/{pr}/comments`
Claude Code Review posts here. Username is `claude[bot]`. Only address the most recent
Claude review - older ones reflect outdated code state.

Line-level review comments (pulls endpoint):
`gh api repos/{owner}/{repo}/pulls/{pr}/comments`
Cursor Bugbot posts here as inline comments on specific code lines. Username is
`cursor[bot]`. Address all Cursor comments - each flags a distinct location.

You can also use:
- `gh pr view {number} --comments` for PR-level comments
- `gh api repos/{owner}/{repo}/pulls/{pr}/reviews` for review status

Identify bot comments by author username. Human comments require different handling -
flag them for user attention rather than auto-addressing. </comment-sources>

<execution-model>
Process bot feedback incrementally as each bot completes. When one bot finishes, address
its comments immediately while others are still running. Claude Code Review typically
completes in 1-2 minutes. Cursor Bugbot takes 3-10 minutes. Process fast bots first
rather than waiting for slow ones.

Poll check status with `gh pr checks --json name,state,bucket`. Review bots include
claude-review, Cursor Bugbot, and greptile.

When bots are still pending, sleep adaptively based on which bots remain. If only Claude
is pending, sleep 30-60 seconds. If Cursor Bugbot is pending, sleep 2-3 minutes. Check
status after each sleep and process any newly-completed bots before sleeping again.

After pushing fixes, re-check for merge conflicts (the base branch may have advanced
while you were working) and return to polling since bots will re-analyze. Exit when all
review bots have completed and no new actionable feedback remains.

Use polling with adaptive sleep intervals to check bot status rather than watch mode.
</execution-model>

<narration>
While working through the phases, share interesting findings:

- "Cursor Bot found a real bug - null pointer if session expires mid-request. Great
  catch, adding heart reaction and fixing."
- "Claude wants magic string extraction for a one-time value. Thumbs down, declining."
- "SQL injection risk in search query - security issue, rocket reaction and addressing."

Keep narration brief and informative.
</narration>

<triage-process>
For each bot comment, ask: "Is this suggestion correct given context I have?"

Address the suggestion when the bot's analysis is correct given full context. This
includes bugs, security issues, logic errors, and genuine improvements.

When a bot correctly identifies an issue but suggests a suboptimal fix, address the
underlying issue with the appropriate solution. Credit the bot for the correct diagnosis.

Decline with explanation when you can articulate why the bot is wrong:

- Bot wants constant extraction, but this value appears once and context is clear
- Bot flags race condition, but operations are already serialized by queue/mutex
- Bot suggests null check, but type system guarantees non-null here
- Bot requests stricter types, but runtime validation already handles the case

Valid declines explain why the bot's analysis is incorrect, not why addressing the issue
is inconvenient. If the feedback would improve the code, address it.

Show triage summary with your reasoning, then proceed autonomously.
</triage-process>

<feedback-as-training>
Responding to bot comments serves two purposes: record-keeping and training. Bots learn
from feedback patterns. Reactions and replies shape future review quality. Thoughtful
feedback improves bot behavior over time.

Use reactions strategically:

- 👍 (+1): Helpful feedback we addressed. Signals "more like this."
- ❤️ (heart): Exceptional catch (security issue, subtle bug). Strongest positive signal.
- 👎 (-1): Incorrect, irrelevant, or low-value suggestion. Signals "less like this."
- 🚀 (rocket): For security vulnerabilities or critical bugs we fixed.

Add reactions via API:
`gh api repos/{owner}/{repo}/issues/comments/{comment_id}/reactions -f content="+1"`
`gh api repos/{owner}/{repo}/pulls/comments/{comment_id}/reactions -f content="-1"`
</feedback-as-training>

<addressing-comments>
Response methods differ by comment type:

PR-level comments (Claude bot):
These live in the issues endpoint. Reply with a new comment on the PR. Group responses
logically - one comment addressing multiple points is fine.

Line-level comments (Cursor bot):
These support threaded replies. Reply directly to the comment thread:
`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies -f body="..."`
This keeps the conversation in context. The reply appears under the original comment,
making it easy for anyone reviewing to see the resolution inline.

For each comment:

1. Add appropriate reaction first (training signal)
2. Make the fix if addressing, commit the change
3. Reply acknowledging the change or explaining the decline

For declined items, reply with a brief, professional explanation referencing project
standards. The thumbs-down reaction signals disagreement; the reply explains why.
</addressing-comments>

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
