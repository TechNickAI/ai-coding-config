---
name: polish-sweep
# prettier-ignore
description: Scan codebase for polish issues - the "last 15%" that separates good from polished
argument-hint: "[scope: all | components | app | path/to/dir]"
version: 1.0.0
---

# /polish-sweep

$ARGUMENTS

---

<objective>
Find user-facing quality issues that make an app feel unfinished. Run 4 specialized
reviewers in parallel, aggregate findings, and present actionable recommendations.

This is the "last 15%" - issues that users feel but can't articulate. Missing feedback,
inconsistent behaviors, dead-end errors, and code patterns that lead to UX problems.
</objective>

<philosophy>
Users don't say "the tooltip delay is inconsistent." They say "this app feels janky."
We're finding the jank at the code level before users experience it.

Focus on HIGH and MEDIUM severity findings. Low severity is polish-on-polish - nice to
have but not blocking. </philosophy>

<scope-handling>
Parse the scope argument:

- **No argument or "all"**: Scan `components/` and `app/` directories
- **"components"**: Scan only `components/` directory
- **"app"**: Scan only `app/` directory
- **Specific path**: Scan the provided directory

Note: Default directories are optimized for Next.js/React projects. For other frameworks (Vue, Angular, etc.), specify a custom path like `src/components`.

Communicate the scope to each agent. </scope-handling>

<execution>
## Parallel Review

Spawn all 4 reviewer agents simultaneously using the Task tool. Each receives the scope
and returns structured findings with file paths, line numbers, severity, and suggested
fixes.

**Agents:**

- **ux-clarity-reviewer** — Missing feedback (loading, success, error, empty states)
- **ux-consistency-reviewer** — Behavioral inconsistency (tooltips, animations,
  patterns)
- **recovery-reviewer** — Dead-end error paths (missing retry, data loss, no escape)
- **code-consistency-reviewer** — Code pattern variance (prop naming, conventions)

## Aggregation

Combine agent outputs: deduplicate same-file+line findings, sort by severity (HIGH →
MEDIUM → LOW), group by file, track pattern frequency.

## Report Format

Format findings for actionability:

```markdown
# Polish Sweep Report

**Scope:** components/, app/ **Found:** X issues (Y high, Z medium)

## High Priority

### path/to/file.tsx

- **[clarity]** Line 45: Async operation without loading state → Add isLoading state,
  show spinner during fetch

- **[recovery]** Line 78: Error caught but no user feedback → Show error toast with
  retry option

## Medium Priority

### path/to/other-file.tsx

...

## Pattern Summary

| Issue Type            | Count | Files |
| --------------------- | ----- | ----- |
| Missing loading state | 5     | 4     |
| Inconsistent tooltip  | 3     | 3     |
| Dead-end error        | 2     | 2     |
```

</execution>

<output-guidelines>
**Keep it actionable:**

- Every finding includes a suggested fix
- Group by file so developer can address all issues in one pass
- Pattern summary shows systemic issues worth addressing globally

**Respect developer time:**

- HIGH and MEDIUM only by default
- Include LOW only if explicitly requested or if count is small (< 5)
- Skip issues in `.polish-ignore` if that file exists

**Be specific:**

- Include file path and line number
- Show the code pattern that triggered the finding
- Reference the standard (e.g., "standard tooltip delay is 300-500ms")
  </output-guidelines>

<ignore-file>
If `.polish-ignore` exists in project root, respect it:

```
# Syntax: path:agent:pattern
# Ignore all issues in a file
components/legacy/old-component.tsx

# Ignore specific agent findings
components/ui/oracle-menu.tsx:ux-consistency:tooltip

# Ignore specific pattern globally
*:code-consistency:import-style
```

Invalid lines are skipped with a warning.

</ignore-file>
