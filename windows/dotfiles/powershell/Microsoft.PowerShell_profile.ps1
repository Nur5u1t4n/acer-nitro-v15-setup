# PowerShell 7 profile — Acer Nitro V15-41 / Nurs
# Target: $PROFILE  (Documents\PowerShell\Microsoft.PowerShell_profile.ps1)

# UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# --- starship ---
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# --- zoxide ---
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# --- PSReadLine (если модуль есть) ---
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# --- Alias ---
Set-Alias -Name g -Value git -ErrorAction SilentlyContinue
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Set-Alias -Name vim -Value nvim
    Set-Alias -Name vi -Value nvim
}

# Быстрый переход в репозиторий setup (если склонирован)
function setup {
    $candidates = @(
        "$env:USERPROFILE\acer-nitro-v15-setup",
        "$env:USERPROFILE\Documents\acer-nitro-v15-setup",
        "$env:USERPROFILE\source\repos\acer-nitro-v15-setup",
        "D:\Projects\acer-nitro-v15-setup"
    )
    foreach ($p in $candidates) {
        if (Test-Path $p) {
            Set-Location $p
            return
        }
    }
    Write-Host "Repo acer-nitro-v15-setup not found in usual paths." -ForegroundColor Yellow
}

# Перезагрузить профиль
function reload {
    . $PROFILE
    Write-Host "Profile reloaded." -ForegroundColor Green
}

Write-Host "PowerShell profile loaded (Nurs / ANV15-41)" -ForegroundColor DarkGray
