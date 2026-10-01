# Acer Nitro V15-41 Dual-Boot Setup

**Цель:** Чистая установка **Windows 11** + **Omarchy** (Arch Linux + Hyprland) на ноутбук Acer Nitro V 15 (ANV15-41).

Linux (Omarchy) — **основная** система.  
Windows 11 — для игр и программ, которым нужен Windows.

---

## Принятые решения

| Решение | Выбор |
|---------|-------|
| Целевой ноутбук | Acer Nitro V15-41 (ANV15-41) |
| Основная ОС | Omarchy (Arch + Hyprland) |
| Вторая ОС | Windows 11 (чистая, debloat) |
| Dual-boot | Да, на одном SSD |
| Bootloader | Limine (от Omarchy) |
| Подготовка | Скрипты и инструкции создаём заранее на текущем Lenovo IdeaPad 3 |

### Железо (Acer Nitro V15-41)
- Процессоры: AMD Ryzen 5 7535HS / Ryzen 7 7735HS (и варианты)
- Графика: Hybrid — AMD Radeon (iGPU) + NVIDIA RTX 2050/3050/4050/4060
- Экран: 15.6" IPS 144/165/180 Hz
- ОЗУ: обычно 16 GB DDR5 (расширяется)

---

## Планируемая разметка диска

| Раздел | Размер | Назначение |
|--------|--------|------------|
| EFI | 512–1024 МБ | Общий EFI (Limine + Windows Boot Manager) |
| Windows | 180–250 ГБ | Windows 11 + игры |
| Omarchy | Остальное | Основная система (минимум 150–200 ГБ, лучше больше) |

> Точные размеры уточним, когда будет известен объём SSD.

---

## Порядок установки (кратко)

1. **Windows 11** — чистая установка с `autounattend.xml`
2. Сжать раздел Windows → оставить **неразмеченное** пространство
3. Отключить BitLocker / Device encryption и Fast Startup
4. В BIOS: отключить Secure Boot и TPM
5. Установить **Omarchy** в free space (режим Free space install)
6. Добавить Windows в Limine через `limine-scan`

---

## Структура репозитория (план)

```
acer-nitro-v15-setup/
├── README.md                 ← этот файл (решения + инструкции)
├── windows/
│   ├── autounattend.xml      ← автоматическая установка Windows 11
│   ├── scripts/
│   │   ├── debloat.ps1       ← удаление bloatware
│   │   ├── install-apps.ps1  ← установка программ через winget
│   │   └── tweaks.ps1        ← твики производительности
│   └── drivers/              ← место под драйверы Acer (позже)
├── omarchy/
│   ├── notes.md              ← заметки по установке и NVIDIA hybrid
│   └── post-install.md       ← что делать после первой загрузки
├── docs/
│   ├── bios-settings.md
│   ├── partition-plan.md
│   └── troubleshooting.md
└── tools/
    └── ...                   ← полезные утилиты / ссылки
```

---

## Текущий статус

- [x] Решение по ОС: Windows 11 + Omarchy
- [x] Linux будет основной системой
- [ ] Уточнить объём SSD
- [ ] Создать `autounattend.xml`
- [ ] Создать PowerShell-скрипты (debloat + apps)
- [ ] Написать подробную инструкцию по dual-boot
- [ ] Добавить заметки по NVIDIA + AMD hybrid на Omarchy/Hyprland
- [ ] Собрать драйверы Acer (когда ноутбук будет под рукой)

---

## Полезные ссылки

- [Omarchy Manual — Dual Boot Install](https://omarchy.org/manual/dual-boot-install/)
- [Omarchy Getting Started](https://omarchy.org/manual/getting-started/)
- Acer Support (драйверы): искать по модели **ANV15-41**
- Hyprland NVIDIA: https://wiki.hypr.land/nvidia/

---

## Как пользоваться этим репозиторием

Всё важное решение и инструкции будут жить здесь.  
Когда появятся скрипты — они тоже будут в этом репо.  
Можно клонировать и держать актуальную версию под рукой:

```bash
git clone https://github.com/Nur5u1t4n/acer-nitro-v15-setup.git
```

---

*Проект создан 2026-10-01. Обновляется по мере подготовки.*
