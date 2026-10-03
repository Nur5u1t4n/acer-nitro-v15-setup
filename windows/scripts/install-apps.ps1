#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Установка программ после чистой Windows 11 (Acer Nitro V15-41)

.NOTES
    Запускать от имени администратора.
    Требуется интернет.
    При ошибке одного пакета скрипт продолжает установку остальных.
#>

$ErrorActionPreference = "Stop"

# Список операций, которые завершились ошибкой.
$InstallFailures = [System.Collections.Generic.List[string]]::new()


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

    try {
        if ($Override) {
            & winget install `
                -e `
                --id $Id `
                --accept-package-agreements `
                --accept-source-agreements `
                --disable-interactivity `
                --override $Override
        }
        else {
            & winget install `
                -e `
                --id $Id `
                --accept-package-agreements `
                --accept-source-agreements `
                --disable-interactivity
        }

        if ($LASTEXITCODE -ne 0) {
            throw "winget завершился с кодом $LASTEXITCODE"
        }

        Write-Host "$Name installed successfully." -ForegroundColor Green
    }
    catch {
        $message = "$Name ($Id): $($_.Exception.Message)"

        $InstallFailures.Add($message)

        Write-Host "Не удалось установить $Name" -ForegroundColor Red
        Write-Host "Причина: $($_.Exception.Message)" -ForegroundColor DarkRed
    }
}


# ============================================================
# Проверка winget
# ============================================================

Write-Step "Проверка winget"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget не найден." -ForegroundColor Red
    Write-Host "Установите App Installer из Microsoft Store." -ForegroundColor Yellow
    exit 1
}

try {
    & winget source update

    if ($LASTEXITCODE -ne 0) {
        throw "winget source update завершился с кодом $LASTEXITCODE"
    }

    Write-Host "Источники winget обновлены." -ForegroundColor Green
}
catch {
    $message = "winget source update: $($_.Exception.Message)"

    $InstallFailures.Add($message)

    Write-Host "Не удалось обновить источники winget." -ForegroundColor Red
    Write-Host "Скрипт продолжит установку." -ForegroundColor Yellow
}


# ============================================================
# Браузеры
# ============================================================

Write-Step "Браузеры"

Install-WingetPackage "Brave.Brave" "Brave"
Install-WingetPackage "Google.Chrome" "Chrome"
Install-WingetPackage "Mozilla.Firefox" "Firefox"


# ============================================================
# Игры
# ============================================================

Write-Step "Steam"

Install-WingetPackage "Valve.Steam" "Steam"


# ============================================================
# Архиваторы
# ============================================================

Write-Step "Архиваторы"

Install-WingetPackage "7zip.7zip" "7-Zip"
Install-WingetPackage "RARLab.WinRAR" "WinRAR"


# ============================================================
# PowerShell 7 и CLI
# ============================================================

Write-Step "PowerShell 7 и CLI-утилиты"

Install-WingetPackage "Microsoft.PowerShell" "PowerShell 7"
Install-WingetPackage "Git.Git" "Git"
Install-WingetPackage "GitHub.cli" "GitHub CLI"
Install-WingetPackage "junegunn.fzf" "fzf"
Install-WingetPackage "BurntSushi.ripgrep.MSVC" "ripgrep"
Install-WingetPackage "ajeetdsouza.zoxide" "zoxide"
Install-WingetPackage "Starship.Starship" "Starship"
Install-WingetPackage "Neovim.Neovim" "Neovim"


# ============================================================
# PDF
# ============================================================

Write-Step "Sumatra PDF"

Install-WingetPackage "SumatraPDF.SumatraPDF" "Sumatra PDF"


# ============================================================
# Редакторы и языки
# ============================================================

Write-Step "VS Code, Python, Rust, Node.js"

Install-WingetPackage "Microsoft.VisualStudioCode" "VS Code"
Install-WingetPackage "Python.Python.3.12" "Python 3.12"
Install-WingetPackage "Rustlang.Rustup" "Rustup"
Install-WingetPackage "OpenJS.NodeJS.LTS" "Node.js LTS"


# ============================================================
# OpenCode
# ============================================================

Write-Step "OpenCode"

# Предпочтительно установить через winget.
# Если пакет недоступен — используем npm после установки Node.js.

try {
    $oc = & winget search --id SST.opencode -e 2>$null

    if ($LASTEXITCODE -eq 0 -and $oc -match "SST\.opencode") {
        Install-WingetPackage "SST.opencode" "OpenCode"
    }
    else {
        Write-Host "SST.opencode не найден в winget." -ForegroundColor Yellow
        Write-Host "Пробуем установить OpenCode через npm..." -ForegroundColor Yellow

        # Обновляем PATH текущей PowerShell-сессии
        # после установки Node.js.
        $env:Path = `
            [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", "User")

        if (Get-Command npm -ErrorAction SilentlyContinue) {
            try {
                & npm install -g opencode-ai

                if ($LASTEXITCODE -ne 0) {
                    throw "npm завершился с кодом $LASTEXITCODE"
                }

                Write-Host "OpenCode installed successfully via npm." -ForegroundColor Green
            }
            catch {
                $message = "OpenCode (npm): $($_.Exception.Message)"

                $InstallFailures.Add($message)

                Write-Host "Не удалось установить OpenCode через npm." -ForegroundColor Red
                Write-Host "Причина: $($_.Exception.Message)" -ForegroundColor DarkRed
            }
        }
        else {
            $message = "OpenCode: npm не найден. После перезагрузки выполните: npm install -g opencode-ai"

            $InstallFailures.Add($message)

            Write-Host "npm пока не найден." -ForegroundColor Red
            Write-Host "После перезагрузки выполните:" -ForegroundColor Yellow
            Write-Host "npm install -g opencode-ai" -ForegroundColor White
        }
    }
}
catch {
    $message = "OpenCode: ошибка проверки winget: $($_.Exception.Message)"

    $InstallFailures.Add($message)

    Write-Host "Не удалось проверить OpenCode через winget." -ForegroundColor Red
}


# ============================================================
# Visual Studio Build Tools + CMake
# ============================================================

Write-Step "Visual Studio Build Tools (C++ / MSVC) + CMake"

$vsOverride = "--quiet --wait --norestart --nocache --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"

Install-WingetPackage `
    "Microsoft.VisualStudio.2022.BuildTools" `
    "VS 2022 Build Tools" `
    $vsOverride

Install-WingetPackage "Kitware.CMake" "CMake"


# ============================================================
# Nerd Fonts
# ============================================================

Write-Step "Nerd Fonts (FiraCode, JetBrainsMono)"

$fontsDir = "$env:TEMP\nerd-fonts"

New-Item `
    -ItemType Directory `
    -Force `
    -Path $fontsDir |
    Out-Null


$fontRepos = @(
    @{
        Name = "FiraCode"
        Url  = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
    },
    @{
        Name = "JetBrainsMono"
        Url  = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    }
)


foreach ($font in $fontRepos) {

    $zip = Join-Path `
        $fontsDir `
        "$($font.Name).zip"

    $extract = Join-Path `
        $fontsDir `
        $font.Name

    try {
        Write-Host "Downloading $($font.Name) Nerd Font..." -ForegroundColor Yellow

        Invoke-WebRequest `
            -Uri $font.Url `
            -OutFile $zip `
            -UseBasicParsing

        Expand-Archive `
            -Path $zip `
            -DestinationPath $extract `
            -Force

        $fonts = Get-ChildItem `
            -Path $extract `
            -Recurse `
            -Include *.ttf, *.otf

        $shell = New-Object -ComObject Shell.Application
        $fontsFolder = $shell.Namespace(0x14)

        foreach ($f in $fonts) {
            $fontsFolder.CopyHere($f.FullName, 0x10)
        }

        Write-Host "$($font.Name) installed." -ForegroundColor Green
    }
    catch {
        $message = "Nerd Font $($font.Name): $($_.Exception.Message)"

        $InstallFailures.Add($message)

        Write-Host "Не удалось установить $($font.Name)." -ForegroundColor Red
        Write-Host "Причина: $($_.Exception.Message)" -ForegroundColor DarkRed
    }
}


# ============================================================
# Итог
# ============================================================

Write-Step "Итог"

if ($InstallFailures.Count -eq 0) {

    Write-Host "Все операции установки завершились успешно." -ForegroundColor Green
}
else {

    Write-Host "Есть ошибки. Неудачные операции:" -ForegroundColor Red

    foreach ($failure in $InstallFailures) {
        Write-Host "  - $failure" -ForegroundColor Red
    }

    Write-Host ""

    Write-Host `
        "Скрипт продолжил установку остальных компонентов, но перечисленное выше нужно проверить вручную." `
        -ForegroundColor Yellow
}


Write-Host @"

Установка завершена (или почти завершена).

Что проверить вручную:

1. Visual Studio Installer
   - workload "Desktop development with C++"

2. Новый терминал:
   node -v
   npm -v
   opencode --version
   rustc --version
   code --version

3. Шрифты:
   - JetBrainsMono Nerd Font
   - FiraCode Nerd Font

4. Dotfiles:
   windows\dotfiles\apply.ps1

5. SSH:
   windows\dotfiles\ssh\setup-ssh.ps1

6. Пароль пользователя Nurs:
   задать позже в Параметрах Windows.

OpenCode:
https://opencode.ai/

Если opencode не в PATH:
npm install -g opencode-ai

"@ -ForegroundColor Green
