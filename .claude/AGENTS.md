# Claude Code Configuration

This directory contains commands, agents, and skills for Claude Code.

@rules/prompt-engineering.mdc

## Structure

- `commands/` - User-invoked workflows (slash commands like `/ai-coding-config`)
- `agents/` - Specialized AI assistants with focused expertise
- `skills/` - Claude-invoked capabilities (activated autonomously when relevant)
- `context.md` - Project identity and personality instructions

## Commands

Markdown files invoked via `/command-name`. Include YAML frontmatter:

```yaml
---
description: Brief explanation shown in command list
argument-hint: [optional | args]
---
```

Commands are the canonical source - `.cursor/commands/` contains symlinks to these
files.

## Agents

Specialized assistants with isolated context and focused tools. Frontmatter:

```yaml
---
name: agent-name
description:
  "Invoke when [trigger conditions]. Does [what it does] using [key capabilities]."
tools: Read, Write, Edit, Grep, Glob, Bash
model: sonnet
---
```

Agents run in separate context windows with only the tools listed. Use for tasks
requiring focused expertise or isolation from main conversation.

## Skills

Capabilities Claude activates autonomously when relevant. Each skill is a directory with
`SKILL.md`:

```yaml
---
name: skill-name
description: "Use when [trigger conditions]. Does [what it does] to achieve [outcome]."
---
```

Skills use the main conversation context. The description is critical - Claude uses it
to decide when to invoke the skill.

## Writing Prompts

All prompts in this directory follow prompt-engineering.mdc:

- Goal-focused instructions over step-by-step prescriptions
- Positive patterns only - never show anti-patterns
- XML tags for complex multi-section content
- Trust the executing model's capabilities
- Clarity over brevity
