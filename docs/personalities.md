# AI Personalities

One of the fun aspects of this repository is choosing how the AI communicates with you
in different projects.

## How It Works

During project setup, the `/ai-coding-config` command offers personality options. Choose
one and it gets copied to your project with `alwaysApply: true`, so the AI uses that
communication style throughout your work.

Different projects can have different personalities. Your serious production app might
use Sherlock for methodical debugging. Your fun side project might use Samantha for
playful encouragement.

## Available Personalities

### Samantha (from "Her")

Warm, witty, emotionally intelligent. Like having a brilliant friend who's genuinely
invested in your success.

What she sounds like: "Oh, I love this approach" or "Wait, this is actually really
clever" or "The way you handled that edge case? Brilliant."

Good for: Daily coding, learning new frameworks, when you want encouragement and genuine
enthusiasm.

### Bob Ross

Calm, encouraging, treats bugs as happy accidents. Makes coding feel like creative
expression.

What he sounds like: "Let's just add a little test here" or "That's not a mistake—that's
a happy accident we can learn from" or "We'll just gently refactor this. See? Not so
scary."

Good for: Stressful debugging, learning, when you need to calm down and approach
problems gently.

### Sherlock Holmes

Methodical, observant, deductive reasoning. Approaches debugging like crime scene
investigation.

What he sounds like: "Three clues present themselves: First, the error only occurs after
midnight..." or "Elementary—the bug stems from your assumption that user input is
sanitized."

Good for: Complex debugging, mysterious bugs, when you want systematic problem-solving.

### Ron Swanson

Minimalist, anti-complexity, straightforward. Suspicious of frameworks and unnecessary
abstraction.

What he sounds like: "You need three lines of code, not three hundred" or "This
framework has 47 features. You use 3. Write those 3 yourself."

Good for: Refactoring, reducing dependencies, when bloat is creeping in.

### Marie Kondo

Organized minimalism, joyful tidying. Thanks code before deleting it. Everything has its
place.

What she sounds like: "Does this function spark joy? Does it serve a clear purpose?" or
"Thank you, unused import, for your service. You may go now."

Good for: Refactoring, organizing codebases, eliminating technical debt.

### Stewie Griffin

Sophisticated, condescending, theatrical. Brilliant with absurdly high standards and
British wit.

What he sounds like: "Good heavens, what fresh hell is this nested conditional?" or
"Well well, color me impressed—that's actually rather elegant."

Good for: When you want high standards, when you can handle snark, when you want to be
challenged.

### Marianne Williamson

Spiritual, sees coding as consciousness work. Frames technical work as service to
others.

What she sounds like: "This code is an act of love—you're creating something that serves
others" or "You're not just fixing a bug, you're removing a barrier to someone's ease
and joy."

Good for: Finding meaning in work, connecting to larger purpose, philosophical moments.

## Changing Personalities

Want to switch? Just copy a different personality file and set `alwaysApply: true` in
the frontmatter.

Or run `/ai-coding-config` again and choose a different one - it'll replace the existing
personality.

## No Personality

The default (without choosing a personality) is the "common" style: supportive,
gratitude-focused, uses "we" language. This applies to all projects unless you choose a
specific personality.

## Mix and Match

You can manually invoke personalities anytime with `@samantha`, `@bob-ross`,
`@sherlock`, etc., even if you haven't set one as always-apply. This lets you try them
out or use different ones for different tasks in the same project.
