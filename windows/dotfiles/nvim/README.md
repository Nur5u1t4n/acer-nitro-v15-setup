# Neovim для Windows (LazyVim)

Конфигурация использует [LazyVim Starter](https://github.com/LazyVim/starter) как основу,
а менеджер плагинов и языковых серверов — `lazy.nvim` и Mason.

## Состав конфигурации

- `init.lua` и `lua/config/` — загрузка LazyVim и общие параметры.
- `lua/plugins/lsp.lua` — настроенные LSP-серверы.
- `lua/plugins/treesitter.lua` — дополнительные Tree-sitter парсеры.

Файлы конфигурации устанавливаются в `%LOCALAPPDATA%\nvim`. Данные LazyVim, включая плагины
и Mason-пакеты, хранятся отдельно в `%LOCALAPPDATA%\nvim-data`.

## Требования

- Windows и актуальная версия Neovim, совместимая с LazyVim.
- Git и доступ к GitHub/интернету для первой загрузки LazyVim и плагинов.
- Node.js LTS и Rust toolchain доступны через общий `windows/scripts/install-apps.ps1`.
- Для работы с конкретными проектами нужны их зависимости и toolchain, например Python
  окружение или Rust toolchain.

## Установка и применение

Из корня репозитория установите Neovim, если он ещё не установлен:

```powershell
winget install --exact --id Neovim.Neovim
```

Затем примените dotfiles:

```powershell
Set-Location windows\dotfiles
.\apply.ps1
```

`apply.ps1` применяет и другие Windows dotfiles, не только Neovim. Если каталог
`%LOCALAPPDATA%\nvim` уже существует, скрипт переименует его в `nvim.bak-<timestamp>`,
а затем скопирует конфигурацию из репозитория.

Запустите Neovim:

```powershell
nvim
```

При первом старте LazyVim загрузит плагины и настроенные через Mason серверы. Дождитесь
завершения установки и перезапустите Neovim, если он попросит об этом.

## Языки и LSP-серверы

Идентификаторы ниже — имена серверов `nvim-lspconfig`; их установкой управляет Mason.

| Язык / область | Сервер |
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

## Проверка и обслуживание

- `:LazyHealth` — диагностика LazyVim.
- `:LspInfo` — активные LSP-серверы для текущего буфера.
- `:Mason` — состояние языковых серверов и других Mason-пакетов.
- `:Lazy` — управление плагинами и их обновление.

Конфигурация хранится в репозитории. Чтобы применить её изменения, получите актуальные
файлы проекта и снова запустите `.\apply.ps1` из `windows\dotfiles`. Текущий каталог
конфигурации перед заменой сохраняется как `nvim.bak-<timestamp>`.

Для обновления плагинов используйте `:Lazy`, для проверки Mason-пакетов — `:Mason`.
Не удаляйте `%LOCALAPPDATA%\nvim-data`, если хотите сохранить скачанные плагины и LSP.

## Переустановка и восстановление

Если удалён только Neovim, установите его снова командой `winget` выше. Каталоги
конфигурации и данных обычно остаются в `%LOCALAPPDATA%`.

Если удалена конфигурация `%LOCALAPPDATA%\nvim`, примените её повторно:

```powershell
Set-Location windows\dotfiles
.\apply.ps1
nvim
```

Если нужно начать с чистой конфигурации и чистыми данными плагинов, закройте Neovim и
переименуйте каталоги, сохранив их резервные копии:

```powershell
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
if (Test-Path "$env:LOCALAPPDATA\nvim") {
    Move-Item "$env:LOCALAPPDATA\nvim" "$env:LOCALAPPDATA\nvim.bak-$stamp"
}
if (Test-Path "$env:LOCALAPPDATA\nvim-data") {
    Move-Item "$env:LOCALAPPDATA\nvim-data" "$env:LOCALAPPDATA\nvim-data.bak-$stamp"
}
```

После этого заново примените конфигурацию из репозитория и запустите `nvim`. Удаляйте
резервные каталоги только после проверки, что восстановленная установка работает и старые
данные больше не нужны.

## Типичные проблемы

- **`nvim` не найден:** перезапустите терминал после установки и проверьте
  `Get-Command nvim`.
- **Плагины не устанавливаются:** проверьте Git и интернет, затем выполните `:Lazy` и
  изучите сообщения об ошибках.
- **LSP не подключается:** проверьте `:LspInfo` и `:Mason`, наличие нужного сервера и
  корневых файлов проекта, по которым определяется его корень.
- **LSP не находит библиотеки проекта:** проверьте и установите зависимости проекта,
  выберите корректное виртуальное окружение и перезапустите LSP.

Официальные руководства: [LazyVim](https://www.lazyvim.org/),
[установка LazyVim](https://www.lazyvim.org/installation),
[Mason](https://github.com/mason-org/mason.nvim).
