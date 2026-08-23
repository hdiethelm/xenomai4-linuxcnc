#! /bin/sh

set -e

. scripts/config.sh

if [ "$BUILD_TYPE" = "kernel" -o "$BUILD_TYPE" = "kernel_rt" ]; then
    #Xenomai4 Kernel-----------------------------------------
    sudo apt install --reinstall \
      ./pkg-kernel/linux-headers-${KERNEL_PACKAGE_VERSION}_amd64.deb \
      ./pkg-kernel/linux-image-${KERNEL_PACKAGE_VERSION}_amd64.deb \
      ./pkg-kernel/linux-libc-evl-dev_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}_amd64.deb

    #Reboot, check for xenomai:
    # sudo dmesg | grep -i xenomai
fi

if [ "$BUILD_TYPE" = "lib" ]; then
    #Xenomai4 userspace tools-------------------------------------
    sudo apt install --reinstall \
      ./pkg-libevl/libevl_${LIBEVL_PACKAGE_VERSION}_amd64.deb \
      ./pkg-libevl/libevl-bin_${LIBEVL_PACKAGE_VERSION}_amd64.deb \
      ./pkg-libevl/libevl-dev_${LIBEVL_PACKAGE_VERSION}_amd64.deb
fi

if [ "$BUILD_TYPE" = "linuxcnc" ]; then
    #LinuxCNC-------------------------------------
    sudo apt install --reinstall \
      ./pkg-linuxcnc/linuxcnc-uspace_${LINUXCNC_PKG_VERSION}_amd64.deb \
      ./pkg-linuxcnc/linuxcnc-doc-en_${LINUXCNC_PKG_VERSION}_all.deb
fi
