# install.ps1 — Install/upgrade m365-mcp on Windows
# Usage: irm https://raw.githubusercontent.com/drorkremer/homebrew-m365-mcp/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$Version = "1.0.0"
$ZipUrl = "https://github.com/drorkremer/homebrew-m365-mcp/releases/download/v${Version}/m365-mcp-windows-x64.zip"
$InstallDir = "$env:LOCALAPPDATA\m365-mcp"

Write-Host "=== m365-mcp installer (v${Version}) ===" -ForegroundColor Cyan
Write-Host ""

# Check/install Azure CLI
$az = Get-Command az -ErrorAction SilentlyContinue
if (-not $az) {
    Write-Host "Azure CLI not found. Installing via winget..." -ForegroundColor Yellow
    winget install Microsoft.AzureCLI --accept-package-agreements --accept-source-agreements
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
}
Write-Host "  Azure CLI: ready" -ForegroundColor Green

# Download and extract
Write-Host ""
# Clean old install (kill any running processes first)
if (Test-Path $InstallDir) {
    Write-Host "Stopping old m365-mcp processes..." -ForegroundColor Yellow
    Get-Process | Where-Object { $_.Path -like "*m365-mcp*" } | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
    Remove-Item -Recurse -Force $InstallDir
}

# Download and extract
Write-Host ""
Write-Host "Downloading m365-mcp v${Version}..." -ForegroundColor Cyan
$zipPath = "$env:TEMP\m365-mcp-windows-x64.zip"
Invoke-WebRequest -Uri $ZipUrl -OutFile $zipPath -UseBasicParsing

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Expand-Archive -Path $zipPath -DestinationPath $InstallDir -Force
Remove-Item $zipPath
Write-Host "  Installed to $InstallDir" -ForegroundColor Green

# Add to PATH
$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$InstallDir*") {
    [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$InstallDir", "User")
    $env:PATH = "$env:PATH;$InstallDir"
    Write-Host "  Added to PATH" -ForegroundColor Green
}

# Verify
& "$InstallDir\m365-mcp.exe" --version

# Show next steps
Write-Host ""
Write-Host "=== Installation complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. az login                         # Login to Azure"
Write-Host "  2. m365-mcp deploy                   # Deploy Azure resources"
Write-Host "  3. m365-mcp config copilot            # Register with Copilot CLI"
Write-Host "  4. Restart Copilot CLI               # Pick up the new config"
Write-Host ""
