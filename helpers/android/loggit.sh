#!/bin/bash
DAY=`date +%d%b_%Y`
mkdir -p ~/logs/${DAY}
FILE=~/logs/${DAY}/`date +%H-%M-%S`.txt

adb logcat | tee ${FILE}
