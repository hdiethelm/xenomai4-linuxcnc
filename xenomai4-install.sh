#! /bin/sh

set -e

. ./xenomai4-vars.sh

#Xenomai4 Kernel-----------------------------------------
sudo dpkg -i \
  deb/linux-headers-${KERNEL_PACKAGE_VERSION}_amd64.deb \
  deb/linux-image-${KERNEL_PACKAGE_VERSION}_amd64.deb

#Reboot, check for xenomai:
# sudo dmesg | grep -i xenomai

#Xenomai4 userspace tools-------------------------------------
sudo dpkg -i deb/libevl_${LIBEVL_VERSION}_amd64.deb
