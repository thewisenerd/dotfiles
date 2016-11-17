#! /bin/bash

set -euo pipefail

if [ "$#" -ne 2 ]; then
    echo "aget.sh {ip}:{port} {file}"
    echo "  example: aget.sh 192.168.1.5:5555 \"/sdcard/file.txt\""
    exit
fi

ip=$( ip route get 8.8.8.8 1 | awk '{print $NF;exit}' )
pwd=$( pwd )
user=$( whoami )
temp=$( mktemp )
line="-----------------------------------"

remote=$1

echo "killing adb"
adb kill-server
echo ${line}

echo "connect adb"
adb connect ${1}
echo ${line}

echo "waitin for device"
adb wait-for-device
echo ${line}

echo rsync -aHXxv --numeric-ids --delete --progress \"${2}\" ${user}@${ip}:${pwd} > ${temp}

echo "gen command"
cat ${temp}
echo ${line}

exit

echo "push file"
adb push ${temp} /data/local/tmp/
echo ${line}

echo "chmod +x"
adb shell chmod +x /data/local/tmp/${temp##*/}
echo ${line}

echo "rsync!"
adb shell /data/local/tmp/${temp##*/}
echo ${line}
