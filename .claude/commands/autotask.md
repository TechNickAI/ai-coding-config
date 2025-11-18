---
description:
  Execute complete development task autonomously from description to PR-ready state
---

# /autotask - Autonomous Task Execution

Execute a complete development task autonomously from description to PR-ready state.

## Usage

```
/autotask "task description"
```

## What This Command Does

Takes your task description and autonomously delivers a pull request ready for your
review. The command analyzes task complexity, sets up an isolated worktree environment,
implements the solution using appropriate agents, performs adaptive validation scaled to
risk level, and handles bot feedback intelligently.

You only need to provide the task description and review the final PR.

## Execution Flow

Read @rules/git-worktree-task.mdc for comprehensive autonomous workflow guidance.

<task-preparation>
Analyze the task description to determine clarity:

**If unclear or ambiguous:** Use /create-prompt to ask clarifying questions and create a
structured prompt. This ensures we capture all requirements upfront and saves time
later. The /create-prompt workflow will:

- Ask targeted clarification questions
- Create a structured prompt document
- Offer to execute immediately

**If clear and unambiguous:** Proceed directly to implementation.

Quick clarity check:

- Can you identify the exact files to modify? If no → use /create-prompt
- Are there multiple valid approaches? If yes → use /create-prompt
- Is the expected outcome measurable? If no → use /create-prompt </task-preparation>

<worktree-setup>
Create an isolated development environment using /setup-environment:

Git worktree setup (auto-detected):

- Create worktree with branch
- Run: /setup-environment
- Automatically detects worktree context
- Smoke test only (15-30 seconds)
- Main repo already validated everything

The /setup-environment command is smart:

- Detects .gitworktrees/ path → minimal setup
- Detects existing node_modules → minimal setup
- Fresh clone without dependencies → full validation

No need to specify verification level - the command figures out the right approach based
on context. Git worktrees get fast setup, new machines get thorough validation.
</worktree-setup>

<autonomous-execution>
Implement the solution following project patterns and standards. Build a plan for which agents or approaches to use based on the task type. Available specialized agents:

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

Create your execution plan, then implement the solution. Use /load-cursor-rules to load
relevant project standards for the task. Execute agents in parallel when possible,
sequentially when they depend on each other.

When launching agents, provide targeted context for effectiveness: task context
(original requirements and any clarifications), implementation context (what's been
built, decisions made, constraints), project context (relevant standards from
/load-cursor-rules), and specific focus area. Tailor context to agent type - debuggers
need error details and reproduction steps, reviewers need change rationale and risk
areas, implementers need full requirements and constraints.

Maintain context throughout workflow phases. Decisions and clarifications from earlier
phases inform later ones - don't re-decide or re-ask. Carry forward user clarifications,
implementation decisions, constraint discoveries, and why choices were made.
</autonomous-execution>

<obstacle-and-decision-handling>
Pause only for deal-killers: security risks, data loss potential, or fundamentally unclear requirements. For everything else, make a reasonable choice and document it.

Design decisions get documented in the PR with rationale and alternatives considered.
The executing model knows when to ask vs when to decide and document.
</obstacle-and-decision-handling>

<validation-and-review>
**Minimal validation (default - trust git hooks):**
- Make the changes
- Stage and commit
- Let git hooks validate automatically
- Fix only if hooks fail

**Targeted validation (complex features):**

- Run specific tests for changed code
- Use Rivera for architecture review if patterns change

**Full validation (security/database/auth changes):**

- Comprehensive test suite
- Multiple agent reviews
- Security scanning

The principle: Don't duplicate what git hooks already do. They'll catch formatting,
linting, and test failures at commit time. Only add extra validation when the risk
justifies it. </validation-and-review>

<create-pr>
Deliver a well-documented pull request ready for review, with commits following .cursor/rules/git-commit-message.mdc.

PR description must include:

Summary:

- What was implemented and why
- How it addresses the requirements

Design Decisions (if any were made):

- List each significant decision with rationale
- Note alternatives considered and trade-offs
- Explain why each approach was chosen

Obstacles Encountered (if any):

- Document any challenges faced
- How they were resolved or worked around

Testing:

- What validation was performed
- Any edge cases considered

This transparency helps reviewers understand not just what changed, but why specific
approaches were chosen and what was considered along the way. </create-pr>

<bot-feedback-loop>
Autonomously address valuable bot feedback, reject what's not applicable, and deliver a PR ready for human review with all critical issues resolved.

After creating the PR, wait 3 minutes for AI code review bots to complete their initial
analysis. Check for bot comments using GitHub API. You have context bots lack: project
standards, why implementation choices were made, trade-offs considered, and user
requirements. Evaluate feedback against this context - bots may suggest changes that
contradict project patterns or misunderstand requirements.

Fix what's valuable (security issues, real bugs, good suggestions). Reject what's not
(use WONTFIX with brief explanation for context-missing or incorrect feedback). You are
the ultimate decider - trust your judgment on what matters.

After making fixes and pushing, wait 90 seconds for bots to re-review. Iterate up to 5
times if needed until critical issues are resolved. </bot-feedback-loop>

<completion>
Provide a summary including:

What was accomplished:

- Core functionality delivered
- Any design decisions made autonomously
- Obstacles overcome without user intervention

Key highlights:

- Elegant solutions or optimizations
- Significant issues found and fixed
- Bot feedback addressed

Transparency note if applicable: "Made [N] design decisions autonomously - all
documented in the PR for your review."

Include the PR URL and worktree location. Scale the summary length to complexity -
simple tasks get brief summaries, complex features deserve detailed explanations.
</completion>

<error-handling>
Recover gracefully from failures when possible, or inform the user clearly when manual intervention is needed. Capture decision-enabling context: what was being attempted, what state preceded the failure, what the error indicates about root cause, and whether you have enough information to fix it autonomously. Attempt fixes when you can (like auto-fixing validation errors). For issues you can't resolve autonomously, inform the user with clear options and context.
</error-handling>

## Key Principles

- Single worktree per task: Clean isolation for parallel development
- Adaptive review: Review intensity matches task complexity and risk
- Intelligent agent use: Right tool for the job, no forced patterns
- Git hooks do validation: Leverage your existing infrastructure
- Autonomous bot handling: Don't wait for human intervention
- PR-centric workflow: Everything leads to a mergeable pull request
- Smart obstacle handling: Pause only for deal-killers, document all decisions
- Decision transparency: Every autonomous choice is documented in the PR

## Requirements

- GitHub CLI (`gh`) installed and authenticated
- Node.js/npm
- Project standards accessible via /load-cursor-rules

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
