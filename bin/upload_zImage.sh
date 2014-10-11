#!/bin/bash

mkdir -p releases

if [ -f releases/lastrelease ]; then
	LOCAL_REV_VERSION=`scripts/setlocalversion`;
	LAST_REV_UPLOAD=`cat releases/lastrelease`;
	if [ $LOCAL_REV_VERSION == $LAST_REV_UPLOAD ]; then
		echo "Latest release already up!";
		exit;
	else
		echo `scripts/setlocalversion` > releases/lastrelease;
	fi
else
	touch releases/lastrelease;
	echo `scripts/setlocalversion` > releases/lastrelease;
fi

mkaflash

mv output.zip releases/output_`date +%d_%b_%Y``scripts/setlocalversion`.zip

devhost upload -u vineethraj49 -p $1 -f 36091 releases/output_`date +%d_%b_%Y``scripts/setlocalversion`.zip
