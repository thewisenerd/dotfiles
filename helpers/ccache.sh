# ccache
export PATH="/usr/lib/ccache/bin":$PATH

export CCACHE_DIR=${HOME}/works/.ccache;
export CCACHE=1;
export USE_CCACHE=1;
export CCACHE_NOCOMPRESS=1;
export CCACHE_SLOPPINESS=time_macros,include_file_mtime,file_macro;
export CCACHE_COMPILERCHECK=content;
export CCACHE_MAXSIZE="40.0G"
