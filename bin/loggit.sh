#!/bin/bash
mkdir -p ~/logs;
FILE=~/logs/log${1}_`date +%d%b_%H-%M-%S`.txt

adb logcat | tee ${FILE}
