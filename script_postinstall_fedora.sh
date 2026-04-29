#!/bin/bash
# Script Post-Instalación Fedora (dnf5) - AMD

# 1. Optimizar DNF5
sudo sh -c 'echo "max_parallel_downloads=20" >> /etc/dnf/dnf5.conf'

# 2. Actualizar sistema
sudo dnf upgrade --refresh -y

# 3. Repos RPM Fusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# 4. Herramientas de desarrollo
sudo dnf install gcc gcc-c++ make automake autoconf libtool patch glibc-devel kernel-headers kernel-devel git wget curl cmake -y

# 5. FFmpeg completo
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
sudo dnf install ffmpeg ffmpeg-libs libva-utils vdpauinfo --allowerasing -y

# 6. Aceleración hardware AMD
sudo dnf install mesa-va-drivers-freeworld mesa-vdpau-drivers-freeworld --allowerasing -y

# 7. Códecs GStreamer
sudo dnf install gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi gstreamer1-libav --allowerasing -y

# 8. Habilitar Flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 9. Reemplazar LibreOffice por ONLYOFFICE
sudo dnf remove libreoffice* -y
sudo dnf install -y https://download.onlyoffice.com/repo/centos/main/noarch/onlyoffice-repo.noarch.rpm
sudo dnf install -y onlyoffice-desktopeditors

# 10. Limpieza
sudo dnf autoremove -y

echo "Configuración completada! Reiniciando en 5 segundos..."
sleep 5s
sudo reboot
