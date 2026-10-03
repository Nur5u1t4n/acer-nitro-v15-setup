# Git (Windows)

## Идентичность

| Параметр | Значение |
|----------|----------|
| `user.name` | **Nursultan Mukhametzhanov** |
| `user.email` | **mukhametzhanovnurs@gmail.com** |

## Основные настройки

| Раздел | Что сделано |
|--------|-------------|
| **init** | ветка по умолчанию `main` |
| **core** | editor `nvim`, `autocrlf=true`, longpaths, global gitignore |
| **pull / push** | ff-only pull, `autoSetupRemote`, followTags |
| **diff / merge** | histogram, zdiff3, colorMoved |
| **rebase** | autoStash, autoSquash |
| **rerere** | включён (запоминает разрешение конфликтов) |
| **url** | `https://github.com/` → `git@github.com:` (SSH) |
| **credential** | Git Credential Manager |

## Глобальный ignore

`~/.gitignore_global` — Thumbs.db, `.DS_Store`, `.env`, ключи, мусор IDE.

## Aliases

| Alias | Команда |
|-------|---------|
| `st` | status -sb |
| `lg` / `ll` | log graph |
| `cm "msg"` | commit -m |
| `aa` / `ap` | add all / patch |
| `sync` | pull --ff-only && push |
| `undo` | soft reset last commit |
| `pushf` | push --force-with-lease |
| `pullr` | pull --rebase |
| `wip` | add all + commit wip |

Список: `git aliases`

## Применение

```powershell
cd path\to\acer-nitro-v15-setup\windows\dotfiles\git
.\setup-git.ps1
```

Проверка:

```powershell
git config --global --list
ssh -T git@github.com
```
