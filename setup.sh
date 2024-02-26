#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

# Set root's home directory to /home/forge
usermod -d /home/forge root

# Clone custom dotfiles from the git repository
cd /home/forge
git clone https://github.com/Alpha-IT-Centre/forge-dotfiles dotfiles
chown -R forge:forge dotfiles

# Run stow to setup the symlinks from the dotfiles directory
su forge -c 'cd /home/forge/dotfiles && stow .'

# Configure sudoers to allow passwordless sudo for users in the sudo group
echo "%sudo ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_nopasswd_sudo
chmod 0440 /etc/sudoers/99_nopasswd_sudo

# Disable password login via SSH (PermtRootLogin no)
sed -i 's/^PermitRootLogin yes/#&/' /etc/ssh/sshd_config

