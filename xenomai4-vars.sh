#! /bin/sh

if [ -z "$BUILD_TYPE" ]; then
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 [lib|kernel|kernel_rt]"
        exit 1
    fi
    BUILD_TYPE=$1
fi

LIBEVL_VERSION=0.59
LIBEVL_VERSION_STUFFIX=3
LIBEVL_PACKAGE_VERSION=${LIBEVL_VERSION}-${LIBEVL_VERSION_STUFFIX}

if [ $BUILD_TYPE = "kernel_rt" ]; then
	KERNEL_CONFIG=kconfig-base-config-6.12.94+deb13-rt-amd64.txt
	KERNEL_LOCAL_VERSION=-xenomai4-${LIBEVL_VERSION}-rt
else
	KERNEL_CONFIG=kconfig-base-config-6.12.94+deb13-amd64.txt
	KERNEL_LOCAL_VERSION=-xenomai4-${LIBEVL_VERSION}
fi

KERNEL_VERSION=6.12.90
KERNEL_VERSION_CIP=-cip24
KERNEL_VERSION_STUFFIX=4
KERNEL_PACKAGE_VERSION=${KERNEL_VERSION}${KERNEL_VERSION_CIP}${KERNEL_LOCAL_VERSION}_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}

LINUXCNC_PKG_VERSION=2.9.10-3
LINUXCNC_VERSION=2:${LINUXCNC_PKG_VERSION}

if [ "$BUILD_TYPE" = "kernel" ]; then
    GH_RELEASE_TAG=kernel-${KERNEL_PACKAGE_VERSION}
    PACKAGE_DIR=pkg-kernel
fi

if [ "$BUILD_TYPE" = "kernel_rt" ]; then
    GH_RELEASE_TAG=kernel-${KERNEL_PACKAGE_VERSION}
    PACKAGE_DIR=pkg-kernel-rt
fi

if [ "$BUILD_TYPE" = "lib" ]; then
    GH_RELEASE_TAG=libevl-${LIBEVL_PACKAGE_VERSION}
    PACKAGE_DIR=pkg-libevl
fi

if [ "$BUILD_TYPE" = "linuxcnc" ]; then
    GH_RELEASE_TAG=linuxcnc-${LINUXCNC_PKG_VERSION}
    PACKAGE_DIR=pkg-linuxcnc
fi
