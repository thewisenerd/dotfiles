# thanks https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md

NPM_PACKAGES="${HOME}/works/.node"

mkdir -p "$NPM_PACKAGES"

export PATH="$NPM_PACKAGES/bin:$PATH"

# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# yarn cache folder
export YARN_CACHE_FOLDER="${HOME}/works/.yarn/cache"

mkdir -p "$YARN_CACHE_FOLDER"
