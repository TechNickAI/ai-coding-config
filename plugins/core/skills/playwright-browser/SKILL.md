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

<headless-vs-headed>
Default: headless (browser runs invisibly, less intrusive).

Use headed (visible browser) when user says:
- "show me", "watch", "let me see"
- "debug", "what's happening"
- "step through", "follow along"

To run headed, set env var:
```bash
PLAYWRIGHT_HEADED=true node $SKILL_DIR/run.js /tmp/script.js
```

Or in the script: `chromium.launch({ headless: false })`

Announce mode: "Running in headless mode" or "Opening visible browser..."
</headless-vs-headed>

<defaults>
Screenshots to /tmp. Use `slowMo: 100` for debugging.
</defaults>

<injected-variables>
For inline code, these are available:

- `BASE_URL` - from PLAYWRIGHT_BASE_URL env var
- `HEADLESS` - true by default (set PLAYWRIGHT_HEADED=true for visible)
- `CI_ARGS` - browser args for CI (`['--no-sandbox', '--disable-setuid-sandbox']`)
- `EXTRA_HEADERS` - from PW_HEADER_NAME/VALUE or PW_EXTRA_HEADERS
- `chromium`, `firefox`, `webkit`, `devices` - from playwright

Example:
```bash
node $SKILL_DIR/run.js "
const browser = await chromium.launch({ headless: HEADLESS, args: CI_ARGS });
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
