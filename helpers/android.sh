# bootimg_tools
export PATH=${HOME}/works/android/generic/bootimg_tools:$PATH

# android generic helpers
export PATH=${DOTFILES_PATH}/helpers/android:$PATH

# sdat2img
export PATH=${HOME}/works/android/generic/sdat2img-master:$PATH

# simg2img
export PATH=${HOME}/works/android/generic/android-simg2img-master:$PATH

# ferrari
export PATH=${DOTFILES_PATH}/helpers/android/ferrari:$PATH

# jack
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"

# {n,s}dk
export ANDROID_HOME=/opt/android-sdk
source /etc/profile.d/android-ndk.sh
