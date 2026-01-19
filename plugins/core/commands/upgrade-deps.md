---
# prettier-ignore
description: "Scan dependencies for updates, discover new features from changelogs, implement quick wins, create issues for larger opportunities - transforms maintenance into capability expansion"
argument-hint: "[package-name?]"
version: 1.0.0
---

# /upgrade-deps - Dependency Discovery & Update

<objective>
Transform dependency updates from maintenance chores into feature discovery opportunities.
Scan outdated packages, analyze changelogs for new capabilities relevant to our codebase,
update with verification at each step, implement quick wins, and create issues for larger
opportunities.
</objective>

<value-proposition>
This is not about "is it safe to update" — tests are the safety net. This is about
discovering what we can BUILD with new versions. Every update is a chance to adopt
better APIs, remove workarounds, and expand capabilities.
</value-proposition>

## Usage

```
/upgrade-deps              # Scan and update all outdated packages
/upgrade-deps react        # Update specific package only
/upgrade-deps @tanstack/*  # Update packages matching pattern
```

## Arguments

$ARGUMENTS

If no argument provided, scan all dependencies.

## Ecosystem Detection

<ecosystem-detection>
Detect the package manager from project files:

**JavaScript/TypeScript:**

- `package.json` + `pnpm-lock.yaml` → pnpm
- `package.json` + `package-lock.json` → npm
- `package.json` + `yarn.lock` → yarn
- `package.json` + `bun.lockb` → bun

**Python:**

- `pyproject.toml` with `[tool.poetry]` → poetry
- `pyproject.toml` with `[tool.uv]` or `uv.lock` → uv
- `pyproject.toml` (generic) → pip with pyproject.toml
- `requirements.txt` → pip

If multiple ecosystems detected (e.g., both package.json and pyproject.toml), process
each ecosystem separately, starting with the one containing the specified package
argument or asking which to update if no argument provided. </ecosystem-detection>

<tooling-matrix>
| Operation | pnpm | npm | yarn | bun | pip | poetry | uv |
|-----------|------|-----|------|-----|-----|--------|-----|
| Outdated | `pnpm outdated` | `npm outdated` | `yarn outdated` or `yarn up -i` (v2+) | `bun outdated` | `pip list --outdated` | `poetry show --outdated` | `uv pip list --outdated` |
| Install | `pnpm install` | `npm install` | `yarn install` | `bun install` | `pip install .` or `-r requirements.txt` | `poetry install` | `uv sync` |
| Update one | `pnpm update {pkg}` | `npm update {pkg}` | `yarn upgrade {pkg}` (v1) or `yarn up {pkg}` (v2+) | `bun update {pkg}` | `pip install --upgrade {pkg}` | `poetry update {pkg}` | `uv add {pkg}@latest` |
| Type check | `pnpm tsc --noEmit` | `npx tsc --noEmit` | `yarn tsc --noEmit` | `bun tsc --noEmit` | `mypy .` (if configured) | `mypy .` | `mypy .` |
| Tests | `pnpm test` | `npm test` | `yarn test` | `bun test` | `pytest` | `pytest` | `pytest` |

**Note on Yarn versions:** Detect Yarn classic vs Berry/v2+ by checking `yarn.lock` for
`__metadata` field. Classic uses `yarn upgrade`, Berry uses `yarn up`.

**Note on pip install:** Check for `requirements.txt` first. If absent but
`pyproject.toml` exists, use `pip install .` for pyproject-only projects.
</tooling-matrix>

## Workflow

<scan>
Before starting updates, verify the baseline: run type check and tests to confirm they
pass. If either fails, note this and ask how to proceed—updating on a broken baseline
makes it impossible to isolate which update caused issues.

Identify all packages with available updates using the appropriate outdated command.
Group by update type:

- Patch: Bug fixes only (1.2.3 → 1.2.4)
- Minor: New features, backward-compatible (1.2.3 → 1.3.0)
- Major: Breaking changes possible (1.2.3 → 2.0.0)

Identify related packages that should update together to avoid version mismatches.
</scan>

<changelog-analysis>
For each outdated package, fetch the changelog between our current version and the latest:

Primary sources (in order of preference):

- GitHub Releases API: `gh api repos/{owner}/{repo}/releases`
- CHANGELOG.md in the repository
- PyPI/npm package page release notes

Extract and categorize:

- New features and APIs we could adopt
- Deprecations affecting code we use
- Bug fixes relevant to our usage patterns
- Breaking changes requiring migration

For bug fixes: Scan our codebase for usage of the affected code paths. Report only bugs
that actually impacted us, not every fix in the changelog.

