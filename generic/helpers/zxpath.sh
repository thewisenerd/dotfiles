add_spath() {
	[ -z "$ZXPATH" ] && {
		export ZXPATH="$1"
		export ZXKEYS="$2"
	} || {
		export ZXPATH="$ZXPATH:$1"
		export ZXKEYS="$ZXKEYS:$2"
	}
	if [ -d $1 ]; then
		export $2=$1
	fi
}

add_spath "$DOTFILES_PATH_ORIG" "dots"

unset -f add_spath
