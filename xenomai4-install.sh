#! /bin/sh

set -e

. ./xenomai4-vars.sh $@

if [ "$1" = "kernel" -o "$1" = "kernel_rt" ]; then
    #Xenomai4 Kernel-----------------------------------------
    sudo dpkg -i \
      deb/linux-headers-${KERNEL_PACKAGE_VERSION}_amd64.deb \
      deb/linux-image-${KERNEL_PACKAGE_VERSION}_amd64.deb

    #Reboot, check for xenomai:
    # sudo dmesg | grep -i xenomai
fi

if [ "$1" = "lib" ]; then
    #Xenomai4 userspace tools-------------------------------------
    sudo dpkg -i \
      deb/libevl_${LIBEVL_PACKAGE_VERSION}_amd64.deb \
      deb/libevl-test_${LIBEVL_PACKAGE_VERSION}_amd64.deb
fi