For new features: Identify where our code could benefit. Look for patterns like:

- Manual implementations that the library now handles
- Workarounds for issues now fixed
- New APIs that simplify existing code </changelog-analysis>

<confirmation-gates>
Proceed automatically for patch and minor updates.

Pause and confirm before:

- Major version updates
- Updates with breaking changes in the changelog
- Updates to core dependencies (react, next, typescript, django, fastapi, sqlalchemy)
- Updates where the changelog indicates significant API changes

Present: Current version, target version, summary of changes, any code modifications
that may be needed. </confirmation-gates>

<update-loop>
For each package (or batch of related packages), update it then verify with type
checking and tests. If either verification fails, stop immediately—report which package
caused the failure and the specific errors. The user needs to decide how to proceed.

If checks pass, continue to the next package.

After all updates complete, run a final batch verification (type check + tests) with all
updates applied together. This catches cross-package conflicts that sequential testing
missed—package A might pass alone, package B might pass alone, but A+B together could be
incompatible. </update-loop>

<feature-implementation>
After successful updates, evaluate discovered opportunities:

Quick wins (implement inline):

- New API that directly replaces existing code
- Simplified syntax for patterns we already use
- Removal of workarounds for fixed bugs
- Single-file changes with clear before/after (roughly 20 lines or fewer)

Medium scope (create GitHub issue):

- New features requiring architectural consideration
- Deprecation migrations affecting multiple files
- Performance improvements requiring measurement
- New capabilities we should adopt but need planning

For each GitHub issue created, include:

- Link to the relevant changelog entry
- Files in our codebase that would be affected
- Suggested implementation approach
- Link to new documentation </feature-implementation>

<commit-strategy>
One PR per command invocation.

Commit granularity:

- Batch commit for patch/minor updates with no code changes:
  `chore(deps): update patch/minor dependencies`
- Separate commit when implementing a feature from an upgrade:
  `feat(deps): update {package} to v{version} - {what was implemented}`
- Separate commit for breaking change migrations:
  `refactor(deps): migrate to {package} v{version} API`

Each commit should pass type check and tests independently. </commit-strategy>

## Final Report

<report-structure>
Present a summary when complete:

**Packages Updated** Table: Package | Previous | Current | Change Type

**New Features Available** For each update with new capabilities:

- What's new (link to docs)
- How it applies to our codebase
- Whether it was implemented or deferred

**Bugs Fixed That Affected Us** Only bugs where we use the affected code paths:

- What was broken
- Where we use it
- Confirmation it's resolved

**Quick Wins Implemented** What was adopted inline during this update.

**GitHub Issues Created** Links to issues for larger opportunities.

**Deprecation Warnings** APIs we use that are now deprecated, with migration timeline.
</report-structure>

## Related Package Groups

Handle these as atomic updates to avoid version mismatches:

**JavaScript/TypeScript:**

```
@tanstack/react-query, @tanstack/react-query-devtools
@radix-ui/* (when updating any Radix component)
eslint, @typescript-eslint/*, eslint-config-*
@testing-library/react, @testing-library/jest-dom
next, @next/*
```

**Python:**

```
sqlalchemy, alembic
django, django-*
fastapi, starlette, pydantic
pytest, pytest-*
mypy, types-*
```

## Edge Cases

<no-changelog>
If a package has no discoverable changelog, proceed with the update but note it in the
report. Rely on type check and tests to catch issues.
</no-changelog>

<pre-existing-failures>
If type check or tests fail BEFORE any updates, note this and ask how to proceed.
Updating on a broken baseline makes it impossible to isolate which update caused issues.
</pre-existing-failures>

<monorepo-packages>
For monorepo packages (multiple packages from same repo), fetch the changelog once and
apply relevant entries to each package being updated.
</monorepo-packages>

<mixed-ecosystem-projects>
For projects with both JS and Python dependencies, process one ecosystem at a time.
Complete all updates for one ecosystem before starting the other. This keeps the
verification loop clean and isolates cross-ecosystem issues.
</mixed-ecosystem-projects>

## Progress Tracking

Use TodoWrite to track:

- Packages to update (with version info)
- Changelog analysis status
- Update and verification status
- Feature implementation status
- GitHub issues to create

This provides visibility into progress for long-running updates across many packages.

## Key Principles

Tests are the safety net, not "safety theater" checks. If tests pass, the update is
good.

Feature discovery is the primary value. Every dependency update is a chance to improve
the codebase, not just bump version numbers.

Isolation through sequential verification. Check after each update so failures point to
the specific package that broke things.

Actionable output. The final report should make it clear what changed, what's possible
now, and what to do next.
