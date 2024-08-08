FROM debian
ARG GIT_TAG=5.02.5185
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  g++ \
  gcc \
  git \
  libiconv-hook-dev \
  libncurses5-dev \
  libreadline-dev \
  libsodium-dev \
  libssl-dev \
  make \
  pkgconf \
  zlib1g-dev 
RUN apt-get install -y --reinstall ca-certificates

WORKDIR /usr/local/src
RUN git clone --depth 1 -b ${GIT_TAG} https://github.com/SoftEtherVPN/SoftEtherVPN.git
ENV USE_MUSL=YES
RUN cd SoftEtherVPN && \
  git submodule init  && \
  git submodule update && \
  ./configure && \
  make -C build

ENTRYPOINT ["tail", "-F", "/dev/null"]
