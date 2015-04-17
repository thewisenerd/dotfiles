#! /bin/bash

#search for needle in haystack and remove straw containing needle

TEXT="stylesheets"

# '@' or ';' or whatever.

#backup current ifs
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for i in $( find ./ -type f | grep .html | colorfix.sh )
do
	if grep --quiet "${TEXT}" "$i"; then
		sed -i '/stylesheets/d' "$i"
	else
		echo not found
	fi
done

#restore ifs
IFS=$SAVEIFS
