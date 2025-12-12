# Cursor Rules → Claude Code: Rule Loading System

## The Problem

You have extensive Cursor rules in `rules/`, but Claude Code doesn't automatically read
them. You need a way to leverage these rules intelligently without:

- Loading everything upfront (wastes context, dilutes focus)
- Manually remembering which rules to reference
- Duplicating rule content across tools

## The Solution: Dynamic Rule Loading

A two-part system that loads rules intelligently based on the current task:

### 1. `.claude/context.md` (Bootstrap)

- Minimal context file that Claude Code reads automatically on every conversation
- Documents available rule categories
- Points to the `/load-rules` command for dynamic loading
- Includes always-applied rules (heart-centered AI philosophy)

### 2. `.claude/commands/load-rules.md` (Intelligent Loader)

- Slash command that analyzes the current task
- Selects and loads ONLY relevant rules from `rules/`
- Provides clear heuristics for rule selection
- Explains what was loaded and why

## How It Works

### User Workflow

```bash
# Start a task - Claude Code reads .claude/context.md automatically
$ claude "add error tracking to payment processor"

# Claude uses /load-rules internally or you invoke it explicitly
$ /load-rules

# Claude analyzes the task, then loads:
# - python/python-coding-standards.mdc (Python code)
# - code-style-and-zen-of-python.mdc (Python code)
# - observability/honeybadger-errors.mdc (error tracking)

# Now Claude works on the task following those specific rules
```

### Claude's Process (Documented in /load-rules)

1. **Understand the task**: What is the user asking for?
2. **Identify relevant rules**: Match task to rule categories
3. **Read selected rules**: Use Read tool on specific .mdc files
4. **Explain selection**: Tell user what was loaded
5. **Apply rules**: Follow guidelines while working

## Rule Selection Logic

The `/load-rules` command contains heuristics for matching tasks to rules:

**Task Pattern** → **Rules to Load**

- Python code → `python/python-coding-standards.mdc`, `code-style-and-zen-of-python.mdc`
- Writing tests → Add `python/pytest-what-to-test-and-mocking.mdc`
- Celery tasks → Add `python/celery-task-structure.mdc`
- React work → `frontend/react-components.mdc`
- Error tracking → `observability/honeybadger-errors.mdc`
- Git commits → `git-commit-message.mdc`
- CI/CD issues → `fixing-github-actions-builds.mdc`
- AI/agents → `ai/agent-file-format.mdc`, `prompt-engineering.mdc`

## Why This Approach Works

### ✅ Advantages over static loading:

- **Efficient context usage**: Only loads what's needed for the task
- **Focused guidance**: Relevant rules, not noise
- **Scalable**: Add more rules without bloating every conversation
- **Explicit**: User understands what rules are active
- **Task-aware**: Different tasks get different rule sets

### ✅ Advantages over manual reference:

- **Automated**: No need to remember rule names
- **Consistent**: Same selection logic every time
- **Discoverable**: Heuristics documented in the command

### ✅ Advantages over duplication:

- **Single source of truth**: `rules/` remains authoritative
- **Cross-tool compatibility**: Same rules work with Cursor and Claude Code
- **Easy updates**: Change rules in one place

## File Structure

```
rules/          # Your existing Cursor rules (unchanged)
├── README.md
├── git-commit-message.mdc
├── heart-centered-ai-philosophy.mdc
├── python/
│   ├── python-coding-standards.mdc
│   └── pytest-what-to-test-and-mocking.mdc
└── ...

.claude/                # New Claude Code integration
├── context.md         # Minimal bootstrap (auto-loaded)
└── commands/
    └── load-cursor-rules.md  # Intelligent rule selector (invoked as /load-rules)
```

## Usage Examples

### Explicit Invocation

```bash
$ claude "I need to refactor the authentication module"
$ /load-rules  # Manually trigger rule loading
# Loads: python standards, naming-stuff.mdc
```

### Implicit Usage (Recommended Flow)

```bash
$ claude "write tests for the payment service"
# Claude internally recognizes this needs rules
# Loads: python standards, pytest-what-to-test-and-mocking.mdc
# Proceeds with task following those rules
```

### Task-Specific Loading

```bash
$ claude "commit these changes"
# Loads ONLY: git-commit-message.mdc

$ claude "fix the failing GitHub Actions build"
# Loads: fixing-github-actions-builds.mdc

$ claude "add Honeybadger tracking to the API"
# Loads: python standards, honeybadger-errors.mdc
```

## Design Principles

### 1. **Selective Over Comprehensive**

Better to load 2-3 relevant rules than 20 potentially useful ones.

### 2. **Task-Driven**

Rules are loaded based on what you're doing, not what might be relevant.

### 3. **Transparent**

Claude explains what rules were loaded and why.

### 4. **Maintainable**

All selection logic lives in one place (`/load-rules.md`), easy to update.

### 5. **Compatible**

Doesn't modify Cursor rules, works alongside existing Cursor workflows.

## Extending the System

### Add New Rules

1. Create `.mdc` file in `rules/` (works with Cursor)
2. Add selection heuristic to `.claude/commands/load-rules.md`
3. Update category list in `.claude/context.md`

### Customize Selection Logic

Edit `.claude/commands/load-rules.md` to adjust when rules are loaded.

### Add Always-Applied Rules

Put them in `.claude/context.md` if they should apply to every conversation.

## Migration Path

This system was built to:

1. Respect your existing Cursor rules structure
2. Make them available to Claude Code
3. Load them intelligently, not dump them all at once
4. Be self-documenting and maintainable

The `/load-rules` command itself follows the principles it enforces: analyze the task,
select what's needed, explain the choice, proceed with clarity.

## Meta: This Document's Creation

This documentation was created using the exact process it describes:

1. **Examined the task**: Help user leverage Cursor rules in Claude Code
2. **Explored existing structure**: Listed `rules/`, read README and samples
3. **Designed solution**: Dynamic loading via slash command vs static loading via
   context
4. **Implemented**: Created `.claude/context.md` and `.claude/commands/load-rules.md`
5. **Documented**: Wrote this explanation of the system and process

The system is self-referential: `/load-rules` itself could be improved by loading
relevant rules about documentation, naming, and user-facing language. 🙂
