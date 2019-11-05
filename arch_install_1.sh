#!/bin/bash

echo 'Настройка консоли и часов'
loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true

#cfdisk

echo 'Форматирование дисков'
mkfs.ext4  /dev/sda2 -L root
mkswap /dev/sda1 -L swap

echo 'Монтирование дисков'
mount /dev/sda2 /mnt
swapon /dev/sda1

echo 'Выбор зеркал для загрузки'
echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo 'Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl

echo 'Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt

echo 'Прописываем имя компьютера'
echo "andrey-pc" > /etc/hostname
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

echo 'Добавляем русскую локаль системы'
echo -e "en_US.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8" >> /etc/locale.gen

echo 'Обновим текущую локаль системы'
locale-gen

echo 'Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo 'Вписываем KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo 'Создадим загрузочный RAM диск'
mkinitcpio -p linux

echo 'Пароль root'
passwd

echo 'Устанавливаем загрузчик'
pacman -Syy
pacman -S grub os-prober mtools fuse --noconfirm
grub-install /dev/sda

echo 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Ставим программу для Wi-fi'
pacman -S dialog wpa_supplicant --noconfirm

echo 'Выход'
exit

umount /mnt

reboot
