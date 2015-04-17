#!/bin/bash
#specific to android build system. don't use.
# used for pushing libs and stuff.
#push files to /system while phone's powered on!

foo=$1
faa=${foo##*'/out/target/product/pico'}

adb shell su -c 'mount -o rw,remount /system';
adb push $foo $faa
adb shell chmod 755 $faa
adb shell umount /system
adb reboot





