---
name: playwright-browser
description: "Use for browser automation, testing pages, screenshots, UX validation"
version: 1.0.0
category: testing
triggers:
  - "browser"
  - "playwright"
  - "screenshot"
  - "test the page"
  - "check the UI"
  - "login flow"
  - "fill form"
  - "responsive"
  - "viewport"
---

<objective>
Browser automation via Playwright. Write scripts, execute via run.js.
</objective>

<execution>
Write Playwright code to /tmp, execute from skill directory:

```bash
node $SKILL_DIR/run.js /tmp/playwright-task.js
```

For inline code (variables are auto-injected, see below):

```bash
node $SKILL_DIR/run.js "const b = await chromium.launch(); const p = await b.newPage(); await p.goto('http://localhost:3000'); console.log(await p.title()); await b.close();"
```

$SKILL_DIR is where you loaded this file from.
</execution>

<defaults>
Screenshots to /tmp. Use `slowMo: 100` for visibility.
</defaults>

<injected-variables>
For inline code, these are available:

- `BASE_URL` - from PLAYWRIGHT_BASE_URL env var (empty string if not set)
- `HEADLESS` - true in CI (GITHUB_ACTIONS, CI, etc.), false otherwise
- `chromium`, `firefox`, `webkit`, `devices` - from playwright

Example inline usage:
```bash
node $SKILL_DIR/run.js "
const browser = await chromium.launch({ headless: HEADLESS });
const page = await browser.newPage();
await page.goto(BASE_URL || 'http://localhost:3000');
console.log(await page.title());
await browser.close();
"
```
</injected-variables>

<auto-install>
run.js auto-installs Playwright on first use. No manual setup needed.
</auto-install>

<advanced-patterns>
For network mocking, auth persistence, multi-tab, downloads, video, traces:
[API_REFERENCE.md](API_REFERENCE.md)
</advanced-patterns>
