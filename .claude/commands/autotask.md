---
description:
  "Execute complete development task autonomously from description to PR-ready state"
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

<worktree-setup>
Create isolated development environment using /setup-environment. The command auto-detects context (worktree vs new machine) and adapts validation appropriately.
</worktree-setup>

<autonomous-execution>
Implement the solution following project patterns and standards. Available agents:

- Dixon (.claude/agents/dev-agents/debugger.md): Root cause analysis, reproduces issues,
  identifies underlying problems
- Ada (.claude/agents/dev-agents/autonomous-developer.md): Implementation work, writes
  tests
- Phil (.claude/agents/dev-agents/ux-designer.md): Reviews user-facing text, validates
  accessibility, ensures UX consistency
- Rivera (.claude/agents/code-review/code-reviewer.md): Architecture review, validates
  design patterns, checks security
- Petra (.claude/agents/dev-agents/prompt-engineer.md): Prompt optimization and
  refinement
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

Targeted validation: Run specific tests for changed code, use Rivera for architecture
review if patterns change.

Full validation: Comprehensive test suite, multiple agent reviews, security scanning.

Principle: Validation intensity should match task risk. Git hooks handle formatting,
linting, and tests. Add extra validation only when risk justifies it.
</validation-and-review>

<create-pr>
Deliver a well-documented pull request with commits following rules/git-commit-message.mdc.

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

Include the PR URL and worktree location. If design decisions were made autonomously,
note they're documented in the PR for review. </completion>

<error-recovery>
Recover gracefully from failures when possible. Capture decision-enabling context: what was attempted, what state preceded the failure, what the error indicates about root cause, and whether you have enough information to fix it autonomously.

Attempt fixes when you can. For issues you can't resolve autonomously, inform the user
with clear options and context. </error-recovery>

## Key Principles

- Single worktree per task: Clean isolation for parallel development
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
- All work happens in isolated worktrees
- Bot feedback handling is autonomous but intelligent
- Worktrees are preserved until you explicitly remove them
