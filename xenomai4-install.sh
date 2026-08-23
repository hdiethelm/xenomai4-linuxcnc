#! /bin/sh

set -e

. ./xenomai4-vars.sh

if [ "$BUILD_TYPE" = "kernel" -o "$BUILD_TYPE" = "kernel_rt" ]; then
    #Xenomai4 Kernel-----------------------------------------
    sudo dpkg -i \
      package/linux-headers-${KERNEL_PACKAGE_VERSION}_amd64.deb \
      package/linux-image-${KERNEL_PACKAGE_VERSION}_amd64.deb \
      package/linux-libc-evl-dev_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}_amd64.deb

    #Reboot, check for xenomai:
    # sudo dmesg | grep -i xenomai
fi

if [ "$BUILD_TYPE" = "lib" ]; then
    #Xenomai4 userspace tools-------------------------------------
    sudo dpkg -i \
      package/libevl_${LIBEVL_PACKAGE_VERSION}_amd64.deb \
      package/libevl-bin_${LIBEVL_PACKAGE_VERSION}_amd64.deb \
      package/libevl-dev_${LIBEVL_PACKAGE_VERSION}_amd64.deb
fi
