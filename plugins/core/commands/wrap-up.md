---
# prettier-ignore
description: "Merge PR, sync local to main, clean up branch - the satisfying end to a feature workflow"
argument-hint: "[pr-number]"
model: haiku
version: 1.0.1
---

# /wrap-up - Complete the Feature Workflow

<objective>
Merge the PR, sync local state to main, clean up the feature branch, and celebrate the
accomplishment. This is the final step after /autotask and /address-pr-comments.
</objective>

## Usage

```
/wrap-up        - Auto-detect PR from current branch
/wrap-up 123    - Wrap up PR #123
```

<pr-detection>
Find the PR from the argument or current branch. If no PR exists or it's already closed,
inform user and exit.
</pr-detection>

<merge-readiness>
Check that the PR can be merged (no conflicts, not blocked). If CI is failing, warn but
proceed - user has context we don't.

If blocked by conflicts or missing approvals, tell user what's blocking and exit.
</merge-readiness>

<merge-and-cleanup>
Use `gh pr merge --merge --delete-branch` for the merge.

This single command handles everything:

1. Merges the PR with a merge commit
2. Deletes the remote branch
3. Switches to main and pulls merged changes
4. Deletes the local branch automatically

Do NOT attempt to delete the local branch manually - `--delete-branch` already did it.
You'll get "branch not found" errors if you try. </merge-and-cleanup>

<completion-state>
After merge, show clear state so the user knows exactly where they are when they context-switch
back to this terminal later.

Detect current state:

- Is this a worktree? (check `git worktree list`)
- What's the absolute path?
- Where's the main repo?

**If in a worktree (common case after /autotask):**

```
✓ PR #123 "Add wrap-up command" merged to main

You're in: {worktree-path} (worktree, now orphaned)
Main repo: {main-repo-path}

→ git worktree remove . (from main repo) to clean up
→ cd {main-repo-path} to continue there
```

**If in main repo:**

```
✓ PR #123 "Add wrap-up command" merged to main

On main at {repo-path}, up to date.
```

The value is clarity of state, not celebration. Brief, informative, shows next options.

Language precision: Say "merged to main" not "live" or "deployed". Merged means it's in
the codebase. Live/deployed means running in production - requires CI to pass and deploy
to complete. Don't conflate these. </completion-state>

<error-messages>
PR not found: Guide user to create one.
Not mergeable: Point to `/address-pr-comments`.
Already merged: Just sync local state.
CI failing: Warn but allow proceeding.
</error-messages>

## Key Behaviors

- Merge commit preserves full branch history
- `--delete-branch` handles both remote and local branch cleanup automatically
- Worktrees preserved for user to clean up when ready
- Output prioritizes state clarity for context-switching back later
