#! /bin/sh

set -e

. ./xenomai4-vars.sh

#Xenomai4 Kernel-----------------------------------------
#git clone https://gitlab.com/xenomai/xenomai4/linux-evl.git
#git -C linux-evl v6.12.y-cip-evl-rebase

#git clone https://gitlab.com/xenomai/xenomai4/libevl.git
#git -C libevl checkout r57

cd linux-evl

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
mv *.deb deb
rm *.changes *.buildinfo

git -C linux-evl clean -fxd
git -C libevl clean -fxd

git add \
  deb/libevl_${LIBEVL_PACKAGE_VERSION}_amd64.deb \
  deb/libevl-test_${LIBEVL_PACKAGE_VERSION}_amd64.deb

git add \
  deb/linux-headers-${KERNEL_PACKAGE_VERSION}_amd64.deb \
  deb/linux-image-${KERNEL_PACKAGE_VERSION}_amd64.deb

git clean -f deb/
