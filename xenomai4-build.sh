#! /bin/sh

set -e

. ./xenomai4-vars.sh

#Xenomai4 Kernel-----------------------------------------
#git clone https://gitlab.com/xenomai/xenomai4/linux-evl.git
#git -C linux-evl v6.12.y-cip-evl-rebase

#git clone https://gitlab.com/xenomai/xenomai4/libevl.git
#git -C libevl checkout r57

cd linux-evl
cp ../kconfig-base-config-6.12.74+deb13+1-rt-amd64.txt .config #Base: debian trixie config-6.12.74+deb13+1-rt-amd64
make oldconfig
echo evl check result--------
evl check -f .config || true
echo ------------------------
make -j16 deb-pkg LOCALVERSION=-xenomai4-$KERNEL_GIT_VERSION KDEB_PKGVERSION=$(make kernelversion)-${KERNEL_VERSION_STUFFIX}
cd ..
  
#Xenomai4 userspace tools-------------------------------------
cd libevl
#DEBEMAIL="hannes.diethelm@gmail.com" DEBFULLNAME="Hannes Diethelm" dh_make --createorig -p libevl_56
#dh_auto_configure --buildsystem=meson -- -Duapi=$(pwd)/../linux-evl/usr/include
#DEBEMAIL="hannes.diethelm@gmail.com" DEBFULLNAME="Hannes Diethelm" dch -v 57 "Update r57"
cp -r ../libevl-debian/ debian
dpkg-buildpackage -b -uc
cd ..

#Cleanup-----------------------------------------------------
mkdir -p deb
mv *.deb deb
rm *.changes *.buildinfo *.orig.tar.gz *.debian.tar.gz *.dsc

git -C linux-evl clean -fxd
git -C libevl clean -fxd

git add \
  deb/libevl_57-1_amd64.deb

git add \
  deb/linux-headers-${KERNEL_VERSION}-cip19-xenomai4-${KERNEL_GIT_VERSION}_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}_amd64.deb \
  deb/linux-image-${KERNEL_VERSION}-cip19-xenomai4-${KERNEL_GIT_VERSION}_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}_amd64.deb

git clean -f deb/
