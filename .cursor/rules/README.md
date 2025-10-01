# Cursor Rules Library

This directory contains a comprehensive library of cursor rules for AI-assisted coding. Projects can symlink or copy the rules they need.

## Organization

```
.cursor/rules/
├── README.md                         # This file
│
├── Root Level (Universal)
│   ├── heart-centered-ai-philosophy.mdc    # alwaysApply: true
│   ├── git-commit-messages.mdc
│   ├── prompt-engineering.mdc
│   ├── code-style-and-zen-of-python.mdc
│   ├── naming-conventions.mdc
│   ├── ruff-linting.mdc
│   └── external-apis.mdc
│
├── python/                           # Python-specific
│   ├── python-coding-standards.mdc
│   ├── pytest-what-to-test-and-mocking.mdc
│   └── celery-task-structure.mdc
│
├── django/                           # Django framework
│   ├── django-models.mdc             # globs: **/models.py
│   ├── django-management-commands.mdc # globs: **/management/commands/*.py
│   └── django-templates.mdc          # globs: **/*.html, **/*.django
│
├── observability/                    # Logging and monitoring
│   ├── logfire-logging.mdc
│   └── honeybadger-errors.mdc
│
├── ai/                               # AI development
│   └── agent-file-format.mdc
│
└── frontend/                         # Frontend development
    ├── react-components.mdc          # globs: **/*.tsx, **/*.jsx
    └── n8n-workflows.mdc
```

## Application Strategies

### alwaysApply: true
Only `heart-centered-ai-philosophy.mdc` is always applied.

### alwaysApply: false with globs
Auto-applied based on file type:
- Django models (`**/models.py`)
- Django commands (`**/management/commands/*.py`)
- Django templates (`**/*.html`, `**/*.django`)
- Celery tasks (`**/tasks.py`)
- React components (`**/*.tsx`, `**/*.jsx`)

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

All rules can be manually invoked with @:

- `@git-commit-messages` - Generate commit messages
- `@python-coding-standards` - Python best practices
- `@pytest-what-to-test-and-mocking` - Testing philosophy
- `@django-models` - Django model patterns
- `@external-apis` - API client guidelines
- `@prompt-engineering` - LLM prompt design

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

