#Requires -Version 5.1
<#
.SYNOPSIS
    Создаёт SSH-ключ Ed25519, config и подключает Windows OpenSSH Agent.
.PARAMETER Email
    Комментарий к ключу (обычно email).
.PARAMETER Comment
    Доп. метка в комментарии ключа.
.PARAMETER Force
    Пересоздать ключ, если уже есть (опасно).
#>
param(
    [string]$Email = "",
    [string]$Comment = "Nurs ANV15-41 Windows",
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$sshDir = Join-Path $env:USERPROFILE ".ssh"
$keyPath = Join-Path $sshDir "id_ed25519"
$pubPath = "$keyPath.pub"
$configPath = Join-Path $sshDir "config"
$configSource = Join-Path $PSScriptRoot "config"

function Find-SshKeygen {
    $cmds = @(
        "ssh-keygen",
        "$env:ProgramFiles\Git\usr\bin\ssh-keygen.exe",
        "$env:WINDIR\System32\OpenSSH\ssh-keygen.exe"
    )
    foreach ($c in $cmds) {
        if ($c -eq "ssh-keygen") {
            $g = Get-Command ssh-keygen -ErrorAction SilentlyContinue
            if ($g) { return $g.Source }
        } elseif (Test-Path $c) {
            return $c
        }
    }
    return $null
}

Write-Host "=== SSH setup (Ed25519 + agent) ===" -ForegroundColor Cyan

if (-not (Test-Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
    Write-Host "Created $sshDir"
}

$sshKeygen = Find-SshKeygen
if (-not $sshKeygen) {
    Write-Host "ssh-keygen not found. Install Git for Windows first (install-apps.ps1)." -ForegroundColor Red
    exit 1
}
Write-Host "Using: $sshKeygen" -ForegroundColor DarkGray

# --- Key ---
if ((Test-Path $keyPath) -and -not $Force) {
    Write-Host "Key already exists: $keyPath (use -Force to recreate)" -ForegroundColor Yellow
} else {
    if ((Test-Path $keyPath) -and $Force) {
        Write-Host "Removing old key (-Force)..." -ForegroundColor Yellow
        Remove-Item $keyPath, $pubPath -Force -ErrorAction SilentlyContinue
    }
    $keyComment = if ($Email) { "$Comment $Email" } else { $Comment }
    Write-Host "Generating Ed25519 key..."
    Write-Host "You can set a passphrase (recommended) or leave empty." -ForegroundColor DarkGray
    & $sshKeygen -t ed25519 -f $keyPath -C $keyComment
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ssh-keygen failed." -ForegroundColor Red
        exit 1
    }
    Write-Host "Created $keyPath" -ForegroundColor Green
}

# --- config ---
if (Test-Path $configSource) {
    if (-not (Test-Path $configPath)) {
        Copy-Item $configSource $configPath
        Write-Host "Wrote $configPath" -ForegroundColor Green
    } else {
        Write-Host "config already exists, not overwriting: $configPath" -ForegroundColor DarkGray
        Write-Host "Merge Host github.com from dotfiles/ssh/config manually if needed." -ForegroundColor DarkGray
    }
}

# --- Agent (Windows OpenSSH) ---
Write-Host "`nConfiguring ssh-agent..." -ForegroundColor Cyan
try {
    $agent = Get-Service ssh-agent -ErrorAction Stop
    if ($agent.StartType -eq "Disabled") {
        Write-Host "Enabling ssh-agent service (may need Admin)..." -ForegroundColor Yellow
        Set-Service -Name ssh-agent -StartupType Manual -ErrorAction Stop
    }
    if ($agent.Status -ne "Running") {
        Start-Service ssh-agent -ErrorAction Stop
    }
    Write-Host "ssh-agent is running." -ForegroundColor Green

    $sshAdd = "$env:WINDIR\System32\OpenSSH\ssh-add.exe"
    if (-not (Test-Path $sshAdd)) {
        $sshAdd = "ssh-add"
    }
    # Убрать старые и добавить текущий
    & $sshAdd $keyPath 2>$null
    Write-Host "Key added to agent (if passphrase prompted — enter it)." -ForegroundColor Green
} catch {
    Write-Host "Could not configure ssh-agent automatically: $_" -ForegroundColor Yellow
    Write-Host "Run PowerShell as Administrator once:" -ForegroundColor Yellow
    Write-Host "  Get-Service ssh-agent | Set-Service -StartupType Manual" -ForegroundColor White
    Write-Host "  Start-Service ssh-agent" -ForegroundColor White
    Write-Host "  ssh-add `$env:USERPROFILE\.ssh\id_ed25519" -ForegroundColor White
}

# --- Public key ---
if (Test-Path $pubPath) {
    $pub = Get-Content $pubPath -Raw
    Write-Host "`n=== Public key (add to GitHub) ===" -ForegroundColor Cyan
    Write-Host $pub
    try {
        Set-Clipboard -Value $pub.Trim()
        Write-Host "(copied to clipboard)" -ForegroundColor Green
    } catch {
        Write-Host "Copy manually from: $pubPath" -ForegroundColor DarkGray
    }
    Write-Host "GitHub: https://github.com/settings/keys" -ForegroundColor Cyan
}

Write-Host "`nNext:" -ForegroundColor Cyan
Write-Host "  1. Add public key on GitHub"
Write-Host "  2. ssh -T git@github.com"
Write-Host "  3. Configure git user.name / user.email"
