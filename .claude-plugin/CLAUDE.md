# Plugin Marketplace Development

## Version Syncing

When bumping versions, update **both** files to stay in sync:

| File                                      | Field              | Purpose                         |
| ----------------------------------------- | ------------------ | ------------------------------- |
| `.claude-plugin/marketplace.json`         | `metadata.version` | Marketplace listing version     |
| `plugins/core/.claude-plugin/plugin.json` | `version`          | Update detection by Claude Code |

The marketplace version is what users see in listings. The plugin.json version is what
Claude Code uses to detect when updates are available.

**Mismatch = updates won't propagate correctly.**
