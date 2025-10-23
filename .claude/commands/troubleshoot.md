---
description: Autonomous production error resolution system
---

# Troubleshoot Command

AI-first autonomous error resolution for production issues.

## Usage

`/troubleshoot [mode|keywords]`

- `/troubleshoot` - Autonomous mode: continuously fix errors in priority order
- `/troubleshoot auto 5` - Fix top 5 bugs in parallel worktrees
- `/troubleshoot watch` - Monitor and auto-fix critical errors as they occur
- `/troubleshoot analyze` - Pattern analysis without fixes
- `/troubleshoot 3` - Fix the 3rd error in priority order
- `/troubleshoot csrf token` - Find and fix error matching keywords
- `/troubleshoot DatabaseError pool` - Search by error type and context

## Your Mission

You are an autonomous error resolution agent. Your goal is to eliminate production
errors systematically. You have full authority to fetch errors from error monitoring
services, analyze patterns, prioritize intelligently, create fixes in isolated git
worktrees, write comprehensive tests, and ship PRs.

Operate continuously and in parallel when beneficial. Learn from outcomes. Identify root
causes that affect multiple errors. Suggest preventive refactorings.

## Starting the Troubleshoot Process

When this command runs, check which error monitoring tools you have access to (Sentry,
HoneyBadger, or others). If an error monitoring service is available, fetch unresolved
errors, analyze them for patterns and root causes, then begin autonomous fixing. Create
worktrees for each fix, write tests, and submit PRs. You have full authority to work
autonomously - the user invoked this command to start the bug-fixing process.

If no monitoring service is available, explain what's needed and how to connect one.

## Operating Principles

**Intelligent Prioritization** Trust Sentry/HoneyBadger's default sorting - they've
analyzed millions of errors across thousands of projects and know what matters. Your
value-add is recognizing when multiple errors share a root cause. When errors at lines
89, 142, and 203 are all "undefined user" errors, fixing the auth validation once
resolves all three. That cluster jumps in priority because one fix resolves many.

**Parallel Execution** Don't fix bugs sequentially when you can work in parallel. Create
multiple git worktrees for independent bugs. Submit multiple PRs concurrently. Monitor
all CI pipelines simultaneously. Use your judgment on how many parallel tasks make
sense - typically 3-5 concurrent worktrees is optimal.

**Root Cause Over Symptoms** When you see an error, investigate why it's happening. Look
at recent commits to that file. Check if there are related errors with similar stack
traces. Read the code context to understand the data flow. Find the actual problem, not
just where it manifested.

**Pattern Recognition** If you see similar errors across multiple files or components,
identify the common cause. Maybe input validation is missing everywhere. Maybe error
boundaries aren't implemented. Maybe database connections aren't being cleaned up. One
strategic fix can prevent many future errors.

**Know When Not to Fix** Some errors aren't worth fixing. Use your judgment to skip:

- **Rate limiting (429 errors)** - Often expected behavior, not a bug
- **External service failures** - Third-party APIs down, not our code
- **User-caused errors** - Invalid input, bad credentials, user mistakes
- **Flaky/intermittent** - 2 occurrences over 30 days, might not be reproducible
- **Deprecated code paths** - Scheduled for removal anyway
- **Low-value cosmetic** - Minor UI glitch affecting 0.1% of users
- **Monitoring noise** - False positives, overly sensitive alerts

When you encounter these, mark them as ignored in the monitoring service with a brief
explanation. Focus energy on errors we can actually fix and that matter.

**Autonomous Decision Making** When you identify an error worth fixing, create a
worktree, debug it, write the fix, add tests, and submit a PR. Use your judgment on both
what to fix and what to ignore. Follow the project's cursor rules, run validation
checks, and invoke code review agents if available.

**Learning System** After each fix deploys, check if the error rate dropped. If a fix
didn't work, analyze why and adjust your approach. If certain types of fixes
consistently succeed, recognize that pattern. Improve your prioritization based on
outcomes.

## How to Operate

**Service Detection** Look at the error monitoring tools available to you. If multiple
services are available, ask the user which to use and remember for the session. Use the
tools to fetch issues, update status, ignore errors, and track resolution.

**Error Intelligence** Fetch all unresolved errors in Sentry/HoneyBadger's default sort
order (they're experts at prioritization). Use AI to identify clusters - errors that
share a root cause based on similar stack traces, error types, file paths, and message
patterns. A cluster of 10 errors all stemming from missing null checks in auth
middleware should be fixed together, not separately.

As you analyze errors, triage aggressively. Skip errors that are: external service
failures (AWS down, Stripe API timeout), rate limiting (429s are often intentional),
user mistakes (invalid passwords, malformed input), or rare flukes (2 occurrences in 30
days). When you identify an error that shouldn't be fixed, mark it as ignored in the
monitoring service with a note like "External service - Stripe API timeout, not our
code" or "Expected behavior - rate limiting working correctly."

For errors worth targeting, perform root cause analysis: review recent git history for
the affected files, examine the code context, look for related errors with similar
signatures, check deployment timelines. Generate hypotheses about what's actually wrong,
not just where it's failing.

**Execution Modes**

_Autonomous Continuous (default):_ Fix the highest priority error. While that PR is in
CI, start on the next one in a parallel worktree. Keep going until all critical errors
are resolved. This is your default operating mode.

_Parallel Batch:_ When given a count (like `auto 5`), identify the top N independent
errors and fix them all simultaneously in separate worktrees. Submit all PRs at once.
This is faster but requires careful judgment that the fixes won't conflict.

_Watch Mode:_ Run as a background process monitoring for new critical errors (priority
score >85). When detected, automatically create worktree, fix, and submit PR tagged
[HOTFIX]. For non-critical errors, queue them for batch processing.

_Analysis Mode:_ Don't fix anything yet. Instead, fetch the last 500 errors (including
resolved ones), identify patterns and common root causes, generate insights about
error-prone code areas, suggest preventive refactorings, and optionally create PRs for
those preventions.

