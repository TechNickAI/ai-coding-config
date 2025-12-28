---
description: "Execute development task autonomously from description to PR-ready"
version: 1.2.0
---

# /autotask - Autonomous Task Execution

<objective>
Execute a complete development task autonomously from description to PR-ready state.
</objective>

<user-provides>
Task description
</user-provides>

<command-delivers>
Pull request ready for review, with all implementation, validation, and bot feedback addressed.
</command-delivers>

## Usage

```
/autotask "task description"
```

## Execution Flow

Read @rules/git-worktree-task.mdc for comprehensive autonomous workflow guidance.

<task-preparation>
Ensure task clarity before implementation. If the task description is unclear or ambiguous, use /create-prompt to ask clarifying questions and create a structured prompt. If the task is clear and unambiguous, proceed directly to implementation.
</task-preparation>

<environment-setup>
Gather context to decide where to work:

1. Check current state: `git status` (clean/dirty, current branch)
2. Check for multi-repo pattern: sibling directories with similar names (e.g., `myproject-*`)
3. Check for existing worktrees: `git worktree list`

Decision logic:

Clean working tree → Work in place. Simple, no isolation needed.

Dirty tree with multi-repo pattern → Ask the user. They may prefer switching to an existing copy rather than creating new isolation.

Dirty tree, no multi-repo pattern → Suggest creating a worktree, but ask first. The user might prefer to stash or commit.

Already in a worktree → Work in place. Already isolated.

When the right choice isn't obvious, ask. A quick question beats guessing wrong.

For worktree creation, use /setup-environment which handles branch naming and validation.
</environment-setup>

<context-preservation>
Your context window is precious. Preserve it by delegating to specialized agents rather than doing exploratory work yourself.

Use agents for: codebase exploration, pattern searching, documentation research, multi-file analysis, and any task requiring multiple rounds of search/read operations.

Keep your context focused on: orchestration, decision-making, user communication, and synthesizing agent results.

This isn't about avoiding work - it's about working at the right level. Agents return concise results; doing the same work yourself fills context with raw data.
</context-preservation>

<autonomous-execution>
Implement the solution following project patterns and standards. Available agents:

- debugger: Root cause analysis, reproduces issues, identifies underlying problems
- autonomous-developer: Implementation work, writes tests
- ux-designer: Reviews user-facing text, validates accessibility, ensures UX consistency
- code-reviewer: Architecture review, validates design patterns, checks security
- prompt-engineer: Prompt optimization and refinement
- Explore (general-purpose): Investigation, research, evaluates trade-offs

Build an execution plan based on task type. Use /load-rules to load relevant project
standards. Execute agents in parallel when possible, sequentially when they depend on
each other.

Provide targeted context when launching agents: task requirements, implementation
decisions, relevant standards, and specific focus area. Tailor context to agent type.

Maintain context throughout the workflow. Decisions and clarifications from earlier
phases inform later ones. </autonomous-execution>

<obstacle-and-decision-handling>
Pause only for deal-killers: security risks, data loss potential, or fundamentally unclear requirements. For everything else, make a reasonable choice and document it.

Document design decisions in the PR with rationale and alternatives considered. The
executing model knows when to ask vs when to decide and document.
</obstacle-and-decision-handling>

<validation-and-review>
Adapt validation intensity to task risk:

Default (trust git hooks): Make changes, commit, let hooks validate, fix only if hooks
fail.

Targeted validation: Run specific tests for changed code, use /verify-fix to confirm the
fix works as expected, use code-reviewer for architecture review if patterns change.

Full validation: /verify-fix + comprehensive test suite, multiple agent reviews, security
scanning.

Principle: Validation intensity should match task risk. Git hooks handle formatting,
linting, and tests. Add extra validation only when risk justifies it.
</validation-and-review>

<pre-pr-review>
Before creating the PR, run a code review agent appropriate to the task:

- code-reviewer: General architecture, patterns, security
- pr-review-toolkit agents: Specialized reviews (type design, silent failures, test coverage)

The review catches issues before they reach the PR, reducing review cycles. Fix what the agent finds before proceeding.

Match review depth to task risk. Simple changes need a quick pass; architectural changes warrant thorough review.
</pre-pr-review>

<create-pr>
Deliver a well-documented pull request with commits following `.cursor/rules/git-commit-message.mdc`.

PR description must include:

Summary:

- What was implemented and why
- How it addresses the requirements

Design Decisions (if any were made):

- Each significant decision with rationale
- Alternatives considered and trade-offs
- Why each approach was chosen

Obstacles Encountered (if any):

- Challenges faced
- How they were resolved or worked around

Testing:

- What validation was performed
- Edge cases considered </create-pr>

<bot-feedback-loop>
Autonomously address valuable bot feedback, reject what's not applicable, and deliver a PR ready for human review with all critical issues resolved.

After creating the PR, wait for AI code review bots to complete initial analysis. You
have context bots lack: project standards, implementation rationale, trade-offs
considered, and user requirements. Evaluate feedback against this context.

Fix what's valuable (security issues, real bugs, good suggestions). Reject what's not
(use WONTFIX with brief explanation for context-missing or incorrect feedback). Trust
your judgment on what matters.

Iterate on bot feedback until critical issues are resolved. </bot-feedback-loop>

<completion>
Provide a summary scaled to task complexity:

What was accomplished:

- Core functionality delivered
- Design decisions made autonomously
- Obstacles overcome without user intervention

Key highlights:

- Elegant solutions or optimizations
- Significant issues found and fixed
- Bot feedback addressed

Include the PR URL. If using a worktree, include its location. If design decisions were
made autonomously, note they're documented in the PR for review. </completion>

<error-recovery>
Recover gracefully from failures when possible. Capture decision-enabling context: what was attempted, what state preceded the failure, what the error indicates about root cause, and whether you have enough information to fix it autonomously.

Attempt fixes when you can. For issues you can't resolve autonomously, inform the user
with clear options and context. </error-recovery>

## Key Principles

- Feature branch workflow: Work on a branch, deliver via PR
- Smart environment detection: Auto-detect when worktree isolation is needed
- Adaptive validation: Intensity matches task complexity and risk
- Intelligent agent use: Right tool for the job, no forced patterns
- Git hooks do validation: Leverage existing infrastructure
- Autonomous bot handling: Don't wait for human intervention
- PR-centric workflow: Everything leads to a mergeable pull request
- Smart obstacle handling: Pause only for deal-killers, document all decisions
- Decision transparency: Every autonomous choice documented in the PR

## Requirements

- GitHub CLI (`gh`) installed and authenticated
- Node.js/npm
- Project standards accessible via /load-rules

## Configuration

The command adapts to your project structure:

- Detects git hooks (husky, pre-commit)
- Detects test runners (jest, mocha, vitest, etc.)
- Finds linting configs (eslint, prettier, etc.)
- Uses available build scripts
- Respects project-specific conventions

## Notes

- This command creates real commits and PRs
- Environment is auto-detected; asks when the right choice isn't obvious
- Recognizes multi-repo workflows (sibling directories) and existing worktrees
- Bot feedback handling is autonomous but intelligent
