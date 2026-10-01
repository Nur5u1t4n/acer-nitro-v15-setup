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
├── starship/
│   └── starship.toml
└── ssh/
    ├── README.md
    ├── config
    └── setup-ssh.ps1
```

## Порядок на новой системе

1. `install-apps.ps1` — Git, PowerShell 7, Nerd Fonts, starship, Node…
2. **`ssh/setup-ssh.ps1`** — ключ Ed25519 + агент → добавить pub на GitHub
3. `apply.ps1` — WT, PowerShell profile, starship, PSReadLine, Terminal-Icons
4. Git: `user.name` / `user.email` (следующий шаг в репо)

```powershell
cd path\to\acer-nitro-v15-setup\windows\dotfiles

# SSH
.\ssh\setup-ssh.ps1
# https://github.com/settings/keys
ssh -T git@github.com

# Terminal + PS
.\apply.ps1
```

## SSH

См. [`ssh/README.md`](ssh/README.md).

## Windows Terminal

- Только профиль **PowerShell 7** (остальные скрыты)
- Шрифт: JetBrainsMono Nerd Font
- Схема: One Half Dark

## PowerShell

- PSReadLine, Terminal-Icons, starship, zoxide

## Starship

`starship/starship.toml` → `%USERPROFILE%\.config\starship.toml`

## Дальше

- [x] Windows Terminal
- [x] PowerShell
- [x] SSH
- [ ] Git config
- [ ] VS Code
- [ ] Neovim
