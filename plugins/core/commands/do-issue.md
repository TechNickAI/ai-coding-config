---
# prettier-ignore
description: "Autonomously triage and resolve a GitHub issue from analysis to PR ready for merge - handles investigation, fixes, testing, and PR workflow"
argument-hint: "[issue-number]"
version: 1.0.0
---

# /do-issue - Autonomous Issue Resolution

<objective>
Take a GitHub issue from initial triage to PR ready for merge, handling the complete lifecycle autonomously. Triage professionally, implement efficiently, deliver production-ready code.
</objective>

<user-provides>
Issue number (or auto-detect from current branch)
</user-provides>

<command-delivers>
Either a PR ready for merge resolving the issue, or a well-explained triage decision closing it.
</command-delivers>

## Usage

```
/do-issue           # Auto-detect from branch name
                    # Patterns: do-issue-123, fix-issue-123, issue-123, fix-123
/do-issue 123       # Explicit issue number
```

<branch-detection>
If no issue number provided, extract from current branch name using `git branch --show-current`.

Match patterns in order (extract first capture group):
- `do-issue-(\d+)`
- `fix-issue-(\d+)`
- `issue-(\d+)`
- `fix-(\d+)`

If no match or not on a branch, prompt user for issue number. Validate it's a positive integer before proceeding.
</branch-detection>

## GitHub Interaction

Use `gh` CLI for all GitHub operations. Use reactions to communicate progress: 👀 when
analyzing, 🚀 when starting work, ❤️ on helpful user comments.

## Workflow

<fetch-and-analyze>
Fetch the issue with `gh`. Check for existing PRs, assignees, and state. Extract the
core request, user impact, and requirements. Add 👀 reaction.
</fetch-and-analyze>

<triage>
Decide autonomously: Fix, Won't Fix, Need More Info, or Invalid.

Show your decision and rationale briefly. Be professional and thoughtful - these are
real users contributing to the project.

For Won't Fix, Need Info, or Invalid: update the issue with explanation and close if
appropriate. Done.

For Fix: continue to implementation. </triage>

<prepare>
When proceeding with a fix: add 🚀 reaction, add in-progress label if available, and comment with your implementation approach (2-3 bullets). Note: AI assistants cannot assign issues to themselves via the GitHub API.
</prepare>

<implement>
Use /autotask to implement the fix. Ensure the PR description includes "Fixes #{number}"
so GitHub auto-links and closes the issue when merged.
</implement>

<polish>
Use /address-pr-comments to handle bot feedback autonomously.

This gets the PR to "ready to merge" state without human intervention for bot-related
feedback. </polish>

<finalize>
Comment on the issue with the PR link. Add ❤️ to helpful user comments. The issue
auto-closes when the PR merges due to the "Fixes #" keyword.
</finalize>

## Progress Tracking

Use TodoWrite to track workflow phases. Create todos at the start, update status as you
progress. The goal is transparency and ensuring you complete all phases.

## Edge Cases

If assigned to someone else, ask before taking over. If a PR already exists, skip if
active or ask if stale (7+ days). If closed, ask before reopening.

## Completion Criteria

You're done when:

- Issue is triaged with clear decision documented
- If fixing: PR is created, bot feedback addressed, and PR is ready to merge
- If not fixing: Issue is updated with explanation
- Issue is properly linked to PR (if fixing)
- All todos are marked completed

Don't stop mid-workflow. The todos help ensure you complete all phases.

## Error Recovery

If /autotask or /address-pr-comments fail, evaluate recoverability. Transient errors
(API failures, missing dependencies): retry with additional context. Fundamental
blockers (architectural issues, unclear requirements): comment on the issue explaining
the blocker and ask for guidance. Never silently abandon the workflow.

## Key Principles

Autonomous but transparent: make decisions independently, document them clearly.
Professional communication: users took time to file issues, treat them with respect.
Bias toward action: move quickly to implementation or explain thoughtfully why not.
Complete the cycle: deliver the PR or close with explanation, never leave half-done.

## Integration Points

Uses existing commands:

- `/autotask` - Implementation and PR creation
- `/address-pr-comments` - Bot feedback handling

Follows existing rules:

- `@rules/git-commit-message.mdc` - Commit formatting (via /autotask)
