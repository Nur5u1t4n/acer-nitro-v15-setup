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

## Dotfiles

Папка [`dotfiles/`](dotfiles/) — конфиги Windows Terminal, PowerShell и далее VS Code / Git / nvim.

```powershell
cd windows\dotfiles
.\apply.ps1
```

Подробности: [`dotfiles/README.md`](dotfiles/README.md)
