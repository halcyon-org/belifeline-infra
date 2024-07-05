FROM debian
ARG GIT_TAG=5.02.5185
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  libreadline-dev \
  libssl-dev \
  libncurses5-dev \
  git \
  cmake \
  make \
  gcc \
  g++ \
  pkgconf \
  zlib1g-dev \
  libsodium-dev \
  libiconv-hook-dev
RUN apt-get install -y --reinstall ca-certificates

WORKDIR /usr/local/src
RUN git clone --depth 1 -b ${GIT_TAG} https://github.com/SoftEtherVPN/SoftEtherVPN.git
ENV USE_MUSL=YES
RUN cd SoftEtherVPN &&\
  git submodule init
RUN cd SoftEtherVPN && \
  git submodule update
RUN cd SoftEtherVPN && \
  ./configure
RUN cd SoftEtherVPN && \
  make -C build

ENTRYPOINT ["tail", "-F", "/dev/null"]
