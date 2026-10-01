#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Установка программ после чистой Windows 11 (Acer Nitro V15-41)
.NOTES
    Запускать от имени администратора.
    Требуется интернет.
#>

$ErrorActionPreference = "Continue"

function Write-Step($msg) {
    Write-Host "`n=== $msg ===" -ForegroundColor Cyan
}

function Install-WingetPackage {
    param(
        [string]$Id,
        [string]$Name = $Id,
        [string]$Override = $null
    )
    Write-Host "Installing $Name ..." -ForegroundColor Yellow
    if ($Override) {
        winget install -e --id $Id --accept-package-agreements --accept-source-agreements --disable-interactivity --override $Override
    } else {
        winget install -e --id $Id --accept-package-agreements --accept-source-agreements --disable-interactivity
    }
}

# --- Проверка winget ---
Write-Step "Проверка winget"
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget не найден. Установите App Installer из Microsoft Store." -ForegroundColor Red
    exit 1
}
winget source update

# --- Браузеры ---
Write-Step "Браузеры"
Install-WingetPackage "Brave.Brave" "Brave"
Install-WingetPackage "Google.Chrome" "Chrome"
Install-WingetPackage "Mozilla.Firefox" "Firefox"

# --- Игры / общение ---
Write-Step "Steam"
Install-WingetPackage "Valve.Steam" "Steam"

# --- Архиваторы ---
Write-Step "Архиваторы"
Install-WingetPackage "7zip.7zip" "7-Zip"
Install-WingetPackage "RARLab.WinRAR" "WinRAR"

# --- Терминал и CLI ---
Write-Step "PowerShell 7 и CLI-утилиты"
Install-WingetPackage "Microsoft.PowerShell" "PowerShell 7"
Install-WingetPackage "Git.Git" "Git"
Install-WingetPackage "GitHub.cli" "GitHub CLI"
Install-WingetPackage "junegunn.fzf" "fzf"
Install-WingetPackage "BurntSushi.ripgrep.MSVC" "ripgrep"
Install-WingetPackage "ajeetdsouza.zoxide" "zoxide"
Install-WingetPackage "Starship.Starship" "Starship"
Install-WingetPackage "Neovim.Neovim" "Neovim"

# --- PDF ---
Write-Step "Sumatra PDF"
Install-WingetPackage "SumatraPDF.SumatraPDF" "Sumatra PDF"

# --- Редакторы и языки ---
Write-Step "VS Code, Python, Rust"
Install-WingetPackage "Microsoft.VisualStudioCode" "VS Code"
Install-WingetPackage "Python.Python.3.12" "Python 3.12"
Install-WingetPackage "Rustlang.Rustup" "Rustup"

# --- Visual Studio Build Tools (MSVC для Rust) + CMake ---
Write-Step "Visual Studio Build Tools (C++ / MSVC) + CMake"
# Build Tools с workload VCTools — нужно для rustc MSVC
$vsOverride = "--quiet --wait --norestart --nocache --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
Install-WingetPackage "Microsoft.VisualStudio.2022.BuildTools" "VS 2022 Build Tools" $vsOverride
Install-WingetPackage "Kitware.CMake" "CMake"

# --- Шрифты (Nerd Fonts) ---
Write-Step "Nerd Fonts (FiraCode, JetBrainsMono)"
# Устанавливаем через scoop-like или прямые пакеты, если есть в winget
# Альтернатива: скачиваем релизы с GitHub
$fontsDir = "$env:TEMP\nerd-fonts"
New-Item -ItemType Directory -Force -Path $fontsDir | Out-Null

$fontRepos = @(
    @{ Name = "FiraCode"; Url = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip" },
    @{ Name = "JetBrainsMono"; Url = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" }
)

foreach ($font in $fontRepos) {
    $zip = Join-Path $fontsDir "$($font.Name).zip"
    $extract = Join-Path $fontsDir $font.Name
    try {
        Write-Host "Downloading $($font.Name) Nerd Font..."
        Invoke-WebRequest -Uri $font.Url -OutFile $zip -UseBasicParsing
        Expand-Archive -Path $zip -DestinationPath $extract -Force
        $fonts = Get-ChildItem -Path $extract -Recurse -Include *.ttf, *.otf
        $shell = New-Object -ComObject Shell.Application
        $fontsFolder = $shell.Namespace(0x14)
        foreach ($f in $fonts) {
            $fontsFolder.CopyHere($f.FullName, 0x10)
        }
        Write-Host "$($font.Name) installed." -ForegroundColor Green
    } catch {
        Write-Host "Не удалось установить $($font.Name): $_" -ForegroundColor Red
    }
}

# --- Настройка starship / zoxide (базово) ---
Write-Step "Базовая настройка профиля PowerShell"
$profilePath = $PROFILE.CurrentUserAllHosts
if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}
$profileContent = @"

# zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# starship
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
"@
Add-Content -Path $profilePath -Value $profileContent -Encoding UTF8

Write-Step "Готово"
Write-Host @"

Установка завершена (или почти завершена).

Что проверить вручную:
1. Visual Studio Installer — убедиться, что установлен workload "Desktop development with C++".
2. Открыть новый терминал и проверить: rustc --version, cargo --version, code --version, nvim --version.
3. Шрифты FiraCode Nerd Font / JetBrainsMono Nerd Font — выбрать в Windows Terminal / VS Code.
4. Пароль пользователя Nurs можно задать позже в Параметрах.

"@ -ForegroundColor Green
