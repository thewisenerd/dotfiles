# Defined in /usr/share/fish/functions/prompt_pwd.fish @ line 1
function prompt_pwd --argument-names 'color_cwd' --description 'Print the current working directory, shortened to fit the prompt'
	set -q argv[1]
	and switch $argv[1]
		case -h --help
			__fish_print_help prompt_pwd
			return 0
	end

	# This allows overriding fish_prompt_pwd_dir_length from the outside (global or universal) without leaking it
	set -q fish_prompt_pwd_dir_length
	or set -l fish_prompt_pwd_dir_length 3

	# do not mess colors if no color_cwd
	set -l color_pre 'normal'
	if test -n "$color_cwd"
		set color_pre 'bryellow'
	end

	# print $PWD outside $HOME
	set realhome ~
	if [ "z$PWD" = "z$realhome" ]
		return 0
	end

	set -l prefix ''
	set -l tpath (string replace -r '^'"$realhome"'($|/)' '~$1' $PWD)
	if set -q ZXPATH
		set -l zxpath (string split ':' -- $ZXPATH)
		set -l zxkeys (string split ':' -- $ZXKEYS)
		for i in (seq (count $zxpath))
			set -l p $zxpath[$i]
			set -l k $zxkeys[$i]

			if string match -q -- "$p*" $PWD
				set prefix '$'"$k"
				set tpath (string replace -ar "$p" '' $PWD)
			end
		end
	end

	if [ $fish_prompt_pwd_dir_length -eq 0 ]
		echo -s (set_color $color_pre) $prefix (set_color $color_cwd) $tmp
	else
		echo -ns (set_color $color_pre) $prefix (set_color $color_cwd)
		# Shorten to at most $fish_prompt_pwd_dir_length characters per directory
		string replace -ar '(\.?[^/]{'"$fish_prompt_pwd_dir_length"'})[^/]*/' '$1/' $tpath
	end
end
