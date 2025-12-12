# Contributing to AI Coding Config

Thank you for your interest in contributing! This marketplace thrives on community
contributions.

## Ways to Contribute

1. **Add new plugins** - Create plugins for languages, frameworks, or tools
2. **Improve existing plugins** - Enhance rules, agents, or commands
3. **Add personalities** - Create new AI personality styles
4. **Fix bugs** - Report and fix issues
5. **Improve documentation** - Help others understand and use the marketplace

## Plugin Contribution Guidelines

### Before You Start

1. Check if a similar plugin already exists
2. Ensure your plugin follows the structure below
3. Test locally before submitting
4. Write clear documentation

### Plugin Structure

All plugins follow this structure:

```
plugins/your-plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Required: Plugin metadata
├── agents/                  # Optional: Agent files (owned by plugin)
├── commands/                # Optional: Copies of .claude/commands/ files
└── README.md               # Required: Plugin documentation
```

**Note:** Plugins contain agents (owned by plugin) and commands (copied). Rules live in
`rules/` and are accessed via `/load-rules` (not in plugins).

### Creating a New Plugin

#### 1. Create Plugin Structure

```bash
mkdir -p plugins/your-plugin-name/{.claude-plugin,rules,commands,agents}
```

#### 2. Create plugin.json

`plugins/your-plugin-name/.claude-plugin/plugin.json`:

```json
{
  "name": "your-plugin-name",
  "description": "Brief description of what this plugin provides",
  "version": "1.0.0",
  "author": {
    "name": "Your Name",
    "url": "https://github.com/yourusername"
  },
  "tags": ["relevant", "tags", "here"]
}
```

#### 3. Add Content

**For rules** - Add to `rules/` (not in plugins):

```bash
# Create your rule file
touch rules/your-category/your-rule.mdc
# Rules are accessed via Cursor natively or /load-rules in Claude Code
# No need to add to plugin
```

**For agents** - Add directly to plugin:

```bash
# Create your agent file in the plugin
touch plugins/your-plugin-name/agents/your-agent.md
# Agents are the main content of plugins
```

**For commands** - Add to `.claude/commands/` then copy:

```bash
# Create your command file
touch .claude/commands/your-command.md

# Copy to plugin
mkdir -p plugins/your-plugin-name/commands
cp .claude/commands/your-command.md plugins/your-plugin-name/commands/
```

#### 4. Create README.md

`plugins/your-plugin-name/README.md`:

```markdown
# Your Plugin Name

Brief description of what this plugin provides.

## Installation

\`\`\`bash /plugin install your-plugin-name \`\`\`

## What's Included

Describe what types of content this plugin provides (rules for X framework, agents for Y
task, commands for Z workflow) without listing every file.

## Usage Examples

Show how someone would actually use this plugin in their workflow with concrete
examples.

## Compatibility

- Claude Code: ✓
- Cursor: ✓

## Related Plugins

- `related-plugin-1` - Why it's related
- `related-plugin-2` - Why it's related
```

#### 5. Update Marketplace Manifest

Add your plugin to `.claude-plugin/marketplace.json`:

```json
{
  "plugins": [
    {
      "name": "your-plugin-name",
      "source": "./plugins/your-plugin-name",
      "description": "Brief description",
      "tags": ["tag1", "tag2"]
    }
  ]
}
```

### Creating a Personality Plugin

Personalities have a special structure:

```
plugins/personalities/personality-yourname/
├── .claude-plugin/
│   └── plugin.json
├── cursor/
│   └── yourname.mdc         # Cursor format (with alwaysApply: true)
├── claude/
│   └── yourname.md          # Plain markdown (no frontmatter)
└── README.md
```

**Cursor version** (`cursor/yourname.mdc`):

```markdown
---
description: Brief personality description
alwaysApply: true
---

# Your Personality Name

[Personality characteristics and patterns]
```

**Claude version** (`claude/yourname.md`):

```markdown
# Your Personality Name

[Same content as Cursor version, but no frontmatter]
```

## Quality Standards

### Rules (rules/)

- Use `.mdc` extension
- Include frontmatter with `description` and optional `globs`
- Be specific and actionable
- Include examples
- Reference official documentation when applicable

### Agents (plugins/\*/agents/)

- Use `.md` extension
- Include frontmatter with `name`, `description`, `tools`, `model`
- Define clear responsibilities
- Provide communication guidelines
- Include example interactions

### Commands (.claude/commands/)

- Use `.md` extension
- Include frontmatter with `name`, `description`, optional `languages`
- Provide step-by-step instructions
- Include error handling guidance
- Show example output

## Testing Your Plugin

### Local Testing

1. Create plugin structure
2. Add to marketplace.json locally
3. Test installation:
   ```bash
   /plugin marketplace add file:///path/to/ai-coding-config
   /plugin install your-plugin-name
   ```
4. Verify all symlinks work
5. Test in actual project

### Checklist

- [ ] Plugin.json is valid JSON
- [ ] All symlinks point to existing files
- [ ] README has clear installation instructions
- [ ] Examples are included
- [ ] Tested in both Claude Code and Cursor (if applicable)
- [ ] No broken links
- [ ] Follows naming conventions

## Submission Process

1. **Fork this repository**
2. **Create a branch** for your plugin:
   ```bash
   git checkout -b plugin/your-plugin-name
   ```
3. **Add your plugin** following the guidelines above
4. **Test thoroughly** - install and use your plugin
5. **Commit with clear message**:
   ```bash
   git add .
   git commit -m "feat(plugin): add your-plugin-name for [purpose]"
   ```
6. **Push to your fork**:
   ```bash
   git push origin plugin/your-plugin-name
   ```
7. **Open Pull Request**:
   - Title: `Add [your-plugin-name] plugin`
   - Description: Explain what the plugin does and why it's useful
   - Include screenshots/examples if applicable

## Pull Request Requirements

Your PR should include:

- [ ] New plugin in `plugins/` directory with agents
- [ ] Rules added to `rules/` (if applicable)
- [ ] Commands added to `.claude/commands/` (if applicable)
- [ ] Agent files in plugin directory
- [ ] Entry in `.claude-plugin/marketplace.json`
- [ ] README.md for the plugin
- [ ] Valid plugin.json

## Code Review Process

1. Maintainers will review for:
   - Quality and usefulness
   - Correct structure
   - Documentation completeness
   - No security concerns
   - Works as described

2. You may be asked to:
   - Make changes
   - Add more documentation
   - Add examples
   - Fix symlinks

3. Once approved, your plugin will be merged!

## Community Guidelines

- Be respectful and constructive
- Help others with their contributions
- Share knowledge and best practices
- Report issues clearly with reproduction steps
- Suggest improvements, not just criticisms

## Questions?

- Open an issue with the `question` label
- Start a discussion in GitHub Discussions
- Check existing issues and documentation first

## License

By contributing, you agree that your contributions will be licensed under the same
license as this project (MIT License).

Thank you for contributing! 🎉
