ARG UBUNTU_VER=20.04

FROM ubuntu:${UBUNTU_VER} AS cross-compiler-builder
ARG DEBIAN_FRONTEND=noninteractive
ENV BUILD_DIR=/code/
ENV VENUS_DIR /venus
ENV VENUS_INITIALIZED_MARK $VENUS_DIR/patched

COPY ./version $VENUS_DIR/version
COPY ./docker-entrypoint.sh $VENUS_DIR/docker-entrypoint.sh

# initilization for the first time
ENTRYPOINT ["/venus/docker-entrypoint.sh"]

CMD ["/usr/bin/bash"]