# Xenomai4 Kernel for LinuxCNC

<strong>Work in progress, not yet working!</strong>

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
- Build LinuxCNC <strong>Not yet working, needs Xenomai4 porting</strong>
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
- Run LinuxCNC <strong>Not yet working, needs Xenomai4 porting</strong>
  - ../scripts/linuxcnc
  - LinuxCNC should show: `Note: Using XENOMAI (posix-skin) realtime`
  - latency-histogram is broken and has to be started using: <br>
  `../scripts/rip-environment ../scripts/latency-histogram`

## Notes

<strong>The target of this repo is to make it easy for others to use LinuxCNC with Xenomai4. No waranty can be given!</strong>

### Xenomai4 tools
- Xenomai latency test
  - Select an isolated CPU. For example for CPU3: <br>
  `sudo latmus -c 3`
- Check for Xenomai enabled threads
  - `evl ps`
  - rtapi_app should show up on the isolated CPU