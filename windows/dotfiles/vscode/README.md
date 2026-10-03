# VS Code — Windows (Acer Nitro V15-41)

Конфигурация Visual Studio Code для пользователя **Nurs**.

## Структура

```
windows/dotfiles/vscode/
├── README.md                 # этот файл
├── settings.json             # пользовательские настройки
├── extensions.txt            # список расширений
└── install-extensions.ps1    # установка расширений одной командой
```

`keybindings.json` пока не кастомизирован — используются стандартные бинды VS Code (см. ниже).

---

## Установка и применение

1. VS Code уже ставится через `windows/scripts/install-apps.ps1` (winget).
2. Применить настройки + (опционально) расширения:

```powershell
cd path\to\acer-nitro-v15-setup\windows\dotfiles
.\apply.ps1
```

`apply.ps1` копирует `settings.json` в `%APPDATA%\Code\User\settings.json` и предлагает запустить установку расширений.

Только расширения:

```powershell
.\vscode\install-extensions.ps1
```

Требования:
- команда `code` в PATH (галочка при установке VS Code);
- **JetBrainsMono Nerd Font** (ставится в `install-apps.ps1`).

---

## Настройки (`settings.json`)

### Редактор

| Параметр | Значение | Зачем |
|----------|----------|--------|
| `editor.fontFamily` | JetBrainsMono Nerd Font (+ fallbacks) | Основной шрифт с лигатурами |
| `editor.fontLigatures` | `true` | `=>`, `!=`, `->` и т.д. |
| `editor.fontSize` | `14` | |
| `editor.lineHeight` | `1.55` | |
| `editor.tabSize` | `2` (по умолчанию) | Для Python/Rust переопределено на `4` |
| `editor.minimap.enabled` | `false` | Меньше шума |
| `editor.bracketPairColorization` | `true` | Цветные скобки |
| `editor.guides.bracketPairs` | `"active"` | Подсветка пары скобок |
| `editor.cursorBlinking` | `smooth` | |
| `editor.cursorSmoothCaretAnimation` | `on` | |
| `editor.wordWrap` | `on` | Перенос длинных строк по ширине окна |
| `editor.wordWrapColumn` | `120` | Используется, если режим `wordWrapColumn` / `bounded` |
| `editor.wrappingIndent` | `same` | Отступ перенесённых строк как у оригинала |
| `editor.formatOnSave` | `true` | |
| `editor.defaultFormatter` | Prettier | Для JS/TS/JSON/MD и т.д. |
| `editor.inlayHints.enabled` | `on` | Подсказки типов |

### Внешний вид

| Параметр | Значение |
|----------|----------|
| Тема | **One Dark Pro** |
| Иконки | **Material Icon Theme** |
| `workbench.startupEditor` | `none` |
| `workbench.editor.enablePreview` | `false` (вкладки открываются сразу) |
| `window.titleBarStyle` | `custom` |

### Файлы

- Auto Save при потере фокуса
- Trim trailing whitespace, final newline
- Скрыты: `.git`, `node_modules`, `__pycache__`, `.venv` / `venv`, кэши pytest/mypy/ruff, `target`

### Терминал

- Шрифт: JetBrainsMono Nerd Font
- Профиль по умолчанию: **PowerShell 7**

### Git

- `git.autofetch`: включён
- `git.confirmSync`: выключен
- Smart commit включён

### Python

| Параметр | Значение |
|----------|----------|
| Formatter | **Ruff** |
| Tab size | `4` |
| On save | format + fixAll + organizeImports |
| Language server | **Pylance** |
| Type checking | `basic` |
| Inlay hints | return types, variable types, pytest params |
| Testing | **pytest** |
| Activate venv in terminal | `true` |

### Ruff

- Линт при сохранении
- Organize imports + Fix All

### Rust

