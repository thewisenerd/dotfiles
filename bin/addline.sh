#! /bin/bash

TEXT="var m_names=new Array("

REPLACE="			var m_names=new Array(\"Jan\",\"Feb\",\"Mar\",\"Apr\",\"May\",\"Jun\",\"Jul\",\"Aug\",\"Sept\",\"Oct\",\"Nov\",\"Dec\");var x=new Date(document.lastModified);document.getElementById(\"last_modified\").innerHTML=\"This page was last Modified On: \"+x.getDate()+\" \"+m_names[x.getMonth()]+\" \"+x.getFullYear()"

# '@' or ';' or whatever.

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for i in $( find ./ -type f | grep .html | colorfix.sh )
do
	if grep --quiet "${TEXT}" "$i"; then
		echo "$i";
		line=$( grep -n "${TEXT}" "$i" | cut -d : -f 1 );
		echo ${line}
		#sed '${line}d' fileName.txt
		#sed -i '/stylesheets/d' "$i"
		sed -i ${line}'s/.*/'${REPLACE}'/' "${i}"
	else
		echo not found
	fi

done




IFS=$SAVEIFS
