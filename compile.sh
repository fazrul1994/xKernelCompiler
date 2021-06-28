#!/bin/bash

# Copyright (C) 2021 a xyzprjkt property

# Warning !! Dont Change anything there without known reason.
cd ${KERNEL_ROOTDIR}
BUILD_START=$(date +"%s")

make -j$(nproc) O=out ARCH=arm64 ${DEVICE_DEFCONFIG}
make menuconfig O=out 
time make -j$(nproc) ARCH=arm64 O=out \
	CC=${CLANG_ROOTDIR}/bin/clang \
	CROSS_COMPILE=${CLANG_ROOTDIR}/bin/aarch64-linux-gnu- \
	CROSS_COMPILE_ARM32=${CLANG_ROOTDIR}/bin/arm-linux-gnueabi-

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))

echo -e ""
echo -e "\033[0;32mBuild completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
curl --upload-file out/arch/arm64/boot/Image.gz-dtb http://transfer.sh/Image.gz-dtb
