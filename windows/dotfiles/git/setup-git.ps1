#Requires -Version 5.1
<#
.SYNOPSIS
    Глобальный git config для Nursultan Mukhametzhanov.
    Запускать после install-apps.ps1 (Git) и желательно после setup-ssh.ps1.
#>

$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "git not found. Run install-apps.ps1 first." -ForegroundColor Red
    exit 1
}

Write-Host "=== Git global config ===" -ForegroundColor Cyan

$name  = "Nursultan Mukhametzhanov"
$email = "mukhametzhanovnurs@gmail.com"

git config --global user.name $name
git config --global user.email $email
git config --global init.defaultBranch main
git config --global core.editor nvim
git config --global core.autocrlf true
git config --global core.longpaths true
git config --global pull.rebase false
git config --global fetch.prune true
git config --global push.default simple
git config --global push.autoSetupRemote true
git config --global color.ui auto
git config --global credential.helper manager

Write-Host "user.name  = $name" -ForegroundColor Green
Write-Host "user.email = $email" -ForegroundColor Green
Write-Host "`nFull config:" -ForegroundColor Cyan
git config --global --list

Write-Host "`nSSH check (optional): ssh -T git@github.com" -ForegroundColor DarkGray
