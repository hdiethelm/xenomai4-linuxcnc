#! /bin/sh

KERNEL_GIT_VERSION=53a3aa
KERNEL_VERSION_STUFFIX=2

#Xenomai4 Kernel-----------------------------------------
sudo dpkg -i \
  deb/linux-headers-6.12.67-xenomai4-${KERNEL_GIT_VERSION}_6.12.67-${KERNEL_VERSION_STUFFIX}_amd64.deb \
  deb/linux-image-6.12.67-xenomai4-${KERNEL_GIT_VERSION}_6.12.67-${KERNEL_VERSION_STUFFIX}_amd64.deb

#Reboot, check for xenomai:
# sudo dmesg | grep -i xenomai

#Xenomai4 userspace tools-------------------------------------
sudo dpkg -i deb/libevl_56-1_amd64.deb
