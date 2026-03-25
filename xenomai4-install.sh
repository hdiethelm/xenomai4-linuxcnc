#! /bin/sh

XENOMAI_GIT_VERSION=73ad3b

#Xenomai4 Kernel-----------------------------------------
sudo dpkg -i \
  deb/linux-headers-6.12.67-xenomai4-${KERNEL_GIT_VERSION}_6.12.67-1_amd64.deb \
  deb/linux-image-6.12.67-xenomai4-${KERNEL_GIT_VERSION}_6.12.67-1_amd64.deb

#Reboot, check for xenomai:
# sudo dmesg | grep -i xenomai

#Xenomai4 userspace tools-------------------------------------
#ToDo:debian packages?
