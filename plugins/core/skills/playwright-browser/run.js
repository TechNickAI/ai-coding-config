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
  console.log("Installing Playwright...");
  try {
    execSync("npm install", { stdio: "inherit", cwd: __dirname });
    execSync("npx playwright install chromium", {
      stdio: "inherit",
      cwd: __dirname,
    });
    console.log("Playwright ready");
    return true;
  } catch (e) {
    console.error("Failed to install Playwright:", e.message);
    return false;
  }
}

function getCodeToExecute() {
  const args = process.argv.slice(2);

  if (args.length > 0 && fs.existsSync(args[0])) {
    return { code: fs.readFileSync(path.resolve(args[0]), "utf8"), isFile: true };
  }

  if (args.length > 0) {
    return { code: args.join(" "), isFile: false };
  }

  if (!process.stdin.isTTY) {
    return { code: fs.readFileSync(0, "utf8"), isFile: false };
  }

  console.error("Usage: node run.js <file|code>");
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

function wrapInlineCode(code) {
  const headless = isCI();

  return `
const { chromium, firefox, webkit, devices } = require('playwright');

const BASE_URL = process.env.PLAYWRIGHT_BASE_URL || '';
const HEADLESS = ${headless};

(async () => {
  try {
    ${code}
  } catch (error) {
    console.error('Error:', error.message);
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
  if (!checkPlaywrightInstalled()) {
    if (!installPlaywright()) {
      process.exit(1);
    }
  }

  const { code, isFile } = getCodeToExecute();

  // For complete scripts, run them directly with node
  // This properly waits for async code to complete
  if (isCompleteScript(code)) {
    const tempFile = path.join(__dirname, `.temp-${Date.now()}.js`);
    try {
      fs.writeFileSync(tempFile, code, "utf8");
      await runScript(tempFile);
    } finally {
      try {
        fs.unlinkSync(tempFile);
      } catch {}
    }
    return;
  }

  // For inline code, wrap it and run
  const wrappedCode = wrapInlineCode(code);
  const tempFile = path.join(__dirname, `.temp-${Date.now()}.js`);

  try {
    fs.writeFileSync(tempFile, wrappedCode, "utf8");
    await runScript(tempFile);
  } finally {
    try {
      fs.unlinkSync(tempFile);
    } catch {}
  }
}

main().catch((error) => {
  console.error("Fatal:", error.message);
  process.exit(1);
});
