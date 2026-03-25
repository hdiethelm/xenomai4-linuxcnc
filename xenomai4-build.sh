#! /bin/sh

#Xenomai4 Kernel-----------------------------------------
#git clone https://gitlab.com/xenomai/xenomai4/linux-evl.git
#git -C linux-evl checkout v6.12.67-evl2-rebase
KERNEL_GIT_VERSION=53a3aa

#git clone https://gitlab.com/xenomai/xenomai4/libevl.git
#git -C libevl checkout r56
LIBEVL_GIT_VERSION=11e6a1

cd linux-evl
cp ../kconfig-base-config-6.12.74+deb13+1-rt-amd64.txt .config #Base: debian trixie config-6.12.74+deb13+1-rt-amd64
make oldconfig
make -j16 deb-pkg LOCALVERSION=-xenomai4-$KERNEL_GIT_VERSION KDEB_PKGVERSION=$(make kernelversion)-2
cd ..
  
#Xenomai4 userspace tools-------------------------------------
mkdir libevl-build
cd libevl-build

# Prepare the build directory
meson setup -Dbuildtype=release -Dprefix=/opt/evl -Duapi=$(pwd)/../linux-evl/usr/include . ../libevl

# Build it
meson compile

# Install the result
ninja install
cd ..

echo "/opt/evl/lib/x86_64-linux-gnu" | sudo tee /etc/ld.so.conf.d/xenomai.conf > /dev/null
sudo ldconfig

#Cleanup-----------------------------------------------------
mkdir deb
mv *.deb deb
rm *.changes *.buildinfo *.tar.gz *.dsc

git -C linux-evl clean -fxd
rm -r libevl-build/

git add \
  deb/linux-headers-6.12.67-xenomai4-${KERNEL_GIT_VERSION}_6.12.67-2_amd64.deb \
  deb/linux-image-6.12.67-xenomai4-${KERNEL_GIT_VERSION}_6.12.67-2_amd64.deb

git clean -f deb/
