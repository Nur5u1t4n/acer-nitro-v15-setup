# Общий раздел DATA — доступ из Windows и Omarchy

Раздел **DATA** (~650 ГБ, NTFS, метка `DATA`) на диске 1 ТБ.

- При переустановке Windows или Omarchy **не форматировать** этот раздел.
- Windows: обычно буква **D:**
- Linux: монтируем в `/mnt/data` (или `/data`)

---

## Содержание

- [В Windows](#в-windows)
- [В Omarchy (разово)](#в-omarchy-разово)
- [Автомонтирование (fstab)](#автомонтирование-fstab)
- [Удобные симлинки](#удобные-симлинки)
- [Права и советы](#права-и-советы)

---

## В Windows

После разметки в GParted:

1. Открыть **Управление дисками** (Win + X).
2. Найти том с меткой **DATA**.
3. Если нет буквы — ПКМ → Изменить букву диска → назначить **D:**.

Дальше можно складывать туда Documents, Downloads, игры, проекты.

---

## В Omarchy (разово)

```bash
# Посмотреть разделы и метки
lsblk -f

# Найти устройство с LABEL="DATA" (пример: /dev/nvme0n1p3)
sudo mkdir -p /mnt/data

# Предпочтительно ядровый драйвер ntfs3
sudo mount -t ntfs3 -o uid=$(id -u),gid=$(id -g),umask=022 /dev/nvme0n1p3 /mnt/data

# Если ntfs3 недоступен:
# sudo mount -t ntfs-3g -o uid=$(id -u),gid=$(id -g) /dev/nvme0n1p3 /mnt/data

ls /mnt/data
```

Замените `/dev/nvme0n1p3` на свой путь из `lsblk -f`.

---

## Автомонтирование (fstab)

1. Узнать UUID раздела DATA:

```bash
lsblk -f
# или
sudo blkid | grep -i data
```

2. Добавить строку в `/etc/fstab` (подставьте свой UUID):

```bash
sudo nano /etc/fstab
```

Пример:

```
UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX  /mnt/data  ntfs3  defaults,uid=1000,gid=1000,umask=022,nofail  0  0
```

- `uid=1000,gid=1000` — обычно ваш пользователь (проверьте: `id`).
- `nofail` — система загрузится, даже если раздел временно недоступен.

3. Проверка:

```bash
sudo mkdir -p /mnt/data
sudo mount -a
df -h /mnt/data
```

---

## Удобные симлинки

Чтобы Documents/Downloads жили на DATA:

```bash
mkdir -p /mnt/data/Documents /mnt/data/Downloads /mnt/data/Pictures /mnt/data/Projects

# Осторожно: если папки в home уже не пустые — сначала перенесите файлы
mv ~/Documents/* /mnt/data/Documents/ 2>/dev/null
mv ~/Downloads/* /mnt/data/Downloads/ 2>/dev/null

rmdir ~/Documents ~/Downloads ~/Pictures 2>/dev/null
ln -s /mnt/data/Documents ~/Documents
ln -s /mnt/data/Downloads ~/Downloads
ln -s /mnt/data/Pictures ~/Pictures
ln -s /mnt/data/Projects ~/Projects
```

---

## Права и советы

1. Перед долгим использованием DATA из Linux сделайте в Windows **чистую перезагрузку** (не гибернацию). Fast Startup должен быть выключен (`powercfg /h off`).
2. Не ставьте `hiberfile` / pagefile на DATA без необходимости.
3. Игры Steam: в Windows библиотеку можно держать на D:\; в Linux — отдельный prefix/proton на ext4/btrfs надёжнее, крупные архивы — на DATA.
4. Бэкап важных файлов с DATA всё равно нужен (облако / второй носитель).
