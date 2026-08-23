# Xenomai4 Kernel for LinuxCNC

<strong>Warning:<br>The supplied scripts clean several folders without warning! Don't place anything inside this repository which you want to keep!</strong>

<strong>Work in progress, things might not work or break your system!</strong>

<strong>Feedback is welcome, create an issue or pull request</strong>

<strong>Expected Distribution: Debian Trixie</strong>

## How To

- Clone repo
- Download the github release
  - `scripts/gh-download.sh kernel`
  - `scripts/gh-download.sh lib`
  - `scripts/gh-download.sh linuxcnc`
- Install the packages
  - `scripts/install.sh kernel`
  - `scripts/install.sh lib`
  - `scripts/install.sh linuxcnc`
- Reboot to xenomai kernel (You probably have to select it in grub)
- Check for xenomai
  - `sudo dmesg | grep -i evl`
- Test LinuxCNC
  - LinuxCNC should show: `Note: Using XENOMAI4 EVL realtime`

## Build libevl and kernel from source

- Clone repo
- Build it from source
  - `git submodule init`
  - `git submodule update`
  - `scripts/install-deps.sh`
  - `scripts/build.sh kernel` or `scripts/build.sh kernel_rt` (Depending if you prefer a kernel without or with PREEMPT_RT)
  - `scripts/build.sh lib`
- Install
  - `scripts/install.sh kernel` or `scripts/install.sh kernel_rt` (Depending if you prefer a kernel without or with PREEMPT_RT)
  - `scripts/install.sh lib`
- Reboot to xenomai kernel (You probably have to select it in grub)
- Check for xenomai
  - `sudo dmesg | grep -i evl`

## Build LinuxCNC from source

### Using the scripts
- Clone repo
- Build it from source
  - `git submodule init`
  - `git submodule update`
  - `scripts/install-deps.sh`
  - `scripts/build.sh linuxcnc`
- Install
  - `scripts/install.sh linuxcnc`

### Upstream master
- Build LinuxCNC
  - `git clone https://github.com/LinuxCNC/linuxcnc.git linuxcnc-src-upstream`
  - `cd inuxcnc-src-upstream`
  - `./debian/configure`
  - `sudo apt-get build-dep .`
  - `cd src`
  - `./autogen.sh`
  - `./configure --with-realtime=uspace`
    - configure should show:<br>
    `checking for evl/evl.h... yes`<br>
    `checking for realtime API(s) to use... uspace+xenomai4`
  - `make -j $(nproc)`
  - If you are on 2.10 branch: `sudo make setuid`
  - If you are on master branch: `sudo make setcap`
    - LinuxCNC master supports rootless operation, 2.10 will fail
- Run LinuxCNC
  - ../scripts/linuxcnc
  - LinuxCNC should show: `Note: Using XENOMAI4 EVL realtime`
  - latency-histogram has to be started using: <br>
  `../scripts/rip-environment ../scripts/latency-histogram`

## Notes

<strong>The target of this repo is to make it easy for others to use LinuxCNC with Xenomai4. No waranty can be given!</strong>

All instuctions in here base on the documentation on https://v4.xenomai.org/ with some quirks resolved.

Xenomai4 support got recently merged to master: https://github.com/LinuxCNC/linuxcnc/pull/3903

### Ethernet

Driver info from Intel: https://www.intel.com/content/www/us/en/support/articles/000005480/ethernet-products.html

The only two drivers are availabe up to now for Xenimai3 and Xenomai4 are:
- Intel igb
  - Driver matches upstream except OOB patches
  - Cards still on sale:
    - 82576
    - I210
    - I350
- Intel e1000e
  - Driver matches upstream except OOB patches
  - Works for tesing in qemu + virtmanager

For details, read: ethernet.md

### Xenomai4 tools
- Xenomai latency test
  - Select an isolated CPU. For example for CPU3: <br>
  `sudo latmus -c 3`
- Check for Xenomai enabled threads and status
  - `evl ps -l`
  - rtapi_app should show up on the isolated CPU
  - ISW should stay constant (unwanted mode switches)
  
### Xenomai4 userspace tools plain install
For other operating systems or if you have issues with the debian packages
```
#make and install
mkdir libevl-build && cd libevl-build

meson setup -Dbuildtype=release -Dprefix=/opt/evl -Duapi=$(pwd)/../linux-evl . ../libevl
meson compile
sudo ninja install
echo "/opt/evl/lib/x86_64-linux-gnu" | sudo tee /etc/ld.so.conf.d/evl.conf > /dev/null
sudo ldconfig

#uninstall:
sudo ninja uninstall
sudo rm -r /opt/evl/

#linuxcnc xenomai4 doesn't support non standard include/lib paths for evl for now
#You need to configure linuxcnc with:
./configure --with-realtime=uspace CPPFLAGS=-I/opt/evl/include LDFLAGS=-L/opt/evl/lib/x86_64-linux-gnu
```

### Developer Information

linux-evl branch: v6.12.y-cip-evl-rebase

evl ABI/API: libevl/include/evl/version.h / linux-evl/include/uapi/evl/control-abi.h
