# Windows dotfiles

Конфиги программ Windows для Acer Nitro V15-41 (пользователь **Nurs**).

## Структура

```
windows/dotfiles/
├── README.md
├── windows-terminal/
│   └── settings.json      ← Windows Terminal (wt)
├── powershell/
│   └── Microsoft.PowerShell_profile.ps1
└── apply.ps1              ← копирует конфиги в нужные места
```

## Порядок

1. Установить программы (`install-apps.ps1`) — PowerShell 7, Nerd Fonts, starship, zoxide и т.д.
2. Запустить `apply.ps1` **от обычного пользователя** (не обязательно админ).
3. Полностью закрыть Windows Terminal и открыть снова.

```powershell
cd path\to\acer-nitro-v15-setup\windows\dotfiles
.\apply.ps1
```

## Windows Terminal

- Файл: `windows-terminal/settings.json`
- Цель: `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
- По умолчанию: **PowerShell 7**
- Шрифт: **JetBrainsMono Nerd Font** (запасной — Cascadia Mono)
- Тема: тёмная, схема One Half Dark

> `apply.ps1` **делает бэкап** текущего `settings.json` перед заменой.

## PowerShell 7

- Файл: `powershell/Microsoft.PowerShell_profile.ps1`
- Цель: `$PROFILE` для pwsh (обычно  
  `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`)
- Включает: starship, zoxide, удобные alias, UTF-8

## Дальше по плану dotfiles

- [x] Windows Terminal
- [x] PowerShell profile
- [ ] VS Code / settings.json
- [ ] Git config
- [ ] Neovim
