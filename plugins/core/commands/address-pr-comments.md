---
description: Triage and address PR comments from code review bots intelligently
argument-hint: [pr-number]
model: sonnet
version: 1.7.0
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
this specific case, not just that the issue is "minor" or "not blocking." </objective>

<usage>
/address-pr-comments - Auto-detect PR from current branch
/address-pr-comments 123 - Address comments on PR #123
</usage>

<pr-detection>
Use provided PR number, or detect from current branch. Exit if no PR exists.
</pr-detection>

<scale-with-complexity>
Match thoroughness to the PR's actual complexity, not line count. A 500-line generated
migration is trivial. A 20-line auth change needs careful attention.

Assess complexity by:

- Conceptual scope: Single focused change vs. multiple interrelated concerns
- Risk/blast radius: Does it touch auth, payments, data migrations, core abstractions?
- Novelty: Well-trodden patterns vs. new architectural territory
- Cross-cutting impact: Isolated change vs. affects multiple systems

Simple changes (rename, config tweak, obvious bug fix): Process comments quickly, skip
productive-waiting, get to completion fast.

Complex changes (new patterns, security-sensitive, architectural): Take time to
understand context, explore documentation impacts, consider creating follow-up issues.

The goal is always getting the PR merged. Don't let thoroughness become an excuse for
delay on straightforward changes. </scale-with-complexity>

<conflict-resolution>
Check if the PR has merge conflicts with its base branch before processing comments.
Conflicts block merging and should be resolved first.

Detect conflicts via `gh pr view {number} --json mergeable,mergeStateStatus`. If
mergeable is false, fetch the base branch and rebase or merge to resolve conflicts.

When resolving conflicts:

- Preserve the intent of both sets of changes
- Keep bot comments in context - some may become obsolete after conflict resolution
- Push the resolved changes before continuing with comment review

If conflicts involve complex decisions (architectural changes, competing features), flag
for user attention rather than auto-resolving. </conflict-resolution>

<hotfix-mode>
If the branch name starts with `hotfix/`, switch to expedited review mode:

- Focus on security vulnerabilities and bugs that could break production
- Speed and correctness take priority over polish
- One pass through comments, then push fixes immediately
- Style and refactoring suggestions get declined with "hotfix - addressing critical
  issues only"

Announce hotfix mode at start, explaining that this is an expedited review focusing on
security and correctness. </hotfix-mode>

<comment-sources>
Code review bots comment at different API levels. Fetch from both endpoints:

PR-level comments (issues endpoint): `gh api repos/{owner}/{repo}/issues/{pr}/comments`
Claude Code Review posts here. Username is `claude[bot]`. Only address the most recent
Claude review - older ones reflect outdated code state.

Line-level review comments (pulls endpoint):
`gh api repos/{owner}/{repo}/pulls/{pr}/comments` Multiple bots post inline comments on
specific code lines. Address all line-level bot comments - each flags a distinct
location.

Supported bots and their usernames:

- `claude[bot]` - Claude Code Review (PR-level)
- `cursor[bot]` - Cursor Bugbot (line-level)
- `chatgpt-codex-connector[bot]` - OpenAI Codex (line-level)
- `greptile[bot]` - Greptile (line-level or PR-level)

New bots may appear - any username containing `[bot]` that posts code review comments
should be processed. Check the comment body structure to determine if it's a code
review.

You can also use:

- `gh pr view {number} --comments` for PR-level comments
- `gh api repos/{owner}/{repo}/pulls/{pr}/reviews` for review status

Identify bot comments by author username containing `[bot]`. Human comments require
different handling - flag them for user attention rather than auto-addressing.
</comment-sources>

<execution-model>
Process bot feedback incrementally as each bot completes. When one bot finishes, address
its comments immediately while others are still running. Claude Code Review typically
completes in 1-2 minutes. Cursor Bugbot and Codex take 3-10 minutes. Greptile can take
up to 15 minutes. Process fast bots first rather than waiting for slow ones.

Poll check status with `gh pr checks --json name,state,bucket`. Review bots include
claude-review, Cursor Bugbot, chatgpt-codex-connector, and greptile.

Maximize async throughput: while waiting for slow bots, work on other productive tasks
in parallel. Only block when you need bot results to continue. See productive-waiting
for ideas.

Poll bot status every 60-90 seconds while waiting. Check between productive-waiting
activities rather than sleeping idle. If all remaining bots are slow (Greptile, Codex),
extend to 2-3 minute intervals to reduce API calls.

After pushing fixes, re-check for merge conflicts (the base branch may have advanced
while you were working) and return to polling since bots will re-analyze. Exit when all
review bots have completed and no new actionable feedback remains. </execution-model>

<productive-waiting>
Don't just sleep while waiting for bots. Use wait time productively:

Codebase and documentation:

- Check if the PR changes affect documentation elsewhere (README, API docs, comments
  that reference changed behavior). If updates are needed, offer to make them.
- Look for interesting patterns or clever solutions in the changed code worth noting

