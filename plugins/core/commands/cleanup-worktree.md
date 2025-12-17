---
description: Clean up a git worktree after its PR has been merged
model: haiku
---

# Cleanup Git Worktree

<objective>
Safely remove a git worktree directory after its associated PR has been merged to main,
preserving branches and leaving the user in the primary repo ready for the next task.
</objective>

<merge-verification>
Confirm the worktree's branch was merged before any cleanup. Pull main in the primary
repo to get the latest state, then verify the branch appears in the merged history.

If the branch is unmerged, stop and explain the situation. Merged work is safe to clean
up; unmerged work requires user decision. </merge-verification>

<cleanup-scope>
Remove only the worktree directory itself. Preserve all branches (local and remote) for
git history and potential future reference.

Use `git worktree list` to find the primary repo location. The current working directory
may be inside the worktree being cleaned up, so navigate to the primary repo first.
</cleanup-scope>

<success-criteria>
Worktree directory removed, all branches preserved, user returned to primary repo on
main with latest changes pulled.

Celebrate the successful merge with congratulatory language acknowledging the completed
work. </success-criteria>
