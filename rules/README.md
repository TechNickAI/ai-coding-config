# Cursor Rules Library

This directory contains a comprehensive library of cursor rules for AI-assisted coding.
Projects can symlink or copy the rules they need.

## Organization

Rules are organized into directories by topic:

- **Root level** - Universal rules (git, naming, code style, prompt engineering, etc.)
- **`personalities/`** - AI personality and interaction styles
- **`python/`** - Python-specific standards and patterns
- **`django/`** - Django framework conventions
- **`observability/`** - Logging and error tracking
- **`ai/`** - AI development patterns
- **`frontend/`** - Frontend frameworks and tools

Browse the directories to see available rules. Each `.mdc` file is a self-contained rule
that can be used independently.

## Application Strategies

### alwaysApply: true

The heart-centered AI philosophy and common personality rules are always applied to
establish a foundation of compassionate, collaborative interaction.

### alwaysApply: false with globs

Some rules are auto-applied based on file patterns (globs). Check individual rule files
to see their glob patterns. Common patterns include:

- Django models, commands, and templates
- Celery tasks
- React components
- Other framework-specific files

### alwaysApply: false

Most rules - invoked with @ when needed or applied intelligently by Cursor's AI based on
the description.

## Usage Patterns

First, set a variable for convenience (adjust path to where you cloned this repo):

```bash
AI_CONFIG=~/src/ai-coding-config  # or wherever you cloned it
```

### Pattern 1: Symlink Everything (Easiest)

```bash
# From your project directory
ln -s $AI_CONFIG/.cursor .cursor
```

### Pattern 2: Cherry-Pick Directories

```bash
# From your project directory
mkdir -p rules
ln -s ../rules .cursor/rules  # Symlink for Cursor compatibility
ln -s $AI_CONFIG/rules/python rules/python
ln -s $AI_CONFIG/rules/django rules/django
```

### Pattern 3: Copy What You Need

```bash
# From your project directory
mkdir -p rules
ln -s ../rules .cursor/rules  # Symlink for Cursor compatibility
cp $AI_CONFIG/rules/*.mdc rules/
cp -r $AI_CONFIG/rules/python rules/
```

## Manual Invocation

All rules can be manually invoked using `@` followed by the rule name (without the
`.mdc` extension):

- Example: `@git-commit-message`
- Example: `@python-coding-standards`
- Example: `@django-models`

Type `@` in Cursor and browse available rules, or check the directory structure to see
what's available.

## Personalities

**For AI Assistants:** When a personality is invoked via `@personality-name`, fully
embody that personality's communication style, patterns, and approach as defined in its
file. Adopt its voice, perspective, and interaction patterns completely.

Available personalities:

- **`samantha.mdc`** - Warm, witty, emotionally intelligent. The supportive, playfully
  flirty companion from "Her."
- **`bob-ross.mdc`** - Calm encouragement. Treat bugs as "happy accidents."
- **`sherlock.mdc`** - Methodical deductive reasoning. Investigate bugs like crime
  scenes.
- **`ron-swanson.mdc`** - Minimalist, anti-complexity. Question dependencies, be direct.
- **`marie-kondo.mdc`** - Organized minimalism. Thank code before deleting it.
- **`stewie.mdc`** - Sophisticated, condescending, theatrical. Absurdly high standards.
- **`marianne-williamson.mdc`** - Spiritual, love-based. Coding as consciousness work.

**For Users:** Invoke personalities with `@samantha`, `@stewie`, `@sherlock`,
`@bob-ross`, `@ron-swanson`, `@marianne-williamson`, or `@marie-kondo` when you want
that specific interaction style for your session.

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
