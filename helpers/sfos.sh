FIX=0
if [ $FIX -eq 1 ]; then

# ~/bin/repo
export PATH="${HOME}/bin":$PATH

# env vars
source ~/.hadk.env

# sfossdk
alias sfossdk=$PLATFORM_SDK_ROOT/sdks/sfossdk/mer-sdk-chroot

# telnetsfos
alias sfdhcp="sudo dhcpcd enp3s0f0u3"
alias sftelnet="telnet 192.168.2.15 2323"

if [ ! -z ${MERSDK+x} ] || [ ! -z ${MERSDKUBU+x} ]; then
	export NOFISH=true
	PS1='[\u@\h \W]\$ '
fi

fi # $FIX
