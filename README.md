# AI Coding Configuration

Shared AI coding assistant configurations that I reuse across projects. Feel free to use them too!

## What's Here

- **`.cursor/rules/`** - Individual `.mdc` files for different domains/topics
- **`CLAUDE.md`** - Claude system prompts and instructions
- **`.vscode/`** - VS Code settings and AI assistant preferences

This mirrors the structure you'd have in an actual project, so you can easily copy or symlink these into your repos.

## Structure

```
ai-coding-config/
├── .cursor/
│   └── rules/
│       └── *.mdc              # Individual rule files
├── CLAUDE.md                  # Claude configuration
└── .vscode/
    └── settings.json          # VS Code settings
```

**Note:** Cursor uses individual `.mdc` files in `.cursor/rules/`. See [Cursor's documentation](https://cursor.com/docs/context/rules) for details.

## Usage

### Symlink Method (Recommended)

```bash
# From your project directory
ln -s /path/to/ai-coding-config/.cursor .cursor
ln -s /path/to/ai-coding-config/CLAUDE.md CLAUDE.md
ln -s /path/to/ai-coding-config/.vscode .vscode
```

### Copy Method

```bash
# From your project directory
cp -r /path/to/ai-coding-config/.cursor .cursor
cp /path/to/ai-coding-config/CLAUDE.md .
cp -r /path/to/ai-coding-config/.vscode .vscode
```

### Git Submodule

```bash
git submodule add <repository-url> .ai-config
ln -s .ai-config/.cursor .cursor
ln -s .ai-config/CLAUDE.md CLAUDE.md
```

## Customization

For project-specific additions, just add your own `.mdc` files to `.cursor/rules/` or extend the existing configs. The symlink method lets you get updates from this repo while keeping local customizations separate.

## Tips

- Keep API keys and secrets out of these configs
- Test configuration changes in a throwaway project first
- Use descriptive filenames for easy organization

