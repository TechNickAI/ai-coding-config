# udecode/dotai

Cross-platform AI context manager. 1,107 stars. Generates configurations for multiple
AI tools from a single source using the skiller CLI.

GitHub: https://github.com/udecode/dotai
Local: ../reference/dotai

## What They Do

Context manager for all coding agents. Single source format generates CLAUDE.md,
AGENTS.md, Cursor rules, and MCP configurations. Uses `npx skiller@latest apply` for
generation.

## Why They Matter

Closest conceptual competitor with similar cross-platform vision. Active development
with regular updates. Generation approach is an alternative to our symlink strategy.

## What We Can Learn

Architecture: Source format structure. Generation pipeline for multiple outputs. Rule
organization and inheritance patterns.

CLI design: Installation experience. Update mechanisms. Configuration management.

Content: Rules and skills included. Session memory patterns. PR workflow automation.

## Key Files to Review

Source rule format for input specification. Generation scripts for output handling.
Skill definitions for behavior patterns. README for positioning and UX.

## Key Differences

We use symlinks, they use generation. We're plugin-marketplace-first, they're CLI-first.
We have bootstrap.sh, they have skiller CLI. Our philosophy is more explicit with
heart-centered values.

## Questions to Explore

Could we learn from their generation approach? Is symlink-based simpler or more complex
for users? What content do they have that we should add?
