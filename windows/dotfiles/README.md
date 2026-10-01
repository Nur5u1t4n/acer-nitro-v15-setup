# Windows dotfiles

Конфиги программ Windows для Acer Nitro V15-41 (пользователь **Nurs**).

## Структура

```
windows/dotfiles/
├── README.md
├── apply.ps1
├── windows-terminal/
│   └── settings.json
├── powershell/
│   └── Microsoft.PowerShell_profile.ps1
└── starship/
    └── starship.toml
```

## Порядок

1. `install-apps.ps1` — PowerShell 7, Nerd Fonts, starship, zoxide…
2. `apply.ps1` — ставит **PSReadLine**, **Terminal-Icons**, копирует конфиги.
3. Полностью закрыть Windows Terminal и открыть снова.

```powershell
cd path\to\acer-nitro-v15-setup\windows\dotfiles
.\apply.ps1
```

Если PSGallery ругается:

```powershell
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module PSReadLine, Terminal-Icons -Scope CurrentUser -Force
```

## Что настроено

### Windows Terminal
- Профиль по умолчанию: PowerShell 7
- Шрифт: JetBrainsMono Nerd Font
- Схема: One Half Dark

### PowerShell
- **PSReadLine** — история, ListView-подсказки, Tab-меню, цвета под One Half Dark
- **Terminal-Icons** — иконки в `ls` / `Get-ChildItem`
- **starship** + **zoxide**

### Starship
Файл: `starship/starship.toml` → `%USERPROFILE%\.config\starship.toml`

Стиль: компактный одно–двухстрочный промпт (directory, git, node/python/rust, время команды).  
Не «тяжёлая» тема — нормально смотрится с Nerd Font и One Half Dark.

Другие пресеты можно поставить так:

```powershell
starship preset nerd-font-symbols -o $env:USERPROFILE\.config\starship.toml
starship preset pure-preset -o $env:USERPROFILE\.config\starship.toml
starship preset tokyo-night -o $env:USERPROFILE\.config\starship.toml
```

Потом снова скопировать наш toml из репо, если передумаешь.

## Дальше

- [x] Windows Terminal
- [x] PowerShell (PSReadLine, Terminal-Icons, starship)
- [ ] VS Code
- [ ] Git
- [ ] Neovim
