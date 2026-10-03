# Windows dotfiles

Конфиги программ Windows для Acer Nitro V15-41 (пользователь **Nurs**).

## Структура

```
windows/dotfiles/
├── apply.ps1                 # WT + PowerShell + Starship + modules
├── windows-terminal/
├── powershell/
├── starship/
├── ssh/                      # ключ Ed25519 + agent
└── git/                      # user.name / user.email
```

## Порядок на новой системе

1. `install-apps.ps1` — Git, PowerShell 7, Nerd Fonts, starship, Node…
2. **`ssh/setup-ssh.ps1`** — ключ → GitHub SSH keys
3. **`git/setup-git.ps1`** — имя и email для коммитов
4. `apply.ps1` — WT, PowerShell, starship

```powershell
cd path\to\acer-nitro-v15-setup\windows\dotfiles

.\ssh\setup-ssh.ps1
# добавить pub на https://github.com/settings/keys
ssh -T git@github.com

.\git\setup-git.ps1

.\apply.ps1
```

## Git

| Поле | Значение |
|------|----------|
| Name | Nursultan Mukhametzhanov |
| Email | mukhametzhanovnurs@gmail.com |

См. [`git/README.md`](git/README.md).

## SSH

Комментарий ключа: `mukhametzhanovnurs@gmail.com (ANV15-41 Windows)`  
См. [`ssh/README.md`](ssh/README.md).

## Windows Terminal

Только **PowerShell 7**, JetBrainsMono Nerd Font, One Half Dark.

## Дальше

- [x] Windows Terminal
- [x] PowerShell
- [x] SSH
- [x] Git config
- [ ] VS Code
- [ ] Neovim
