#! /bin/bash

TEXT="stylesheets"

# '@' or ';' or whatever.

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for i in $( find ./ -type f | grep .html | colorfix.sh )
do
	if grep --quiet "${TEXT}" "$i"; then
		#echo "$i";
		#line=$( grep -n "${TEXT}" "$i" | cut -d : -f 1 );
		#echo ${line}
		#sed '${line}d' fileName.txt
		sed -i '/stylesheets/d' "$i"
	else
		echo not found
	fi

done




IFS=$SAVEIFS
