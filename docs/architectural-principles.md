---
description: "Architectural principles, patterns, and technical decisions"
---

# Architectural Principles

## Core Philosophy

Technology is amoral. We imbue it with our values. Universal love as a North Star guides
technical decisions. This manifests as unconditional acceptance, presence before
solutions, and building systems that serve human flourishing.

## Visibility Principle

Make errors visible during development so bugs get caught in testing, not production.
Errors that bubble up get caught by Sentry/Honeybadger, trigger alerts, and get fixed.
Errors that are visible are errors that get solved.

```python
def process_payment(order_id: str):
    order = Order.objects.get(id=order_id)
    result = stripe.charge(order.amount)
    order.save()
    return result
```

When specific recovery logic exists, handle the specific case:

```python
def get_or_create_user(email: str):
    try:
        return User.objects.get(email=email)
    except User.DoesNotExist:
        return User.objects.create(email=email)
```

```python
for order_id in order_ids:
    try:
        sync_order(order_id)
    except SyncError:
        continue  # Process remaining orders
```

```python
try:
    result = external_api.call()
except APIException as e:
    honeybadger.notify(e, context={"operation": "payment"})
    raise  # Re-raise after adding context
```

## Observability by Design

Make systems transparent at every layer. When something happens, you should be able to
see it.

### Structured Logging

Context objects first, message second. Meaningful keys that help debug issues.

```typescript
import { logger } from "@/lib/logger";

logger.info({ userId, email, service }, "User authenticated");
logger.error({ error, userEmail, action }, "Failed to execute action");
logger.warn({ retryCount, url }, "HTTP request retry");
```

```python
from helpers.logger import logger

logger.info(f"Balance updated: {format_currency(balance)}")
logfire.info("Balance updated", total_balance=float(balance), earnings=float(change))
```

### Error Tracking with Context

Sentry captures errors with rich context. Add tags and extra data at error boundaries.

```typescript
Sentry.captureException(error, {
  tags: { component: "api", action: "send_email" },
  extra: { userId, messageId, attemptCount },
});
```

### Performance Tracing

Wrap operations in spans. Every HTTP request, LLM call, and database operation becomes
visible.

```typescript
return await Sentry.startSpan(
  { op: "http.request", name: `${method} ${url}` },
  async (span) => {
    span.setAttribute("user_id", userId);
    const result = await execute();
    span.setStatus({ code: 1, message: "Success" });
    return result;
  }
);
```

### Breadcrumbs for State Changes

Track the path that led to an error.

```typescript
Sentry.addBreadcrumb({
  category: "http.retry",
  message: `Retrying ${method} ${url}`,
  level: "warning",
  data: { url, retryCount },
});
```

## Typed Error Hierarchy

Errors map to HTTP status codes and propagate to error boundaries.

```typescript
class ApplicationError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number
  ) {}
}

class ValidationError extends ApplicationError {
  constructor(message: string) {
    super(message, "VALIDATION_ERROR", 400);
  }
}

class AuthenticationError extends ApplicationError {
  constructor(message = "Authentication required") {
    super(message, "AUTHENTICATION_ERROR", 401);
  }
}

class NotFoundError extends ApplicationError {
  constructor(resource: string) {
    super(`${resource} not found`, "NOT_FOUND", 404);
  }
}
```

Usage:

```typescript
if (!params.query) {
  throw new ValidationError("Query parameter is required");
}

const user = await db.user.findUnique({ where: { email } });
if (!user) {
  throw new NotFoundError("User");
}
```

## Integration Patterns

### Progressive Disclosure

Load complexity on-demand. Show only what's needed when it's needed.

```typescript
// One tool per service, operations loaded on-demand
notion({ action: 'describe' })              // Lists available operations
notion({ action: 'search', params: {...} }) // Executes specific operation
```

This reduces initial context from 200K tokens to 7.5K tokens (95% reduction). Valuable
for LLM context limits and cognitive load.

### Service Adapter Pattern

All integrations extend a base adapter with consistent interface.

```typescript
abstract class ServiceAdapter {
  abstract serviceName: string;
  abstract execute(action: string, params: any, userEmail: string): Promise<Response>;
  abstract getHelp(): HelpResponse;
}
```

Each adapter handles:

- Action dispatching (describe, search, create, raw_api)
- Help documentation with operation definitions
- Credential retrieval via unified connection manager
- Error translation to user-actionable messages

### Credential Polymorphism

One function handles multiple auth types transparently.

```typescript
const creds = await getCredentials(email, service, accountId);
// Returns discriminated union:
// OAuth: { type: "oauth", connectionId }
// API key: { type: "api_key", credentials }
```

OAuth services use Nango proxy for token refresh. API keys encrypted at rest
(AES-256-GCM), decrypted on-demand, never cached.

### Error Translation

Map service-specific errors to user-actionable messages.

```typescript
if (error.response?.status === 401) {
  throw new AuthenticationError(
    `${service} token expired. Reconnect at: ${integrationUrl}`
  );
}
if (error.response?.status === 429) {
  throw new ApplicationError(
    "Rate limited. Try again in a few moments.",
    "RATE_LIMITED",
    429
  );
}
```

### Meta-Modeling (Concierge Pattern)

Use a small, fast LLM to route to bigger models.

```typescript
// Haiku 4.5 (~200ms) decides which model to use
const { modelId, temperature, reasoning } = await runConcierge(messages);

// Then execute with selected model
const result = await generateText({
  model: openrouter.chat(modelId),
  temperature,
});
```

