# install.ps1 — Install m365-mcp on Windows
# Usage: irm https://raw.githubusercontent.com/drorkremer/homebrew-m365-mcp/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$Version = "1.0.0"
$WhlUrl = "https://github.com/drorkremer/homebrew-m365-mcp/releases/download/v${Version}/m365_copilot_skill-${Version}-py3-none-any.whl"

Write-Host "=== m365-mcp installer (v${Version}) ===" -ForegroundColor Cyan
Write-Host ""

# Check Python
$python = Get-Command python3 -ErrorAction SilentlyContinue
if (-not $python) { $python = Get-Command python -ErrorAction SilentlyContinue }
if (-not $python) {
    Write-Host "Python not found. Installing via winget..." -ForegroundColor Yellow
    winget install Python.Python.3.11 --accept-package-agreements --accept-source-agreements
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
    $python = Get-Command python -ErrorAction SilentlyContinue
    if (-not $python) {
        Write-Host "Please restart your terminal and run this script again." -ForegroundColor Red
        exit 1
    }
}
Write-Host "  Python: $(& $python.Source --version 2>&1)" -ForegroundColor Green

# Check Azure CLI
$az = Get-Command az -ErrorAction SilentlyContinue
if (-not $az) {
    Write-Host "Azure CLI not found. Installing via winget..." -ForegroundColor Yellow
    winget install Microsoft.AzureCLI --accept-package-agreements --accept-source-agreements
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
}
Write-Host "  Azure CLI: ready" -ForegroundColor Green

# Create venv and install
$venvPath = "$env:LOCALAPPDATA\m365-mcp"
Write-Host ""
Write-Host "Installing m365-mcp to $venvPath..." -ForegroundColor Cyan

& $python.Source -m venv $venvPath
& "$venvPath\Scripts\pip" install --quiet $WhlUrl

# Add to PATH
$binPath = "$venvPath\Scripts"
$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$binPath*") {
    [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$binPath", "User")
    $env:PATH = "$env:PATH;$binPath"
    Write-Host "  Added $binPath to PATH" -ForegroundColor Green
}

# Verify
& "$binPath\m365-mcp" --version

Write-Host ""
Write-Host "=== Installation complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. az login                      # Login to Azure"
Write-Host "  2. m365-mcp deploy               # Deploy Azure resources"
Write-Host "  3. m365-mcp config copilot        # Configure MCP client"
Write-Host ""
