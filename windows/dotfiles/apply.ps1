#Requires -Version 5.1
<#
.SYNOPSIS
    Применяет Windows Terminal + PowerShell dotfiles из этого репозитория.
#>

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot

function Backup-File([string]$Path) {
    if (Test-Path $Path) {
        $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $bak = "$Path.bak-$stamp"
        Copy-Item -Path $Path -Destination $bak -Force
        Write-Host "Backup: $bak" -ForegroundColor DarkGray
    }
}

Write-Host "=== Apply Windows dotfiles ===" -ForegroundColor Cyan

# --- Windows Terminal ---
$wtCandidates = @(
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json",
    "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
)

$wtTarget = $wtCandidates | Where-Object { Test-Path (Split-Path $_ -Parent) } | Select-Object -First 1
$wtSource = Join-Path $Root "windows-terminal\settings.json"

if (-not (Test-Path $wtSource)) {
    Write-Host "Missing: $wtSource" -ForegroundColor Red
} elseif (-not $wtTarget) {
    Write-Host "Windows Terminal folder not found. Install WT first, open it once, then re-run." -ForegroundColor Yellow
} else {
    Backup-File $wtTarget
    Copy-Item -Path $wtSource -Destination $wtTarget -Force
    Write-Host "Windows Terminal settings -> $wtTarget" -ForegroundColor Green
}

# --- PowerShell 7 profile ---
$psSource = Join-Path $Root "powershell\Microsoft.PowerShell_profile.ps1"

# Профиль для pwsh: CurrentUserCurrentHost
if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    $pwshProfile = & pwsh -NoProfile -Command 'echo $PROFILE'
    $pwshDir = Split-Path $pwshProfile -Parent
    if (-not (Test-Path $pwshDir)) {
        New-Item -ItemType Directory -Path $pwshDir -Force | Out-Null
    }
    Backup-File $pwshProfile
    Copy-Item -Path $psSource -Destination $pwshProfile -Force
    Write-Host "PowerShell 7 profile -> $pwshProfile" -ForegroundColor Green
} else {
    # Fallback: Documents\PowerShell
    $fallback = Join-Path $env:USERPROFILE "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    $dir = Split-Path $fallback -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    Backup-File $fallback
    Copy-Item -Path $psSource -Destination $fallback -Force
    Write-Host "PowerShell profile (fallback) -> $fallback" -ForegroundColor Yellow
    Write-Host "Install PowerShell 7, then re-run if needed." -ForegroundColor Yellow
}

Write-Host "`nDone. Restart Windows Terminal." -ForegroundColor Cyan
Write-Host "Font: JetBrainsMono Nerd Font (install via install-apps.ps1 if missing)." -ForegroundColor DarkGray
