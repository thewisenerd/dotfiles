set -gx CROSS_COMPILE (toolchain_script)

set -gx CCACHE 'ccache'

set -gx KERNEL (pwd)
set -gx ARCH arm64
set -gx SUBARCH arm64
set -gx KBUILD_BUILD_USER "thewisenerd"
set -gx KBUILD_BUILD_HOST "eniac-v2"

rm std*.log ^ /dev/null

make $argv #> >(tee stdout.log) 2> >(tee stderr.log >&2)
