ARG UBUNTU_VER=20.04
ARG BUILD_DIR=/code/

FROM ubuntu:${UBUNTU_VER} AS prepare-builder
ARG DEBIAN_FRONTEND=noninteractive
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/ports.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    # dpkg --add-architecture i386 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install git locales cmake wget; \
    locale-gen en_US.UTF-8 && echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash && \
    dpkg-reconfigure --frontend noninteractive tzdata

FROM prepare-builder AS clang-builder
ARG BUILD_DIR
RUN mkdir -p ${BUILD_DIR} && \
    cd ${BUILD_DIR} && \
    bash -c "while ! git clone https://github.com/c6supper/osxcross.git --depth=1; do sleep 1; done" && \
    cd ${BUILD_DIR}/osxcross && \
    wget -c -t 0 https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX10.15.sdk.tar.xz -O tarballs/MacOSX10.15.sdk.tar.xz && \
    DEBIAN_FRONTEND=noninteractive tools/get_dependencies.sh && \
    UNATTENDED=1 CLANG_VERSION=12.0.0 JOBS=4 INSTALLPREFIX=/opt/clang ./build_clang.sh

FROM clang-builder AS tool-builder
ARG BUILD_DIR
RUN cd ${BUILD_DIR} && \
    UNATTENDED=1 JOBS=4 ./build.sh

FROM tool-builder AS gcc-builder
ARG BUILD_DIR
RUN cd ${BUILD_DIR} && \
    UNATTENDED=1 GCC_VERSION=10.3.0 JOBS=4 ./build_gcc.sh

COPY ./version $VENUS_DIR/version
ENV VENUS_DIR /venus
ENV VENUS_INITIALIZED_MARK $VENUS_DIR/patched
COPY ./version $VENUS_DIR/version
COPY ./docker-entrypoint.sh $VENUS_DIR/docker-entrypoint.sh

# initilization for the first time
ENTRYPOINT ["/venus/docker-entrypoint.sh"]

CMD ["/usr/bin/bash"]