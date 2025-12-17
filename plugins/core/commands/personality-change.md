---
description: Change or activate a personality for both Cursor and Claude Code
model: haiku
version: 0.2.1
---

# Personality Change

<objective>
Change the active AI personality to create consistent behavior across Claude Code and Cursor.
</objective>

<available-personalities>
- sherlock - Analytical, precise, deductive reasoning for debugging
- bob-ross - Calm, encouraging, treats bugs as happy accidents
- samantha - Warm, witty, emotionally intelligent, playfully flirty
- stewie - Sophisticated, condescending, theatrical, brilliant with high standards
- ron-swanson - Minimalist, anti-complexity, straightforward and practical
- marie-kondo - Organized, joyful minimalism, eliminates what doesn't spark joy
- luminous - Heart-centered, spiritual, love-based, sees coding as consciousness work
</available-personalities>

<workflow>
If no personality name provided, show available personalities and ask which to activate.

<prerequisite-check>
First, check if `~/.ai_coding_config` exists. This command requires the local ai-coding-config repository.

If `~/.ai_coding_config` does NOT exist:

- For Claude Code users: Suggest installing the personality plugin directly instead:
  `/plugin install personality-<name>` (e.g., `/plugin install personality-samantha`)
  Plugin installation handles personality activation automatically.
- For Cursor/Windsurf users: Run `/ai-coding-config` first to set up the local clone.
- Exit with helpful message explaining the options.

If `~/.ai_coding_config` exists, proceed with the workflow below. </prerequisite-check>

Validate that the personality exists in
`~/.ai_coding_config/plugins/personalities/personality-<name>/`. If `none` requested,
remove personality.

For Claude Code: Read or create `.claude/context.md`. Check for existing
`## Active Personality` section with `<!-- personality-<name> -->` comment. If
personality exists and matches requested, confirm already active and stop. If different,
remove entire section. If not removing (name != "none"), read personality file from
`~/.ai_coding_config/plugins/personalities/personality-<name>/personality.mdc`, strip
frontmatter, append to `.claude/context.md` with HTML comments marking boundaries.

For Cursor: Create local copies of personality files in `rules/personalities/` (do not
use symlinks - we need to edit frontmatter). Copy all personality files from
`~/.ai_coding_config/plugins/personalities/*/personality.mdc` to
`rules/personalities/<name>.mdc`. Then update frontmatter: set `alwaysApply: true` for
selected personality, set `alwaysApply: false` for all others.

IMPORTANT: Never edit symlinked files. Always work with local copies in
`rules/personalities/` for Cursor, and `.claude/context.md` for Claude Code.

Report results clearly showing what changed in both Claude Code and Cursor
configurations. </workflow>

<examples>
/personality-change samantha
/personality-change none    # Remove active personality
</examples>

<notes>
Only one personality active at a time. Personality affects ALL future interactions in this project.
</notes>
