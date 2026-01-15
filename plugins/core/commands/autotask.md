---
# prettier-ignore
description: "Execute development task autonomously from description to PR-ready - handles implementation, testing, and git workflow without supervision"
version: 2.1.0
---

# /autotask - Autonomous Task Execution

<objective>
Execute a complete development task autonomously from description through PR creation to
bot feedback resolution. The task is NOT complete until bot feedback has been addressed.
</objective>

<user-provides>
Task description with optional complexity signal (auto, quick, balanced, deep)
</user-provides>

<command-delivers>
Pull request ready for human review with all implementation complete, validation passed,
and bot feedback addressed.
</command-delivers>

## Complexity Levels

Complexity determines how much planning, review, and validation the task receives.

### auto (default)

Analyze the task to determine appropriate complexity. Consider:

- **Scope**: How many files likely affected? Single file → quick. Multi-file → balanced.
  Cross-cutting → deep.
- **Risk**: Does it touch auth, payments, data migrations, core abstractions? Higher
  risk → deeper review.
- **Novelty**: Established patterns → lighter touch. New patterns or architecture →
  deeper analysis.
- **Ambiguity**: Clear requirements → move fast. Fuzzy requirements → plan more.

**Precedence**: Explicit user signals (quick, balanced, deep) override auto-detection.
Risk factors can escalate complexity but never reduce it below what the user specified.

When in doubt, err toward balanced. Quick is for genuinely trivial changes. Deep is for
genuinely complex ones.

### quick

Single-file changes, clear requirements, no design decisions.

- Skip heavy planning
- Implement directly
- Trust git hooks for validation
- Single self-review pass
- Create PR, brief bot wait, address feedback

Signals: "quick fix", "simple change", trivial scope, typo, single function

### balanced

Standard multi-file implementation, some design decisions.

- Light planning with /load-rules
- Delegate exploration to sub-agents
- Targeted testing for changed code
- /multi-review with 2-3 domain-relevant agents
- Create PR → /address-pr-comments → completion

Signals: Most tasks land here when auto-detected

### deep

Architectural changes, new patterns, high-risk, multiple valid approaches.

- Full exploration via sub-agents
- Use /brainstorm-synthesis for hard architectural decisions during exploration
- Create detailed plan document incorporating synthesis results
- **Review the PLAN with /multi-review** before implementation (architecture-auditor,
  domain experts)
- Full implementation with comprehensive testing
- /verify-fix to confirm behavior
- /multi-review with 5+ agents on the implementation
- Create PR → wait for all bots → /address-pr-comments → iterate until clean

Signals: "thorough", "deep", "ultrathink", architectural scope, new patterns

## Compaction Handling

If context compaction occurs mid-task, **save your todos to the todo list before
compaction completes**. The TodoWrite tool persists across compaction when you actively
maintain it. After compaction, check git state (branch, commits, PR status) to re-orient
and continue from where you left off.

## Workflow

Read @rules/git-worktree-task.mdc for environment setup guidance.

<environment-setup>
Determine where to work based on current git state:

- Clean working tree → Work in place
- Dirty tree with multi-repo pattern → Ask user preference
- Dirty tree, no multi-repo → Suggest worktree, confirm first
- Already in worktree → Work in place

For worktree creation, use /setup-environment. When the right choice isn't obvious, ask.
</environment-setup>

<context-preservation>
Your context window is precious. Preserve it through delegation.

Delegate to sub-agents: codebase exploration, pattern searching, documentation research,
multi-file analysis, any task requiring multiple search/read rounds.

Keep in main context: orchestration, decision-making, user communication, synthesizing
results, state management, phase transitions.

Sub-agents work with fresh context optimized for their task and return concise results.
Doing exploratory work yourself fills context with raw data. This is about working at
the right level. </context-preservation>

<task-preparation>
Ensure task clarity before implementation. If the task description is unclear or
ambiguous, use /create-prompt to ask clarifying questions. If clear, proceed to planning
or implementation based on complexity level.
</task-preparation>

<planning>
Scale planning to complexity:

**quick**: Skip to implementation.

**balanced**: Load relevant rules with /load-rules. Brief exploration via sub-agent if
needed. Create implementation outline.

**deep**: Full exploration via sub-agents. Create detailed plan document. Run
/multi-review on the PLAN with architecture-focused agents. Incorporate feedback before
writing code. Document design decisions with rationale. </planning>

<implementation>
Execute using appropriate agents based on task type:

- debugger: Root cause analysis, reproduces issues
- autonomous-developer: Implementation work, writes tests
- ux-designer: User-facing text, accessibility, UX consistency
- code-reviewer: Architecture review, design patterns, security
- prompt-engineer: Prompt optimization
- Explore: Investigation, research, trade-off evaluation

