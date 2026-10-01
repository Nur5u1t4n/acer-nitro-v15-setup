#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Лёгкий debloat Windows 11 для Acer Nitro V15-41
.DESCRIPTION
    Удаляет типичный bloatware, отключает часть телеметрии.
    Не ломает Store и важные компоненты.
#>

$ErrorActionPreference = "SilentlyContinue"

Write-Host "=== Debloat Windows 11 ===" -ForegroundColor Cyan

# Приложения, которые обычно не нужны
$apps = @(
    "Microsoft.BingNews",
    "Microsoft.BingWeather",
    "Microsoft.BingSearch",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.People",
    "Microsoft.PowerAutomateDesktop",
    "Microsoft.Todos",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "MicrosoftCorporationII.QuickAssist",
    "MicrosoftTeams",
    "Clipchamp.Clipchamp",
    "Microsoft.OutlookForWindows",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.SkypeApp"
)

foreach ($app in $apps) {
    Write-Host "Removing $app ..." -ForegroundColor Yellow
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $app } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

# Отключить часть телеметрии
Write-Host "Tweaking telemetry..." -ForegroundColor Yellow
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f | Out-Null
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f | Out-Null

# Отключить рекламу в Пуске
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f | Out-Null

Write-Host "`nDebloat завершён. Перезагрузка рекомендуется." -ForegroundColor Green
