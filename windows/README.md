# Windows 11 — файлы установки и dotfiles

## Установка ОС

| Файл | Назначение |
|------|------------|
| `autounattend.xml` | Автоустановка Windows 11 |
| `scripts/install-apps.ps1` | Программы через winget + Nerd Fonts |
| `scripts/debloat.ps1` | Лёгкий debloat |

### Параметры autounattend.xml

| Параметр | Значение |
|----------|----------|
| Язык | Русский (ru-RU) |
| Регион | Казахстан (ru-KZ) |
| Раскладки | RU + EN |
| Имя ПК | **ANV15-41** |
| Пользователь | **Nurs** (без пароля) |
| Часовой пояс | Astana UTC+5 (`West Asia Standard Time`) |

`autounattend.xml` → **корень** флешки с Windows 11. Ставить только на диск **512 ГБ**.

После входа:

```powershell
Set-ExecutionPolicy RemoteSigned -Force
.\install-apps.ps1
.\debloat.ps1
```

## Список программ (install-apps.ps1)

- Браузеры: Brave, Chrome, Firefox
- Steam, 7-Zip, WinRAR
- PowerShell 7, Git, GitHub CLI, fzf, ripgrep, zoxide, starship, Neovim
- Sumatra PDF, VS Code
- Python 3.12, **Node.js LTS**, Rust (rustup)
- **OpenCode** (`SST.opencode` или `npm i -g opencode-ai`)
- VS 2022 Build Tools (MSVC) + CMake
- Nerd Fonts: FiraCode, JetBrainsMono

## Dotfiles

Папка [`dotfiles/`](dotfiles/) — Windows Terminal, PowerShell, Starship.

```powershell
cd windows\dotfiles
.\apply.ps1
```

Подробности: [`dotfiles/README.md`](dotfiles/README.md)
