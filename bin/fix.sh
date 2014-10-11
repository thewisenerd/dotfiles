#! /bin/bash

# for track id fix
max=10

for i in $( ls * | grep -v fix.sh ) #ignore this fix.sh
do 
Track=$( exiftool "$i" -p '$Track' )
Artist=$( exiftool "$i" -p '$Artist' )
Title=$( exiftool "$i" -p '$Title' )
fix_Track=$( printf "%0*d\n" ${#max} ${Track} )
echo moving "\"${i}\"" to "\"${fix_Track} ${Artist} - ${Title}.mp3\""
mv "${i}" "${fix_Track} ${Artist} - ${Title}.mp3"
done
