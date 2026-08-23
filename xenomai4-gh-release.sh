#! /bin/sh

set -e

BUILD_TYPE=kernel . ./xenomai4-vars.sh

gh release create ${KERNEL_VERSION}${KERNEL_VERSION_CIP}${KERNEL_LOCAL_VERSION} -d package/*
