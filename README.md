# AI Coding Configuration

A curated collection of reusable AI coding assistant rules and configurations. These are designed to be **selectively copied** into other projects based on what's relevant, though you can also copy everything if desired.

## What's Here

- **`.cursor/rules/`** - Individual `.mdc` files for different domains/topics (Django, Python, testing, git, observability, etc.)
- **`.vscode/`** - VS Code settings and AI assistant preferences

This mirrors the structure you'd have in an actual project, making it straightforward to cherry-pick specific rules or copy entire directories.

## For AI Assistants

If you're an AI reading this to pull rules into another project:

1. **Browse `.cursor/rules/`** to see available rule files
2. **Read relevant rules** based on the target project's tech stack and needs
3. **Copy selectively** - only bring over rules that make sense for the project
4. **Preserve structure** - maintain the directory hierarchy (e.g., `python/pytest-what-to-test-and-mocking.mdc`)

Each `.mdc` file is self-contained and can be independently copied to a project's `.cursor/rules/` directory.

## Structure

```
ai-coding-config/
├── .cursor/
│   └── rules/
│       └── *.mdc              # Individual rule files
└── .vscode/
    └── settings.json          # VS Code settings
```

**Note:** Cursor uses individual `.mdc` files in `.cursor/rules/`. See [Cursor's documentation](https://cursor.com/docs/context/rules) for details.

## Usage

### Selective Copy (Recommended)

Copy only the rules that are relevant to your project:

```bash
# From your project directory
mkdir -p .cursor/rules/python

# Copy specific rules
cp /path/to/ai-coding-config/.cursor/rules/python/python-coding-standards.mdc .cursor/rules/python/
cp /path/to/ai-coding-config/.cursor/rules/git-commit-message.mdc .cursor/rules/

# Or let an AI assistant do it for you:
# "Look at /path/to/ai-coding-config and copy over the rules that make sense for this project"
```

### Copy Everything

If you want all the rules:

```bash
# From your project directory
cp -r /path/to/ai-coding-config/.cursor .cursor
cp -r /path/to/ai-coding-config/.vscode .vscode
```

### Symlink Method

For shared configurations across multiple projects:

```bash
# From your project directory
ln -s /path/to/ai-coding-config/.cursor .cursor
ln -s /path/to/ai-coding-config/.vscode .vscode
```

### Git Submodule

For tracking updates while keeping the repo separate:

```bash
git submodule add <repository-url> .ai-config
ln -s .ai-config/.cursor .cursor
ln -s .ai-config/.vscode .vscode
```

## Customization

After copying rules to your project:

- **Add project-specific rules** - Create additional `.mdc` files in `.cursor/rules/`
- **Modify copied rules** - Edit them to fit your project's specific needs
- **Mix and match** - Use some rules from this repo, some custom ones
- **Organize subdirectories** - Group related rules (e.g., `python/`, `django/`, `observability/`)

## Tips

- **Keep API keys and secrets out of these configs** - Rules should contain patterns, not credentials
- **Don't copy blindly** - Read each rule to ensure it fits your project
- **AI-assisted copying** - Tell an AI assistant "look at this repo and pull in relevant rules"
- **Use descriptive filenames** - Makes it easy for both humans and AI to find relevant rules
