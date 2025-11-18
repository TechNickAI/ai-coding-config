---
description: Execute complete development task autonomously from description to PR-ready state
---

# /autotask - Autonomous Task Execution

Execute a complete development task autonomously from description to PR-ready state.

## Usage

```
/autotask "task description"
```

## What This Command Does

Takes your task description and autonomously delivers a pull request ready for your review. The command analyzes task complexity, sets up an isolated worktree environment, implements the solution using appropriate agents, performs adaptive validation scaled to risk level, and handles bot feedback intelligently.

You only need to provide the task description and review the final PR.

## Execution Flow

<task-preparation>
Ensure you have clear, unambiguous requirements before starting implementation. If the task description is unclear or has multiple valid interpretations, clarify requirements with the user before proceeding. For tasks with clear requirements and single valid interpretation, proceed directly to implementation.
</task-preparation>

<worktree-setup>
Create a fully functional, isolated development environment in .gitworktrees/ where all tests pass and the project is ready for development work. Ensure the environment is secure (prevent shell injection), handle any conflicts, and set up all necessary dependencies and configurations using /setup-environment.
</worktree-setup>

<autonomous-execution>
Implement the solution following project patterns and standards. Build a plan for which agents or approaches to use based on the task type. Available specialized agents:

- Dixon (.claude/agents/dev-agents/debugger.md): Root cause analysis, reproduces issues, identifies underlying problems
- Ada (.claude/agents/dev-agents/autonomous-developer.md): Implementation work, writes tests
- Phil (.claude/agents/dev-agents/ux-designer.md): Reviews user-facing text, validates accessibility, ensures UX consistency
- Rivera (.claude/agents/code-review/code-reviewer.md): Architecture review, validates design patterns, checks security
- Petra (.claude/agents/code-review/architecture-auditor.md): System-level architecture analysis
- Explore (general-purpose): Investigation, research, evaluates trade-offs

Create your execution plan, then implement the solution. Use /load-cursor-rules to load relevant project standards for the task. Execute agents in parallel when possible, sequentially when they depend on each other.

When launching agents, provide targeted context for effectiveness: task context (original requirements and any clarifications), implementation context (what's been built, decisions made, constraints), project context (relevant standards from /load-cursor-rules), and specific focus area. Tailor context to agent type - debuggers need error details and reproduction steps, reviewers need change rationale and risk areas, implementers need full requirements and constraints.

Maintain context throughout workflow phases. Decisions and clarifications from earlier phases inform later ones - don't re-decide or re-ask. Carry forward user clarifications, implementation decisions, constraint discoveries, and why choices were made.
</autonomous-execution>

<validation-and-review>
Ensure code quality through adaptive validation that scales with complexity and risk. Match review intensity to the changes: simple changes need only automated checks, medium complexity benefits from targeted agent review, high-risk or security-sensitive changes warrant comprehensive review. Use your judgment to determine what level of validation the changes require.
</validation-and-review>

<create-pr>
Deliver a well-documented pull request ready for review, with commits following .cursor/rules/git-commit-message.mdc. Provide reviewers with decision context: why this approach over alternatives, what trade-offs were made, how this fits the larger system, and what testing validates the changes.
</create-pr>

<bot-feedback-loop>
Autonomously address valuable bot feedback, reject what's not applicable, and deliver a PR ready for human review with all critical issues resolved. Give bots time to analyze, then review their feedback critically. You have context bots lack: project standards, why implementation choices were made, trade-offs considered, and user requirements. Evaluate feedback against this context - bots may suggest changes that contradict project patterns or misunderstand requirements. Fix what's valuable (security issues, real bugs, good suggestions). Reject what's not (use WONTFIX with brief explanation for context-missing or incorrect feedback). You are the ultimate decider - trust your judgment on what matters. Iterate as needed until critical issues are resolved.
</bot-feedback-loop>

<completion>
Provide a summary of what was accomplished, highlights you're proud of, and any significant issues found and fixed during bot review. Scale the summary length to the complexity of the change - simple fixes get a sentence or two, major features deserve a paragraph. Include the PR URL and worktree location.
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

## Requirements

- Git worktrees support
- GitHub CLI (`gh`) installed and authenticated
- Node.js/npm or yarn
- Project must have main/master branch
- `.cursor/rules/*.mdc` standards in place

## Configuration

The command adapts to your project structure:

- Detects test runners (jest, mocha, vitest, etc.)
- Finds linting configs (eslint, prettier, etc.)
- Uses available build scripts
- Respects project-specific conventions

## Notes

- This command creates real commits and PRs
- All work happens in isolated worktrees
- Bot feedback handling is autonomous but intelligent
- Worktrees are preserved until you explicitly remove them
