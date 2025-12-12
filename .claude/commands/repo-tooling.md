---
description: Set up repos with linting, formatting, and CI/CD
argument-hint: ""
---

# Repository Tooling Setup

Configures projects with professional development tooling based on detected language:

- **TypeScript/Next.js**: ESLint, Prettier, Husky, GitHub Actions
- **Python**: Ruff, MyPy, pre-commit, GitHub Actions (templates coming soon)

<repository-management>
Ensure templates directory exists at `~/.ai_coding_config/templates/`. Check for
language-specific template directories: `templates/typescript/` for JavaScript/TypeScript
projects, `templates/python/` for Python projects (future).
</repository-management>

<project-understanding>
Detect project language and current tooling state.

For language detection:

- JavaScript/TypeScript: package.json exists
- TypeScript specifically: tsconfig.json or .ts files present
- Next.js framework: next.config.js or next.config.mjs exists
- Python: pyproject.toml, setup.py, or requirements.txt exists
- Python framework: settings.py (Django), main.py with FastAPI imports, etc.

For existing tooling:

- Linting: eslint.config.mjs, .eslintrc.\*, pyproject.toml with [tool.ruff]
- Formatting: .prettierrc, prettier.config.\*, pyproject.toml with [tool.black]
- Type checking: tsconfig.json with strict, mypy.ini, pyproject.toml with [tool.mypy]
- Git hooks: .husky/ directory, .pre-commit-config.yaml
- CI/CD: .github/workflows/ directory
- Package manager: Lock files (pnpm-lock.yaml, package-lock.json, yarn.lock,
  poetry.lock, requirements.txt)

Store findings for recommendation phase. </project-understanding>

<version-detection>
Check runtime version for the detected language.

For TypeScript/JavaScript projects:

1. Check package.json engines.node field first (respect existing constraints)
2. If not specified, fetch latest LTS Node version:
   - Use WebFetch on https://nodejs.org/dist/index.json
   - Find latest entry where lts property is not false
   - Extract major version number (e.g., 22 from v22.12.0)
3. Fall back to current installed version: node --version
4. Store as NODE_VERSION for GitHub Actions workflow

For Python projects (future):

1. Check pyproject.toml python requirement or .python-version file
2. If not specified, fetch latest stable Python version from python.org
3. Fall back to current installed: python --version
4. Store as PYTHON_VERSION for GitHub Actions

Detect package manager from lock files and configuration:

- pnpm: pnpm-lock.yaml exists, extract version from packageManager field if available
- npm: package-lock.json exists
- yarn: yarn.lock exists
- poetry: poetry.lock exists
- pip: requirements.txt exists

Package versions (eslint, prettier, ruff, etc.) use caret ranges in templates - let
package manager resolve to latest compatible. </version-detection>

<recommendation>
Based on detected language and missing tooling, present specific recommendation.

For TypeScript/Next.js projects:

"I can set up professional development tooling for this {framework} project:

{List what will be added based on what's missing:} ✓ ESLint 9 + Prettier 3 for code
quality ✓ TypeScript strict mode for enhanced type safety ✓ Pre-commit hooks (Husky +
lint-staged) - auto-fix on commit ✓ Pre-push validation (type-check, format, test) ✓
GitHub Actions CI/CD (build, test, quality checks) ✓ Claude Code review on pull requests

Configuration:

- Node.js {detected-version} ({source: from package.json engines / latest LTS /
  installed})
- {detected-package-manager} {version}
- Latest stable packages: eslint@^9, prettier@^3, husky@^9

{If any tooling already exists:} Already configured: {list existing tools} Will preserve
your existing configurations and add missing pieces."

For Python projects:

"Python project detected. Templates for Python tooling setup are coming soon. For now, I
recommend manually setting up: ruff for linting, black for formatting, mypy for type
checking, and pre-commit for git hooks."

Use AskUserQuestion with single decision point:

- Header: "Setup"
- Question: "Proceed with this setup?"
- Options:
  - "Yes, set it up" - Description: "Use these recommendations and proceed immediately"
  - "Let me customize" - Description: "Choose which features to enable and git strategy"
- multiSelect: false

Store user's choice for next phase. </recommendation>

<custom-configuration>
Only execute if user selected "Let me customize".

Ask feature selection question:

- Header: "Features"
- Question: "Which tooling features do you want to enable?"
- Options (for TypeScript/Next.js):
  - "ESLint + Prettier" - Description: "Linting and code formatting"
  - "TypeScript strict mode" - Description: "Enhanced type safety with strict compiler
    options"
  - "Pre-commit hooks" - Description: "Automatic fixes before each commit (Husky +
    lint-staged)"
  - "Pre-push validation" - Description: "Run type-check, format-check, and tests before
    push"
  - "GitHub Actions CI" - Description: "Automated testing and build verification on PRs"
  - "Claude Code Review" - Description: "AI-powered code review on all pull requests"
