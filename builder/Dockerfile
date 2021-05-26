ARG UBUNTU_VER=20.04

FROM ubuntu:${UBUNTU_VER} AS cross-compiler-builder
ARG DEBIAN_FRONTEND=noninteractive

#default args
#ARG BUILD_TYPE=debug
#ARG BUILD_TYPE=release
ARG BUILD_DIR=/code/

RUN mkdir -p ${BUILD_DIR} && \
    sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install locales gperf bison flex texinfo help2man gawk libtool-bin libncurses5-dev git \
        bash nano wget xz-utils build-essential autoconf unzip gettext python3 pkg-config gcc g++ zlib1g-dev libmpc-dev libmpfr-dev libgmp-dev \
        xutils-dev cmake unzip xtrans-dev git autopoint; \
    # echo "https_proxy = $PROXY_SERVER" >> /etc/wgetrc; \
    #     echo "http_proxy = $PROXY_SERVER" >> /etc/wgetrc; \
    #     echo "ftp_proxy = $PROXY_SERVER" >> /etc/wgetrc; \
    #     echo "use_proxy = on" >> /etc/wgetrc; \
    locale-gen en_US.UTF-8 && echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash && \
    cd ${BUILD_DIR} && \
    bash -c "while ! git clone https://github.com/tpoechtrager/osxcross.git --depth=1; do sleep 1; done" && \
    # git clone https://github.com/tpoechtrager/osxcross.git && \
    cd osxcross && \
    tools/get_dependencies.sh && \
    INSTALLPREFIX=/opt/clang ./build_clang.sh && \
    UNATTENDED=1 ./build.sh && \
    GCC_VERSION=10.3.0 ./build_gcc.sh

# FROM ubuntu:${UBUNTU_VER} AS building-env
# ARG DEBIAN_FRONTEND=noninteractive
# COPY --from=lxc-builder /opt/x-tool.tar.xz /opt/
# ENV JUPITER_DIR /jupiter
# COPY docker-entrypoint.sh $JUPITER_DIR/
# ENV JUPITER_INITIALIZED_MARK $JUPITER_DIR/patched
# RUN mkdir -p $JUPITER_DIR
# ENV PATH=$PATH:/opt/x-tools/armv7-mx5-linux-musleabihf/bin:/opt/x-tools/armv7-mx5-linux-musleabihf/fakebin
# ENV PKG_CONFIG_PATH=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/lib/pkgconfig/:/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/lib/pkgconfig/:/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/share/pkgconfig/
# RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
#     dpkg --add-architecture i386 && \
#     apt-get update && \
#     apt-get -y install bash xz-utils locales; \
#         echo 'export PATH=$PATH:/opt/x-tools/armv7-mx5-linux-musleabihf/bin:/opt/x-tools/armv7-mx5-linux-musleabihf/fakebin' >> ~/.bashrc; \
#         echo 'export LC_ALL="en_US.UTF-8"' >> ~/.bashrc && \
#     echo "dash dash/sh boolean false" | debconf-set-selections && \
#     DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash && \
#     echo 'over'

# initilization for the first time
ENTRYPOINT ["/venus/docker-entrypoint.sh"]

CMD ["/usr/bin/bash"]