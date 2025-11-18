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

Takes your task description and autonomously:

1. Analyzes complexity and creates structured prompt if needed
2. Sets up isolated git worktree environment
3. Implements the solution using intelligent agent orchestration
4. Adaptive validation & review based on complexity
5. Creates PR with proper commit messages
6. Handles bot feedback autonomously
7. Delivers PR ready for your review

You only need to provide the task description and review the final PR.

## Execution Flow

<task-preparation>
Analyze the task complexity. If the requirements are unclear or the task is complex with multiple interpretations, use the create-prompt agent to ask clarifying questions and create a structured prompt. Save to .created-prompts/ and get user confirmation before proceeding.

For straightforward tasks with clear requirements, proceed directly to worktree setup.
</task-preparation>

<worktree-setup>
**Goal**: Create an isolated development environment in `.gitworktrees/` with a sanitized branch name derived from the task description.

**Requirements**:
- Sanitize task description to prevent shell injection
- Generate feature branch name (lowercase, alphanumeric, max 60 chars)
- Handle existing worktree conflicts
- Run /setup-environment to install dependencies, copy configs, and set up git hooks

**Success criteria**: Clean worktree ready for development work.
</worktree-setup>

<autonomous-execution>
**Goal**: Implement the solution following project patterns and standards.

Build a plan for which agents or approaches to use based on the task type. Available specialized agents:

- **Dixon** (dev-agents:debugger): Root cause analysis, reproduces issues, identifies underlying problems
- **Ada** (dev-agents:autonomous-developer): Implementation work, reads all .cursor/rules/*.mdc, writes tests
- **Phil** (dev-agents:ux-designer): Reviews user-facing text, validates accessibility, ensures UX consistency
- **Rivera** (code-review:code-reviewer): Architecture review, validates design patterns, checks security
- **Petra** (code-review:architecture-auditor): System-level architecture analysis
- **Explore** (general-purpose): Investigation, research, evaluates trade-offs

Create your execution plan, then implement the solution. Read all .cursor/rules/*.mdc files to understand project conventions. Run agents in parallel when possible, sequentially when they depend on each other.
</autonomous-execution>

<validation-and-review>
**Goal**: Ensure code quality through adaptive validation that scales with complexity.

**Review intensity scales with risk**:
- Simple changes: Git hooks only
- Medium complexity: Hooks + one relevant agent (Phil for UI, Dixon for bugs, Rivera for architecture)
- High risk/security: Hooks + multiple agents

Run git hooks (husky/pre-commit) and auto-fix failures if possible. Analyze what changed to determine review needs. Launch appropriate review agents and address their feedback.

Decide what's needed based on actual changes - trust your judgment.
</validation-and-review>

<create-pr>
**Goal**: Create a well-documented pull request ready for review.

**Requirements**:
- Commit with proper format (emoji, imperative verb, concise description)
- Include "🤖 Generated with Claude Code" and co-author line
- Push to feature branch
- Create PR with summary, changes, testing approach, and checklist
- Follow project's commit message conventions (read git-commit-message.mdc if it exists)

**Success criteria**: PR created, all information clear, ready for bot/human review.
</create-pr>

<bot-feedback-loop>
**Goal**: Autonomously address bot feedback without user intervention.

**Process**:
1. Wait 3 minutes for bots to complete initial analysis
2. Check for bot comments using GitHub API
3. Review each piece of feedback and decide:
   - Fix what's valuable (security issues, real bugs, good suggestions)
   - Reject what's not (use WONTFIX with brief explanation for context-missing or incorrect feedback)
   - **You are the ultimate decider** - trust your judgment on what matters
4. Make fixes, commit, push
5. Wait for bots to re-review (90s)
6. Repeat up to 5 times if needed

**Success criteria**: All critical issues addressed, PR ready for human review.
</bot-feedback-loop>

<completion>
Task execution complete! Here's your summary:

```
✅ Development complete
✅ All validations passed
✅ PR created and bot feedback addressed
✅ Ready for your review

📍 PR: {{PR_URL}}
🌳 Worktree: .gitworktrees/{{BRANCH_NAME}}

When you're ready:
1. Review the PR at {{PR_URL}}
2. Merge when satisfied
3. Run: git worktree remove .gitworktrees/{{BRANCH_NAME}}

The PR is fully ready - all checks passing, bot feedback addressed.
You have full control over the merge decision.
```

</completion>

<error-handling>
When a phase fails critically, capture the error context and assess recovery options:

- For validation failures: Attempt automatic fix using appropriate agent
- For bot feedback that can't be addressed: Continue with PR, note remaining items for user
- For other failures: Present options to fix and retry, skip if safe, abort and clean up, or switch to manual mode

Attempt automatic recovery when possible, otherwise inform the user and provide clear options.
</error-handling>

## Key Principles

- **Single worktree per task**: Clean isolation for parallel development
- **Adaptive review**: Review intensity matches task complexity and risk
- **Intelligent agent use**: Right tool for the job, no forced patterns
- **Git hooks do validation**: Leverage your existing infrastructure
- **Autonomous bot handling**: Don't wait for human intervention
- **PR-centric workflow**: Everything leads to a mergeable pull request

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
- You always have the final say on merging
- Worktrees are preserved until you explicitly remove them
