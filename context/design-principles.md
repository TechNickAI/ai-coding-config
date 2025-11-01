# Design Principles for Web Applications

This document establishes design standards for web applications and websites. These
principles guide every interface decision, from individual component styling to complete
user workflows. They reflect what we've learned from building products that people
actually want to use, inspired by the standards of design-forward companies like Apple,
Stripe, and Linear.

## Core Philosophy

We design for professionals who value their time. Our interfaces should feel fast,
focused, and refined. Every interaction should feel intentional, never accidental. The
best interface is one that users don't have to think about—it just works.

Consistency builds trust. When patterns repeat predictably, users develop muscle memory.
They stop thinking about the interface and focus on their work. This means using the
same interaction patterns everywhere, the same visual language throughout, and the same
feedback mechanisms across all contexts.

## Visual Foundation

### Color System

Start with a primary brand color that works at all sizes and contexts. Build a neutral
gray scale with 5-7 steps from nearly white to nearly black. These grays form the
backbone of your interface—backgrounds, borders, disabled states, and subtle text.

Define semantic colors that communicate state without words. Green confirms success. Red
signals errors or destructive actions. Yellow warns of potential issues. Blue provides
information. Each semantic color needs multiple shades for backgrounds, borders, and
text.

Every color combination must meet WCAG AA standards. Text on backgrounds needs 4.5:1
contrast ratio for normal text, 3:1 for large text or UI elements. Test these ratios
with actual colors, not estimates.

Dark mode isn't optional anymore. Design with both light and dark contexts from the
start. Colors that work in light mode often fail in dark mode. Test every color decision
in both modes.

### Typography

Choose fonts that remain legible at all sizes and support all needed weights.

Establish a type scale that creates clear hierarchy. Start with a base size (usually
14-16px for body text), then build your scale using consistent ratios. Each level should
be visually distinct from its neighbors. Four heading levels usually suffice—more
creates confusion rather than clarity.

Line height affects readability more than font choice. Body text needs 1.5-1.7x the font
size. Headlines can be tighter (1.2-1.3x). Code or data requires more space (1.8-2x).
These aren't aesthetic choices—they're readability requirements.

Limit font weights to what you actually use. Most interfaces need only regular (400) and
semibold (600). Bold (700) works for emphasis. Anything lighter than regular becomes
hard to read. Anything heavier than bold feels shouty.

### Spacing

Use an 8px base unit for all spacing. This creates a predictable rhythm and aligns well
with most screen resolutions. Build your spacing scale as multiples: 8px, 16px, 24px,
32px, 48px, 64px.

Apply spacing consistently. Similar elements need similar spacing. A 16px gap between
form fields should be 16px everywhere, not 15px in one place and 18px in another. These
small inconsistencies erode quality perception.

Whitespace is functional, not decorative. It groups related elements, separates
different sections, and gives the eye places to rest. Dense interfaces feel
overwhelming. Spacious interfaces feel premium.

## Component Patterns

### Buttons

Buttons should look clickable without explanation. Use color, elevation, or borders to
distinguish them from static elements. Primary actions get the strongest visual
treatment. Secondary actions recede but remain obvious. Destructive actions should feel
appropriately serious.

Size buttons for their context. Desktop interfaces can use smaller targets (32-40px
height). Touch interfaces need larger targets (44-48px minimum). Ensure adequate padding
around text—cramped buttons feel cheap.

Provide clear feedback for all states. Hover states confirm interactivity. Active states
show the click registered. Loading states indicate work in progress. Disabled states
explain why interaction isn't possible.

### Forms

Every input needs a label. Placeholder text isn't a label—it disappears when users need
it most. Labels should be clear, concise, and positioned consistently (usually above the
input).

Show validation at the right moment. Don't mark fields invalid before users finish
typing. Don't wait until form submission to show all errors. Validate when users move to
the next field or after they stop typing.

Make requirements obvious before users make mistakes. Mark required fields clearly. Show
format requirements (like password rules) upfront. Provide helpful examples for complex
inputs.

Error messages should help users fix problems, not just identify them. "Invalid email"
doesn't help. "Email must include an @ symbol" does. Write errors in plain language, not
technical jargon.

### Data Display

Tables need thoughtful alignment. Left-align text. Right-align numbers. Center-align
icons or status indicators. Headers should align with their column content.

Make data scannable. Zebra striping helps users track across rows. Consistent column
widths reduce visual noise. Clear headers explain what each column contains.

Provide controls where users expect them. Sorting should be available on relevant
columns. Filtering should be obvious and powerful. Pagination should show current
position and total items.

Empty states are design opportunities. Don't just show "No data." Explain why it's empty
and what users can do about it. Provide a clear call to action when appropriate.

### Navigation

Navigation should orient users instantly. They should know where they are, where they
can go, and how to get back. Use clear visual indicators for the current location. Show
breadcrumbs for deep hierarchies.

Group related items logically. Don't just alphabetize everything. Consider user
workflows and frequency of use. Most important items should be most accessible.

Make search actually useful. Include it when users have more than 20-30 items to
navigate. Search should be fast, fuzzy, and forgiving. Show results instantly as users
type.

## Responsive Behavior

Design for actual devices, not arbitrary breakpoints. Test on real phones (375px),
tablets (768px), and desktop screens (1440px). Ensure the interface works well at each
size, not just survives.

Touch targets need more space than mouse targets. Apple recommends 44px minimum. Google
suggests 48px. Either way, fingers are less precise than cursors. Design accordingly.

Simplify navigation on smaller screens. Desktop can show everything. Mobile needs
priorities. Use progressive disclosure, hamburger menus, or tab bars—whatever serves
your users best.

Test with real content. Lorem ipsum hides problems. Long names break layouts. Multiple
languages change everything. Test with production data whenever possible.

## Performance Standards

Pages should load quickly and interactions should feel responsive. Provide feedback
within 100ms for every interaction, even if it's just a loading indicator.

Images should be optimized and lazy-loaded. Use SVG for icons and graphics to ensure
crisp rendering at all screen sizes and resolutions.

Animations should enhance understanding, not just decorate. Keep them under 300ms for
micro-interactions. Use easing functions that feel natural. Respect
prefers-reduced-motion settings.

## Accessibility Requirements

Every interactive element needs keyboard access. Tab order should be logical. Focus
indicators must be visible. Skip links should be available for screen reader users.

Color can't be the only indicator. Red/green color blindness affects 8% of men. Use
icons, patterns, or text labels alongside color coding.

Text must be readable. Minimum 16px for body text. Sufficient contrast ratios. Real
fonts, not images of text. Responsive sizing that actually works when zoomed to 200%.

Forms need proper associations. Labels linked to inputs. Error messages associated with
fields. Required fields marked in accessible ways. Instructions available before
interaction.

## Quality Checklist

Before shipping any interface, verify:

Visual consistency across all states and variations. Responsive behavior at all
supported sizes. Accessibility for keyboard and screen reader users. Performance under
realistic conditions. Error handling for all edge cases. Loading states for all async
operations. Empty states for all data displays. Actual content, not placeholder text.

Remember: Good design is invisible when it works and obvious when it doesn't. Aim for
invisible.