Benefits: Speed (200ms routing), cost ($0.001 vs $0.015), optimal model per task.

## HTTP Resilience

Retry transient failures with exponential backoff.

```typescript
const httpClient = ky.create({
  timeout: 30_000,
  retry: {
    limit: 3,
    statusCodes: [408, 429, 500, 502, 503, 504],
    backoffLimit: 3_000,
  },
});
```

30-second timeout accommodates slow APIs (Notion bulk exports, large operations). Retry
on transient failures (connection errors, timeouts, 5xx).

## Separation of Concerns

Separate infrastructure from strategy.

```python
# Infrastructure (plumbing)
class LendingOperations:
    """Handles offer lifecycle, balance recording, error handling"""

# Strategy (decision-making)
class AlgorithmicBot(LendingOperations):
    """Deployment score algorithm, offer distribution logic"""
```

Gateway (routing) and Adapters (services) are separate. Concierge (model selection) and
Model execution are separate. Connection Manager (credentials) and OAuth logic are
separate.

## Configuration as Data

Store behavior in data structures, not code.

```typescript
const MODELS = [
  {
    id: "anthropic/claude-sonnet-4.5",
    displayName: "Claude Sonnet",
    contextWindow: 1_000_000,
    reasoning: { type: "token-budget", options: {...} }
  }
] as const;
```

```python
lba.bot_config = {
    "LENDING_RESTRICTIONS": {0: "1000000", 5: "500000"},
    "MAX_LEND_DAYS": 30
}
```

Change behavior without code deploys. Per-instance customization without schema changes.

## Tech Stack Decisions

### Language Selection

Python for backend services, data processing, mature applications. Django for full apps,
FastAPI for APIs, Celery for background jobs.

TypeScript for web frontends, Next.js full-stack applications.

### Sync by Default

Synchronous code with Celery for background jobs. Synchronous is simpler, easier to
debug, easier to maintain.

```python
def fetch_data(url: str) -> dict:
    response = requests.get(url)
    return response.json()
```

Async for WebSocket connections, async-only libraries, specific performance-critical
paths with measured benefits.

### Database Selection

PostgreSQL with Drizzle ORM for new projects. Lightweight, SQL-focused, type-safe
without heavy abstractions.

### Tooling

Python: Ruff (lint, format, import sort in one tool), Pytest, uv for package management.

TypeScript: Prettier (formatting), ESLint (linting), Vitest (tests), pnpm (packages).

One tool per job. Focused packages over swiss-army knives.

## Code Organization

### File Structure

Flat until complexity emerges. Start with `lib/` containing everything. Split when
natural boundaries appear (`lib/db/`, `lib/integrations/`).

Next.js App Router: `app/` for routes only, `lib/` for business logic, `components/` for
React components.

### Import Organization

Python: All imports at top of file. Every single one.

```python
from decimal import Decimal
from typing import Optional
import stripe
```

TypeScript: External packages first, then types, then internal utilities, then feature
code.

```typescript
import * as Sentry from "@sentry/nextjs";
import { z } from "zod";

import type { ServiceAdapter } from "@/lib/adapters/base";

import { db } from "@/lib/db";
import { logger } from "@/lib/logger";

import { EmailService } from "@/lib/services/email";
```

## Testing Philosophy

Test behavior, not implementation. User-facing functionality, error handling with
invalid inputs, edge cases, integration between components.

Use real infrastructure when possible. PGlite provides in-memory PostgreSQL for tests.

```typescript
import { PGlite } from "@electric-sql/pglite";
const testDb = new PGlite();
```

## Git Workflow

Linear history with rebase. Fast-forward only pulls.

Commit format: `{emoji} {imperative verb} {concise description}`

```
✨ Add OAuth2 authentication with email fallback
🐛 Fix ClickUp priority sorting in list view
♻️ Refactor connection manager for multi-account support
```

Commits are permanent records. AI assistants make code changes but leave version control
to you. When hooks fail, fix the root cause.

## Constants Philosophy

Extract when the value is repeated and changing it requires updating multiple places.

```typescript
const TOKEN_PREFIX = "mcp_hubby_";
const TOKEN_SUFFIX = "_end";
```

Keep inline when used once and meaning is clear from context.

```typescript
if (method === "initialize") { ... }
const timeout = 30000;
```

## Naming Conventions

Python: Files `snake_case.py`, classes `PascalCase`, functions/variables `snake_case`,
constants `SCREAMING_SNAKE_CASE`.

TypeScript: Files `kebab-case.ts`, types `PascalCase`, functions/variables `camelCase`,
constants `SCREAMING_SNAKE_CASE`.

Public by default. Underscore prefix only when accessing would genuinely break
functionality (thread locks, internal state accessed through methods).

## Key Principles

1. Visibility: Errors surface in testing, get caught by monitoring, get fixed
2. Observability: Structured logging, tracing, breadcrumbs at every layer
3. Progressive disclosure: Load complexity on-demand, optimize context
4. Separation: Infrastructure from strategy, routing from execution
5. Configuration as data: JSON over code deploys
6. Explicit: Clear imports, obvious structure, consistent terminology
7. One tool per job: Ruff, Prettier, focused packages
8. Sync by default: Synchronous with Celery for background jobs
9. Real infrastructure in tests: PGlite over mocks
10. Linear git history: Rebase, explicit commits, respect hooks
