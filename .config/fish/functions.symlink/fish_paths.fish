function fish_paths

	# csm
	set -gx PATH $PATH "$WORKS_PATH/unix/chromium-sandbox-manager"
	set -gx csm_extensions_dir "$WORKS_PATH/web"

	# caddy
	set -gx PATH $PATH "$WORKS_PATH/unix/caddy"

	# npm
	set -gx PATH $PATH "$WORKS_PATH/.node/bin"
	if [ $NODE_PATH ]
		set -gx NODE_PATH  "$WORKS_PATH/.node/lib/node_modules:$NODE_PATH"
	else
		set -gx NODE_PATH  "$WORKS_PATH/.node/lib/node_modules"
	end

	# git
	alias gpik='git cherry-pick'
	alias gshow='git show'

	# python lib
	set -gx PATH $PATH "$HOME/.local/bin"

end
