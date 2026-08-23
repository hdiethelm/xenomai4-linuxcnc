#! /bin/sh

set -e

#Xenomai4 kernel-----------------------------------------
sudo apt install build-essential libncurses-dev bison flex libssl-dev libelf-dev dwarves git fakeroot rsync sbsigntool kernel-wedge

#Xenomai4 libevl-------------------------------------
sudo apt install libltdl-dev gdb devscripts meson ninja-build libbpf-dev cpio

