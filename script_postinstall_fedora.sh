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

# 5. FFmpeg completo y Códecs
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
sudo dnf install ffmpeg ffmpeg-libs libavcodec-freeworld libva-utils vdpauinfo lame --allowerasing -y

# 6. Aceleración hardware y Vulkan (AMD)
sudo dnf install mesa-va-drivers-freeworld mesa-vdpau-drivers-freeworld vulkan-radeon mesa-vulkan-drivers mesa-libOpenCL --allowerasing -y

# 7. Códecs GStreamer
sudo dnf install gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi gstreamer1-libav gstreamer1-plugin-openh264 --allowerasing -y

# 8. Habilitar Flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 9. Reemplazar LibreOffice por ONLYOFFICE (Flatpak)
sudo dnf remove libreoffice* -y
sudo flatpak install -y flathub org.onlyoffice.desktopeditors

# 10. Reemplazar Firefox por Brave Browser
sudo dnf remove firefox -y
sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser -y

# 11. Visual Studio Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
sudo dnf install code -y

# 12. Utilidades y Multimedia
sudo dnf install unrar p7zip p7zip-plugins unzip btop fastfetch vlc kvantum -y
sudo flatpak install -y flathub com.github.tchx84.Flatseal com.spotify.Client

# 13. Software de Juegos
echo ""
read -p "¿Quieres instalar software de juegos? (Y/n) " install_games
if [[ "$install_games" =~ ^[Yy]$ ]] || [[ -z "$install_games" ]]; then
    echo "Instalando Steam, MangoHud, GameMode y CoreCtrl..."
    sudo dnf install steam mangohud gamemode corectrl -y
    
    echo "Configurando permisos de CoreCtrl..."
    sudo tee /etc/polkit-1/rules.d/90-corectrl.rules > /dev/null <<EOF
polkit.addRule(function(action, subject) {
    if ((action.id == "org.corectrl.helper.init" ||
         action.id == "org.corectrl.helperkiller.init") &&
        subject.local == true &&
        subject.active == true &&
        subject.isInGroup("wheel")) {
            return polkit.Result.YES;
    }
});
EOF
    
    echo "Instalando PCSX2, Ryujinx, Heroic Games Launcher y ProtonUp-Qt desde Flathub..."
    sudo flatpak install -y flathub net.pcsx2.PCSX2 org.ryujinx.Ryujinx com.heroicgameslauncher.hgl net.davidotek.pupgui2
fi
echo ""

# 14. Limpieza
sudo dnf autoremove -y

echo "Configuración completada! Reiniciando en 5 segundos..."
sleep 5s
sudo reboot
