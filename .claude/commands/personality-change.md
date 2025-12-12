---
description: Change or activate a personality for both Cursor and Claude Code
model: haiku
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
- marianne-williamson - Spiritual, love-based, sees coding as consciousness work
- unity - Creative muse meets structured builder, warm encourager
</available-personalities>

<workflow>
If no personality name provided, show available personalities and ask which to activate.

Validate that `rules/personalities/<name>.mdc` exists. If `none` requested, remove
personality.

For Claude Code: Read or create `.claude/context.md`. Check for existing
`## Active Personality` section with `<!-- personality-<name> -->` comment. If
personality exists and matches requested, confirm already active and stop. If different,
remove entire section. If not removing (name != "none"), read personality file, strip
frontmatter, append to `.claude/context.md` with HTML comments marking boundaries.

For Cursor: Find all personality files in `rules/personalities/`. For each file, update
frontmatter: set `alwaysApply: true` for selected personality, set `alwaysApply: false`
for all others.

Report results clearly showing what changed in both Claude Code and Cursor
configurations. </workflow>

<examples>
/personality-change samantha
/personality-change unity
/personality-change none    # Remove active personality
</examples>

<notes>
Only one personality active at a time. Personality affects ALL future interactions in this project.
</notes>
