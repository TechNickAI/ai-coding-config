# Plugin Marketplace Development

## Version Syncing

When bumping versions, update **all three** locations to stay in sync:

| File                                      | Field                | Purpose                         |
| ----------------------------------------- | -------------------- | ------------------------------- |
| `.claude-plugin/marketplace.json`         | `metadata.version`   | Marketplace listing version     |
| `.claude-plugin/marketplace.json`         | `plugins[0].version` | Individual plugin version       |
| `plugins/core/.claude-plugin/plugin.json` | `version`            | Update detection by Claude Code |

The marketplace metadata version is what users see in listings. The plugin entry version
and plugin.json version are what Claude Code uses to detect when updates are available.

**Mismatch = updates won't propagate correctly.**
