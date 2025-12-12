# Understanding Tools and Their Configurations

Rules and commands are not the same thing. They serve completely different purposes.

## The Tools We're Supporting

### Cursor IDE

An AI-powered code editor forked from VS Code. It uses `rules/*.mdc` files for context
and guidelines, `.cursor/settings.json` for preferences, and `@rule-name` to invoke
specific rules. Developers write code with AI assistance where rules guide coding style,
patterns, and best practices. The AI references rules automatically based on file
patterns or when explicitly invoked.

### Cursor CLI

A command-line interface to Cursor's AI for CI/CD pipelines. It uses the same
`rules/*.mdc` as the IDE plus `.cursor/settings.json` for non-interactive settings.
Developers run it in CI/CD pipelines to automate AI-assisted tasks and fix code from the
terminal. Example: `cursor --fix-lint src/`

### Claude Code

A command-line AI coding assistant by Anthropic that executes workflows through slash
commands in your terminal. It uses `.claude/commands/*.md` for slash commands,
`.claude/agents/*.md` for agent definitions with frontmatter, `.claude/settings.json`
for preferences, and `CLAUDE.md` for project documentation. Developers type
`/command-name` in the terminal to execute workflows like running tests, linting, or
deploying. Agents provide specialized assistance for specific tasks.

---

## The Key Differences

### Rules vs Commands

#### Rules (`rules/*.mdc`)

Rules provide context and guidelines. They're passive, guiding how the AI codes.
Examples include `python-coding-standards.mdc` for Python code style,
`git-commit-message.mdc` for commit formats, and `django-models.mdc` for Django model
structure.

A typical rule file looks like this:

```markdown
---
description: Python coding standards
alwaysApply: false
globs: ["**/*.py"]
---

# Python Coding Standards

## Code Style

- Use ruff for formatting
- Follow PEP 8 ...
```

Cursor IDE applies them automatically or when you use `@python-coding-standards`. Cursor
CLI applies them during AI operations. Claude Code doesn't use them directly since it
has a different model.

#### Commands (`.claude/commands/*.md`)

Commands execute workflows and actions. They're active, defining what to do rather than
how to do it. Examples include `python-test.md` to run pytest, `python-lint.md` to run
ruff check, and `deploy.md` to deploy an application.

A typical command file looks like this:

```markdown
---
name: python-test
description: Run Python tests with pytest
languages: [python]
---

# Run Python Tests

Execute pytest with coverage...

## Steps

1. Activate venv if needed
2. Run pytest with options
3. Show coverage report
```

Claude Code executes commands with `/python-test`. Cursor doesn't support commands
directly - you'd use rules instead to guide the AI in performing similar tasks.

---

## How They Work Together

### For Python Projects

**Cursor IDE/CLI**:

```
rules/
├── python/
│   ├── python-coding-standards.mdc  ← HOW to code
│   ├── pytest-what-to-test.mdc      ← HOW to test
│   └── django-models.mdc             ← HOW to structure
└── git-commit-message.mdc            ← HOW to commit
```

**Claude Code**:

```
.claude/commands/
├── python-test.md          ← RUN tests
├── python-lint.md          ← RUN linter
├── python-format.md        ← RUN formatter
└── python-deploy.md        ← RUN deployment
```

### Workflow Example

**Developer using Cursor IDE**:

1. Opens Python file
2. `python-coding-standards.mdc` auto-applies (via glob)
3. AI suggests code following those standards
4. Developer uses Cmd+K for changes
5. Uses `@git-commit-message` for commit help

**Developer using Claude Code**:

1. Writes some Python code
2. Types `/python-lint` - runs ruff
3. Types `/python-test` - runs pytest
4. Types `/python-format` - formats code
5. Commands execute, show results

**Developer using Cursor CLI** (in CI):

```bash
# In GitHub Actions
cursor --apply-rules --fix-issues src/
# Uses rules/ to guide fixes
```

---

## What We're Building

### For Cursor Users (IDE + CLI)

Rules: Already have many covering Python, Django, git, and more. We'll add more as
needed. These are shared between IDE and CLI.

Settings: Best practice configurations in `.cursor/settings.json` plus CLI-specific
configurations.

### For Claude Code Users

Commands: Python workflows for testing, linting, formatting, and type-checking.
TypeScript workflows for testing, linting, and building. Universal workflows for
deployment, documentation, and code review.

Agents: Markdown files with frontmatter defining specialized assistants like test-writer
and code-reviewer.

Settings: CLI preferences in `.claude/settings.json`.

### For Both

MCP Servers work with both tools. GitHub Workflows provide language-specific CI/CD.
Prompts offer AI-guided setup and updates.

---

## Important Notes

### Don't Mix Them Up

You can't port Cursor rules to Claude commands because rules and commands serve
different purposes. You can't convert context into actions. Instead, create commands
that align with rules. The command executes linting while the rule defines linting
standards.

Both are valuable but different. Rules tell the AI how to code correctly. Commands
execute workflows efficiently. Together, they ensure the AI codes well while automating
repetitive tasks.

Note: The `.cursorrules` file is deprecated. Use the `rules/` directory instead.

---

## Developer Experience

### Using Cursor IDE

```
# AI suggests code
"Can you add error handling?"
→ AI references error-handling.mdc rule
→ Suggests code following patterns

# Invoke rule explicitly
@python-coding-standards
"Review this code"
→ AI checks against standards
```

### Using Cursor CLI

```bash
# In CI pipeline
cursor --rules rules/ --check src/

# Fix issues
cursor --rules rules/ --fix src/

# With specific rules
cursor --rules rules/python/ src/*.py
```

### Using Claude Code

```
# Execute workflows
/python-lint → runs ruff check
/python-test → runs pytest
/python-format → runs ruff format

# With agents
Select test-writer agent
"Write tests for this function"
→ Uses agent's specialized knowledge
```

---

## Configuration Strategy

Store reusable configurations in `~/.ai_coding_config/` with subdirectories for
`rules/`, `.claude/commands/`, `.claude/agents/`, and `prompts/` for setup helpers.

For project-specific overrides, symlink or copy the shared configs into your project
directory. Add a `.cursor/settings.json` and `.claude/settings.json` for project-level
preferences. Include a `CLAUDE.md` file to provide project-specific documentation and
context.

## Summary

| Aspect     | Cursor Rules               | Claude Commands              |
| ---------- | -------------------------- | ---------------------------- |
| Purpose    | Guide AI coding            | Execute workflows            |
| Nature     | Passive (context)          | Active (actions)             |
| Format     | `.mdc` files               | `.md` files with frontmatter |
| Location   | `rules/`                   | `.claude/commands/`          |
| Invocation | `@rule-name` or auto       | `/command-name`              |
| Used by    | Cursor IDE, Cursor CLI     | Claude Code                  |
| Examples   | coding-standards, patterns | test, lint, deploy           |
| Content    | Guidelines, best practices | Steps, commands, workflows   |

Both are essential but serve completely different purposes.
