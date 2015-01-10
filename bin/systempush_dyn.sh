#!/bin/bash

#push files to /system while phone's on!
#echo $1
#/home/vineeth/works/omni-4.4/out/target/product/pico/system/framework/services.jar
#echo
#echo

#adb shell mount /system &&
#adb push /home/vineeth/works/omni-4.4/out/target/product/pico/system/lib/libmediaplayerservice.so /system/lib/libmediaplayerservice.so
#&& adb shell chmod 755 /system/lib/libmediaplayer.so &&
#adb shell umount /system &&
#adb reboot

foo=$1
faa=${foo##*'/out/target/product/pico'}

#if [ foo -eq faa ]
#faa=

#echo $faa;

adb shell su -c 'mount -o rw,remount /system';
adb push $foo $faa
adb shell chmod 755 $faa
adb shell umount /system
adb reboot





