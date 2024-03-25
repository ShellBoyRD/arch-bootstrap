#!/bin/bash

# Define the Arch Linux bootstrap URL
ARCH_BOOTSTRAP_URL="http://mirror.rackspace.com/archlinux/iso/latest/archlinux-bootstrap-x86_64.tar.gz"

# Define where the Arch Linux environment will be setup
ARCH_CHROOT_DIR="/arch-chroot"

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Install necessary packages for the script to work on Debian/Ubuntu, Fedora, and Arch Linux based systems
if command -v apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y wget tar gzip arch-install-scripts
elif command -v dnf >/dev/null 2>&1; then
    dnf install -y wget tar gzip arch-install-scripts
elif command -v pacman >/dev/null 2>&1; then
    pacman -Sy --needed wget tar gzip arch-install-scripts
else
    echo "Unsupported package manager. Please install wget, tar, gzip, and arch-install-scripts manually."
    exit 1
fi

# Prepare the directory for Arch Linux bootstrap
mkdir -p "$ARCH_CHROOT_DIR"
cd "$ARCH_CHROOT_DIR"

# Download and extract the Arch Linux bootstrap image
echo "Downloading Arch Linux bootstrap..."
wget -O arch-bootstrap.tar.gz "$ARCH_BOOTSTRAP_URL"
tar xzf arch-bootstrap.tar.gz --strip-components=1
rm arch-bootstrap.tar.gz

# Prepare the chroot environment
mkdir -p root.x86_64/{dev,proc,sys,run}
mount --bind /dev root.x86_64/dev
mount --bind /proc root.x86_64/proc
mount --bind /sys root.x86_64/sys
mount --bind /run root.x86_64/run

# Copy the resolv.conf to use the host's DNS settings
cp /etc/resolv.conf root.x86_64/etc/

# Enter the chroot environment
echo "Entering the Arch Linux chroot environment. When you are done, type 'exit' to leave chroot."
arch-chroot root.x86_64

# Cleanup
echo "Cleaning up..."
umount -l root.x86_64/{dev,proc,sys,run}
echo "Arch Linux chroot environment setup is complete. You can now use 'arch-chroot $ARCH_CHROOT_DIR/root.x86_64' to enter it again."

