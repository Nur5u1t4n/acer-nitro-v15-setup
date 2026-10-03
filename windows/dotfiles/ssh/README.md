# SSH на Windows (перед Git)

Цель: ключ **Ed25519**, агент Windows, доступ к **GitHub** без пароля по HTTPS.

## Комментарий ключа (`-C`)

Это **не** email для git-коммитов. Это подпись внутри ключа — видна в GitHub и в `ssh-keygen -l`.

Обычно пишут:

- только email: `you@mail.com`
- email + устройство: `you@mail.com (ANV15-41 Windows)` — удобно, когда ключей несколько (Windows / Linux / ноут)

У нас по умолчанию:

```text
mukhametzhanovnurs@gmail.com (ANV15-41 Windows)
```

Title на GitHub (отдельное поле при добавлении ключа) можно так же: `ANV15-41 Windows`.

## Порядок

1. Установлен **Git for Windows** (`install-apps.ps1`).
2. Запустить `setup-ssh.ps1`.
3. Публичный ключ → GitHub → Settings → SSH keys.
4. `ssh -T git@github.com`
5. Настроить Git (`user.name`, `user.email`).

## Быстрый старт

```powershell
cd path\to\acer-nitro-v15-setup\windows\dotfiles\ssh
.\setup-ssh.ps1
# email и комментарий уже заданы по умолчанию
```

## Проверка

```powershell
ssh -T git@github.com
# Hi Nur5u1t4n! You've successfully authenticated...
```

## Важно

- Приватный ключ `id_ed25519` не коммитить и не копировать в чаты.
- На Omarchy лучше отдельный ключ (другой `-C`, например `... (ANV15-41 Omarchy)`).
