#!/bin/bash
#specific to android build system. don't use.
# used for pushing libs and stuff.

foo=$1
faa=${foo##*'/out/target/product/pico'}

adb shell mount /system;
adb push $foo $faa
adb shell chmod 755 $faa
adb shell umount /system
adb reboot