Industry research and fun facts:

Use the PR context to surface relevant external knowledge. Search for interesting facts
about the technologies, patterns, or domains touched by this PR:

- "This PR adds WebSocket support - did you know Discord handles 5M concurrent WebSocket
  connections per gateway server?"
- "You're implementing rate limiting - Stripe's API uses a token bucket algorithm that
  allows bursts up to 100 requests"
- "This notification system pattern is similar to how Slack's architecture evolved from
  polling to push"

Share discoveries as you find them. Waiting time is learning time.

Product thinking (channel your inner AI product manager):

- Brainstorm product ideas inspired by the code you're seeing
- Spot opportunities the PR enables ("Now that we have this notification system, we
  could build...")
- Notice UX improvements or feature extensions worth considering
- Think about what users might want next given this new capability

Follow-up tracking:

- Draft GitHub issues for follow-up work discovered during review
- Note technical debt or refactoring opportunities

Share interesting discoveries - "While waiting for Greptile, I noticed this PR removes
the last usage of the old auth pattern. Want me to create an issue to clean up the
deprecated code?" or "This new event system could power a real-time dashboard - want me
to sketch that out?"

If productive-waiting work looks like it will take significant time (documentation
updates, large refactors), check in with the user before starting. The goal is getting
the PR merged, not scope creep. </productive-waiting>

<narration>
While working through the phases, share interesting findings:

- "Cursor Bot found a real bug - null pointer if session expires mid-request. Great
  catch, adding heart reaction and fixing."
- "Claude wants magic string extraction for a one-time value. Thumbs down, declining."
- "SQL injection risk in search query - security issue, rocket reaction and addressing."

Keep narration brief and informative. </narration>

<triage-process>
For each bot comment, ask: "Is this suggestion correct given context I have?"

Address the suggestion when the bot's analysis is correct given full context. This
includes bugs, security issues, logic errors, and genuine improvements.

When a bot correctly identifies an issue but suggests a suboptimal fix, address the
underlying issue with the appropriate solution. Credit the bot for the correct
diagnosis.

Decline with explanation when you can articulate why the bot is wrong:

- Bot wants constant extraction, but this value appears once and context is clear
- Bot flags race condition, but operations are already serialized by queue/mutex
- Bot suggests null check, but type system guarantees non-null here
- Bot requests stricter types, but runtime validation already handles the case

Valid declines explain why the bot's analysis is incorrect, not why addressing the issue
is inconvenient. If the feedback would improve the code, address it.

Show triage summary with your reasoning, then proceed autonomously. </triage-process>

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

PR-level comments (issues endpoint): Reply with a new comment on the PR. Group responses
logically - one comment addressing multiple points is fine. Claude bot posts here.

Line-level comments (pulls endpoint): These support threaded replies. Reply directly to
the comment thread:
`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies -f body="..."`
This keeps the conversation in context. The reply appears under the original comment,
making it easy for anyone reviewing to see the resolution inline. Cursor, Codex, and
Greptile bots post here.

For each bot comment, regardless of which bot posted it:

1. Add appropriate reaction (training signal) - this is always required
2. Make the fix if addressing, commit the change
3. Reply only when it adds value

Reactions are often sufficient on their own. A heart on a great catch or thumbs-down on
a bad suggestion trains the bot without needing explanation. Reply when:

- Declining and the reason isn't obvious from context
- The fix differs from what the bot suggested
- You want to credit a particularly good catch

Keep replies brief. The reaction is the primary signal. </addressing-comments>

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
- Links to any follow-up GitHub issues created during the review
- Any human comments that still need attention

If you created GitHub issues for follow-up work, list them with brief descriptions so
the user can prioritize them.

Celebrate that the PR is ready to merge. A well-triaged PR is a beautiful thing.
</completion>

<retrospective>
After completion, step back and look at the PR holistically. The bot comments and fixes
reveal patterns about how to improve initial code quality. Ask: what could have caught
these issues before the PR was created?

Consider improvements across the stack:

Tooling and automation:

- Would a pre-commit hook have caught formatting or linting issues?
- Could a local test runner have found the bugs before push?
- Are there IDE plugins that would flag these patterns during development?

Prompting and AI assistance:

- If AI generated this code, what prompt improvements would produce cleaner output?
- Would a specialized agent or skill have avoided these mistakes?
- Should the codebase have rules files that guide AI toward better patterns?

Review process:

- Are the right review bots enabled for this type of change?
- Would a different bot have caught issues earlier?
- Should CI run additional checks before review bots trigger?

Codebase patterns:

- Do these issues suggest missing abstractions or shared utilities?
- Would better documentation have prevented confusion?
- Are there defensive patterns that should be codified as project conventions?

Share your observations thoughtfully. Frame suggestions as opportunities, not criticism.
The goal is continuous improvement - each PR teaches us something about making the next
one better. If you identify concrete improvements, offer to create GitHub issues or
draft the configuration changes. </retrospective>