| Параметр | Значение |
|----------|----------|
| Formatter | **rust-analyzer** |
| Tab size | `4` |
| Check | **clippy** (вместо `cargo check`) |
| Features | `all` |
| buildScripts / procMacro | включены |
| Inlay hints | types, parameters, chaining, closing braces |
| Code Lens | Run + Debug |
| Auto import / auto self | включены |

### Better Comments + Todo Tree

Один набор тегов в обоих расширениях (цвета совпадают):

| Тег | Цвет | Смысл |
|-----|------|--------|
| `!` | красный, bold | важно / alert |
| `?` | синий | вопрос |
| `*` | зелёный | highlight |
| `//` | серый + strikethrough | закомментированный код |
| `TODO` | оранжевый `#FF8C00` | задача |
| `FIXME` | красный `#FF2D00` | надо починить |
| `HACK` | фиолетовый `#C678DD` | костыль |
| `BUG` | розовый `#E06C75` | баг |
| `XXX` | жёлтый `#E5C07B` | странное место |
| `NOTE` | голубой `#61AFEF` | заметка |

- **Better Comments** — подсветка в редакторе
- **Todo Tree** — дерево по workspace, счётчики, status bar, иконки
- Todo Tree исключает: `node_modules`, `.git`, `dist`, `build`, `target`, venv, `__pycache__`

Примеры:

```text
// ! важное предупреждение
// ? вопрос / сомнение
// * выделенный комментарий
// // закомментированный код
// TODO: сделать потом
// FIXME: падает на пустом вводе
// HACK: временный костыль
// BUG: race condition
// XXX: пересмотреть логику
// NOTE: контекст для ревью
```

### Прочее

- Spell checker: **en + ru**
- Telemetry: **off**
- Workspace Trust: выключен (удобнее на домашней машине)

---

## Расширения (`extensions.txt`)

### Тема и иконки

| ID | Название | Назначение |
|----|----------|------------|
| `zhuangtongfa.Material-theme` | One Dark Pro | Тёмная тема |
| `PKief.material-icon-theme` | Material Icon Theme | Иконки файлов/папок |

### Ядро

| ID | Название | Назначение |
|----|----------|------------|
| `esbenp.prettier-vscode` | Prettier | Форматтер JS/TS/JSON/CSS/MD… |
| `dbaeumer.vscode-eslint` | ESLint | Линтер JS/TS |
| `ms-python.python` | Python | Запуск, окружения, базовая поддержка |
| `ms-python.vscode-pylance` | Pylance | IntelliSense и анализ типов |
| `ms-python.debugpy` | Python Debugger | Отладка |
| `charliermarsh.ruff` | Ruff | Линтер + форматтер Python |

### Git

| ID | Название | Назначение |
|----|----------|------------|
| `eamodio.gitlens` | GitLens | Blame, история, авторы строк |
| `mhutchie.git-graph` | Git Graph | Граф коммитов и веток |

### Продуктивность

| ID | Название | Назначение |
|----|----------|------------|
| `usernamehw.errorlens` | Error Lens | Ошибки inline в строке |
| `christian-kohler.path-intellisense` | Path Intellisense | Автодополнение путей |
| `formulahendry.auto-rename-tag` | Auto Rename Tag | Парное переименование HTML/XML-тегов |
| `streetsidesoftware.code-spell-checker` | Code Spell Checker | Орфография (EN) |
| `streetsidesoftware.code-spell-checker-russian` | Russian dictionary | Словарь RU |
| `naumovs.color-highlight` | Color Highlight | Подсветка `#hex` / `rgb()` |
| `oderwat.indent-rainbow` | Indent Rainbow | Цветные уровни отступов |
| `aaron-bond.better-comments` | Better Comments | Цветные комментарии (теги выше) |
| `Gruntfuggly.todo-tree` | Todo Tree | Дерево TODO/FIXME/… по проекту |

### Языки

