# Acer Nitro V15-41 Dual-Boot Setup

**Цель:** Чистая установка **Windows 11** + **Omarchy** (Arch Linux + Hyprland) на ноутбук Acer Nitro V 15 (ANV15-41).

Linux (Omarchy) — **основная** система.  
Windows 11 — для игр и программ, которым нужен Windows.

**Обязательное требование:** общий раздел с данными (DATA), доступный из обеих систем и переживающий переустановку ОС.

---

## Содержание

- [Принятые решения](#принятые-решения)
- [Разметка дисков (финальная)](#разметка-дисков-финальная)
- [Важные документы в репозитории](#важные-документы-в-репозитории)
- [Порядок установки](#порядок-установки)
- [Текущий статус](#текущий-статус)
- [Полезные ссылки](#полезные-ссылки)

---

## Принятые решения

| Решение | Выбор |
|---------|-------|
| Целевой ноутбук | Acer Nitro V15-41 (ANV15-41) |
| Основная ОС | Omarchy (Arch + Hyprland) |
| Вторая ОС | Windows 11 (чистая, debloat) |
| Dual-boot | Да |
| Диски | **2 SSD**: 1 ТБ + 512 ГБ |
| Общий раздел данных | **Да** (NTFS), доступен из Windows и Linux |
| Размер Omarchy | **350 ГБ** |
| DATA | **~650 ГБ** |
| Bootloader | Limine (от Omarchy) |
| Инструмент разметки | **GParted Live** (для диска 1 ТБ) |
| Пользователь Windows | **Nurs** (без пароля) |
| Имя ПК | **ANV15-41** |
| Язык / регион | Русский / **Казахстан** (ru-KZ) |
| Часовой пояс | Astana UTC+5 |

---

## Разметка дисков (финальная)

### Диск 1 — 1 ТБ

| Раздел | Размер | ФС | Назначение |
|--------|--------|----|------------|
| EFI | **1 ГБ** | FAT32 | ESP (Limine) |
| Omarchy | **350 ГБ** | Btrfs + LUKS | Система Linux |
| DATA | **~650 ГБ** | NTFS | Общие данные |

### Диск 2 — 512 ГБ

Полностью под Windows 11 (стандартная разметка установщиком).

---

## Важные документы в репозитории

| Документ | О чём |
|----------|--------|
| **[docs/dual-boot-guide.md](docs/dual-boot-guide.md)** | **Полная пошаговая инструкция** (главный чеклист) |
| [docs/bios-settings.md](docs/bios-settings.md) | BIOS: Secure Boot, Fast Boot, TPM |
| [docs/windows-prep.md](docs/windows-prep.md) | BitLocker и Fast Startup |
| [docs/partitioning.md](docs/partitioning.md) | GParted, EFI 1 ГБ |
| [docs/partition-plan.md](docs/partition-plan.md) | Схема разделов |
| [docs/data-mount.md](docs/data-mount.md) | Монтирование DATA в Windows и Omarchy |
| [windows/](windows/) | `autounattend.xml` + install-apps + debloat |

Правила структуры и сопровождения документации: [docs/documentation-guidelines.md](docs/documentation-guidelines.md).

---

## Порядок установки

1. BIOS → [`docs/bios-settings.md`](docs/bios-settings.md)
2. Windows 11 на 512 ГБ + `autounattend.xml`
3. BitLocker / Fast Startup OFF → [`docs/windows-prep.md`](docs/windows-prep.md)
4. Скрипты `install-apps.ps1` / `debloat.ps1`
5. GParted: разметка 1 ТБ → [`docs/partitioning.md`](docs/partitioning.md)
6. Omarchy на раздел 350 ГБ
7. `sudo limine-scan`
8. DATA → [`docs/data-mount.md`](docs/data-mount.md)

**Сквозной гайд:** [`docs/dual-boot-guide.md`](docs/dual-boot-guide.md)

---

## Текущий статус

- [x] Решение по ОС и дискам
- [x] Размеры: Omarchy 350 ГБ, DATA ~650 ГБ
- [x] Инструкция по BIOS
- [x] Инструкция по BitLocker / Fast Startup
- [x] GParted и разметка
- [x] `autounattend.xml` (Nurs, RU, KZ, ANV15-41, UTC+5)
- [x] Скрипты install-apps.ps1 и debloat.ps1
- [x] **Полная пошаговая инструкция dual-boot**
- [x] **Монтирование DATA в Omarchy**
- [ ] Заметки NVIDIA + AMD hybrid (когда ноутбук под рукой)
- [ ] Драйверы Acer (когда ноутбук под рукой)

---

## Полезные ссылки

- [Omarchy Manual](https://omarchy.org/manual/)
- [Omarchy Dual Boot](https://omarchy.org/manual/dual-boot-install/)
- [GParted](https://gparted.org/)
- Hyprland NVIDIA: https://wiki.hypr.land/nvidia/

---

*Репозиторий: https://github.com/Nur5u1t4n/acer-nitro-v15-setup*
