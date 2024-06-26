FROM debian
ARG GIT_TAG=v4.41-9782-beta
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  libreadline-dev \
  libssl-dev \
  libncurses5-dev \
  git \
  cmake \
  zlib1g-dev \
  libsodium-dev \
  libiconv-hook-dev
RUN apt-get install -y --reinstall ca-certificates

WORKDIR /usr/local/src
RUN git clone --depth 1 -b ${GIT_TAG} https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git
ENV USE_MUSL=YES
RUN cd SoftEtherVPN_Stable &&\
  git submodule init &&\
  git submodule update &&\
  ./configure &&\
  make

ENTRYPOINT ["tail", "-F", "/dev/null"]
