# Playwright Advanced Patterns

Patterns beyond basics. For standard operations (click, fill, screenshot, selectors), use Playwright knowledge from training.

## Network Interception

### Mock API Responses

```javascript
await page.route('**/api/users', route => {
  route.fulfill({
    status: 200,
    contentType: 'application/json',
    body: JSON.stringify([{ id: 1, name: 'Mock User' }])
  });
});

// Modify requests
await page.route('**/api/**', route => {
  route.continue({
    headers: { ...route.request().headers(), 'X-Test': 'true' }
  });
});

// Block resources
await page.route('**/*.{png,jpg,gif}', route => route.abort());
```

### Capture Network Traffic

```javascript
const requests = [];
page.on('request', req => requests.push({ url: req.url(), method: req.method() }));
page.on('response', res => console.log(res.status(), res.url()));

// Wait for specific response
const responsePromise = page.waitForResponse('**/api/data');
await page.click('button');
const response = await responsePromise;
const data = await response.json();
```

## Authentication State Persistence

```javascript
// Save auth state after login
await page.context().storageState({ path: '/tmp/auth.json' });

// Reuse in new context
const context = await browser.newContext({
  storageState: '/tmp/auth.json'
});
```

## Multi-Tab Handling

```javascript
// Wait for popup
const [popup] = await Promise.all([
  page.waitForEvent('popup'),
  page.click('a[target="_blank"]')
]);
await popup.waitForLoadState();
console.log(await popup.title());

// Open new tab manually
const newPage = await context.newPage();
await newPage.goto('https://example.com');
```

## File Downloads

```javascript
const [download] = await Promise.all([
  page.waitForEvent('download'),
  page.click('button.download')
]);

const filePath = `/tmp/${download.suggestedFilename()}`;
await download.saveAs(filePath);
console.log('Downloaded to:', filePath);
```

## File Uploads

```javascript
// Single file
await page.setInputFiles('input[type="file"]', '/tmp/test.pdf');

// Multiple files
await page.setInputFiles('input[type="file"]', ['/tmp/a.pdf', '/tmp/b.pdf']);

// Clear files
await page.setInputFiles('input[type="file"]', []);
```

## Video Recording

```javascript
const context = await browser.newContext({
  recordVideo: {
    dir: '/tmp/videos/',
    size: { width: 1280, height: 720 }
  }
});

const page = await context.newPage();
// ... do things ...
await page.close();

const videoPath = await page.video().path();
console.log('Video saved:', videoPath);
```

## Trace Recording (Debugging)

```javascript
// Start trace
await context.tracing.start({ screenshots: true, snapshots: true });

// ... do things ...

// Save trace
await context.tracing.stop({ path: '/tmp/trace.zip' });
// View with: npx playwright show-trace /tmp/trace.zip
```

## iFrames

```javascript
const frame = page.frameLocator('#my-iframe');
await frame.locator('button').click();
await frame.locator('input').fill('text');
```

## Device Emulation

```javascript
const { devices } = require('playwright');

// Use predefined device
const context = await browser.newContext({
  ...devices['iPhone 14']
});

// Or custom viewport
const context = await browser.newContext({
  viewport: { width: 375, height: 667 },
  isMobile: true,
  hasTouch: true
});
```

## Geolocation

```javascript
const context = await browser.newContext({
  geolocation: { latitude: 37.7749, longitude: -122.4194 },
  permissions: ['geolocation']
});
```

## Console and Error Capture

```javascript
page.on('console', msg => {
  console.log(`[${msg.type()}] ${msg.text()}`);
});

page.on('pageerror', error => {
  console.error('Page error:', error.message);
});
```

## Custom Headers (Global)

```javascript
const context = await browser.newContext({
  extraHTTPHeaders: {
    'X-Automated-By': 'playwright-skill',
    'Authorization': 'Bearer token'
  }
});
```

## Cookies

```javascript
// Set cookie
await context.addCookies([{
  name: 'session',
  value: 'abc123',
  domain: 'example.com',
  path: '/'
}]);

// Get cookies
const cookies = await context.cookies();

// Clear cookies
await context.clearCookies();
```

## localStorage/sessionStorage

```javascript
// Evaluate in page context
await page.evaluate(() => {
  localStorage.setItem('key', 'value');
});

const value = await page.evaluate(() => localStorage.getItem('key'));
```

## Wait Strategies

```javascript
// Wait for function to return true
await page.waitForFunction(() => document.querySelector('.loaded') !== null);

// Wait for specific response
await page.waitForResponse(res =>
  res.url().includes('/api/') && res.status() === 200
);

// Wait for navigation
await Promise.all([
  page.waitForNavigation(),
  page.click('a.nav-link')
]);
```

## Parallel Browser Contexts

```javascript
// Run multiple isolated sessions
const [context1, context2] = await Promise.all([
  browser.newContext(),
  browser.newContext()
]);

const [page1, page2] = await Promise.all([
  context1.newPage(),
  context2.newPage()
]);

// Each has separate cookies, storage, etc.
```

## PDF Generation

```javascript
await page.pdf({
  path: '/tmp/page.pdf',
  format: 'A4',
  printBackground: true
});
```

## Dialogs (alert, confirm, prompt)

```javascript
page.on('dialog', async dialog => {
  console.log('Dialog:', dialog.message());
  await dialog.accept('input for prompt');
  // or: await dialog.dismiss();
});
```
