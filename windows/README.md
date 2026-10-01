# Windows 11 — файлы установки

## Файлы

| Файл | Назначение |
|------|------------|
| `autounattend.xml` | Автоматическая установка Windows 11 |
| `scripts/install-apps.ps1` | Установка программ через winget + Nerd Fonts |
| `scripts/debloat.ps1` | Лёгкий debloat |

## Параметры autounattend.xml

| Параметр | Значение |
|----------|----------|
| Язык интерфейса | Русский (ru-RU) |
| Регион / форматы | Казахстан (ru-KZ) |
| Раскладки | Русская + Английская |
| Имя ПК | **ANV15-41** |
| Пользователь | **Nurs** (администратор, без пароля) |
| Часовой пояс | Central Asia Standard Time (UTC+6) |

## Как использовать autounattend.xml

1. Создайте загрузочную флешку с Windows 11 (Rufus / Media Creation Tool).
2. Скопируйте `autounattend.xml` **в корень** флешки.
3. При установке Windows файл подхватится автоматически.
4. Устанавливайте **только на диск 512 ГБ**.

## После первого входа

1. Подключите интернет.
2. Запустите PowerShell **от имени администратора**.
3. Выполните:

```powershell
Set-ExecutionPolicy RemoteSigned -Force
# путь к скриптам на флешке или скопированным локально
.\install-apps.ps1
.\debloat.ps1
```

## Список программ (install-apps.ps1)

- Браузеры: Brave, Chrome, Firefox
- Steam, 7-Zip, WinRAR
- PowerShell 7, Git, GitHub CLI, fzf, ripgrep, zoxide, starship, Neovim
- Sumatra PDF, VS Code, Python 3.12, Rust (rustup)
- Visual Studio 2022 Build Tools (MSVC + C++ workload) + CMake
- Nerd Fonts: FiraCode, JetBrainsMono

## Примечания

- Пароль пользователя **Nurs** пустой — задайте позже в Параметрах → Учётные записи.
- Visual Studio Build Tools ставится в тихом режиме; при необходимости доустановите компоненты через Visual Studio Installer.
- После установки шрифтов выберите FiraCode Nerd Font / JetBrainsMono Nerd Font в Windows Terminal и VS Code.
