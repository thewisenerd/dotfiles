function fish_paths

	# csm
	set -gx PATH "$WORKS_PATH/unix/chromium-sandbox-manager" $PATH
	set -gx csm_extensions_dir "$WORKS_PATH/web"

	# caddy
	set -gx PATH "$WORKS_PATH/unix/caddy" $PATH

	# npm
	set -gx PATH "$WORKS_PATH/.node/bin" $PATH
	if [ $NODE_PATH ]
		set -gx NODE_PATH  "$WORKS_PATH/.node/lib/node_modules:$NODE_PATH"
	else
		set -gx NODE_PATH  "$WORKS_PATH/.node/lib/node_modules"
	end

	# git
	alias gpik='git cherry-pick'
	alias gshow='git show'

	# python lib
	set -gx PATH "$HOME/.local/bin" $PATH

	# ccache
	set -gx PATH "/usr/lib/ccache/bin" $PATH

	# x-tools
	set -gx PATH "$HOME/x-tools/arm-opi-linux-gnueabihf/bin" $PATH

	# gcp
	source "$WORKS_PATH/web/gcp/google-cloud-sdk/path.fish.inc"
end
