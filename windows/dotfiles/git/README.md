# Git (Windows)

| Параметр | Значение |
|----------|----------|
| `user.name` | **Nursultan Mukhametzhanov** |
| `user.email` | **mukhametzhanovnurs@gmail.com** |
| default branch | `main` |
| editor | `nvim` |
| `core.autocrlf` | `true` (Windows) |

## Применение

После Git + SSH:

```powershell
cd path\to\acer-nitro-v15-setup\windows\dotfiles\git
.\setup-git.ps1
```

Или вручную:

```powershell
git config --global user.name "Nursultan Mukhametzhanov"
git config --global user.email "mukhametzhanovnurs@gmail.com"
```

Проверка:

```powershell
git config --global --list
ssh -T git@github.com
```

Клонирование по SSH:

```powershell
git clone git@github.com:Nur5u1t4n/acer-nitro-v15-setup.git
```
