#! /usr/bin/env bash

source helpers/shml/shml.sh

bashrc_file=~/.bashrc

ln="\nexport EXTENTS_PATH=$(pwd)\nsource $(pwd)/.bashrc-extents"

echo $(fgc yellow)"find and delete the following lines from ${bashrc_file}"$(fgc end)
echo "$(hr)"
echo -e ${ln}
echo "$(hr)"
