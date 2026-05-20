#!/bin/bash

FEDORA_VERSION=$(rpm -E %fedora)

echo "Instalando RPM Fusion para Fedora $FEDORA_VERSION..."

wget https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$FEDORA_VERSION.noarch.rpm
wget https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$FEDORA_VERSION.noarch.rpm

sudo dnf install -y ./rpmfusion-free-release-$FEDORA_VERSION.noarch.rpm ./rpmfusion-nonfree-release-$FEDORA_VERSION.noarch.rpm

echo "¡RPM Fusion instalado!"

echo "Descargando RustDesk..."

wget https://github.com/rustdesk/rustdesk/releases/download/1.4.6/rustdesk-1.4.6-0.x86_64.rpm

sudo dnf install -y ./rustdesk-1.4.6-0.x86_64.rpm

echo "¡Listo! RPM Fusion y RustDesk instalados correctamente."
