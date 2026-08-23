#! /bin/sh

set -e

. ./xenomai4-vars.sh

gh release create ${GH_RELEASE_TAG} -d -n "" ${PACKAGE_DIR}/*

