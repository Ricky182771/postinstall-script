#!/bin/bash

FEDORA_VERSION=$(rpm -E %fedora)


wget https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$FEDORA_VERSION.noarch.rpm
wget https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$FEDORA_VERSION.noarch.rpm

sudo dnf install -y ./rpmfusion-free-release-$FEDORA_VERSION.noarch.rpm ./rpmfusion-nonfree-release-$FEDORA_VERSION.noarch.rpm
