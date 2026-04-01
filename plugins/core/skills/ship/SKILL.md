---
name: ship
# prettier-ignore
description: "Use when shipping code - complete workflow: merge main, run tests, multi-review with auto-fix, commit, push, create PR. Replaces manual commit-push-pr flows."
version: 1.1.0
category: workflow
triggers:
  - "ship"
  - "ship it"
  - "push and PR"
  - "ready to ship"
  - "land this"
  - "send it"
---

# Ship

Complete shipping workflow. When the user says "ship it", DO IT — don't ask for
confirmation at every step. Only stop for: merge conflicts, test failures, ASK items
from review, or errors.

## Usage

- `/ship` — Full workflow on current branch
- `/ship --skip-tests` — Skip test step (use when tests already passed)
- `/ship --skip-review` — Skip multi-review (use for trivial changes)
- `/ship --quick` — Skip both tests and review (docs-only, typo fixes)

## Pre-flight

1. **Branch check**: If on main/master, STOP. Tell the user to create a feature branch
   first. Do not create branches for them — that's a decision about naming and scope.

2. **Detect base branch**: Check `git remote show origin` or common names (main, master,
   develop). This is the merge target.

3. **Check for uncommitted changes**: If there are unstaged/staged changes, note what
   will be included. Stash them before merging if git would refuse the merge, then
   unstash after.

## Step 1: Merge latest base branch

Use `git rev-parse --abbrev-ref origin/HEAD` (fast, local) to detect the base branch.

```
git fetch origin <base>
git merge origin/<base>
```

If merge conflicts occur, STOP and report them. Do not auto-resolve — merge conflicts
require human judgment about which version is correct.

If already up-to-date, continue silently.

## Step 2: Run tests

Detect the test runner from project context:

- `package.json` scripts: `test`, `test:unit`, `test:integration`
- `pytest` / `python -m pytest`
- `go test ./...`
- `cargo test`
- `mix test`
- `bundle exec rspec`

Run the detected test command. If tests fail:

- **Pre-existing failures** (also fail on base branch): Note them, continue with a
  warning. These aren't your problem.
- **New failures** (pass on base, fail on branch): STOP. Report which tests broke. Do
  not ship broken code.

If no test runner is detected, skip with a note.

Skip this step if `--skip-tests` or `--quick` was passed.

## Step 3: Multi-review with fix-first

Invoke `/multi-review balanced` (or `deep` for changes touching 10+ files).

Multi-review runs parallel agents, automatically fixes unambiguous issues, and reports
what was Fixed, Wontfix, and Deferred. Any auto-fixed changes will be included in the
commit.

If review surfaces items requiring user decision (ASK tier), STOP and present them
before continuing.

Skip this step if `--skip-review` or `--quick` was passed.

## Step 4: Version bump + changelog (optional)

Only if the project has these files:

- **VERSION file**: Detect change magnitude from diff:
  - Docs/comments only → no bump
  - Bug fixes, small changes → patch bump
  - New features, API additions → minor bump
  - Breaking changes → ASK user for confirmation before major bump

- **CHANGELOG.md**: Auto-generate entry from diff. Use the commit messages and PR
  description to write a human-readable summary. Prepend to the existing changelog.

If neither file exists, skip silently.

## Step 5: Commit

Analyze all changes (original work + auto-fixes + version bump).

Create commits following the project's commit style (check recent `git log` for
conventions). If the repo uses conventional commits, follow that. If it uses emoji
prefixes, follow that.

For large changesets, create bisectable commits — logical units, not one giant commit.
Typical split: migrations → models → services → controllers → tests → version/changelog.

For small changesets, one commit is fine.

Always include:

```
Co-Authored-By: Claude <noreply@anthropic.com>
```

## Step 6: Push

```
git push -u origin <current-branch>
```

If push fails due to divergence, report it. Do not force-push.

## Step 7: Create PR

First check if a PR already exists: `gh pr view --json url`. If it exists, skip creation
and output the existing PR URL. Otherwise create with `--base <base>`:

```
gh pr create --title "<concise title>" --base <base> --body "$(cat <<'EOF'
## Summary
<1-3 bullet points describing what this PR does>

## Changes
<Brief description of key changes, organized logically>

## Review findings
<Summary from multi-review: auto-fixed items, user decisions, wontfix items>
<Omit this section if review was skipped>

## Test plan
- [ ] Tests pass locally
- [ ] <Specific test scenarios relevant to the changes>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

## Step 8: Report

Output the PR URL and a one-line summary:

```
PR #123 'Add user notifications' created on feature/notifications → main
https://github.com/org/repo/pull/123
```

## Gates (always stop for)

- On main/master branch (no branch to ship from)
- Merge conflicts
- New test failures
- ASK items from multi-review
- Push failures
- PR creation failures
- Major version bump confirmation

## Non-interactive philosophy

This skill is designed to be invoked and left alone. The user said "ship it" — they want
it shipped, not a conversation about shipping. Do the work, report the result.

The only interruptions should be genuine blockers that require human judgment, not
confirmations of things the user already decided by saying "ship."
