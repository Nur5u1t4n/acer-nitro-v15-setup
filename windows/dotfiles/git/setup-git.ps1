#Requires -Version 5.1
<#
.SYNOPSIS
    Глобальный git config + ~/.gitignore_global.
    После: install-apps.ps1 (Git), желательно setup-ssh.ps1.
#>

$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "git not found. Run install-apps.ps1 first." -ForegroundColor Red
    exit 1
}

$Root = $PSScriptRoot
$homeGitignore = Join-Path $env:USERPROFILE ".gitignore_global"
$srcGitignore = Join-Path $Root "gitignore_global"

Write-Host "=== Git global config ===" -ForegroundColor Cyan

$name  = "Nursultan Mukhametzhanov"
$email = "mukhametzhanovnurs@gmail.com"

# Identity
git config --global user.name $name
git config --global user.email $email

# Init / core
git config --global init.defaultBranch main
git config --global core.editor nvim
git config --global core.pager "less -F -X"
git config --global core.autocrlf true
git config --global core.eol crlf
git config --global core.longpaths true
git config --global core.ignorecase true
git config --global core.untrackedCache true

# Global gitignore
if (Test-Path $srcGitignore) {
    Copy-Item $srcGitignore $homeGitignore -Force
    git config --global core.excludesfile $homeGitignore
    Write-Host "excludesfile -> $homeGitignore" -ForegroundColor Green
}

# Pull / fetch / push
git config --global pull.rebase false
git config --global pull.ff only
git config --global fetch.prune true
git config --global fetch.prunetags true
git config --global push.default simple
git config --global push.autoSetupRemote true
git config --global push.followTags true

# Rebase / merge / diff
git config --global rebase.autoStash true
git config --global rebase.autoSquash true
git config --global rebase.updateRefs true
git config --global merge.ff false
git config --global merge.conflictstyle zdiff3
git config --global diff.algorithm histogram
git config --global diff.colorMoved plain
git config --global diff.renames true
git config --global diff.mnemonicPrefix true

# Status / branch / tag
git config --global status.showUntrackedFiles all
git config --global status.submoduleSummary true
git config --global branch.sort -committerdate
git config --global branch.autosetupmerge always
git config --global tag.sort version:refname

# Rerere / help
git config --global rerere.enabled true
git config --global rerere.autoupdate true
git config --global help.autocorrect 20

# Color
git config --global color.ui auto

# Credential + GitHub SSH preference
git config --global credential.helper manager
git config --global url."git@github.com:".insteadOf "https://github.com/"

# Aliases
git config --global alias.st "status -sb"
git config --global alias.s "status"
git config --global alias.co "checkout"
git config --global alias.sw "switch"
git config --global alias.br "branch"
git config --global alias.ci "commit"
git config --global alias.cm "commit -m"
git config --global alias.ca "commit --amend --no-edit"
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD --stat"
git config --global alias.lg "log --oneline --decorate --graph -20"
git config --global alias.ll "log --oneline --decorate --graph --all -30"
git config --global alias.ld "log --pretty=format:\"%C(yellow)%h%Creset %C(cyan)%ad%Creset %C(green)%an%Creset %s\" --date=short -15"
git config --global alias.df "diff"
git config --global alias.dfc "diff --cached"
git config --global alias.ds "diff --stat"
git config --global alias.aa "add --all"
git config --global alias.ap "add -p"
git config --global alias.pullr "pull --rebase"
git config --global alias.pullff "pull --ff-only"
git config --global alias.pushf "push --force-with-lease"
git config --global alias.sync "!git pull --ff-only && git push"
git config --global alias.undo "reset --soft HEAD~1"
git config --global alias.wip "!git add -A && git commit -m \"wip\""
git config --global alias.root "rev-parse --show-toplevel"
git config --global alias.aliases "config --get-regexp ^alias\\."

Write-Host "user.name  = $name" -ForegroundColor Green
Write-Host "user.email = $email" -ForegroundColor Green
Write-Host "`n--- git config --global --list ---" -ForegroundColor Cyan
git config --global --list

Write-Host "`nПолезные alias: st, lg, ll, cm, aa, ap, sync, undo, pushf, pullr" -ForegroundColor DarkGray
Write-Host "SSH: ssh -T git@github.com" -ForegroundColor DarkGray
