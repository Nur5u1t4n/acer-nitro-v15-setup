# Windows dotfiles

Конфиги программ Windows для Acer Nitro V15-41 (пользователь **Nurs**).

## Структура

```
windows/dotfiles/
├── apply.ps1                 # WT + PowerShell + Starship + VS Code + Neovim
├── windows-terminal/
├── powershell/
├── starship/
├── vscode/                   # settings.json + extensions
├── nvim/                     # LazyVim + LSP servers
├── ssh/                      # ключ Ed25519 + agent
└── git/                      # user.name / user.email
```

## Порядок на новой системе

1. `install-apps.ps1` — Git, PowerShell 7, Nerd Fonts, starship, VS Code, Neovim, Node…
2. **`ssh/setup-ssh.ps1`** — ключ → GitHub SSH keys
3. **`git/setup-git.ps1`** — имя и email для коммитов
4. `apply.ps1` — WT, PowerShell, starship, VS Code и Neovim settings
5. Первый запуск `nvim` — LazyVim загрузит плагины и установит LSP-серверы

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

## VS Code

- `vscode/settings.json` — основные настройки (One Dark Pro, JetBrainsMono, Prettier, и т.д.)
- `vscode/extensions.txt` — список расширений
- `vscode/install-extensions.ps1` — установка расширений

`apply.ps1` копирует `settings.json` в `%APPDATA%\Code\User\` и предлагает установить расширения.

Можно запустить отдельно:

```powershell
.\vscode\install-extensions.ps1
```

## Neovim (LazyVim)

Конфигурация в `nvim/` устанавливается в `%LOCALAPPDATA%\nvim` командой `apply.ps1`.
Перед заменой существующей конфигурации скрипт сохраняет её рядом как `nvim.bak-<timestamp>`.

Используется базовая конфигурация LazyVim и Mason для управления LSP:

| Язык / область | LSP-сервер |
|---|---|
| Python | Pyright (`pyright`) |
| Rust | rust-analyzer (`rust_analyzer`) |
| HTML | `html` |
| CSS | `cssls` |
| JavaScript / TypeScript | vtsls (`vtsls`) |
| Tailwind CSS | `tailwindcss` |
| TOML | Taplo (`taplo`) |
| YAML | `yamlls` |
| Markdown | Marksman (`marksman`) |
| Lua | `lua_ls` |

Требуются Neovim, Git и доступ к интернету при первом запуске. После `apply.ps1` откройте
PowerShell и выполните:

```powershell
nvim
```

Первый запуск загрузит плагины; Mason установит настроенные LSP-серверы. Для диагностики
в Neovim выполните `:LazyHealth`, а для проверки активного сервера — `:LspInfo`.

## Дальше

- [x] Windows Terminal
- [x] PowerShell
- [x] SSH
- [x] Git config
- [x] VS Code
- [x] Neovim (LazyVim + LSP)
