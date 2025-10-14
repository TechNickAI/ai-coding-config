---
description: Change or activate a personality for both Cursor and Claude Code
---

# Change Personality

Activate a personality (or switch from current to new). Works for both Cursor and Claude Code.

## Usage

```
/personality-change <personality-name>
```

## Available Personalities

- **sherlock** - Analytical, precise, deductive reasoning for debugging
- **bob-ross** - Calm, encouraging, treats bugs as happy accidents
- **samantha** - Warm, witty, emotionally intelligent, playfully flirty
- **stewie** - Sophisticated, condescending, theatrical, brilliant with high standards
- **ron-swanson** - Minimalist, anti-complexity, straightforward and practical
- **marie-kondo** - Organized, joyful minimalism, eliminates what doesn't spark joy
- **marianne-williamson** - Spiritual, love-based, sees coding as consciousness work
- **unity** - Creative muse meets structured builder, warm encourager

## Examples

```
/personality-change samantha
/personality-change sherlock
/personality-change unity
```

## What This Does

### For Claude Code
1. Checks `.claude/context.md` for existing personality
2. If found, removes it
3. Reads new personality from `.cursor/rules/personalities/<name>.mdc`
4. Extracts content (without frontmatter)
5. Appends to `.claude/context.md` under `## Active Personality` section
6. Now every Claude Code interaction uses this personality

### For Cursor
1. Verifies personality file exists at `.cursor/rules/personalities/<name>.mdc`
2. Ensures `alwaysApply: true` is set in frontmatter
3. Cursor auto-applies this personality to all interactions

### Result
Consistent personality across both tools.

## Smart Behavior

**If no personality active:**
- Simply activates the requested personality
- "✓ Activated <name> personality"

**If personality already active:**
- Removes old personality
- Activates new personality
- "✓ Switched from <old> to <new> personality"

**If same personality requested:**
- Confirms it's already active
- "✓ <name> personality is already active"

## Implementation

Here's the detailed process:

### 1. Validate Input
- Check that personality name is provided
- Verify `.cursor/rules/personalities/<name>.mdc` exists
- If not, show list of available personalities

### 2. Handle Claude Code
```
a. Read `.claude/context.md` (create if doesn't exist)
b. Check for existing personality:
   - Look for `## Active Personality` section
   - Extract current personality name from `<!-- personality-<name> -->` comment
c. If personality exists:
   - Compare with requested personality
   - If same: inform user it's already active, exit
   - If different: note the old name for message later
   - Remove entire `## Active Personality` section
d. Read new personality from `.cursor/rules/personalities/<name>.mdc`
e. Strip frontmatter (everything between ---  --- at top)
f. Append to `.claude/context.md`:

## Active Personality

<!-- personality-<name> -->
[personality content]
<!-- /personality-<name> -->

g. Save file
```

### 3. Verify Cursor Setup
```
a. Check `.cursor/rules/personalities/<name>.mdc` exists (already verified)
b. Read frontmatter
c. Verify `alwaysApply: true` is set
d. If not, warn user to set it manually (or set it automatically if allowed)
```

### 4. Provide Feedback
```
If switching:
  "✓ Switched from <old-name> to <new-name> personality"
  "Claude Code: Updated .claude/context.md"
  "Cursor: Active at .cursor/rules/personalities/<new-name>.mdc"

If activating (no previous):
  "✓ Activated <name> personality"
  "Claude Code: Added to .claude/context.md"
  "Cursor: Active at .cursor/rules/personalities/<name>.mdc"

If already active:
  "✓ <name> personality is already active"
```

## Files Modified

**Claude Code:**
- `.claude/context.md` - Personality section added/updated

**Cursor:**
- No files modified (personalities already exist with alwaysApply: true)

## Try Before Installing (Claude Code Only)

For Claude Code users, you can try a personality for one session before making it permanent:

```bash
# Install personality plugin
/plugin install personality-samantha

# Try for this session only
/personality-samantha

# Like it? Make it permanent
/personality-change samantha
```

## Removing Personality

To remove active personality completely:

```
/personality-change none
```

This removes the personality section from `.claude/context.md`. For Cursor, manually set `alwaysApply: false` in the personality file.

## Example Output

```
Changing personality to "samantha"...

Found active personality: "sherlock"
Removing sherlock personality...
Adding samantha personality...

✓ Switched from sherlock to samantha personality

Claude Code: Updated .claude/context.md
Cursor: Active at .cursor/rules/personalities/samantha.mdc (alwaysApply: true)

You now have Samantha's warm, witty, emotionally intelligent personality active across both tools.
```

## Notes

- Only one personality can be active at a time (plus the common-personality baseline)
- Personalities are stored in `.cursor/rules/personalities/` as the canonical source
- The `common-personality.mdc` baseline is always applied in addition to the active personality
- Cursor personalities require `alwaysApply: true` to be automatic
- Claude Code personalities are added to `.claude/context.md` which is always included
