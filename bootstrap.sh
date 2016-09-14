#!/usr/bin/env bash

# Fixes 'WARNING! Your environment specifies an invalid locale.' with the
# Ubuntu Server 14.04 LTS (HVM), SSD Volume Type instance.
sudo locale-gen en_GB
sudo update-locale LANG=en_GB

# Install apache2 and symlink the rsycned /vagrant folder.
sudo apt-get update
sudo apt-get install -y apache2
if ! [ -L /var/www ]; then
  sudo rm -rf /var/www
  sudo ln -fs /vagrant /var/www
fi