Launch agents in parallel when independent, sequentially when dependent. Provide
targeted context: task requirements, implementation decisions, relevant standards,
specific focus area.

Capture decisions made and any blockers encountered for the PR description.
</implementation>

<obstacle-handling>
Pause only for deal-killers: security risks, data loss potential, fundamentally unclear
requirements. For everything else, make a reasonable choice and document it in the PR.

The executing model knows when to ask versus when to decide and document.
</obstacle-handling>

<validation>
Scale validation to complexity:

**quick**: Trust git hooks. If hooks pass, proceed.

**balanced**: Run targeted tests for changed code. Brief self-review. Fix obvious
issues.

**deep**: /verify-fix to confirm behavior works from user perspective. Comprehensive
test suite. Security scan if applicable. Performance check if applicable. </validation>

<pre-pr-review>
Scale review to complexity:

**quick**: Single self-review pass.

**balanced**: /multi-review with 2-3 agents selected by domain:

- Changed API → security-reviewer
- Changed UI → ux-designer, design-reviewer
- Changed logic → logic-reviewer
- Changed tests → test-analyzer

**deep**: /multi-review with 5+ agents:

- architecture-auditor
- security-reviewer
- performance-reviewer
- error-handling-reviewer
- logic-reviewer
- Domain-specific reviewers as needed

Fix issues found before creating PR. </pre-pr-review>

<create-pr>
Create PR with commits following .cursor/rules/git-commit-message.mdc.

PR description includes:

**Summary**: What was implemented and why. How it addresses requirements.

**Design Decisions** (if any): Each decision with rationale. Alternatives considered.
Why this approach.

**Complexity Level**: quick|balanced|deep and why.

**Validation Performed**: Tests run. Verification steps taken. </create-pr>

<bot-feedback-loop>
This phase is MANDATORY. Autotask is not complete without it.

After PR creation, poll for bot analysis using `gh pr checks`:

- quick: Poll for up to 2 minutes
- balanced: Poll for up to 5 minutes
- deep: Poll for up to 15 minutes, wait for all configured checks

If checks complete sooner, proceed immediately. If timeout reached with checks still
pending, proceed with available feedback and note incomplete checks.

Execute /address-pr-comments on the PR. This is not optional.

Fix valuable feedback (security issues, real bugs, good suggestions). Decline with
WONTFIX and rationale where bot lacks context. Iterate until critical issues resolved.

</bot-feedback-loop>

<completion-verification>
Autotask is complete when ALL are true:

- PR created with proper description
- Review bots have completed (or confirmed none configured)
- /address-pr-comments executed
- All "Fix" items resolved or documented

Report format:

```
## Autotask Complete

**PR:** #[number] - [title]
**Branch:** [branch-name]
**Worktree:** [path if applicable]

**Complexity:** [quick|balanced|deep]

**What was accomplished:**
- Core functionality delivered
- Design decisions made autonomously
- Obstacles overcome

**Bot feedback addressed:**
- Fixed: [count]
- Declined: [count with reasons]
```

</completion-verification>

<error-recovery>
**Git failures**: Merge conflicts → pause for user resolution. Push rejected → pull and
rebase if safe, ask if not. Hook failures → fix the issue, never use --no-verify.

**GitHub CLI failures**: Auth issues → run `gh auth status`, inform user. Rate limits →
log and suggest waiting. PR creation fails → check branch exists remotely, retry once.

**Sub-agent failures**: Log which agent failed. Retry once with simplified scope. If
still fails, continue without that input and note the gap.

For issues you cannot resolve autonomously, inform user with clear options and context.
Never swallow errors silently. </error-recovery>

## Key Principles

- Feature branch workflow: Work on branch, deliver via PR
- Complexity scaling: Effort matches task scope
- Context preservation: Delegate exploration, orchestrate at top level
- Mandatory completion: Task not done until bot feedback addressed
- Smart environment detection: Auto-detect when worktree needed
- Git hooks do validation: Leverage existing infrastructure
- PR-centric: Everything leads to mergeable pull request
- Decision transparency: Every autonomous choice documented in PR

## Requirements

- GitHub CLI (`gh`) installed and authenticated
- Node.js/npm
- Project standards accessible via /load-rules

## Configuration

Adapts to project structure:

- Detects git hooks (husky, pre-commit)
- Detects test runners (jest, mocha, vitest, etc.)
- Finds linting configs (eslint, prettier, etc.)
- Uses available build scripts
- Respects project-specific conventions

## Notes

- Creates real commits and PRs
- Environment auto-detected; asks when ambiguous
- Recognizes multi-repo workflows and existing worktrees
- Bot feedback handling is autonomous and mandatory
