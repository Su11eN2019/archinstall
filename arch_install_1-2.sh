#!/bin/bash
echo "andrey-pc" > /etc/hostname
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
echo -e "en_US.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
mkinitcpio -p linux
passwd
pacman -Syy
pacman -S grub os-prober mtools fuse --noconfirm
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S dialog wpa_supplicant --noconfirm
exit
umount /mnt
reboot
