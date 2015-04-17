#!/bin/sh
mkbootfs boot | gzip > unpack/boot.img-ramdisk-new.gz;
mkdir -p ./output;
#rm ./unpack/boot.img-zImage;
#cp ./workspace/zImage ./unpack/boot.img-zImage;
mkbootimg --kernel ./unpack/boot.img-zImage --ramdisk ./unpack/boot.img-ramdisk-new.gz -o ./output/boot.img --base `cat ./unpack/boot.img-base`
