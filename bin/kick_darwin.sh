#! /bin/bash

if [ "$1" == "-h" ]
then
	echo "kick_darwin.sh"
	echo "help:	automagically finds the darwin based projects and removes"
	echo "	them, and gives you a clean local_manifests file or by any other"
	echo "	name, if set in parameter \$1."
	echo "usage:	kick_darwin.sh <file_name> (generates local_manifests file)"
	echo "	kick_darwin.sh -h (show this screen)"
	exit
fi

if [ "$1" != "" ]
then
	LOCAL_MANIFESTS_FILE=$1
else
	LOCAL_MANIFESTS_FILE=local_manifests.xml
fi


if [ -e $LOCAL_MANIFESTS_FILE ]
then
	rm -f $LOCAL_MANIFESTS_FILE
fi

#fixme: it mightn't be always default.xml?
if [ ! -e .repo/manifests/default.xml ]
then
	echo "manifest file/repo not found!"
	exit
fi

#file header, starts something like: <?xml version="1.0" encoding="UTF-8"?>
#todo: hardcode header (if safe)
echo $( cat .repo/manifests/default.xml | \
		grep -i "?xml v" ) | tee -a "$LOCAL_MANIFESTS_FILE"
echo $( cat .repo/manifests/default.xml | \
		grep -i "<manifest" ) | tee -a "$LOCAL_MANIFESTS_FILE"


# - find the lines with "darwin"; grep
# - make sure we have only the 'remove-project' && 'name' only; trash the rest; awk
# - fixup newlines; sed
# - fixup alignment; sed
echo $(
	cat .repo/manifests/default.xml | \
	grep -i "darwin" | \
	sed s@"<project "@"<remove-project "@g | \
	awk '{for (i=1;i<=NF;i++) {if ( ($i ~ /remove-project/) || ($i ~ /name=/) || ($i ~ /\/>/)) {print $i;}}}'
	) | sed s@"> <"@">\n<"@g | \
		sed s@"<remove"@"  <remove"@g | \
			tee -a "$LOCAL_MANIFESTS_FILE"

#footer
#todo: hardcore footer (if safe)
echo $( 
	cat .repo/manifests/default.xml | \
	grep -i "</manifest"
) | tee -a "$LOCAL_MANIFESTS_FILE"