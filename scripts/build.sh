#! /bin/sh

set -e

. scripts/config.sh

if [ "$BUILD_TYPE" = "kernel" -o "$BUILD_TYPE" = "kernel_rt" ]; then
    #Xenomai4 Kernel-----------------------------------------
    #git clone https://gitlab.com/xenomai/xenomai4/linux-evl.git
    #git -C linux-evl v6.12.y-cip-evl-rebase

    #git clone https://gitlab.com/xenomai/xenomai4/libevl.git
    #git -C libevl checkout r57

    cd linux-evl

    patch -p1 < ../linux-evl-deb.patch

    if [ $KERNEL_VERSION != $(make kernelversion) ]; then
        echo Error: kernel version missmatch, $KERNEL_VERSION != $(make kernelversion)
        exit 1
    fi

    if [ $KERNEL_VERSION_CIP != $(cat localversion-cip) ]; then
        echo Error: cip version missmatch, $KERNEL_VERSION_CIP != $(cat localversion-cip)
        exit 1
    fi

    cp ../$KERNEL_CONFIG .config
    make oldconfig
    echo evl check result--------
    evl check -f .config || true
    echo ------------------------
    make -j$(nproc) bindeb-pkg LOCALVERSION=$KERNEL_LOCAL_VERSION KDEB_PKGVERSION=$(make kernelversion)-${KERNEL_VERSION_STUFFIX}

    cd ..

    #Cleanup-----------------------------------------------------
    rm -rf ${PACKAGE_DIR}
    mkdir -p ${PACKAGE_DIR}
    mv *.deb *.changes *.buildinfo ${PACKAGE_DIR}

    git -C linux-evl clean -fxd
    git -C linux-evl checkout -- .
fi

if [ "$BUILD_TYPE" = "lib" ]; then
    #Xenomai4 userspace tools-------------------------------------
    cd libevl
    #DEBEMAIL="hannes.diethelm@gmail.com" DEBFULLNAME="Hannes Diethelm" dh_make --createorig -p libevl_56
    #dh_auto_configure --buildsystem=meson -- -Duapi=$(pwd)/../linux-evl/usr/include
    cp -r ../libevl-debian/ debian
    DEBEMAIL="hannes.diethelm@gmail.com" DEBFULLNAME="Hannes Diethelm" dch -v ${LIBEVL_PACKAGE_VERSION} "Update ${LIBEVL_VERSION}"
    dpkg-buildpackage -b -uc
    cd ..

    #Cleanup-----------------------------------------------------
    rm -rf ${PACKAGE_DIR}
    mkdir -p ${PACKAGE_DIR}
    mv *.deb *.changes *.buildinfo ${PACKAGE_DIR}

    git -C libevl clean -fxd
fi

if [ "$BUILD_TYPE" = "linuxcnc" ]; then
    #LinuxCNC-------------------------------------
    cd linuxcnc-src
    DEBEMAIL="hannes.diethelm@gmail.com" DEBFULLNAME="Hannes Diethelm" dch -v ${LINUXCNC_VERSION} "Custom LinuxCNC with Xenomai4 support and other backports"
    ./debian/configure
    dpkg-buildpackage -b -uc
    cd ..

    #Cleanup-----------------------------------------------------
    rm -rf ${PACKAGE_DIR}
    mkdir -p ${PACKAGE_DIR}
    mv *.deb *.changes *.buildinfo ${PACKAGE_DIR}

    git -C linuxcnc-src clean -fxd
    git -C linuxcnc-src checkout -- .
fi
