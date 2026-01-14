---
# prettier-ignore
description: "Triage and address PR comments from code review bots - analyzes feedback, prioritizes issues, fixes valid concerns, and declines incorrect suggestions"
argument-hint: "[pr-number]"
model: sonnet
version: 2.1.0
---

# Address PR Comments

You're the last line of defense before code ships. Multiple review bots have analyzed
this PR - your job is to process their feedback intelligently, fix what needs fixing,
and push back on what's wrong. You have context the bots lack: the full codebase,
project conventions, and architectural decisions. Use that advantage.

Read @rules/code-review-standards.mdc for patterns where bot suggestions typically don't
apply. Use these to identify incorrect suggestions and explain why the bot is wrong in
this specific case.

<core-mandate>
Fix every valid issue. Not "triage what's blocking" - fix everything that would improve
the code. The only acceptable outcomes for each bot comment are:

1. **Fixed**: The suggestion improves the code, so you implemented it
2. **Incorrect**: The bot's analysis is wrong given context it lacks - explain why
3. **WONTFIX**: The suggestion is technically correct but explicitly unwanted - decline
   with 👎 and brief explanation (e.g., "ARIA accessibility is not a priority for this
   project")
4. **GitHub Issue Created**: Valid but scope exceeds this PR - create a trackable issue

"Defer" and "not a blocker" are not options. If a suggestion would genuinely improve the
code AND we want that improvement, fix it now. The goal is code quality, not just
getting past review gates. </core-mandate>

<efficiency-mandate>
Your time is valuable. Never idle. The parallel nature of bot reviews creates
opportunities - use them:

Work while bots run. Don't poll-and-sleep. When waiting for slow bots (Cursor, Codex,
Greptile), keep working on fixes from fast bots or investigating the codebase.

Check bot status between fixes rather than blocking on a single bot. Process whatever
comments are available, make fixes, push, then check again.

Investigate stalls immediately. If a bot stays "queued" or "in_progress" for more than 5
minutes without output, something is wrong. Check for:

