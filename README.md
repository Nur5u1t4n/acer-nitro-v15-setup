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
| Dual-boot | Да |
| Диски | **2 SSD**: 1 ТБ + 512 ГБ |
| Размещение ОС | **Omarchy на 1 ТБ**, **Windows на 512 ГБ** |
| Bootloader | Limine (от Omarchy) — основной |
| Подготовка | Скрипты и инструкции создаём заранее на текущем Lenovo IdeaPad 3 |

### Железо (Acer Nitro V15-41)
- Процессоры: AMD Ryzen 5 7535HS / Ryzen 7 7735HS (и варианты)
- Графика: Hybrid — AMD Radeon (iGPU) + NVIDIA RTX 2050/3050/4050/4060
- Экран: 15.6" IPS 144/165/180 Hz
- ОЗУ: обычно 16 GB DDR5 (расширяется)
- Диски: 1 × 1 ТБ + 1 × 512 ГБ SSD

---

## Разметка дисков (принято)

### Диск 1 — 1 ТБ (основной, под Omarchy)

| Раздел | Размер | Файловая система | Назначение |
|--------|--------|------------------|------------|
| EFI | 1 ГБ | FAT32 | ESP (Limine + копия Windows Boot Manager) |
| Omarchy (root) | ~ остальное (~930+ ГБ) | Btrfs + LUKS | Основная система + home + snapshots |

Omarchy по умолчанию ставит LUKS-шифрование и Btrfs с субволюмами.

### Диск 2 — 512 ГБ (под Windows 11)

| Раздел | Размер | Файловая система | Назначение |
|--------|--------|------------------|------------|
| EFI | 100–500 МБ | FAT32 | Windows EFI (создаётся установщиком Windows) |
| MSR | ~16 МБ | — | Microsoft Reserved |
| Windows (C:) | ~ остальное | NTFS | Windows 11 + игры + программы |
| Recovery | ~1 ГБ | NTFS | Восстановление Windows |

> Windows будет установлен **первым** на 512 ГБ диск.  
> Omarchy — **вторым** на 1 ТБ диск (полный диск).

### Почему именно так?

- Linux — основная система → даём ей большой и быстрый диск (1 ТБ).
- Windows нужен в основном для игр → 512 ГБ более чем достаточно.
- Разные физические диски = меньше проблем с загрузчиками, шифрованием и обновлениями.
- Можно полностью стереть/переустановить одну ОС, не трогая другую.
- Limine будет основным загрузчиком и сможет запускать Windows через chainload.

---

## Порядок установки (обновлённый)

1. **BIOS**: отключить Secure Boot и TPM, режим UEFI.
2. Установить **Windows 11** на диск 512 ГБ (чистая установка + `autounattend.xml`).
3. В Windows: отключить BitLocker / Device encryption и Fast Startup.
4. Установить **Omarchy** на диск 1 ТБ (full-disk install).
5. После установки Omarchy выполнить `sudo limine-scan` и добавить Windows в меню Limine.
6. Сделать Limine загрузчиком по умолчанию (если нужно).

---

## Структура репозитория

```
acer-nitro-v15-setup/
├── README.md                 ← этот файл (решения + инструкции)
├── windows/
│   ├── autounattend.xml      ← автоматическая установка Windows 11
│   ├── scripts/
│   │   ├── debloat.ps1
│   │   ├── install-apps.ps1
│   │   └── tweaks.ps1
│   └── drivers/              ← драйверы Acer (позже)
├── omarchy/
│   ├── notes.md
│   └── post-install.md
├── docs/
│   ├── bios-settings.md
│   ├── partition-plan.md     ← подробная разметка
│   └── troubleshooting.md
└── tools/
```

---

## Текущий статус

- [x] Решение по ОС: Windows 11 + Omarchy
- [x] Linux будет основной системой
- [x] Уточнены диски: 1 ТБ + 512 ГБ
- [x] Принята схема: Omarchy на 1 ТБ, Windows на 512 ГБ
- [ ] Создать `autounattend.xml`
- [ ] Создать PowerShell-скрипты (debloat + apps)
- [ ] Написать подробную инструкцию по dual-boot (два диска)
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

```bash
git clone https://github.com/Nur5u1t4n/acer-nitro-v15-setup.git
```

---

*Проект создан 2026-10-01. Последнее обновление: разметка дисков (1 ТБ Omarchy + 512 ГБ Windows).*
