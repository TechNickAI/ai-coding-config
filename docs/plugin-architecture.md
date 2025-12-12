# Plugin Marketplace Architecture

This document explains how the plugin marketplace works and the design principles behind
it.

## Core Principle

**Single source of truth with plugin symlinks for distribution.**

Content lives in one canonical location. Plugins are curated bundles that symlink to
these canonical sources. This eliminates duplication while enabling flexible packaging.

## Canonical Locations

### Rules: `rules/`

**What:** Coding standards, patterns, frameworks, conventions **Format:** `.mdc` files
with frontmatter (description, globs, alwaysApply) **Used by:** Cursor IDE (native),
Claude Code (via `/load-rules`) **Access:** `@rule-name` in Cursor, `/load-rules` in
Claude Code

### Agents: `plugins/*/agents/`

**What:** Specialized AI assistants with specific roles **Format:** `.md` files with
frontmatter (name, description, tools, model) **Location:** Live directly in plugin
bundles (e.g., `plugins/code-review/agents/`) **Used by:** Claude Code (native
subagent), Cursor (via `@plugins/code-review/agents/name.md`) **Access:** Native in
Claude Code, @ mention in Cursor

### Commands: `.claude/commands/`

**What:** Executable workflows and automation **Format:** `.md` files with frontmatter
(name, description, languages) **Used by:** Claude Code (native), Cursor (native as of
v1.6) **Access:** `/command-name` in both tools

## Plugin Structure

Each plugin is a directory with symlinks to canonical sources:

```
plugins/plugin-name/
├── .claude-plugin/
│   └── plugin.json              # Metadata
├── agents/                       # Agent files (owned by plugin)
└── README.md                     # Documentation
```

### Why This Structure?

**Rules** stay in `rules/` - Cursor's native location. Claude Code accesses them via
`/load-rules`.

**Commands** stay in `.claude/commands/` - both tools can access them natively.

**Agents** live in plugins because they're distributed content that gets installed with
the plugin.

## Tool Compatibility

### Cursor

- **Rules**: Native via `@rule-name` or auto-apply with globs
- **Commands**: Native via `/command-name` (as of v1.6)
- **Agents**: Via @ mention of agent file path
- **Plugins**: Not native, but content works when copied to project

### Claude Code

- **Rules**: Via `/load-rules` bridge command
- **Commands**: Native via `/command-name`
- **Agents**: Native subagent system
- **Plugins**: Native via `/plugin install`

## Bridge Commands

Bridges allow tools to access each other's native content:

**`/load-rules`** - Claude Code → Cursor rules

- Analyzes task
- Loads relevant rules from `rules/`
- Provides them as context

**`/personality-change`** - Unified personality management

- Updates `.claude/context.md` for Claude Code
- Verifies `rules/personalities/` for Cursor
- Works across both tools

## Personality System

Personalities have special handling because they need tool-specific formats:

```
plugins/personalities/personality-name/
├── .claude-plugin/plugin.json
├── cursor/
│   └── name.mdc                 # With frontmatter, alwaysApply: true
├── claude/
│   └── name.md                  # Plain markdown, no frontmatter
└── README.md
```

**For Cursor:** Copied to `rules/personalities/` with `alwaysApply: true`

**For Claude Code:** Content appended to `.claude/context.md` under
`## Active Personality` section

**Management:** `/personality-change <name>` handles both tools automatically

## Content Flow

### Installing a Plugin (Claude Code)

```
User: /plugin install python

1. Claude Code reads .claude-plugin/marketplace.json
2. Finds plugin entry for "python"
3. Clones/downloads plugin directory
4. Resolves symlinks to canonical sources
5. Makes rules/commands/agents available
6. User can now use /python-test, @python rules, etc.
```

### Installing a Plugin (Cursor - Manual)

```
User: Runs /ai-coding-config or bootstrap

1. Script detects project type
2. Shows relevant plugins/rules
3. User selects what to install
4. Script copies canonical files to project
5. Files appear in project's .cursor/ or .claude/
6. Cursor/Claude Code sees them natively
```

## Design Decisions

### Why Not Duplicate Content?

**Rejected:** Cursor-specific and Claude-specific copies **Problem:** Content drift,
update nightmares, inconsistency **Solution:** Single source of truth with tool-specific
access patterns

### Why Separate Rules and Commands?

**Rejected:** One unified format **Problem:** Tools have different paradigms (passive vs
active) **Solution:** Rules guide AI, commands execute workflows - both valuable

### Why Plugin Symlinks?

**Rejected:** Copying files into plugin directories **Problem:** Duplication, hard to
update, wastes space **Solution:** Symlinks maintain single source while enabling
bundling

### Why Bridge Commands?

**Rejected:** Force all content into one tool's format **Problem:** Loses each tool's
native strengths **Solution:** Let tools be themselves, bridge where needed

## Adding New Content

### Adding a Rule

1. Create in `rules/category/rule-name.mdc`
2. Include frontmatter with description, globs
3. That's it - rules are accessed via Cursor natively or `/load-rules` in Claude Code
4. No need to add to plugins

### Adding an Agent

1. Create directly in plugin: `plugins/your-plugin/agents/agent-name.md`
2. Include frontmatter with name, tools, model
3. No symlinks needed - agents live in plugins

### Adding a Command

1. Create in `.claude/commands/command-name.md`
2. Include frontmatter with name, description
3. Create or update plugin that includes it
4. Symlink from plugin:
   `ln -s ../../../.claude/commands/command-name.md plugins/your-plugin/commands/`

### Adding a Personality

1. Create cursor version in `rules/personalities/name.mdc`
2. Create claude version (same content, no frontmatter) in plugin
3. Create plugin structure in `plugins/personalities/personality-name/`
4. No symlinks needed - personalities are copied, not linked

## Marketplace Manifest

`.claude-plugin/marketplace.json` lists all available plugins:

```json
{
  "name": "ai-coding-config",
  "owner": { "name": "TechNickAI" },
  "description": "...",
  "plugins": [
    {
      "name": "plugin-name",
      "source": "./plugins/plugin-name",
      "description": "...",
      "tags": ["tag1", "tag2"]
    }
  ]
}
```

Claude Code reads this to show available plugins when users run `/plugin search`.

## Best Practices

### Plugin Naming

- Use descriptive names: `python`, `react`, `git-commits`
- Prefix personalities: `personality-sherlock`
- Prefix agents if bundled: `code-review`, `dev-agents`

### Plugin Scope

- **Focused** - One language/framework/workflow per plugin
- **Complete** - Include everything needed for that use case
- **Documented** - README explains what it does and how to use it

### Content Quality

- **Rules** - Specific, actionable, with examples
- **Agents** - Clear role, communication style, expertise
- **Commands** - Step-by-step, handles errors, shows output

### Updates

- Update canonical source, all plugins reflect change
- Version plugins when making breaking changes
- Document changes in plugin README

## Future Enhancements

Potential improvements:

- **Version management** - Track plugin versions, handle updates
- **Dependency resolution** - Plugins can depend on other plugins
- **Local overrides** - Project-specific customizations
- **Plugin testing** - Automated validation of plugin structure
- **Discovery website** - Browse plugins with search and categories

## See Also

- [tools-and-configs.md](tools-and-configs.md) - Rules vs commands explained
- [coding-ecosystem.md](coding-ecosystem.md) - Tool comparison
- [CONTRIBUTING.md](../CONTRIBUTING.md) - How to add plugins
