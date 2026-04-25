#! /bin/sh

set -e

. ./xenomai4-vars.sh

#Xenomai4 Kernel-----------------------------------------
sudo dpkg -i \
  deb/linux-headers-${KERNEL_VERSION}-cip19-xenomai4-${KERNEL_GIT_VERSION}_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}_amd64.deb \
  deb/linux-image-${KERNEL_VERSION}-cip19-xenomai4-${KERNEL_GIT_VERSION}_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}_amd64.deb

#Reboot, check for xenomai:
# sudo dmesg | grep -i xenomai

#Xenomai4 userspace tools-------------------------------------
sudo dpkg -i deb/libevl_57-1_amd64.deb
