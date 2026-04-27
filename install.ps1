# install.ps1 — Install/upgrade m365-mcp on Windows
# Usage: irm https://raw.githubusercontent.com/drorkremer/homebrew-m365-mcp/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$Version = "1.0.0"
$WhlUrl = "https://github.com/drorkremer/homebrew-m365-mcp/releases/download/v${Version}/m365_copilot_skill-${Version}-py3-none-any.whl"
$InstallDir = "$env:LOCALAPPDATA\m365-mcp"

Write-Host "=== m365-mcp installer (v${Version}) ===" -ForegroundColor Cyan
Write-Host ""

# Check Python
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Host "Python not found. Installing via winget..." -ForegroundColor Yellow
    winget install Python.Python.3.12 --accept-package-agreements --accept-source-agreements
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
    $python = Get-Command python -ErrorAction SilentlyContinue
    if (-not $python) {
        Write-Host "Please restart your terminal and run this script again." -ForegroundColor Red
        exit 1
    }
}
Write-Host "  Python: $(& $python.Source --version 2>&1)" -ForegroundColor Green

# Check/install Azure CLI
$az = Get-Command az -ErrorAction SilentlyContinue
if (-not $az) {
    Write-Host "Azure CLI not found. Installing via winget..." -ForegroundColor Yellow
    winget install Microsoft.AzureCLI --accept-package-agreements --accept-source-agreements
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
}
Write-Host "  Azure CLI: ready" -ForegroundColor Green

# Create venv and install wheel
Write-Host ""
Write-Host "Installing m365-mcp v${Version}..." -ForegroundColor Cyan

if (Test-Path $InstallDir) {
    # Upgrade: remove old venv
    Remove-Item -Recurse -Force $InstallDir
}

& $python.Source -m venv $InstallDir
& "$InstallDir\Scripts\python.exe" -m pip install --quiet $WhlUrl

# Verify
& "$InstallDir\Scripts\m365-mcp.exe" --version
Write-Host "  Installed to $InstallDir" -ForegroundColor Green

# Add Scripts to PATH
$binPath = "$InstallDir\Scripts"
$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$binPath*") {
    [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$binPath", "User")
    $env:PATH = "$env:PATH;$binPath"
    Write-Host "  Added to PATH" -ForegroundColor Green
}

# Configure MCP client automatically
Write-Host ""
$mcpConfigDir = Join-Path $HOME ".copilot"
$mcpConfigFile = Join-Path $mcpConfigDir "mcp-config.json"
$mcpExe = "$InstallDir\Scripts\m365-mcp.exe"
$escapedPath = $mcpExe -replace '\\', '\\'

if (Test-Path $mcpConfigFile) {
    $config = Get-Content $mcpConfigFile -Raw | ConvertFrom-Json
} else {
    New-Item -ItemType Directory -Force -Path $mcpConfigDir | Out-Null
    $config = [PSCustomObject]@{}
}

if (-not $config.mcpServers) {
    $config | Add-Member -NotePropertyName "mcpServers" -NotePropertyValue ([PSCustomObject]@{})
}

$m365Entry = [PSCustomObject]@{
    type = "stdio"
    command = $mcpExe
    args = @()
}
if ($config.mcpServers.m365) {
    $config.mcpServers.m365 = $m365Entry
} else {
    $config.mcpServers | Add-Member -NotePropertyName "m365" -NotePropertyValue $m365Entry
}

$config | ConvertTo-Json -Depth 10 | Set-Content $mcpConfigFile -Encoding UTF8
Write-Host "  Updated $mcpConfigFile" -ForegroundColor Green

Write-Host ""
Write-Host "=== Installation complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. az login                         # Login to Azure"
Write-Host "  2. m365-mcp deploy                   # Deploy Azure resources"
Write-Host "  3. Restart Copilot CLI               # Pick up the new config"
Write-Host ""
