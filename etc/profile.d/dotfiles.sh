#!/bin/bash

if [[ $USER == "thewisenerd" ]]; then
	export DOTFILES_PATH="/home/thewisenerd/works/unix/dotfiles"
	[ -e "${DOTFILES_PATH}/configure" ] && source "${DOTFILES_PATH}/configure"
fi
