# m365-mcp

MCP server for Microsoft 365 via Azure Logic App proxies. Provides 50+ tools for Email, Calendar, Teams, OneDrive, SharePoint, and more.

## Install

**macOS / Linux (Homebrew):**
```bash
brew tap drorkremer/m365-mcp
brew install m365-mcp
```

**Windows (PowerShell — one-liner):**
```powershell
irm https://raw.githubusercontent.com/drorkremer/homebrew-m365-mcp/main/install.ps1 | iex
```

## First-time setup

```bash
# 1. Login to Azure
az login

# 2. Deploy Azure Logic App proxies
m365-mcp deploy

# 3. Configure your MCP client
m365-mcp config copilot    # GitHub Copilot CLI
m365-mcp config claude     # Claude Code
m365-mcp config cursor     # Cursor
m365-mcp config vscode     # VS Code
```

## Upgrade

```bash
brew upgrade m365-mcp      # macOS/Linux
m365-mcp deploy            # Updates Azure resources if needed
```

## Uninstall

```bash
m365-mcp deploy --cleanup          # Remove Azure resources
m365-mcp config copilot --remove   # Remove MCP client config
brew uninstall m365-mcp            # macOS/Linux
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
