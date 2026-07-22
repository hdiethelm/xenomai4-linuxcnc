#! /bin/sh

set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [lib|kernel|kernel_rt]"
    exit 1
fi

. ./xenomai4-vars.sh $@

if [ "$1" = "kernel" -o "$1" = "kernel_rt" ]; then
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
    mkdir -p deb
    mv *.deb *.changes *.buildinfo deb

    git -C linux-evl clean -fxd
    git -C linux-evl checkout -- .

    git add \
      deb/linux-headers-${KERNEL_PACKAGE_VERSION}_amd64.deb \
      deb/linux-image-${KERNEL_PACKAGE_VERSION}_amd64.deb \
      deb/linux-libc-evl-dev_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}_amd64.deb

    git clean -f deb/
fi

if [ "$1" = "lib" ]; then
    #Xenomai4 userspace tools-------------------------------------
    cd libevl
    #DEBEMAIL="hannes.diethelm@gmail.com" DEBFULLNAME="Hannes Diethelm" dh_make --createorig -p libevl_56
    #dh_auto_configure --buildsystem=meson -- -Duapi=$(pwd)/../linux-evl/usr/include
    cp -r ../libevl-debian/ debian
    DEBEMAIL="hannes.diethelm@gmail.com" DEBFULLNAME="Hannes Diethelm" dch -v ${LIBEVL_PACKAGE_VERSION} "Update r${LIBEVL_VERSION}"
    dpkg-buildpackage -b -uc
    cd ..

    #Cleanup-----------------------------------------------------
    mkdir -p deb
    mv *.deb *.changes *.buildinfo deb

    git -C libevl clean -fxd

    git add \
      deb/libevl_${LIBEVL_PACKAGE_VERSION}_amd64.deb \
      deb/libevl-bin_${LIBEVL_PACKAGE_VERSION}_amd64.deb \
      deb/libevl-dev_${LIBEVL_PACKAGE_VERSION}_amd64.deb \
      deb/libevl-test_${LIBEVL_PACKAGE_VERSION}_amd64.deb

    git clean -f deb/
fi
