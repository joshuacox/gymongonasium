FROM ubuntu:xenial

ENV \
  BUILD_PACKAGES='sudo make automake libtool pkg-config' \
  KEEP_PACKAGES='curl git libaio-dev vim-common libmysqlclient-dev libpq-dev unzip' \
  LUA_PKG='libmongoc-dev libbson-dev luarocks' \
  SUDO_FORCE_REMOVE=yes \
  GYMONGONASIUM_UPDATED=20171112

RUN DEBIAN_FRONTEND=noninteractive \
  && apt-get -qq update && apt-get -qqy dist-upgrade \
  && apt-get -qqy --no-install-recommends install ca-certificates apt-transport-https software-properties-common \
  && apt-get -qqy --no-install-recommends install \
     $BUILD_PACKAGES \
     $KEEP_PACKAGES \
     $LUA_PKG \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL'>> /etc/sudoers \
  && curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh | sudo bash \
  && sudo apt -y install sysbench \
  && sudo apt -y remove sysbench \
  && cd /usr/local \
  && git clone --depth 1 https://github.com/akopytov/sysbench.git \
  && git clone --depth 1 https://github.com/Percona-Lab/sysbench-mongodb-lua.git \
  && git clone --depth 1 https://github.com/mongodb-labs/mongorover.git \
  && cd sysbench \
  && ./autogen.sh \
  && LDFLAGS=-L/usr/local/opt/openssl/lib ./configure --with-pgsql \
  && make -j \
  && make install \
  && cd /usr/local/mongorover

RUN echo 'break' \
  && cd /usr/local/mongorover \
  && luarocks make mongorover*.rockspec \
  && cd /usr/local/sysbench-mongodb-lua \
  && apt-get -qqy remove \
     $BUILD_PACKAGES \
  && rm -Rf /usr/local/sysbench \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/*

WORKDIR /usr/local/sysbench-mongodb-lua

COPY assets /assets
ENTRYPOINT [ "/assets/start" ]
