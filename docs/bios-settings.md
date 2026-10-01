# Настройки BIOS / UEFI для Acer Nitro V15-41

**Обязательно сделать перед установкой Omarchy и dual-boot.**

---

## Содержание

- [Как войти в BIOS](#как-войти-в-bios)
- [Что нужно отключить / изменить](#что-нужно-отключить--изменить)
  - [1. Secure Boot → Disabled](#1-secure-boot--disabled)
  - [2. Fast Boot → Disabled](#2-fast-boot--disabled)
  - [3. TPM](#3-tpm-trusted-platform-module)
  - [4. Boot Mode](#4-boot-mode)
  - [5. SATA Mode / VMD](#5-sata-mode--vmd-если-есть)
- [Рекомендуемый порядок действий в BIOS](#рекомендуемый-порядок-действий-в-bios)
- [Важно](#важно)
- [Ссылки](#ссылки)

---

## Как войти в BIOS

1. Полностью выключите ноутбук (не перезагрузка).
2. Включите питание.
3. Как только появится логотип Acer — **многократно нажимайте F2**.
4. Если не получается — попробуйте **Fn + F2**.

Одноразовое Boot Menu (выбор флешки): **F12** (иногда нужно сначала включить F12 Boot Menu в BIOS).

---

## Что нужно отключить / изменить

### 1. Secure Boot → Disabled

На Acer часто опция **серая** (недоступна), пока не поставите Supervisor Password.

**Как сделать:**

1. Зайдите во вкладку **Security**.
2. Выберите **Set Supervisor Password** → задайте временный пароль (например `1234`) → подтвердите.
3. Сохраните (F10) и выйдите, затем снова войдите в BIOS (F2).
4. Теперь во вкладке **Boot** (или Security) опция **Secure Boot** должна стать активной.
5. Поставьте **Secure Boot = Disabled**.
6. После всех настроек можно снова зайти и **удалить** Supervisor Password (Clear Supervisor Password), если не хотите его оставлять. **Обязательно запомните/запишите пароль**, пока он стоит!

### 2. Fast Boot → Disabled

Находится во вкладке **Boot**.

Отключение Fast Boot помогает корректно видеть USB и Linux-загрузчики.

### 3. TPM (Trusted Platform Module)

- Для простой установки Omarchy **рекомендуется отключить TPM** (или хотя бы знать, что он есть).
- Если планируете BitLocker в Windows — лучше оставить TPM включённым, но тогда при dual-boot возможны запросы recovery key.
- Наш план: Windows без BitLocker → можно отключить TPM для спокойствия.

Ищите во вкладке **Security** → TPM / Security Chip / Trusted Computing → **Disabled**.

### 4. Boot Mode

Должен быть **UEFI** (не Legacy / CSM).

CSM / Legacy лучше держать **выключенным**.

### 5. SATA Mode / VMD (если есть)

Оставьте **AHCI** (не RAID), если опция доступна. На многих Nitro по умолчанию уже AHCI.

---

## Рекомендуемый порядок действий в BIOS

1. F2 → войти.
2. Security → Set Supervisor Password (временно).
3. F10 → Save & Exit → снова F2.
4. Boot → Secure Boot = **Disabled**.
5. Boot → Fast Boot = **Disabled**.
6. Security → TPM = **Disabled** (по возможности).
7. Убедиться, что Boot Mode = UEFI.
8. (Опционально) Clear Supervisor Password.
9. F10 → Save & Exit.

---

## Важно

- Без отключённого Secure Boot установщик Omarchy / Arch часто **не загрузится** или Limine не будет работать.
- После установки Linux Secure Boot можно попробовать включить обратно (сложнее, нужно подписывать загрузчик) — для начала оставляем выключенным.

---

## Ссылки

- Официальная инструкция Acer по Secure Boot: https://community.acer.com/kb/articles/88-enable-or-disable-secure-boot-on-an-acer-notebook
