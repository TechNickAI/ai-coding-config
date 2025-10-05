# Installation Instructions for AI Coding Tools

Quick reference for installing Cursor and Claude Code on macOS and Linux.

## Cursor (IDE + CLI)

### macOS

Option 1: Install via Homebrew (recommended):

```bash
brew install --cask cursor
```

Option 2: Direct download from https://cursor.com - click "Download for Mac", open the
.dmg, and drag to Applications.

Enable the Cursor CLI:

```bash
# Open Cursor IDE
# Press Cmd+Shift+P
# Type: "Shell Command: Install 'cursor' command in PATH"
# Or from terminal:
ln -s /Applications/Cursor.app/Contents/Resources/app/bin/cursor /usr/local/bin/cursor
```

Verify the installation:

```bash
cursor --version
```

### Linux

For Debian/Ubuntu:

```bash
# Download latest .deb
wget https://download.cursor.sh/linux/appImage/x64
chmod +x cursor-*.AppImage
sudo mv cursor-*.AppImage /usr/local/bin/cursor

# Or use the .deb package
wget https://download.cursor.sh/linux/deb/x64
sudo dpkg -i cursor_*.deb
```

For Arch Linux, use an AUR helper:

```bash
yay -S cursor-appimage
```

Enable the CLI:

```bash
# Should be automatic with package install
# Verify:
which cursor
cursor --version
```

---

## Claude Code

### macOS & Linux

Option 1: Install via npm (recommended, requires Node.js 18+):

```bash
npm install -g @anthropic-ai/claude-code
```

Option 2: Direct download from https://www.anthropic.com/claude/code following the
platform-specific instructions.

Verify the installation:

```bash
claude --version
# or
claude code --version
```

Initial setup - Claude Code will prompt for your API key on first run:

```bash
claude code --help

# Or set the API key manually
export ANTHROPIC_API_KEY=sk-ant-...
# Add to ~/.zshrc or ~/.bashrc to persist
```

---

## Required Dependencies

### Node.js (for Claude Code and MCP servers)

On macOS, install via Homebrew or use nvm for managing multiple versions:

```bash
brew install node

# Or with nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
nvm use 20
```

On Linux:

```bash
# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Or using nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
```

### Python (for Python development)

On macOS, install via Homebrew or use pyenv:

```bash
brew install python@3.12

# Or with pyenv (recommended)
brew install pyenv
pyenv install 3.12.0
pyenv global 3.12.0
```

On Linux:

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3.12 python3.12-venv python3-pip

# Or using pyenv
curl https://pyenv.run | bash
pyenv install 3.12.0
```

### Git (usually pre-installed)

On macOS, Git usually comes with Xcode Command Line Tools:

```bash
xcode-select --install

# Or install via Homebrew
brew install git
```

On Linux:

```bash
# Ubuntu/Debian
sudo apt install git

# Fedora/RHEL
sudo dnf install git
```

---

## Verification Script

Use this to check what's installed:

```bash
echo "=== AI Coding Tools ==="
command -v cursor >/dev/null && echo "✓ Cursor CLI: $(cursor --version)" || echo "✗ Cursor CLI not found"
command -v claude >/dev/null && echo "✓ Claude Code: $(claude --version)" || echo "✗ Claude Code not found"

echo -e "\n=== Dependencies ==="
command -v node >/dev/null && echo "✓ Node.js: $(node --version)" || echo "✗ Node.js not found"
command -v python3 >/dev/null && echo "✓ Python: $(python3 --version)" || echo "✗ Python not found"
command -v git >/dev/null && echo "✓ Git: $(git --version)" || echo "✗ Git not found"
```

Save as `check-tools.sh` and run:

```bash
bash check-tools.sh
```

---

## API Keys Setup

### Anthropic API Key (for Claude Code)

1. Visit https://console.anthropic.com
2. Sign up or log in
3. Go to API Keys section
4. Create new key
5. Copy and save securely

Add to your environment temporarily for the current session or permanently by adding to
`~/.zshrc` or `~/.bashrc`:

```bash
# Temporary
export ANTHROPIC_API_KEY=sk-ant-...

# Permanent
echo 'export ANTHROPIC_API_KEY=sk-ant-...' >> ~/.zshrc
source ~/.zshrc
```

### OpenAI API Key (for Cursor, optional)

1. Visit https://platform.openai.com
2. Sign up or log in
3. Go to API Keys
4. Create new key
5. Copy and save securely

Add to Cursor: Open Cursor Settings with Cmd+Shift+J, go to Models, and paste your API
key.

### GitHub Token (for MCP servers)

1. Visit https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Select scopes: `repo`, `read:org`, `read:user`
4. Generate and copy

Add to your environment:

```bash
echo 'export GITHUB_TOKEN=ghp_...' >> ~/.zshrc
source ~/.zshrc
```

---

## Troubleshooting

### Cursor CLI not found after installation

```bash
# macOS: Install shell command from IDE
# Open Cursor → Cmd+Shift+P → "Shell Command: Install 'cursor' command in PATH"

# Or manually:
ln -s /Applications/Cursor.app/Contents/Resources/app/bin/cursor /usr/local/bin/cursor
```

### Claude Code command not found

```bash
# Check npm global bin location
npm bin -g

# Add to PATH if needed (add to ~/.zshrc)
export PATH="$(npm bin -g):$PATH"

# Or use npx
npx @anthropic-ai/claude-code --version
```

### Permission denied errors

```bash
# Fix npm permissions
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
source ~/.zshrc

# Reinstall Claude Code
npm install -g @anthropic-ai/claude-code
```

---

## Quick Reference

After installing everything, you should be able to run:

```bash
# Check installations
cursor --version
claude --version
node --version
python3 --version
git --version

# Run bootstrap
curl -fsSL https://raw.githubusercontent.com/TechNickAI/ai-coding-config/main/scripts/bootstrap.sh | bash
```

---

## See Also

- [coding-ecosystem.md](coding-ecosystem.md) - Which tools to use
- [implementation-plan.md](../implementation-plan.md) - Full plan
- [README.md](../README.md) - Quick start guide
