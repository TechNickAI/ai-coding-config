---
description: Initialize development environment for git worktree
model: sonnet
version: 1.0.0
---

# Setup Development Environment

<objective>
Get the development environment ready for productive work with context-aware setup that adapts to git worktrees vs new machines.
</objective>

<context-awareness>
Detect whether this is a git worktree or new machine setup:
- Current path within .gitworktrees/? → worktree setup
- node_modules already exists in main repo? → worktree setup
- Neither? → new machine setup

For worktrees: Minimal setup (install dependencies, copy environment files, smoke test).
For new machines: Full setup (install and verify dependencies, set up git hooks, run
build, execute tests).

Trust main repo validation for worktrees. Comprehensive verification for new machines.
</context-awareness>

<project-detection>
Identify project type and package manager by examining project files.

Project types: Node.js (package.json), Python (requirements.txt or Pipfile), Ruby
(Gemfile), Go (go.mod), Rust (Cargo.toml), Java (pom.xml or build.gradle), .NET
(.csproj).

Node.js package managers: pnpm (pnpm-lock.yaml), yarn (yarn.lock), bun (bun.lockb), npm
(default). </project-detection>

<dependencies>
Install project dependencies using the appropriate package manager. Use frozen/locked versions to ensure consistency with the main repository.
</dependencies>

<environment-files>
For git worktrees, copy environment files from main repository: .env and variants (.env.local, .env.development, .env.test), local configuration files, and secret files needed for development.

Find main repository path using git worktree list. </environment-files>

<git-hooks>
Set up git hooks based on what the project uses: Husky (run husky install if .husky exists), Pre-commit (run pre-commit install if .pre-commit-config.yaml exists), custom hooks (copy from main repository's .git/hooks).

For worktrees, find main repository path using git worktree list. </git-hooks>

<code-generation>
Run necessary code generation steps: Prisma (generate client if @prisma/client in dependencies), GraphQL (run codegen if configuration exists), TypeScript (generate declarations if configured), package prepare scripts (run if defined in package.json).
</code-generation>

<verification>
For worktrees: Confirm dependencies installed, run quick compilation check if applicable, trust main repository validation.

For new machines: Verify development tools available and working, run build process,
execute test suite, test git hooks function correctly, check required command-line tools
installed. </verification>

<error-recovery>
When encountering failures, identify root cause and attempt automatic resolution where possible. For issues requiring manual intervention, provide clear guidance. Continue with other setup steps when safe to do so without the failed component.
</error-recovery>

<success-criteria>
Worktrees: Dependencies installed, smoke test passes, development environment ready.

New machines: All dependencies and tools functioning, build and test processes verified,
git hooks operational, complete development environment validated.

Goal: Right-sized verification matching context. </success-criteria>
