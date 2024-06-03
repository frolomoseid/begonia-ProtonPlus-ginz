#!/bin/bash

set -e
set -x

# sync rom
repo init --depth=1 -u //github.com/ProtonPlus-ORG/manifest -b tm-qpr3
git clone https://github.com/PixelExperience-Devices/device_xiaomi_begonia --depth 1 -b aex .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# build rom
source build/envsetup.sh
lunch device-buildtype
m otapackage

# upload rom
up(){
	curl --upload-file $1 https://transfer.sh/$(basename $1); echo
	# 14 days, 10 GB limit
}

up out/target/product/begonia/*.zip
