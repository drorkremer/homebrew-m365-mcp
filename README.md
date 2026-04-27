# m365-mcp — Homebrew Tap

MCP server for Microsoft 365 via Azure Logic App proxies. Provides 50+ tools for Email, Calendar, Teams, OneDrive, SharePoint, and more.

## Install

```bash
brew tap drorkremer/m365-mcp
brew install m365-mcp
```

This automatically installs Python 3.11 and Azure CLI as dependencies.

## First-time setup

```bash
# 1. Deploy Azure Logic App proxies (needs az login)
az login
m365-mcp deploy

# 2. Configure your MCP client
m365-mcp config copilot    # GitHub Copilot CLI
m365-mcp config claude     # Claude Code
m365-mcp config cursor     # Cursor
m365-mcp config vscode     # VS Code
```

## Upgrade

```bash
brew upgrade m365-mcp
m365-mcp deploy            # Updates Azure resources if needed
```

## Uninstall

```bash
m365-mcp deploy --cleanup  # Remove Azure resources
m365-mcp config copilot --remove
brew uninstall m365-mcp
```

## Alternative: Install via pipx (any OS)

```bash
pipx install m365-copilot-skill \
  --index-url "https://read:7rdCsetPal0TYstp5jhAyA7ZFw4koB6IcbRDHxa9XSfi4xjjPRqVJQQJ99CDACAAAAAAAAAAAAASAZDOmRZo@pkgs.dev.azure.com/ghostwheel/_packaging/m365-mcp/pypi/simple/" \
  --pip-args="--extra-index-url https://pypi.org/simple/"
```

## CLI Commands

| Command | Description |
|---------|-------------|
| `m365-mcp` | Start the MCP server |
| `m365-mcp --version` | Show version |
| `m365-mcp deploy [rg] [location] [prefix]` | Deploy Azure resources |
| `m365-mcp deploy --cleanup` | Remove Azure resources |
| `m365-mcp config <tool>` | Configure MCP client |
| `m365-mcp config <tool> --remove` | Remove MCP client config |
