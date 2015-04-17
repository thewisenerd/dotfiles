#! /bin/bash

#search for needle in haystack (html) and replace line with straw

TEXT="needle"
REPLACE="straw"

# '@' or ';' or whatever.

#backup current field separaotr
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for i in $( find ./ -type f | grep .html | colorfix.sh )
do
	if grep --quiet "${TEXT}" "$i"; then
		echo "$i";
		line=$( grep -n "${TEXT}" "$i" | cut -d : -f 1 );
		echo ${line}
		sed -i ${line}'s/.*/'${REPLACE}'/' "${i}"
	else
		echo not found
	fi

done

#restore field separaotr
IFS=$SAVEIFS
