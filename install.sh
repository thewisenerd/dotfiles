#! /usr/bin/env bash

source helpers/shml/shml.sh

bashrc_file=~/.bashrc
gitconfig=".gitconfig"

echo -n $(fgc yellow)"checkin bashrc... "$(fgc end)

if [ ! -e ${bashrc_file} ]
then
  echo $(color red)$(icon xmark)$(color end)
  exit
fi

sed -i -e '$a\' ${bashrc_file}

if grep -q "bashrc-extents" ${bashrc_file}
then
  echo $(color red)$(icon xmark)$(color end)
else
  echo $(color green)$(icon check)$(color end)

  echo -n $(fgc yellow)"       install... "$(fgc end)
  {
    ln="\nexport EXTENTS_PATH=$(pwd)\nsource $(pwd)/.bashrc-extents"
    echo -e ${ln} >> ${bashrc_file}
  } &> /dev/null
  if [ $? -ne 0 ]; then
    echo $(color red)$(icon xmark)$(color end)
  else
    echo $(color green)$(icon check)$(color end)
  fi

  if [ -e ${gitconfig} ]; then
    mv ~/${gitconfig} ~/${gitconfig}-backup
  fi

  ln -s $( pwd )/${gitconfig} ~/${gitconfig}
fi
