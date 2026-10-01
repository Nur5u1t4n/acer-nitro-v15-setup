# PowerShell 7 profile — Acer Nitro V15-41 / Nurs
# Target: $PROFILE  (Documents\PowerShell\Microsoft.PowerShell_profile.ps1)

# UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# --- Terminal-Icons (иконки файлов в ls/dir) ---
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons
}

# --- PSReadLine ---
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine

    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -BellStyle None

    # Цвета (подходят к One Half Dark / тёмному WT)
    Set-PSReadLineOption -Colors @{
        Command            = "#61AFEF"
        Parameter          = "#E5C07B"
        String             = "#98C379"
        Operator           = "#C678DD"
        Variable           = "#E06C75"
        Number             = "#D19A66"
        Type               = "#56B6C2"
        Comment            = "#5C6370"
        Keyword            = "#C678DD"
        Error              = "#E06C75"
        Selection          = "#474E5D"
        InlinePrediction   = "#5C6370"
        ListPrediction     = "#61AFEF"
        ListPredictionSelected = "#282C34"
    }

    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
}

# --- starship (конфиг: ~/.config/starship.toml) ---
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# --- zoxide ---
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# --- Alias ---
Set-Alias -Name g -Value git -ErrorAction SilentlyContinue
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Set-Alias -Name vim -Value nvim
    Set-Alias -Name vi -Value nvim
}

# Быстрый переход в репозиторий setup
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

function reload {
    . $PROFILE
    Write-Host "Profile reloaded." -ForegroundColor Green
}

Write-Host "PowerShell profile loaded (Nurs / ANV15-41)" -ForegroundColor DarkGray
