#!/bin/sh
mkdir -p unpack;
unpackbootimg -i boot.img -o unpack;
mkdir -p boot;
cd boot;
gzip -dc ../unpack/boot.img-ramdisk.gz | cpio -i;
cd ../;
#mkbootfs boot | gzip > unpack/boot.img-ramdisk-new.gz;
#mkdir -p output;
#mkbootimg --kernel unpack/boot.img-zImage --ramdisk unpack/boot.img-ramdisk-new.gz -o output/boot.img --base `cat unpack/boot.img-base`
