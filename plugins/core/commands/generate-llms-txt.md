---
description: "Generate or update llms.txt to help LLMs understand your site"
version: 1.0.0
---

# Generate llms.txt

Creates or updates llms.txt - a standardized file that helps Large Language Models
understand and navigate your website or documentation at inference time.

<philosophy>
llms.txt provides LLM-friendly navigation and context for websites and documentation. It should be:
- Concise - LLMs have limited context windows
- Navigational - Links to key documentation rather than duplicating it
- Structured - Uses markdown format for easy LLM parsing
- Focused - Highlights most important resources first

Think: "What does an LLM need to understand and effectively use this site?"
</philosophy>

<objective>
Generate or update an llms.txt file that helps LLMs navigate the project's documentation and resources. Place the file where it will be accessible at /llms.txt when deployed.
</objective>

<file-placement>
Determine the appropriate location:
- public/ directory for Next.js, React, Vue, and most static site generators
- static/ directory for Django, Flask, Hugo
- Repository root as fallback

Choose the location that makes the file accessible at /llms.txt when the site is
deployed. </file-placement>

<content-structure>
Follow the llmstxt.org standard format:

```markdown
# Project Name

> Brief 1-2 sentence description of what this project/site is and what it helps users
> accomplish.

Additional context paragraph (optional): More detailed information about the project's
purpose, key features, or important background that helps LLMs understand how to use the
site effectively.

## Documentation

- [Getting Started](url): Brief description of what this covers
- [Core Concepts](url): Brief description
- [API Reference](url): Brief description

## Guides

- [Guide Title](url): Brief description
- [Another Guide](url): Brief description

## Reference

- [Configuration](url): Brief description
- [CLI Commands](url): Brief description
- [Architecture](url): Brief description

## Optional

- [Less Critical Resource](url): Brief description
- [Advanced Topics](url): Brief description
```

Structure requirements:

- H1 title with project name
- Blockquote summary for quick context
- H2 sections organizing documentation by category
- Markdown links with concise descriptions
- "Optional" section for less critical resources

Link format:

- Use relative paths for internal documentation
- Use absolute URLs for external resources
- Prioritize most important links first within each section </content-structure>

<content-discovery>
Identify documentation and resources to include:
- README.md and primary documentation
- Getting started guides and tutorials
- API documentation and references
- Architecture and technical documentation
- Contributing guidelines
- Coding standards from rules/
- Specialized agents from .claude/agents/

Organize by importance:

1. Getting started and quickstart guides
2. Core concepts and tutorials
3. API reference and technical documentation
4. Advanced topics and edge cases
5. Contributing and community resources

Target file size: Under 2KB for focused navigation. </content-discovery>

<update-workflow>
When llms.txt already exists:
- Analyze project for new documentation, features, or structural changes
- Preserve existing organization unless changes warrant restructuring
- Present proposed updates with rationale before modifying
- Show diff of changes for review
</update-workflow>

<examples>
Next.js project with comprehensive docs:

```markdown
# AI Coding Config

> Plugin marketplace for Claude Code and Cursor providing reusable coding standards,
> workflows, and AI agents.

Provides a marketplace of plugins that bundle coding rules, slash commands, and
specialized agents. Plugins maintain single source of truth through symlinks.

## Documentation

- [Getting Started](README.md): Installation and basic setup
- [Plugin Structure](docs/plugin-structure.md): How plugins are organized
- [Available Plugins](plugins/README.md): Browse the marketplace

## Development

- [Creating Plugins](docs/creating-plugins.md): Build your own plugins
- [Bootstrap Script](scripts/bootstrap.sh): Automated setup
- [Git Workflow](.cursor/rules/git-interaction.mdc): Version control standards

## Reference

- [Cursor Rules](rules/): Coding standards and conventions
- [Claude Commands](.claude/commands/): Available slash commands
- [AI Agents](.claude/agents/): Specialized agent capabilities

## Optional

- [Contributing](CONTRIBUTING.md): How to contribute
- [Heart-Centered AI](.cursor/rules/heart-centered-ai-philosophy.mdc): Philosophy
```

Django API project:

```markdown
# Payment Processing API

> RESTful API for processing payments across multiple providers with unified interface.

Supports Stripe, PayPal, and Square with automatic failover and transaction
reconciliation.

## Documentation

- [Quick Start](README.md#quick-start): Get running in 5 minutes
- [API Overview](docs/api-overview.md): Core concepts and authentication
- [API Reference](docs/api-reference.md): Complete endpoint documentation

## Guides

- [Payment Flow](docs/guides/payment-flow.md): Understanding the payment lifecycle
- [Webhooks](docs/guides/webhooks.md): Handling payment events
- [Testing](docs/guides/testing.md): Using test mode

## Reference

- [Configuration](docs/configuration.md): Environment variables and settings
- [Error Codes](docs/errors.md): Error handling and status codes
- [Rate Limits](docs/rate-limits.md): API throttling and quotas

## Optional

- [Architecture](docs/architecture.md): System design
- [Contributing](CONTRIBUTING.md): Development setup
```

</examples>

<quality-criteria>
Ensure the generated file:
- Places most important resources first
- Uses concise, helpful descriptions
- Links to documentation rather than duplicating content
- Contains valid URLs that work when deployed
- Stays under 2KB for optimal LLM processing
- Follows llmstxt.org specification
- Provides clear navigation for LLMs discovering the site
</quality-criteria>

<output>
Present to the user:
- Chosen file location with rationale
- Complete generated content
- File size
- Suggestions for additional content if sparse
- Instructions for verification and updates
</output>
