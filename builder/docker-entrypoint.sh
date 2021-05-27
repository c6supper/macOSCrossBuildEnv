#!/bin/sh

set -ex

patch_conf() {
    touch $VENUS_INITIALIZED_MARK
}

prepare_src() {
    mkdir -p ${BUILD_DIR} && \
    sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install git locales cmake; \
    locale-gen en_US.UTF-8 && echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    cd ${BUILD_DIR} && \
    bash -c "while ! git clone https://github.com/c6supper/osxcross.git --depth=1; do sleep 1; done" && \
    wget -t 0 https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX11.3.sdk.tar.xz
}

build_cross_compiler() {
    cd ${BUILD_DIR}/osxcross && \
    DEBIAN_FRONTEND=noninteractive tools/get_dependencies.sh && \
    CLANG_VERSION=11.0.0 INSTALLPREFIX=/opt/clang ./build_clang.sh && \
    UNATTENDED=1 ./build.sh && \
    GCC_VERSION=10.3.0 ./build_gcc.sh
}

if [ ! -f "$VENUS_INITIALIZED_MARK" ]; then

  prepare_src

  build_cross_compiler

  echo
  echo 'venus init process complete; ready for start up.'
  echo
else
  echo
  echo 'Skipping initialization'
  echo
fi

/bin/sh -c "$@"