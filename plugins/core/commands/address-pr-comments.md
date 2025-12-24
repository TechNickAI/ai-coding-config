---
description: Triage and address PR comments from code review bots intelligently
argument-hint: [pr-number]
model: sonnet
version: 1.3.0
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

After pushing fixes, return to polling since bots will re-analyze. Exit when all review
bots have completed and no new actionable feedback remains.

Avoid `gh pr checks --watch` - it's designed for human terminals and causes
unpredictable LLM behavior.
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
