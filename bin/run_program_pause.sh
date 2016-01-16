#!/bin/bash

EXEC=$*
BASE=$( basename ${EXEC} )

${EXEC}

echo ""
echo ""
echo "------------------"
echo \(${BASE} exited with code: $?\)
read -p "Press return to continue"

