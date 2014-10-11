#!/bin/bash

foo=$1
faa=${foo##*'/out/target/product/pico'}

echo $faa;

adb shell mount /system;
adb push $foo $faa
adb shell chmod 755 $faa
adb shell umount /system
#adb reboot





