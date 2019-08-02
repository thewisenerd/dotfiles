# ps1

RED="\[$(tput setaf 1)\]"
GREEN="\[$(tput setaf 2)\]"
RESET="\[$(tput sgr0)\]"

if [ "$EUID" -eq 0 ]; then
	export PS1="bash ${RED}\$( fish -c 'prompt_pwd' )${RESET}# "
else
	export PS1="bash ${GREEN}\$( fish -c 'prompt_pwd' )${RESET}> "
fi
