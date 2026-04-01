---
# prettier-ignore
description: "Multi-agent code review with diverse perspectives - run multiple specialized reviewers in parallel for comprehensive analysis"
argument-hint: "[count|depth]"
version: 3.0.0
model: inherit
---

# Multi-Agent Code Review

<objective>
Run N parallel code review agents with diverse perspectives. Each agent operates in
isolation, catching issues that others miss. Synthesize findings into actionable fixes.

Usage:

- `/multi-review` - auto-detect appropriate depth
- `/multi-review 5` - explicit count
- `/multi-review deep` - depth-based scaling (quick | balanced | deep) </objective>

<depth-scaling>
When depth is specified or inferred from context:

**quick**: 1-2 agents focused on correctness. Minimal overhead for simple changes.

**balanced** (default): 2-3 agents covering primary domains the code touches.

**deep**: 5+ agents for comprehensive coverage:

- architecture-auditor (always)
- security-reviewer (always)
- logic-reviewer (always)
- performance-reviewer
- error-handling-reviewer
- Domain-specific reviewers based on code

Auto-detect depth from context: single-file change with clear purpose → quick;
multi-file implementation → balanced; architectural changes, new patterns, security-
sensitive code → deep.

When called from /autotask, respect the complexity level already determined.
</depth-scaling>

<philosophy>
Multi-review exists to surface issues and fix them before merging. This is not a
gate-keeping exercise looking for "blockers"—it's a collaborative improvement process.

When agents surface valid issues, fix them. Don't carry technical debt forward with
"we'll address this later." The only valid reasons to not fix something:

1. **Wontfix**: The suggestion doesn't apply given full context
2. **Complexity trade-off**: The fix adds more complexity than the risk it mitigates
3. **Large scope**: Fixing would require substantial architectural changes outside this
   PR

Reference `plugins/core/code-review-standards.md` for detailed guidance on false
positives (single-use values, theoretical race conditions, redundant type safety,
premature optimization) and complexity trade-offs. If the project has custom standards
in `.cursor/rules/code-review-standards.mdc`, reference those as well.

For large scope: Create a follow-up issue/task, but be honest—if it should have been
done differently from the start, that's feedback for next time, not permission to merge
broken code. </philosophy>

<agent-discovery>
Discover available review agents by examining the Task tool's agent types and any
project-specific agents in .claude/agents/. Look for agents with "review" or "audit" in
their name or description.

Categorize by focus area: correctness, security, performance, architecture, quality, UX,
observability. Select N agents ensuring diversity—don't pick multiple agents from the
same domain.

When the code has characteristics that no discovered agent covers well, create a dynamic
agent using general-purpose with a focused prompt. </agent-discovery>

<execution>
Identify the code to review from context (branch diff, PR changes, staged changes, or
recent modifications). Analyze what domains the code touches. Select N agents ensuring
diversity across domains. Launch all agents in parallel using multiple Task tool calls
in a single message.

After agents complete, apply the fix-first synthesis workflow:

1. **Collect**: Gather all findings, deduplicate across agents, group by severity, note
   which agent caught each issue

2. **Classify** each finding as AUTO-FIX, ASK, or DEFER:

   **AUTO-FIX** — Apply immediately without asking. High confidence, unambiguous, low
   risk of changing behavior in unexpected ways. In test files, only apply AUTO-FIX for
   import/formatting issues — route logic changes to ASK:
   - Unused imports, dead code flagged by multiple agents
   - Missing `await` where the return value is used or error must be caught (not
     fire-and-forget patterns — those require judgment and belong in ASK)
   - Obvious null/undefined checks where crash is certain
   - Wrong casing or naming convention violations
   - Missing error propagation (empty catch blocks, swallowed errors)
   - Import ordering, formatting issues
   - Straightforward type fixes (wrong type annotation, missing return type)

   **ASK** — Batch into a single question for the user. Needs judgment, multiple valid
   approaches, or risk of unintended behavior change. **When in doubt, classify as
   ASK.**
   - Architectural restructuring or pattern changes
   - Performance optimizations with trade-offs
   - Security-sensitive changes (auth, crypto, input validation)
   - Changes that alter public API or user-facing behavior
   - Suggestions where the "right" answer depends on product context
   - Anything that touches test assertions or expected values
   - Changes where reasonable engineers would disagree
   - Missing `await` on fire-and-forget patterns (behavior change, not just style)
   - Deduplication requiring abstraction design decisions (where does it live?)

   **DEFER** — Valid but out of scope for this PR. Create a follow-up task and note it:
   - Improvements to shared utilities used across many files
   - Refactors that touch unrelated code
   - Suggestions that would significantly expand PR scope

3. **Fix**: Apply all AUTO-FIX items immediately. Keep a running list of what was fixed.

4. **Ask**: If any ASK items exist, present them in a single batch with context and a
   recommendation for each. Use the actual agent name that caught the issue:

   ```
   Review found N items needing your input:

   1. [Agent: security-reviewer] SQL query in user-search.ts:42 uses string
      interpolation → RECOMMENDATION: parameterize, because user input flows here
   2. [Agent: architecture-auditor] Service layer bypasses repository pattern
      → RECOMMENDATION: keep as-is, this is a one-off admin endpoint
   ```

5. **Apply user decisions**: Fix items the user approves, mark others as wontfix.

6. **Report**: Summary of everything — auto-fixed, user-approved fixes, declined items
   with reasons, and deferred items with task references. Omit empty sections.
   </execution>

<dynamic-agents>
When code requires domain expertise no existing agent provides, create a focused
reviewer. Use subagent_type="general-purpose" with a prompt specifying the domain and
key concerns. Keep prompts goal-focused—state what to review for, not how to review.

Common domains: Temporal workflows, GraphQL, database migrations, rate limiting,
authentication, caching, streaming, real-time updates. </dynamic-agents>

<output-format>
After completing the fix-first workflow, provide a summary:

**Auto-fixed** (N issues):

- Issue description → what was changed (agent that caught it)

**User-approved fixes** (N issues, only if ASK items were presented and approved):

- Issue description → what was changed

**Wontfix** (N issues):

- Issue description → why bot analysis doesn't apply given full context

**Deferred** (N issues, only for large scope):

- Issue description → follow-up task created

If all agents return no issues, note this explicitly. When called from /ship or
/autotask, keep the summary concise — the caller will incorporate it into the PR body.
</output-format>
