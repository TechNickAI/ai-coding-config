---
# prettier-ignore
description: "Multi-agent code review with diverse perspectives - run multiple specialized reviewers in parallel for comprehensive analysis"
argument-hint: "[count|depth]"
version: 2.2.0
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

After agents complete:

1. Synthesize results: deduplicate, group by severity, note which agent caught each
   issue
2. For each issue, determine: fix now, wontfix (with reason), or large scope (create
   task)
3. Fix all "fix now" issues immediately
4. Report summary of what was fixed and what was declined (with reasons) </execution>

<dynamic-agents>
When code requires domain expertise no existing agent provides, create a focused
reviewer. Use subagent_type="general-purpose" with a prompt specifying the domain and
key concerns. Keep prompts goal-focused—state what to review for, not how to review.

Common domains: Temporal workflows, GraphQL, database migrations, rate limiting,
authentication, caching, streaming, real-time updates. </dynamic-agents>

<output-format>
After fixing issues, provide a summary:

**Fixed** (N issues):

- Issue description → what was changed

**Wontfix** (N issues):

- Issue description → why bot analysis doesn't apply given full context

**Deferred** (N issues, only for large scope):

- Issue description → follow-up task created

If all agents return no issues, note this explicitly. </output-format>