- Merge conflicts (PR won't run checks until conflicts resolved)
- Build failures (subsequent checks may be blocked)
- CI queue depth (jobs waiting for runners)

Track elapsed time. If you've been waiting more than 10 minutes since starting with no
bot completing, something is wrong - report the stall and investigate root cause.

If you find yourself with nothing to do, say so explicitly and explain why. "Waiting for
Cursor with nothing else actionable" is acceptable. Silently sleeping is not.
</efficiency-mandate>

<usage>
/address-pr-comments - Auto-detect PR from current branch
/address-pr-comments 123 - Address comments on PR #123
</usage>

<pr-detection>
Use provided PR number, or detect from current branch via `gh pr view --json number`.
Exit with clear message if no PR exists for current branch.
</pr-detection>

<preflight-checks>
Before processing comments, verify the PR is in a runnable state:

**Mergeable status**: If conflicts exist, resolve them first. If mergeStateStatus is
BLOCKED, identify why (required checks failing, reviews needed).

**CI status**: If build is failing, that blocks other checks - investigate build failure
first. If jobs are queued indefinitely, there may be CI infrastructure issues.

These conditions explain why bots might not be running. Address root causes before
waiting for bot comments that won't arrive. </preflight-checks>

<comment-sources>
Code review bots comment at different API levels:

**PR-level comments** (issues endpoint): Claude Code Review posts here. Only address the
most recent Claude review - older ones reflect outdated code state.

**Line-level comments** (pulls endpoint): Cursor, Codex, Greptile post inline comments
on specific code lines. Address all of them - each flags a distinct location.

Known bots:

- `claude[bot]` - Claude Code Review (PR-level)
- `cursor[bot]` - Cursor Bugbot (line-level)
- `chatgpt-codex-connector[bot]` - OpenAI Codex (line-level)
- `greptile[bot]` - Greptile (line-level or PR-level)

New bots may appear - process any username ending with `[bot]` that posts code review
comments.

Fetch bot comments from both endpoints:

```bash
# PR-level (issues endpoint)
gh api repos/{owner}/{repo}/issues/{pr}/comments --jq '.[] | select(.user.login | endswith("[bot]"))'

# Line-level (pulls endpoint)
gh api repos/{owner}/{repo}/pulls/{pr}/comments --jq '.[] | select(.user.login | endswith("[bot]"))'
```

</comment-sources>

<reaction-protocol>
Every bot comment gets a reaction. No exceptions.

Reactions are training signals that shape future bot behavior:

- 👍 (+1): Helpful feedback you addressed. "More like this."
- ❤️ (heart): Exceptional catch - security issue, subtle bug, great insight
- 👎 (-1): Incorrect, irrelevant, or wrong analysis. "Less like this."
- 🚀 (rocket): Critical security vulnerability or production bug you fixed

Add reactions via API:

```bash
# PR-level comments (issues endpoint)
gh api repos/{owner}/{repo}/issues/comments/{comment_id}/reactions -f content="+1"

# Line-level comments (pulls endpoint)
gh api repos/{owner}/{repo}/pulls/comments/{comment_id}/reactions -f content="+1"
```

After processing all comments, verify every bot comment has a reaction before declaring
complete. </reaction-protocol>

<reply-protocol>
Replies are most valuable when explaining WHY a suggestion is wrong - this creates
training data that helps bots improve over time.

When declining, explain the context the bot lacks:

- "This value appears exactly once - constant extraction adds indirection without
  benefit"
- "Race condition isn't possible here - operations are serialized by the job queue"
- "Type system guarantees non-null at this point via the guard on line 42"

When a bot makes an exceptional catch (security issue, subtle bug), a brief
acknowledgment is welcome - "Great catch!" with a heart reaction reinforces good
behavior. But pure pleasantries without substance ("Thanks for the review!") add less
training value than a reaction alone.

When fixing, the commit speaks for itself. Mention the commit hash if helpful for
tracking.

Keep replies brief. The reaction is the primary signal; replies add context.
</reply-protocol>

<narration>
While working, share what you're finding:

- "Cursor found a real bug - null pointer if session expires mid-request. Great catch,
  adding heart reaction and fixing."
- "Claude wants magic string extraction for a one-time value. Thumbs down, declining."
- "SQL injection risk in search query - security issue, rocket reaction and addressing."

Keep narration brief and informative. </narration>

<triage-criteria>
For each bot comment, ask: "Is this suggestion correct given context the bot lacks?"

**Fix it** when the analysis is correct:

- Bug identified: Fix the bug
- Security issue found: Fix immediately, add heart/rocket reaction
- Logic error caught: Fix the logic
- Genuine improvement suggested: Implement it

When a bot correctly identifies an issue but suggests a suboptimal fix, address the
underlying issue with the appropriate solution. Credit the bot for the correct
diagnosis.

**Decline as Incorrect** when you can articulate why the bot is wrong:

- Bot wants constant extraction for a one-time contextually-clear value
- Bot flags race condition but operations are already serialized
- Bot suggests null check but type system guarantees non-null
- Bot requests validation but it's handled at a different layer

**Decline as WONTFIX** when the suggestion is correct but explicitly unwanted:

- ARIA accessibility suggestions (not a project priority)
- Internationalization when the app is English-only
- Performance optimizations for paths that don't matter
- Style preferences that conflict with project conventions

**Create GitHub issue** when suggestion is valid but scope exceeds this PR:

- Suggestion requires refactoring unrelated code
- Fix would be a separate feature or improvement
- Investigation needed beyond current PR context

Example: Bot finds a bug in a shared utility function used by your PR. Fixing the
utility would affect 10 other files. Create an issue rather than expanding PR scope.

Create the issue and link it in your reply so it's trackable.

Never decline just because fixing is inconvenient. If the code would be better with the
change, make the change. </triage-criteria>

<parallel-execution>
Process bot feedback incrementally. When one bot completes, address its comments
immediately while others run.

Claude Code Review typically completes faster than Cursor, Codex, or Greptile. Process
whichever bot's comments are available first rather than waiting for all bots. Make
fixes, commit, push, then process the next bot that completes.

After pushing fixes, re-poll since bots will re-analyze. Continue until all bots
complete and no new actionable feedback remains. If you've pushed 3+ times and bots keep
finding new issues, flag for user attention - something systematic may be wrong.
</parallel-execution>

<iteration-tracking>
Track processed comments by ID to avoid re-processing on subsequent iterations. Each
GitHub comment has a unique ID in the API response.

On re-poll after fixes:

- Skip comments with IDs you've already processed
- Only process new comments from bot re-analysis
- If a bot posts a new comment on a line you already fixed, it's new feedback

When called multiple times (e.g., from /autotask iterating), maintain awareness of
previously addressed feedback. Don't re-react to the same comment or re-announce the
same fix. </iteration-tracking>

<stall-detection>
Track waiting time. If you've been waiting more than 5 minutes for a specific bot with
no output, investigate.

Common stall causes:

- Merge conflicts: PR won't run new checks until conflicts resolved
- Build failure: Subsequent checks blocked until build passes
- CI queue: Jobs waiting for available runners
- Rate limiting: Too many concurrent checks

Report stalls clearly: "Cursor has been queued for 8 minutes. Build is failing on
`type-check` - this may be blocking other checks. Investigating build failure."

Don't silently wait. If something is stuck, say so and explain what you're doing about
it. </stall-detection>

<scale-with-complexity>
Match thoroughness to PR complexity, not line count. A 500-line generated migration is
trivial. A 20-line auth change needs careful attention.

Assess complexity by:

- Conceptual scope: Single focused change vs. multiple interrelated concerns
- Risk/blast radius: Does it touch auth, payments, data migrations, core abstractions?
- Novelty: Well-trodden patterns vs. new architectural territory
- Cross-cutting impact: Isolated change vs. affects multiple systems

Simple changes (config tweak, obvious bug fix, rename): Process comments quickly, fix
issues, complete fast. Don't over-think straightforward PRs.

Complex changes (new patterns, security-sensitive, architectural): Understand context
thoroughly. Consider creating GitHub issues for related improvements discovered during
review.

The goal is always code quality and PR completion. Thoroughness serves quality, not
delay. </scale-with-complexity>

<conflict-resolution>
Merge conflicts block bot checks and must be resolved first.

Fetch base branch, rebase or merge (depending on project conventions), and push. After
resolving, bots will re-run. Some previous comments may become obsolete.

For complex conflicts involving architectural decisions, flag for user attention rather
than auto-resolving. </conflict-resolution>

<human-comments>
Human reviewer comments require user attention, not auto-handling. Present separately
and clearly flag them for user review.
</human-comments>

<completion>
When all bots have completed and no actionable feedback remains, report:

- PR URL (prominent - user may have multiple sessions)
- PR title
- Structured counts: Fixed (N), Declined (N), Issues Created (N)
- Brief summary of what was fixed and why key suggestions were declined
- Any human comments still needing attention

Report format for callers (e.g., /autotask):

```
## Bot Feedback Addressed

**PR:** #123 - [title]
**Fixed:** 5 issues
**Declined:** 3 issues (2 incorrect analysis, 1 WONTFIX)
**Issues Created:** 1

Ready for human review.
```

Verify completeness: Did every bot comment get a reaction? If you missed any, go back
and add reactions before declaring complete.

Celebrate that the PR is ready to merge. A well-triaged PR is a beautiful thing.
</completion>

<retrospective>
After completion, consider what patterns emerged:

- What could have caught these issues earlier (pre-commit hooks, IDE plugins, better
  prompts)?
- Did multiple bots flag the same issue type, suggesting a systematic gap?
- Would new rules files or conventions prevent similar issues?

Share observations as opportunities for improvement. If you identify concrete changes,
offer to create GitHub issues or draft configurations. </retrospective>
