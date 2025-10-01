# Cursor Rules Library

This directory contains a comprehensive library of cursor rules for AI-assisted coding. Projects can symlink or copy the rules they need.

## Organization

Rules are organized into directories by topic:

- **Root level** - Universal rules (git, naming, code style, prompt engineering, etc.)
- **`python/`** - Python-specific standards and patterns
- **`django/`** - Django framework conventions
- **`observability/`** - Logging and error tracking
- **`ai/`** - AI development patterns
- **`frontend/`** - Frontend frameworks and tools

Browse the directories to see available rules. Each `.mdc` file is a self-contained rule that can be used independently.

## Application Strategies

### alwaysApply: true

Only the heart-centered AI philosophy rule is always applied.

### alwaysApply: false with globs

Some rules are auto-applied based on file patterns (globs). Check individual rule files to see their glob patterns. Common patterns include:

- Django models, commands, and templates
- Celery tasks
- React components
- Other framework-specific files

### alwaysApply: false

Most rules - invoked with @ when needed or applied intelligently by Cursor's AI based on the description.

## Usage Patterns

### Pattern 1: Symlink Everything (Easiest)

```bash
ln -s /path/to/ai-coding-config/.cursor .cursor
```

### Pattern 2: Cherry-Pick Directories

```bash
mkdir -p .cursor/rules
ln -s /path/to/ai-coding-config/.cursor/rules/python .cursor/rules/python
ln -s /path/to/ai-coding-config/.cursor/rules/django .cursor/rules/django
```

### Pattern 3: Copy What You Need

```bash
mkdir -p .cursor/rules
cp /path/to/ai-coding-config/.cursor/rules/*.mdc .cursor/rules/
cp -r /path/to/ai-coding-config/.cursor/rules/python .cursor/rules/
```

## Manual Invocation

All rules can be manually invoked using `@` followed by the rule name (without the `.mdc` extension):

- Example: `@git-commit-message`
- Example: `@python-coding-standards`
- Example: `@django-models`

Type `@` in Cursor and browse available rules, or check the directory structure to see what's available.

## Customization

Projects can:

1. Use rules as-is
2. Override specific rules by creating same-named files locally
3. Add project-specific rules alongside these
4. Modify glob patterns in frontmatter as needed

## Philosophy

These rules embody:

- Heart-centered AI collaboration
- Clear, thoughtful coding standards
- Thoughtful testing and error handling
- Modern Python and framework best practices
- Universal patterns that work across projects
