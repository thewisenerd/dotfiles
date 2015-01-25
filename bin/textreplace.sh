#! /bin/bash

ORIG=""
REPL=""

# '@' or ';' or whatever.
find ./ -type f -exec sed -i "s@${ORIG}@${REPL}@g" {} \;
