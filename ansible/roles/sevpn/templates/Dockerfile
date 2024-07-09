FROM alpine
ARG GIT_TAG=v4.41-9782-beta
RUN mkdir /usr/local/src && apk add binutils --no-cache \
  build-base \
  readline-dev \
  openssl-dev \
  ncurses-dev \
  git \
  cmake \
  zlib-dev \
  libsodium-dev \
  gnu-libiconv \
  make

WORKDIR /usr/local/src
RUN git clone --depth 1 -b ${GIT_TAG} https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git
ENV USE_MUSL=YES
RUN cd SoftEtherVPN_Stable &&\
  git submodule init &&\
  git submodule update &&\
  ./configure &&\
  make

FROM alpine
RUN apk add --no-cache readline \
  openssl \
  libsodium \
  gnu-libiconv\
  iptables
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
ENV LD_LIBRARY_PATH /root
WORKDIR /usr/local/bin
VOLUME /mnt
RUN ln -s /mnt/vpn_server.config vpn_server.config && \
  mkdir /mnt/backup.vpn_server.config &&\
  ln -s /mnt/backup.vpn_server.config backup.vpn_server.config &&\
  ln -s /mnt/lang.config lang.config
COPY --from=builder /usr/local/src/SoftEtherVPN/build/vpnserver /usr/local/src/SoftEtherVPN/build/vpncmd /usr/local/src/SoftEtherVPN/build/hamcore.se2 usr/local/src/SoftEtherVPN/build/libcedar.so usr/local/src/SoftEtherVPN/build/libmayaqua.so ./

EXPOSE 443/tcp 992/tcp 1194/tcp 1194/udp 5555/tcp 500/udp 4500/udp
CMD ["LD_LIBRARY_PATH=/usr/local/bin/", "/usr/local/bin/vpnserver", "execsvc"]
