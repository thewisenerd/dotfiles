#!/bin/bash
if [ "$1" == "init" ]; then
#echo "Success"
cp --recursive ~/bin/zipup/META-INF ./META-INF_new;
	if [ -d META-INF ];	then
		mv META-INF META-INF_old;
	fi;
mv META-INF_new META-INF;
else
	#echo "Too bad, too sad!";
	zip -r -y -q $1.zip * -x *.zip* build README.md
fi;
