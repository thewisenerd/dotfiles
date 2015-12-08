for i in $( find ${EXTENTS_PATH}/extents/ -type f | grep -v main.sh )
do
  source $i
done