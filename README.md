# Xenomai4 Kernel for LinuxCNC

<strong>Work in progress, things might not work or break your system!</strong>

<strong>Feedback is welcome, create an issue or pull request</strong>

<strong>Expected Distribution: Debian Trixie</strong>

## How To

- Clone repo
- If you trust my binary packages
  - `./xenomai4-install.sh`
- Build it from source
  - `git submodule init`
  - `git submodule update`
  - `xenomai4-prepare.sh`
  - `xenomai4-build.sh`
  - `xenomai4-install.sh`
- Reboot to xenomai kernel (You probably have to select it in grub)
- Check for xenomai
  - `sudo dmesg | grep -i evl`
- Build LinuxCNC
  - `git clone https://github.com/LinuxCNC/linuxcnc.git linuxcnc-src`
  - `cd inuxcnc-src/src`
  - `./debian/configure`
  - `sudo apt-get build-dep .`
  - `./autogen.sh`
  - `./configure --with-realtime=uspace`
    - configure should show:<br>
    `checking for rtai-config... none`<br>
    `checking for xeno-config... /usr/xenomai/bin/xeno-config`<br>
    `checking for realtime API(s) to use... uspace+xenomai`
  - `make -j`
  - `sudo make setuid`
- Run LinuxCNC
  - ../scripts/linuxcnc
  - LinuxCNC should show: `Note: Using XENOMAI4 EVL realtime`
  - latency-histogram has to be started using: <br>
  `../scripts/rip-environment ../scripts/latency-histogram`

## Notes

<strong>The target of this repo is to make it easy for others to use LinuxCNC with Xenomai4. No waranty can be given!</strong>

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