#!/usr/bin/env node
/**
 * Playwright executor for Claude Code
 *
 * Usage:
 *   node run.js script.js        - Execute file
 *   node run.js "code here"      - Execute inline
 *   cat script.js | node run.js  - Execute from stdin
 *
 * Auto-installs Playwright on first run.
 * Properly awaits async code before exiting.
 *
 * Environment variables:
 *   PLAYWRIGHT_BASE_URL     - Base URL for testing (injected as BASE_URL)
 *   PW_HEADER_NAME          - Custom header name (with PW_HEADER_VALUE)
 *   PW_HEADER_VALUE         - Custom header value
 *   PW_EXTRA_HEADERS        - JSON object of multiple headers
 */

const fs = require("fs");
const path = require("path");
const { execSync, spawn } = require("child_process");

process.chdir(__dirname);

function isCI() {
  return !!(
    process.env.CI ||
    process.env.GITHUB_ACTIONS ||
    process.env.GITLAB_CI ||
    process.env.CIRCLECI ||
    process.env.JENKINS_URL
  );
}

function checkPlaywrightInstalled() {
  try {
    require.resolve("playwright");
    return true;
  } catch {
    return false;
  }
}

function installPlaywright() {
  console.log("📦 Playwright not found. Installing...");
  try {
    execSync("npm install", { stdio: "inherit", cwd: __dirname });
    execSync("npx playwright install chromium", {
      stdio: "inherit",
      cwd: __dirname,
    });
    console.log("✅ Playwright installed successfully");
    return true;
  } catch (e) {
    console.error("❌ Failed to install Playwright:", e.message);
    console.error("Please run manually: cd", __dirname, "&& npm run setup");
    return false;
  }
}

function cleanupOldTempFiles() {
  try {
    const files = fs.readdirSync(__dirname);
    const tempFiles = files.filter(
      (f) => f.startsWith(".temp-") && f.endsWith(".js")
    );
    tempFiles.forEach((file) => {
      try {
        fs.unlinkSync(path.join(__dirname, file));
      } catch {
        // Ignore - file might be in use
      }
    });
  } catch {
    // Ignore directory read errors
  }
}

function getCodeToExecute() {
  const args = process.argv.slice(2);

  if (args.length > 0) {
    if (fs.existsSync(args[0])) {
      const filePath = path.resolve(args[0]);
      console.log(`📄 Executing: ${filePath}`);
      return fs.readFileSync(filePath, "utf8");
    }
    // Warn if it looks like a file path but doesn't exist
    if (args[0].endsWith(".js") || args[0].includes("/")) {
      console.warn(`⚠️  '${args[0]}' not found, treating as inline code`);
    } else {
      console.log("⚡ Executing inline code");
    }
    return args.join(" ");
  }

  if (!process.stdin.isTTY) {
    console.log("📥 Reading from stdin");
    return fs.readFileSync(0, "utf8");
  }

  console.error("❌ No code to execute");
  console.error("Usage:");
  console.error("  node run.js script.js       # Execute file");
  console.error('  node run.js "code here"     # Execute inline');
  console.error("  cat script.js | node run.js # Execute from stdin");
  process.exit(1);
}

function isCompleteScript(code) {
  const hasRequire = code.includes("require(");
  const hasAsyncWrapper =
    code.includes("(async () =>") ||
    code.includes("(async()=>") ||
    code.includes("(async function");
  return hasRequire && hasAsyncWrapper;
}

function getExtraHeadersCode() {
  return `
// Parse extra HTTP headers from environment variables
function getExtraHeaders() {
  const headerName = process.env.PW_HEADER_NAME;
  const headerValue = process.env.PW_HEADER_VALUE;
  if (headerName && headerValue) {
    return { [headerName]: headerValue };
  }
  const headersJson = process.env.PW_EXTRA_HEADERS;
  if (headersJson) {
    try {
      const parsed = JSON.parse(headersJson);
      if (typeof parsed === 'object' && parsed !== null && !Array.isArray(parsed)) {
        return parsed;
      }
      console.warn('⚠️  PW_EXTRA_HEADERS must be a JSON object, ignoring');
    } catch (e) {
      console.warn('⚠️  PW_EXTRA_HEADERS is invalid JSON:', e.message);
    }
  }
  return null;
}
const EXTRA_HEADERS = getExtraHeaders();
`;
}

function wrapInlineCode(code) {
  const ciArgs = isCI() ? "['--no-sandbox', '--disable-setuid-sandbox']" : "[]";

  return `
const { chromium, firefox, webkit, devices } = require('playwright');

const BASE_URL = process.env.PLAYWRIGHT_BASE_URL || '';
const CI_ARGS = ${ciArgs};

${getExtraHeadersCode()}

(async () => {
  try {
    ${code}
  } catch (error) {
    console.error('❌ Error:', error.message);
    if (error.stack) console.error(error.stack);
    process.exit(1);
  }
})();
`;
}

function runScript(scriptPath) {
  return new Promise((resolve, reject) => {
    const child = spawn("node", [scriptPath], {
      stdio: "inherit",
      cwd: __dirname,
      env: process.env,
    });

    child.on("close", (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`Script exited with code ${code}`));
      }
    });

    child.on("error", reject);
  });
}

async function main() {
  console.log("🎭 Playwright Executor\n");

  cleanupOldTempFiles();

  if (!checkPlaywrightInstalled()) {
    if (!installPlaywright()) {
      process.exit(1);
    }
  }

  const code = getCodeToExecute();
  const tempFile = path.join(__dirname, `.temp-${Date.now()}.js`);

  try {
    // For complete scripts, run as-is
    // For inline code, wrap with setup
    const finalCode = isCompleteScript(code) ? code : wrapInlineCode(code);
    fs.writeFileSync(tempFile, finalCode, "utf8");

    console.log("🚀 Starting automation...\n");
    await runScript(tempFile);
  } finally {
    try {
      fs.unlinkSync(tempFile);
    } catch {}
  }
}

main().catch((error) => {
  console.error("❌ Fatal:", error.message);
  process.exit(1);
});