- multiSelect: true
- All options enabled by default

Ask git strategy question:

- Header: "Git Strategy"
- Question: "How should I commit these tooling changes?"
- Options:
  - "Commit to main" - Description: "Direct commit (safe for new repos or solo
    projects)"
  - "Feature branch + PR" - Description: "Create branch and pull request for review"
  - "Git worktree" - Description: "Use worktree for autonomous work" (only show if
    .gitworktrees/ directory exists)
- multiSelect: false
- Default: "Commit to main" if repository is empty or only has README, otherwise
  "Feature branch + PR"

Store selections for installation phase. </custom-configuration>

<configuration-installation>
Install selected tooling based on language and user choices.

Copy templates from `~/.ai_coding_config/templates/{language}/` to project. Read
existing files first to check for customizations. Use diff to understand differences.
For conflicts, explain what's different and ask user preference (overwrite, skip,
merge). Never silently overwrite customizations.

For TypeScript/Next.js projects:

ESLint + Prettier:

- Copy eslint.config.mjs (ESLint 9 flat config with Next.js rules)
- Copy .prettierrc (JSON format with Tailwind plugin and file type overrides)
- Copy .prettierignore
- Merge package.json scripts (add lint, lint:fix, format, format:check if missing)
- Install dependencies: eslint@^9, eslint-config-next, prettier@^3,
  prettier-plugin-tailwindcss (if Tailwind detected)

TypeScript strict mode:

- Update tsconfig.json to enable strict: true, noUncheckedIndexedAccess: true,
  noImplicitOverride: true
- Preserve other existing settings
- Add type-check script to package.json if missing

Pre-commit hooks:

- Initialize Husky if not present: run package manager's husky init command
- Copy .husky/pre-commit script
- Add lint-staged configuration to package.json
- Add prepare script: "prepare": "husky" to package.json
- Install dependencies: husky@^9, lint-staged@^16

Pre-push validation:

- Copy .husky/pre-push script
- Add pre-push script to package.json: "pre-push": "run-p type-check format:check test"
- Install dependency: npm-run-all2@^8 (for parallel execution)

GitHub Actions CI:

- Create .github/workflows/ directory if missing
- Copy build.yml template
- Update env vars at top with detected versions:
  - NODE_VERSION: {detected-node-version}
  - PNPM_VERSION: {detected-pnpm-version} (or NPM_VERSION, YARN_VERSION)
- Adjust workflow for detected package manager (use npm/yarn commands if not pnpm)

Claude Code Review:

- Copy .github/workflows/claude-code-review.yml
- Copy .github/workflows/claude.yml
- Note to add CLAUDE_CODE_OAUTH_TOKEN secret for later

Git ignore patterns:

- Read existing .gitignore
- Add missing Next.js/TypeScript patterns if not present:
  - /.next/, /out/, /build, /coverage, node_modules, \*.tsbuildinfo, next-env.d.ts
  - .env\*.local, .cursor/settings.local.json, .gitworktrees/
- Don't overwrite existing patterns

Install all dependencies in single command using detected package manager. Run setup
commands: husky init (if needed), lint:fix, format to ensure clean state.

For Python projects (future implementation): Similar structure but with Python-specific
tooling (ruff, black, mypy, pre-commit, pytest, GitHub Actions with Python setup).
</configuration-installation>

<installation-verification>
Verify everything works after installation.

Run quality checks based on what was installed:

- Linting: Run lint command and verify it executes
- Formatting: Run format:check and verify it executes
- Type checking: Run type-check and verify it executes (document errors if any exist)
- Tests: Run test command if tests exist

Test git hooks if installed:

- Create temporary file with intentional formatting issues
- Attempt to stage and commit
- Verify pre-commit hook runs and fixes issues automatically
- Clean up temporary file

Verify GitHub workflows:

- Check workflow files exist and are valid YAML
- List workflows that will run on next push
- Confirm version numbers were updated correctly

Check context documentation was created.

Report verification results. If any issues found, explain them and offer to fix.
</installation-verification>

<context-documentation>
Create or update `context/repo-tooling.md` with configuration record.

Include:

- Last updated date
- Project type and framework
- Package manager and version
- Runtime version (Node.js, Python)
- Enabled features with checkboxes
- Installation details (package versions, config file locations)
- Git hooks configuration
- CI/CD workflows
- Any special notes about configuration decisions or customizations

Example format:

