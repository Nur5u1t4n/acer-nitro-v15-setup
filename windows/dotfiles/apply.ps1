#Requires -Version 5.1
<#
.SYNOPSIS
    Применяет Windows Terminal + PowerShell + Starship + VS Code dotfiles.
    При необходимости ставит PSReadLine и Terminal-Icons из PSGallery.
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

function Install-PsModuleIfMissing([string]$Name) {
    if (-not (Get-Module -ListAvailable -Name $Name)) {
        Write-Host "Installing module $Name ..." -ForegroundColor Yellow
        Install-Module -Name $Name -Scope CurrentUser -Force -AllowClobber -AcceptLicense -ErrorAction Stop
    } else {
        Write-Host "Module $Name already installed." -ForegroundColor DarkGray
    }
}

Write-Host "=== Apply Windows dotfiles ===" -ForegroundColor Cyan

# --- Modules ---
Write-Host "`n--- PowerShell modules ---" -ForegroundColor Cyan
try {
    Install-PsModuleIfMissing "PSReadLine"
    Install-PsModuleIfMissing "Terminal-Icons"
} catch {
    Write-Host "Module install failed: $_. Run as user with internet; may need: Set-PSRepository PSGallery -InstallationPolicy Trusted" -ForegroundColor Red
}

# --- Windows Terminal ---
Write-Host "`n--- Windows Terminal ---" -ForegroundColor Cyan
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
    Write-Host "Windows Terminal folder not found. Open WT once, then re-run." -ForegroundColor Yellow
} else {
    Backup-File $wtTarget
    Copy-Item -Path $wtSource -Destination $wtTarget -Force
    Write-Host "WT settings -> $wtTarget" -ForegroundColor Green
}

# --- Starship ---
Write-Host "`n--- Starship ---" -ForegroundColor Cyan
$starSource = Join-Path $Root "starship\starship.toml"
$starDir = Join-Path $env:USERPROFILE ".config"
$starTarget = Join-Path $starDir "starship.toml"
if (Test-Path $starSource) {
    if (-not (Test-Path $starDir)) {
        New-Item -ItemType Directory -Path $starDir -Force | Out-Null
    }
    Backup-File $starTarget
    Copy-Item -Path $starSource -Destination $starTarget -Force
    Write-Host "starship.toml -> $starTarget" -ForegroundColor Green
}

# --- PowerShell 7 profile ---
Write-Host "`n--- PowerShell profile ---" -ForegroundColor Cyan
$psSource = Join-Path $Root "powershell\Microsoft.PowerShell_profile.ps1"

if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    $pwshProfile = & pwsh -NoProfile -Command 'echo $PROFILE'
    $pwshDir = Split-Path $pwshProfile -Parent
    if (-not (Test-Path $pwshDir)) {
        New-Item -ItemType Directory -Path $pwshDir -Force | Out-Null
    }
    Backup-File $pwshProfile
    Copy-Item -Path $psSource -Destination $pwshProfile -Force
    Write-Host "Profile -> $pwshProfile" -ForegroundColor Green
} else {
    $fallback = Join-Path $env:USERPROFILE "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    $dir = Split-Path $fallback -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    Backup-File $fallback
    Copy-Item -Path $psSource -Destination $fallback -Force
    Write-Host "Profile (fallback) -> $fallback" -ForegroundColor Yellow
}

# --- VS Code ---
Write-Host "`n--- VS Code ---" -ForegroundColor Cyan
$vscodeSource = Join-Path $Root "vscode\settings.json"
$vscodeDir = Join-Path $env:APPDATA "Code\User"
$vscodeTarget = Join-Path $vscodeDir "settings.json"

if (-not (Test-Path $vscodeSource)) {
    Write-Host "Missing: $vscodeSource" -ForegroundColor Red
} else {
    if (-not (Test-Path $vscodeDir)) {
        New-Item -ItemType Directory -Path $vscodeDir -Force | Out-Null
        Write-Host "Created: $vscodeDir" -ForegroundColor DarkGray
    }
    Backup-File $vscodeTarget
    Copy-Item -Path $vscodeSource -Destination $vscodeTarget -Force
    Write-Host "settings.json -> $vscodeTarget" -ForegroundColor Green

    # Optional: install extensions
    $extScript = Join-Path $Root "vscode\install-extensions.ps1"
    if (Test-Path $extScript) {
        Write-Host "Run extensions installer? (y/N)" -ForegroundColor Yellow
        $answer = Read-Host
        if ($answer -eq 'y' -or $answer -eq 'Y') {
            & $extScript
        } else {
            Write-Host "Skipped extensions. Run later: .\vscode\install-extensions.ps1" -ForegroundColor DarkGray
        }
    }
}

Write-Host "`nDone. Restart Windows Terminal and VS Code." -ForegroundColor Cyan
Write-Host "Need: JetBrainsMono Nerd Font + starship + VS Code (install-apps.ps1)." -ForegroundColor DarkGray
