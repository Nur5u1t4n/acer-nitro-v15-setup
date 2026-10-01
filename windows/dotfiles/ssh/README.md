# SSH на Windows (перед Git)

Цель: ключ **Ed25519**, агент Windows, доступ к **GitHub** без пароля по HTTPS.

## Порядок

1. Установлен **Git for Windows** (`install-apps.ps1`) — в нём есть `ssh`, `ssh-keygen`.
2. Запустить `setup-ssh.ps1` (обычный пользователь, не обязательно админ).
3. Публичный ключ добавить в GitHub.
4. Проверить: `ssh -T git@github.com`
5. Дальше настраивать Git (`user.name`, `user.email`, `core.sshCommand` при необходимости).

## Быстрый старт

```powershell
cd path\to\acer-nitro-v15-setup\windows\dotfiles\ssh
.\setup-ssh.ps1
# при необходимости:
.\setup-ssh.ps1 -Email "you@example.com" -Comment "Nurs ANV15-41"
```

Скрипт:

- создаёт `%USERPROFILE%\.ssh`, если нет;
- генерирует `id_ed25519` / `id_ed25519.pub` (если ключа ещё нет);
- пишет `config` (шаблон GitHub);
- включает **OpenSSH Authentication Agent** и добавляет ключ;
- копирует публичный ключ в буфер обмена (если можно).

## Добавить ключ на GitHub

1. Открыть: https://github.com/settings/keys
2. **New SSH key**
3. Title: например `ANV15-41 Windows`
4. Key: содержимое `id_ed25519.pub` (уже в буфере после скрипта)
5. Save

Или через CLI (если `gh` залогинен):

```powershell
gh auth login
gh ssh-key add $env:USERPROFILE\.ssh\id_ed25519.pub --title "ANV15-41 Windows"
```

## Проверка

```powershell
ssh -T git@github.com
# Hi Nur5u1t4n! You've successfully authenticated...
```

Клонирование:

```powershell
git clone git@github.com:Nur5u1t4n/acer-nitro-v15-setup.git
```

## Файлы

| Файл | Назначение |
|------|------------|
| `setup-ssh.ps1` | Генерация ключа + агент + config |
| `config` | Шаблон `~/.ssh/config` (Host github.com) |

## Важно

- **Приватный** ключ `id_ed25519` никуда не копировать и не коммитить.
- Пароль (passphrase) на ключ — по желанию; со passphrase удобнее с агентом.
- На **Omarchy/Linux** ключи будут отдельные (или скопируешь свой pub на второй аккаунт GitHub — лучше отдельный ключ на каждую ОС).
