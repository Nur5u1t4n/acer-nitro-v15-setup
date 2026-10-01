# Полная пошаговая инструкция: dual-boot Windows 11 + Omarchy

**Ноутбук:** Acer Nitro V15-41 (ANV15-41)  
**Диски:** 512 ГБ → Windows | 1 ТБ → Omarchy (350 ГБ) + DATA (~650 ГБ NTFS)

Идите по шагам сверху вниз. Не пропускайте чеклисты.

---

## Содержание

- [Что подготовить заранее](#что-подготовить-заранее)
- [Этап 0. BIOS](#этап-0-bios)
- [Этап 1. Установка Windows 11](#этап-1-установка-windows-11)
- [Этап 2. Подготовка Windows](#этап-2-подготовка-windows)
- [Этап 3. Разметка диска 1 ТБ (GParted)](#этап-3-разметка-диска-1-тб-gparted)
- [Этап 4. Установка Omarchy](#этап-4-установка-omarchy)
- [Этап 5. Добавить Windows в Limine](#этап-5-добавить-windows-в-limine)
- [Этап 6. Общий раздел DATA](#этап-6-общий-раздел-data)
- [Чеклист «всё готово»](#чеклист-всё-готово)
- [Если что-то пошло не так](#если-что-то-пошло-не-так)

---

## Что подготовить заранее

### Флешки (минимум 2)

| Флешка | Содержимое | Как записать |
|--------|------------|--------------|
| USB A | Windows 11 ISO + `autounattend.xml` в **корне** | Rufus (GPT, UEFI) |
| USB B | GParted Live ISO | Rufus / balenaEtcher |
| USB C (или та же B) | Omarchy ISO | balenaEtcher / Rufus |

Файлы репозитория:
- `windows/autounattend.xml` → корень флешки Windows
- `windows/scripts/` → удобно скопировать на ту же флешку в папку `scripts\`

### Скачать

- Windows 11: [Microsoft Media Creation Tool](https://www.microsoft.com/software-download/windows11) или ISO
- [GParted Live](https://gparted.org/download.php)
- [Omarchy ISO](https://omarchy.org/) (официальный сайт)

### Важно

- Все важные данные с обоих SSD — в бэкап (установка **сотрёт** выбранные диски).
- Для ввода пароля LUKS при загрузке Omarchy нужна **проводная или 2.4 GHz** клавиатура (Bluetooth на экране расшифровки не работает).

---

## Этап 0. BIOS

Подробно: [`bios-settings.md`](bios-settings.md)

Кратко:

1. Выключить ноутбук полностью.
2. Включить → сразу **F2** (или Fn+F2).
3. **Security** → Set Supervisor Password (временно, иначе Secure Boot может быть серым).
4. F10 → Save → снова F2.
5. **Boot** → Secure Boot = **Disabled**.
6. **Boot** → Fast Boot = **Disabled**.
7. **Security** → TPM = **Disabled** (по возможности).
8. Boot Mode = **UEFI**.
9. (Опционально) Clear Supervisor Password.
10. F10 → Save & Exit.

Чеклист:
- [ ] Secure Boot OFF
- [ ] Fast Boot OFF
- [ ] TPM OFF (желательно)
- [ ] UEFI

---

## Этап 1. Установка Windows 11

1. Вставить флешку с Windows 11 (`autounattend.xml` в корне).
2. F12 → выбрать **UEFI:** ваша флешка.
3. Установка должна пройти почти без вопросов (язык RU, регион KZ, пользователь **Nurs**, ПК **ANV15-41**).
4. На экране выбора диска:
   - Выбрать **только диск 512 ГБ**
   - Диск 1 ТБ **не трогать** (или удалить с него разделы, если старые — но лучше оставить разметку на этап GParted)
5. Дождаться окончания и первого входа под **Nurs**.

Чеклист:
- [ ] Windows загружается с диска 512 ГБ
- [ ] Имя пользователя Nurs
- [ ] Есть интернет

---

## Этап 2. Подготовка Windows

Подробно: [`windows-prep.md`](windows-prep.md)

### 2.1 BitLocker / Device encryption — OFF

Параметры → Конфиденциальность и защита → Шифрование устройства → **Выкл.**  
Дождаться полной расшифровки.

Или PowerShell (админ):

```powershell
Get-BitLockerVolume
Disable-BitLocker -MountPoint "C:"
```

### 2.2 Fast Startup — OFF

```cmd
powercfg /h off
```

Или: `powercfg.cpl` → Действия кнопок питания → снять «Быстрый запуск».

### 2.3 Скрипты (по желанию, но рекомендуется)

PowerShell **от администратора**:

```powershell
Set-ExecutionPolicy RemoteSigned -Force
# путь к скриптам на флешке, например:
D:\scripts\install-apps.ps1
D:\scripts\debloat.ps1
```

Чеклист:
- [ ] BitLocker / Device encryption полностью выключен
- [ ] Fast Startup выключен
- [ ] Windows стабильно загружается

---

## Этап 3. Разметка диска 1 ТБ (GParted)

Подробно: [`partitioning.md`](partitioning.md)

1. Загрузиться с **GParted Live** (F12 → UEFI USB).
2. Выбрать диск **~931 ГБ / 1 ТБ** (не 512 ГБ!).
3. Device → Create Partition Table → **gpt** (если диск пустой/нужно с нуля).
4. Создать разделы:

| № | Размер | ФС | Флаг | Метка |
|---|--------|-----|------|-------|
| 1 | **1024 МБ** | fat32 | **esp** | EFI |
| 2 | **350 ГБ** | (не форматировать / btrfs) | — | omarchy |
| 3 | **остальное** | **ntfs** | — | **DATA** |

5. Apply (зелёная галочка).
6. Выйти, вынуть флешку.

Чеклист:
- [ ] На 1 ТБ: EFI 1 ГБ + ~350 ГБ + DATA NTFS
- [ ] Диск 512 ГБ не изменён

---

## Этап 4. Установка Omarchy

1. Записаться на флешку **Omarchy ISO**, загрузиться (F12, Secure Boot уже OFF).
2. Пройти вопросы установщика (пользователь, пароль LUKS и т.д.).
3. Выбор диска:
   - Выбрать **диск 1 ТБ**
   - Если есть опция **установки на свободное место / конкретный раздел** — выбрать раздел **350 ГБ** (не full-disk wipe всего 1 ТБ, иначе сотрётся DATA)
   - **Не** выбирать диск 512 ГБ

> Официальный dual-boot Omarchy рассчитан на «free space» на одном диске с Windows. У нас Windows на другом диске, а на 1 ТБ уже размечены EFI + Omarchy + DATA.  
> Если установщик предлагает только «весь диск» — **остановитесь** и уточните в установщике manual / partition mode. Цель: поставить систему **только** в раздел 350 ГБ, оставив DATA нетронутым.

4. Дождаться конца установки, перезагрузка.
5. При загрузке — пароль LUKS (проводная клавиатура).

Чеклист:
- [ ] Omarchy загружается
- [ ] Раздел DATA на диске всё ещё виден (например через GParted или `lsblk`)

---

## Этап 5. Добавить Windows в Limine

В терминале Omarchy:

```bash
sudo limine-scan
```

Следовать подсказкам: добавить **Windows Boot Manager**.

После перезагрузки в меню Limine должны быть:
- Omarchy
- Windows

Если Windows не появляется в Limine — можно выбрать его через **F12** (Boot Menu BIOS).

Чеклист:
- [ ] `limine-scan` выполнен
- [ ] Из Limine можно зайти и в Omarchy, и в Windows

---

## Этап 6. Общий раздел DATA

Подробно: [`data-mount.md`](data-mount.md)

Кратко в Omarchy:

```bash
# Найти раздел с меткой DATA
lsblk -f

# Пример: /dev/nvme0n1p3
sudo mkdir -p /mnt/data
sudo mount -t ntfs3 /dev/nvme0n1p3 /mnt/data   # или ntfs-3g
```

Постоянно — запись в `/etc/fstab` (см. `data-mount.md`).

В Windows раздел DATA должен появиться как диск **D:** (или другая буква) с меткой DATA.

---

## Чеклист «всё готово»

- [ ] BIOS: Secure Boot / Fast Boot OFF
- [ ] Windows на 512 ГБ, пользовательтель Nurs
- [ ] BitLocker и Fast Startup OFF
- [ ] 1 ТБ: EFI + Omarchy 350 ГБ + DATA NTFS
- [ ] Omarchy — основная система, LUKS работает
- [ ] Limine показывает Omarchy и Windows
- [ ] DATA доступен в Windows и в Linux

---

## Если что-то пошло не так

| Проблема | Что сделать |
|----------|-------------|
| Не заходит в BIOS | Полное выключение, F2 сразу при логотипе Acer; попробовать Fn+F2 |
| Secure Boot серый | Сначала Supervisor Password, Save, снова войти |
| Флешка не в Boot Menu | UEFI-режим записи Rufus; Secure Boot OFF |
| BitLocker ругается при Linux | Полностью расшифровать C: в Windows |
| Omarchy стёр DATA | Восстановление только из бэкапа; впредь не выбирать full-disk на 1 ТБ |
| Нет Windows в Limine | `sudo limine-scan` ещё раз; или F12 → Windows Boot Manager |
| NTFS не монтируется RW | В Windows: `powercfg /h off`, чистая перезагрузка; в Linux драйвер `ntfs3` или `ntfs-3g` |

Официальные ссылки:
- [Omarchy Dual Boot](https://omarchy.org/manual/dual-boot-install/)
- [Omarchy Getting Started](https://omarchy.org/manual/getting-started/)
