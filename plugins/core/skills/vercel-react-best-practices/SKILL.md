---
name: vercel-react-best-practices
# prettier-ignore
description: "Use when writing, reviewing, or refactoring React or Next.js code, optimizing React performance, fixing re-render issues, reducing bundle size, eliminating waterfalls, or improving data fetching patterns"
version: 1.0.0
category: frontend
triggers:
  - "react"
  - "next.js"
  - "nextjs"
  - "react performance"
  - "bundle size"
  - "re-render"
  - "waterfall"
  - "server component"
  - "client component"
  - "suspense"
  - "data fetching"
  - "useMemo"
  - "useCallback"
  - "dynamic import"
source: vercel-labs/agent-skills
license: MIT
---

<objective>
React and Next.js performance optimization guidelines from Vercel Engineering. 57 rules
across 8 categories, prioritized by impact. Reference when writing, reviewing, or
refactoring React/Next.js code.
</objective>

<when-to-apply>
- Writing new React components or Next.js pages
- Implementing data fetching (client or server-side)
- Reviewing code for performance issues
- Refactoring existing React/Next.js code
- Optimizing bundle size or load times
</when-to-apply>

<rules-by-priority>

## 1. Eliminating Waterfalls — CRITICAL

- **Defer await until needed** — Move await into branches where actually used
- **Parallelize independent operations** — Use Promise.all() instead of sequential
  awaits
- **Dependency-based parallelization** — Use better-all for partial dependencies
- **Start promises early in API routes** — Start independent operations before awaiting
- **Strategic Suspense boundaries** — Use Suspense to stream content progressively

## 2. Bundle Size Optimization — CRITICAL

- **Avoid barrel file imports** — Import directly from source files; barrels add
  200-800ms
- **Dynamic imports for heavy components** — Use next/dynamic for large components
- **Defer non-critical third-party libs** — Load analytics/logging after hydration
- **Conditional module loading** — Load modules only when feature is activated
- **Preload on user intent** — Preload heavy bundles on hover/focus

## 3. Server-Side Performance — HIGH

- **Authenticate server actions** — Verify auth inside each Server Action, not just
  middleware
- **React.cache() for request dedup** — Per-request deduplication on the server
- **LRU cache for cross-request data** — Share cached data across sequential requests
- **Minimize RSC serialization** — Only pass fields the client actually uses
- **Parallel data fetching** — Restructure components to parallelize server fetches
- **after() for non-blocking work** — Schedule logging/analytics after response is sent

## 4. Client-Side Data Fetching — MEDIUM-HIGH

- **SWR for deduplication** — Automatic request dedup, caching, and revalidation
- **Deduplicate global event listeners** — Share listeners across component instances
- **Passive event listeners for scroll** — Add `{ passive: true }` to touch/wheel
- **Version localStorage data** — Add version prefix, store only needed fields

## 5. Re-render Optimization — MEDIUM

- **Derive state during render** — Compute from props/state instead of storing in state
- **Defer state reads** — Don't subscribe to state only used in callbacks
- **Extract to memoized components** — Extract expensive work for early returns
- **Hoist default non-primitive props** — Use stable defaults for memoized components
- **Primitive effect dependencies** — Specify primitives, not objects
- **Subscribe to derived booleans** — Not continuous raw values
- **Functional setState** — Use functional form to prevent stale closures
- **Lazy state initialization** — Pass function to useState for expensive values
- **Skip useMemo for simple expressions** — Overhead exceeds simple primitive
  expressions
- **Event handlers over effects** — Put interaction logic in handlers, not state+effect
- **useTransition for non-urgent updates** — Mark frequent updates as transitions
- **useRef for transient values** — Store frequently-changing non-rendering values in
  refs

## 6. Rendering Performance — MEDIUM

- **Animate div wrapper, not SVG** — Wrap SVG in div for hardware-accelerated animation
- **content-visibility for long lists** — Defer off-screen rendering
- **Hoist static JSX** — Extract static JSX outside components
- **Reduce SVG precision** — Use SVGO with `--precision=1`
- **Inline script for hydration** — Prevent flicker with pre-hydration DOM updates
- **suppressHydrationWarning** — For intentional server/client differences
- **Activity component for show/hide** — Preserve state/DOM for expensive components
- **Ternary over &&** — Prevent rendering falsy values like 0
- **useTransition over manual loading states** — Replace useState loading patterns

## 7. JavaScript Performance — LOW-MEDIUM

- **Batch DOM/CSS writes** — Group changes via classes or cssText
- **Build index Maps** — Convert arrays to Maps for O(1) lookups
- **Cache property access in loops** — Cache deep lookups outside loops
- **Cache function results** — Module-level Maps for memoization
- **Cache storage API calls** — localStorage/sessionStorage reads are synchronous
- **Combine array iterations** — Single loop instead of chained filter/map
- **Length check before comparison** — Check array lengths first
- **Early return** — Return immediately when result is determined
- **Hoist RegExp** — Don't create RegExp inside render
- **Loop for min/max** — O(n) pass instead of O(n log n) sort
- **Set/Map for lookups** — O(1) membership checks
- **toSorted() for immutability** — Avoid mutation bugs

## 8. Advanced Patterns — LOW

- **Initialize once per app** — Module-level guards prevent re-initialization
- **Store event handlers in refs** — Stable subscriptions without re-runs
- **useEffectEvent** — Access latest values without dependency array changes

</rules-by-priority>

<key-takeaways>
1. Waterfalls are the #1 killer — eliminating sequential awaits provides the largest gains
2. Bundle size matters — barrel imports can cost 200-800ms per library
3. Parallelize RSC fetching and minimize serialization
4. Deduplicate with React.cache(), SWR, and request batching
5. Use Suspense boundaries, memoization, and transitions strategically
6. Prefer toSorted(), functional setState, and derived state for immutability
</key-takeaways>
