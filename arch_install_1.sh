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
