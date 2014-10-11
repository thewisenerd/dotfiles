#!/bin/bash
# mk_products.sh #
#author: thewisenerd <contact.twn@openmailbox.org> #

#edit this correctly.
VENDOR_PATH="vendor/htc/pico"

#any extra files? your headache
file_list=$( find . -type f | grep -v .patch | grep -v .md | grep -v .mk | grep -v .sh | grep -v .git | sed 's@\.\/@@g' )


fil=tmp_blobs.mk

if [ -e tmp_blobs.mk ]
then
	rm -f tmp_blobs.mk
fi
touch $fil

echo "#######################################################" > $fil
echo "#This is an automatically generated file. Do not edit!#" >> $fil
echo "#######################################################" >> $fil

echo "LOCAL_PATH := ${VENDOR_PATH}" >> $fil

echo "PRODUCT_COPY_FILES += \\" >> $fil

for i in $file_list
do
	file_v="\$(LOCAL_PATH)"/"${i}"
	file_c=system/${i}
	echo "    "${file_v}:${file_c} \\ >> $fil
done

last_line=$( cat tmp_blobs.mk | grep "." | tail -1 )
last_line_fix=$( echo ${last_line} | sed 's@ \\@@g' )
sed -i '$d' $fil
echo "    "$last_line_fix >> $fil

mv $fil vendor_blobs.mk
