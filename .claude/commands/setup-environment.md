---
description: Initialize development environment for git worktree
---

# Setup Development Environment

Initialize development environment with context-aware setup that distinguishes between
git worktrees and new machines.

<objective>
Get the development environment ready for productive work, with right-sized verification based on context.
</objective>

<context-detection>
Determine whether this is a git worktree or new machine setup by checking:
- Is the current path within .gitworktrees/? → worktree setup
- Does node_modules already exist in main repo? → worktree setup
- Neither of the above? → new machine setup
</context-detection>

<setup-approach>
For git worktrees (15-30 seconds):
- Install dependencies only
- Copy environment files if needed
- Run minimal smoke test
- Trust main repo's validation

For new machines (2-5 minutes):

- Install and verify all dependencies
- Set up and test git hooks
- Run build process
- Execute test suite
- Verify all tools are available </setup-approach>

<project-detection>
Identify the project type and package manager by examining project files:

Project types:

- Node.js: package.json present
- Python: requirements.txt or Pipfile present
- Ruby: Gemfile present
- Go: go.mod present
- Rust: Cargo.toml present
- Java: pom.xml or build.gradle present
- .NET: .csproj files present

Package managers for Node.js:

- pnpm if pnpm-lock.yaml exists
- yarn if yarn.lock exists
- bun if bun.lockb exists
- npm as default fallback </project-detection>

<dependency-installation>
Install project dependencies using the appropriate package manager. For Node.js projects, use pnpm/yarn/bun/npm based on which lockfile exists. For Python, use pip or pipenv. Install with frozen/locked versions to ensure consistency with the main repository.
</dependency-installation>

<environment-configuration>
For git worktrees, copy environment files from the main repository. Look for:
- .env and its variants (.env.local, .env.development, .env.test)
- Local configuration files not in version control
- Secret files needed for development

The main repository path can be found using git worktree list.
</environment-configuration>

<git-hooks-setup>
Set up git hooks based on what the project uses:
- Husky: Run husky install if .husky directory exists
- Pre-commit: Run pre-commit install if .pre-commit-config.yaml exists
- Custom hooks: Copy any custom hooks from main repository's .git/hooks

For git worktrees, the main repository path can be found using git worktree list.
</git-hooks-setup>

<code-generation>
Run any necessary code generation steps the project requires:
- Prisma: Generate client if @prisma/client is in dependencies
- GraphQL: Run codegen if codegen configuration exists
- TypeScript: Generate declarations if configured
- Package prepare scripts: Run if defined in package.json

These ensure generated code is available for development. </code-generation>

<verification>
Verify the environment is ready based on context:

For git worktrees (smoke test only):

- Confirm dependencies were installed successfully
- Run a quick TypeScript compilation check if applicable
- Trust that the main repository's validation is sufficient

For new machines (thorough verification):

- Verify all development tools are available and working
- Run the build process to ensure it completes
- Execute the test suite to confirm everything works
- Test that git hooks function correctly
- Check that all required command-line tools are installed </verification>

<error-handling>
When encountering failures, identify the root cause and attempt automatic resolution where possible. For issues that require manual intervention, provide clear guidance on how to proceed. Continue with other setup steps when it's safe to do so without the failed component.
</error-handling>

<success-criteria>
Git worktree success (15-30 seconds):
- Dependencies installed successfully
- Basic smoke test passes
- Development environment ready for immediate use

New machine success (2-5 minutes):

- All dependencies and tools functioning correctly
- Build and test processes verified
- Git hooks operational
- Complete development environment validated

The goal is right-sized verification: minimal for worktrees that inherit from the main
repository, comprehensive for new machine setups. </success-criteria>
