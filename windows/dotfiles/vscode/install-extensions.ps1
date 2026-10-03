#Requires -Version 5.1
<#
.SYNOPSIS
    Installs VS Code extensions listed in extensions.txt
#>

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot
$List = Join-Path $Root "extensions.txt"

if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: 'code' command not found. Is VS Code installed and in PATH?" -ForegroundColor Red
    Write-Host "Re-run install-apps.ps1 or reinstall VS Code with 'Add to PATH' checked." -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $List)) {
    Write-Host "Missing: $List" -ForegroundColor Red
    exit 1
}

Write-Host "=== Installing VS Code extensions ===" -ForegroundColor Cyan

$lines = Get-Content $List | Where-Object {
    $_ -and ($_ -notmatch '^\s*#') -and ($_ -match '\S')
}

$count = 0
foreach ($ext in $lines) {
    $ext = $ext.Trim()
    Write-Host "Installing $ext ..." -ForegroundColor Yellow
    code --install-extension $ext --force
    if ($LASTEXITCODE -eq 0) {
        $count++
    } else {
        Write-Host "  Failed: $ext" -ForegroundColor Red
    }
}

Write-Host "`nDone. Installed $count extensions." -ForegroundColor Green
Write-Host "Restart VS Code to apply theme and icons." -ForegroundColor DarkGray