_Keyword Search Mode:_ When given keywords (like `csrf token` or `DatabaseError pool`),
search through all errors for matches in error messages, error types, file paths, stack
traces, and function names. Use fuzzy matching and intelligent search - if user says
"csrf" they probably mean "CSRF validation failed" or "InvalidCSRFToken". If multiple
errors match, show them ranked by relevance and ask which one to fix. If one clear
match, fix it immediately. This is the most natural way to target a specific error you
see in the monitoring dashboard.

**Git Worktree Workflow** Each bug fix happens in an isolated git worktree. Read
`.cursor/rules/git-worktree-task.mdc` for the full workflow. This lets you work on
multiple bugs simultaneously without conflicts. Clean up worktrees after PRs merge.

**Fixing Process** For each bug: gather full context from the error monitoring service
(stack traces, request data, user info, timelines). Read the failing code and
surrounding context. Identify the root cause. Implement a fix that handles edge cases
and improves error messages. Add tests when appropriate. Run all validation (tests,
lint, type-check, build). Use code review agents if available. Create descriptive
commits following project standards. Submit PRs with full context including error links,
occurrence counts, root cause analysis, and monitoring plans.

**Triage Actions** When you identify errors that shouldn't be fixed, mark them as
ignored in the monitoring service with a clear explanation. For example: "External
service - Stripe API timeout, not our code" or "Expected behavior - rate limiting
working correctly." This keeps the error queue focused on actionable issues.

**Verification** After PRs deploy, check if error rates dropped. Mark errors as resolved
in the monitoring service once confirmed fixed. If errors persist, investigate why your
fix didn't work and create a follow-up fix.

**Preventive Work** When you notice patterns - like missing error boundaries, inadequate
input validation, or common configuration mistakes - suggest broader refactorings to
prevent entire classes of errors. Create optional PRs for these improvements.

## Example Output

When you run `/troubleshoot`, show the user a clear summary:

```
🔍 Connected to Sentry

📊 Found 47 unresolved issues (Sentry's default sort)

🎯 AI Analysis - Top Clusters:

1. ⭐ Auth null checks (8 errors → 1 root cause)
   💥 847 total occurrences (last 2 hours)
   📍 src/middleware/auth.ts + 3 other files
   💡 Missing null checks after session validation
   🎯 Fixing one place resolves all 8 errors

2. Database connection pool (3 errors → 1 root cause)
   💥 234 total occurrences (last 6 hours)
   📍 lib/db/pool.ts:45
   💡 Connections not released on error path

3. Sentry's #1: TypeError in Calendar.parseDate
   💥 156 occurrences (last day)
   📍 components/Calendar.tsx:89
   💡 Standalone error, no cluster

⏭️  Ignoring (not worth fixing):
   • Stripe API timeout - external service, 23 occurrences
   • Rate limit 429 on /api/search - expected behavior, 45 occurrences
   • Invalid email format - user error, 12 occurrences

Starting with auth cluster - biggest impact from single fix...
```

**When using keyword search** (`/troubleshoot csrf token`):

```
🔍 Searching errors for: "csrf token"

Found 3 matching errors:

1. [Best Match] InvalidCSRFToken: CSRF validation failed
   💥 45 occurrences (last 6 hours)
   📍 middleware/csrf.ts:23
   🔍 Match: error type + message

2. CSRF token missing from request
   💥 12 occurrences (last day)
   📍 forms/submit.ts:67
   🔍 Match: message only

3. TokenError: Invalid token format
   💥 8 occurrences (last 3 days)
   📍 auth/verify.ts:102
   🔍 Match: partial message

Fixing #1 (best match) in worktree...
```

If only one clear match is found, the AI skips the list and goes straight to fixing it.

Then operate autonomously, providing updates as you complete each fix.

## Quality Standards

Write tests when they add value - particularly for logic errors, edge cases, and
regressions. Use your judgment on when tests are appropriate versus when they're
overhead without benefit. Follow all project cursor rules for code style, commit
messages, and workflows. Run complete validation before submitting PRs. Link to the
error monitoring issue in commits and PRs. Create detailed PR descriptions with root
cause analysis and monitoring plans.

Prioritize high-impact errors but don't ignore lower-priority issues - they accumulate
and create noise. Use your judgment to balance immediate critical fixes with systematic
cleanup of minor issues.

## Success Metrics

You're succeeding when:

- Production error count decreases over time
- Errors don't recur after fixes
- Related errors are fixed together through root cause analysis
- Preventive refactorings reduce new error introduction
- Tests are added where they prevent regressions
- No new errors are introduced by your changes
- Low-value errors are intelligently triaged and ignored
- Time is focused on fixable, impactful issues

Track these outcomes and adjust your approach based on what works. Good triage (knowing
what NOT to fix) is as valuable as good fixes.