| ID | Название | Назначение |
|----|----------|------------|
| `rust-lang.rust-analyzer` | rust-analyzer | Полная поддержка Rust |
| `yzhang.markdown-all-in-one` | Markdown All in One | TOC, таблицы, shortcuts |
| `tamasfe.even-better-toml` | Even Better TOML | TOML + схемы (Cargo, pyproject) |
| `redhat.vscode-yaml` | YAML | YAML + JSON Schema |
| `sumneko.lua` | Lua | Lua Language Server |

### Опционально (закомментированы)

```
golang.go
ms-vscode.cpptools
bradlc.vscode-tailwindcss
Vue.volar
ms-dotnettools.csharp
```

Раскомментировать в `extensions.txt` и снова запустить `install-extensions.ps1`.

---

## Горячие клавиши (бинды)

Кастомный `keybindings.json` пока **не** добавлен. Ниже — полезные стандартные бинды VS Code (Windows).

### Общие

| Комбинация | Действие |
|------------|----------|
| `Ctrl+Shift+P` | Command Palette |
| `Ctrl+,` | Settings (UI) |
| `Ctrl+K Ctrl+S` | Keyboard Shortcuts |
| `Ctrl+B` | Показать/скрыть боковую панель |
| `Ctrl+J` | Показать/скрыть панель (терминал и т.д.) |
| `Ctrl+`` ` | Интегрированный терминал |
| `Ctrl+Shift+E` | Explorer |
| `Ctrl+Shift+G` | Source Control |
| `Ctrl+Shift+X` | Extensions |
| `Ctrl+Shift+F` | Поиск по файлам |
| `Ctrl+P` | Quick Open (файл по имени) |
| `Ctrl+Tab` | Переключение между вкладками |

### Редактор

| Комбинация | Действие |
|------------|----------|
| `Alt+↑` / `Alt+↓` | Двигать строку вверх/вниз |
| `Shift+Alt+↑` / `Shift+Alt+↓` | Дублировать строку |
| `Ctrl+Shift+K` | Удалить строку |
| `Ctrl+/` | Комментарий |
| `Ctrl+D` | Выделить следующее вхождение слова |
| `Ctrl+Shift+L` | Выделить все вхождения |
| `Alt+Click` | Мультикурсор |
| `Ctrl+Shift+[\]` | Перейти к парной скобке |
| `F2` | Rename symbol |
| `F12` | Go to Definition |
| `Alt+F12` | Peek Definition |
| `Shift+F12` | Find All References |
| `Ctrl+.` | Quick Fix / Code Actions |
| `Shift+Alt+F` | Format Document |
| `Alt+Z` | Toggle Word Wrap (вкл/выкл перенос) |

### Отладка и запуск

| Комбинация | Действие |
|------------|----------|
| `F5` | Start Debugging |
| `Ctrl+F5` | Run Without Debugging |
| `F9` | Toggle Breakpoint |
| `F10` | Step Over |
| `F11` | Step Into |
| `Shift+F11` | Step Out |

### Git (встроенные + GitLens)

| Комбинация | Действие |
|------------|----------|
| `Ctrl+Enter` | Commit (в SCM input) |
| `Ctrl+Shift+G G` | открыть Git Graph (после установки расширения; можно назначить вручную) |

### Markdown All in One (после установки)

| Комбинация | Действие |
|------------|----------|
| `Ctrl+Shift+V` | Preview |
| `Ctrl+K V` | Preview side by side |
| `Ctrl+Shift+]` / `[` | Уровень заголовка вверх/вниз (расширение) |

---

## Куда кладутся файлы на диске

| Файл | Путь Windows |
|------|----------------|
| settings.json | `%APPDATA%\Code\User\settings.json` |
| keybindings.json | `%APPDATA%\Code\User\keybindings.json` |
| Расширения | `%USERPROFILE%\.vscode\extensions` |

---

## Дальше

- [ ] Добавить `keybindings.json` с личными биндами (если понадобятся)
- [ ] Синхронизация / зеркало настроек для Omarchy (Linux)
- [ ] При необходимости: C/C++, Go, Tailwind, Vue, C# из optional-списка
