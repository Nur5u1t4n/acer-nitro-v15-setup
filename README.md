# Acer Nitro V15-41 Dual-Boot Setup

**Цель:** Чистая установка **Windows 11** + **Omarchy** (Arch Linux + Hyprland) на ноутбук Acer Nitro V 15 (ANV15-41).

Linux (Omarchy) — **основная** система.  
Windows 11 — для игр и программ, которым нужен Windows.

**Обязательное требование:** общий раздел с данными (DATA), доступный из обеих систем и переживающий переустановку ОС.

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

- **[docs/bios-settings.md](docs/bios-settings.md)** — как войти в BIOS на Acer Nitro, отключить Secure Boot, Fast Boot, TPM
- **[docs/partitioning.md](docs/partitioning.md)** — какой программой размечать диск, почему GParted, как создать EFI 1 ГБ
- **[docs/partition-plan.md](docs/partition-plan.md)** — общая схема разделов

---

## Порядок установки (кратко)

1. Настроить BIOS (Secure Boot OFF, Fast Boot OFF, TPM по возможности OFF) → см. `docs/bios-settings.md`
2. Установить Windows 11 на диск **512 ГБ**
3. В Windows отключить BitLocker / Device encryption и Fast Startup
4. Загрузиться с **GParted Live** и разметить диск **1 ТБ** (EFI 1 ГБ + Omarchy 350 ГБ + DATA) → см. `docs/partitioning.md`
5. Установить Omarchy на раздел 350 ГБ
6. Добавить Windows в Limine (`sudo limine-scan`)
7. Настроить автомонтирование DATA в Linux

---

## Текущий статус

- [x] Решение по ОС и дискам
- [x] Размеры: Omarchy 350 ГБ, DATA ~650 ГБ
- [x] Инструкция по BIOS (Secure Boot и др.)
- [x] Рекомендация по инструменту разметки (GParted)
- [ ] Создать `autounattend.xml`
- [ ] PowerShell-скрипты (debloat + apps)
- [ ] Полная пошаговая инструкция dual-boot
- [ ] Монтирование DATA в Omarchy

---

## Полезные ссылки

- [Omarchy Manual](https://omarchy.org/manual/)
- [GParted](https://gparted.org/)
- Hyprland NVIDIA: https://wiki.hypr.land/nvidia/

---

*Репозиторий: https://github.com/Nur5u1t4n/acer-nitro-v15-setup*
