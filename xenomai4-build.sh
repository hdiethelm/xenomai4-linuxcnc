#! /bin/sh

source xenomai4-vars.sh

#Xenomai4 Kernel-----------------------------------------
#git clone https://gitlab.com/xenomai/xenomai4/linux-evl.git
#git -C linux-evl checkout v6.12.67-evl2-rebase

#git clone https://gitlab.com/xenomai/xenomai4/libevl.git
#git -C libevl checkout r56

cd linux-evl
cp ../kconfig-base-config-6.12.74+deb13+1-rt-amd64.txt .config #Base: debian trixie config-6.12.74+deb13+1-rt-amd64
make oldconfig
evl check -f .config
make -j16 deb-pkg LOCALVERSION=-xenomai4-$KERNEL_GIT_VERSION KDEB_PKGVERSION=$(make kernelversion)-${KERNEL_VERSION_STUFFIX}
cd ..
  
#Xenomai4 userspace tools-------------------------------------
cd libevl
#DEBEMAIL="hannes.diethelm@gmail.com" DEBFULLNAME="Hannes Diethelm" dh_make --createorig -p libevl_56
#dh_auto_configure --buildsystem=meson -- -Duapi=$(pwd)/../linux-evl/usr/include
cp -r ../libevl-debian/ debian
dpkg-buildpackage -b -uc

#Cleanup-----------------------------------------------------
mkdir deb
mv *.deb deb
rm *.changes *.buildinfo *.orig.tar.gz *.debian.tar.gz *.dsc

git -C linux-evl clean -fxd
git -C libevl clean -fxd

git add \
  deb/libevl_56-1_amd64.deb

git add \
  deb/linux-headers-6.12.67-xenomai4-${KERNEL_GIT_VERSION}_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}_amd64.deb \
  deb/linux-image-6.12.67-xenomai4-${KERNEL_GIT_VERSION}_${KERNEL_VERSION}-${KERNEL_VERSION_STUFFIX}_amd64.deb

git clean -f deb/
