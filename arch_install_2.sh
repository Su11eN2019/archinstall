#!/bin/bash

echo 'Добавляем пользователя'
useradd -m -g users -G wheel -s /bin/bash andrey

echo 'Устанавливаем пароль пользователя'
passwd andrey

echo 'Устанавливаем sudo'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo 'Раскомментируем репозиторий multilib'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo 'Ставим иксы и драйвера'
pacman -S xorg-server xorg-drivers xorg-xinit xorg-xkill xorg-xapps --noconfirm
pacman -S mesa lib32-mesa mesa-demos --noconfirm
pacman -S xf86-video-intel lib32-intel-dri --noconfirm

pacman -S xfce4 xfce4-goodies --noconfirm

echo 'Cтавим DM'
pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm
systemctl enable lightdm

echo 'Ставим шрифты'
pacman -S ttf-liberation ttf-dejavu font-bh-ttf font-bitstream-speedo gsfonts sdl_ttf ttf-bitstream-vera --noconfirm
pacman -S xorg-fonts-type1 noto-fonts ttf-hack ttf-ubuntu-font-family --noconfirm

echo 'Ставим сеть'
pacman -S networkmanager network-manager-applet ppp --noconfirm

echo 'Подключаем автозагрузку менеджера входа и интернет'
systemctl enable NetworkManager

echo 'Установка программ'
pacman -S bash-completion lsof dmidecode aspell-ru mc screenfetch htop git wget --noconfirm
pacman -S zip unzip unrar p7zip rsync file-roller --noconfirm
pacman -S dosfstools ntfs-3g btrfs-progs exfat-utils gptfdisk autofs fuse2 fuse3 fuseiso f2fs-tools libmtp gvfs --noconfirm
pacman -S traceroute bind-tools speedtest-cli wavemon --noconfirm
pacman -S alsa-utils alsa-plugins pulseaudio pulseaudio-alsa alsa-lib --noconfirm
pacman -S gst-plugins-base gst-plugins-good gst-plugins-ugly gst-libav --noconfirm
pacman -S firefox firefox-i18n-ru gnome-calculator libreoffice libreoffice-fresh-ru vlc qbittorrent --noconfirm

echo 'Установка AUR'
sudo pacman -Syu
mkdir -p /tmp/yay_install
cd /tmp/yay_install
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sir --needed --noconfirm --skippgpcheck
rm -rf yay_install

mkdir -p /tmp/pamac-aur_install
cd /tmp/pamac-aur_install
sudo pacman -S git
git clone https://aur.archlinux.org/pamac-aur.git
cd pamac-aur
makepkg -si --needed --noconfirm --skippgpcheck
rm -rf pamac-aur_install

echo 'Установка завершена!'