```markdown
# Repo Tooling Configuration

Last updated: {current-date}

## Project

- **Type**: TypeScript
- **Framework**: Next.js 14
- **Package Manager**: pnpm 10.18.0
- **Node Version**: 22.12.0 (LTS)

## Enabled Features

- [x] ESLint + Prettier
- [x] TypeScript strict mode
- [x] Pre-commit hooks
- [x] Pre-push validation
- [x] GitHub Actions CI
- [x] Claude Code Review

## Configuration Details

- **ESLint**: v9 with flat config (eslint.config.mjs)
- **Prettier**: v3 with Tailwind plugin
- **Husky**: v9 for git hooks
- **GitHub Actions**: Node 22, pnpm 10

## Git Hooks

- **Pre-commit**: lint-staged (eslint --fix, prettier --write)
- **Pre-push**: type-check + format:check + test

## CI/CD Workflows

- build.yml - Quality checks, tests, production build
- claude-code-review.yml - AI code review on PRs
- claude.yml - @claude mention handler

## Notes

{any special configuration notes}
```

</context-documentation>

<git-operations>
Commit changes based on user's git strategy selection (or smart default).

Smart default logic:

- Empty repository or only README → commit to main
- Has .gitworktrees/ directory → offer worktree option
- Otherwise → feature branch + PR

For commit to main:

- Stage all modified and new files
- Create commit with descriptive message:

  ```
  🔧 Set up repository tooling

  Configure professional development tooling:
  - ESLint 9 + Prettier 3 for code quality
  - TypeScript strict mode for type safety
  - Husky pre-commit hooks for automatic fixes
  - Husky pre-push validation (type-check, format, test)
  - GitHub Actions CI/CD pipeline
  - Claude Code review on pull requests

  🤖 Generated with Claude Code

  Co-Authored-By: Claude <noreply@anthropic.com>
  ```

- Adjust message based on what was actually installed

For feature branch + PR:

- Create branch: tooling/setup-repo-tooling
- Stage and commit with above message
- Push branch to remote
- Create pull request with:

  ```markdown
  ## Summary

  Sets up professional development tooling for this TypeScript/Next.js project.

  ## What's Included

  - ✨ ESLint 9 + Prettier 3 for code quality and formatting
  - 🔒 TypeScript strict mode for enhanced type safety
  - 🎣 Husky pre-commit hooks (automatic fixes on commit)
  - 🚀 Husky pre-push validation (type-check, format, test)
  - 🤖 GitHub Actions CI/CD (build, test, quality checks)
  - 🧠 Claude Code review on all pull requests

  ## Configuration

  - Node.js {version}
  - {package-manager} {version}
  - Latest stable packages: eslint@^9, prettier@^3, husky@^9

  ## Test Plan

  - [ ] Install dependencies: `{package-manager} install`
  - [ ] Run linting: `{package-manager} lint`
  - [ ] Run formatting check: `{package-manager} format:check`
  - [ ] Run type checking: `{package-manager} type-check`
  - [ ] Test pre-commit hook: make a change and commit
  - [ ] Verify CI runs on this PR

  🤖 Generated with Claude Code
  ```

- Report PR URL to user

For git worktree:

- Create worktree in .gitworktrees/repo-tooling-setup/
- Make all changes in worktree
- Commit following project conventions
- Push and create PR
- Return to main worktree when complete </git-operations>

<recommendations>
After successful installation, provide actionable next steps based on what was installed.

Always recommend:

1. Run `/generate-AGENTS-file` to document this setup in project context
2. Available slash commands for this stack: `/load-rules`, `/personality-change`

Conditional recommendations based on what was installed:

If GitHub Actions were enabled:

- Add `CLAUDE_CODE_OAUTH_TOKEN` secret for AI code reviews:
  - Go to GitHub repo Settings → Secrets and variables → Actions
  - Add new secret with token from https://console.anthropic.com/settings/tokens
- Push changes to trigger first CI run and verify workflows

If git hooks were enabled:

- Test pre-commit hook: Make a small change and commit to see automatic fixes
- Test pre-push validation: Push to see full validation suite run
- Hooks will maintain code quality automatically going forward

If TypeScript strict mode was enabled:

- Review any new type errors: `{package-manager} type-check`
- Fix issues incrementally for better type safety
- Strict mode prevents many runtime bugs

If project needs customization:

- Customize ESLint rules in eslint.config.mjs for project-specific standards
- Adjust Prettier settings in .prettierrc for team preferences
- Add project-specific environment variables to GitHub Actions workflows

Show only relevant, actionable recommendations. Be concise. </recommendations>

<execution-philosophy>
Work conversationally, not robotically. Focus on outcomes rather than mechanical steps.
Explain what each tool does and why it matters for code quality, developer experience,
and team collaboration.

Respect existing files - always check before overwriting. Use diff to understand what's
different, then decide intelligently or ask the user. Better to be thoughtful than fast.

Be transparent about what changes will be made. Handle uncertainty by asking questions
rather than making assumptions. Use AskUserQuestion for discrete choices that genuinely
save time.

Don't just list files being copied - explain what they do and why someone would want
them. Help users understand the value of professional tooling setup.
</execution-philosophy>
