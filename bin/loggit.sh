#!/bin/bash
mkdir -p ~/logs;
FILE=~/logs/log${1}_`date +%d%b_%H-%M`.txt
FILE_S=~/logs/log${1}_`date +%d%b_%H-%M-%S`.txt

if [ ! -f $FILE ]; then
	adb logcat | tee ~/logs/zzz_last.txt;
	mv ~/logs/zzz_last.txt ${FILE}
else
	adb logcat | tee ~/logs/zzz_last.txt;
	mv ~/logs/zzz_last.txt ${FILE_S}
fi
