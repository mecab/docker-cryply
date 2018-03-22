FROM debian:9-slim AS builder
LABEL maintainer "mecab <mecab@misosi.ru>"

RUN apt-get update && \
    apt-get -y install curl git build-essential libtool autotools-dev automake pkg-config libssl1.0-dev libevent-dev bsdmainutils libboost-all-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev && \
    curl -L -o cryply.tar.gz https://github.com/cryply/cryply-wallet/archive/1.0.tar.gz && \
    sha256sum cryply.tar.gz && \
    echo '8638c95cb138698c44ef75d7aac5a7c310f1293c1a03d4aa9318e2bc7799e039  cryply.tar.gz' | sha256sum -c && \
    tar zxvf cryply.tar.gz && \
    cd cryply-wallet-1.0 && \
    CRYPLY_ROOT=$(pwd) && \
    BDB_PREFIX="${CRYPLY_ROOT}/db4" && \
    mkdir -p $BDB_PREFIX && \
    curl -L -O 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz' && \
    echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef  db-4.8.30.NC.tar.gz' | sha256sum -c && \
    tar -xzvf db-4.8.30.NC.tar.gz && \
    cd db-4.8.30.NC/build_unix/ && \
    ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$BDB_PREFIX && \
    make -j$(nproc) && \
    make install && \
    cd $CRYPLY_ROOT && \
    ./autogen.sh && \
    ./configure LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/" --disable-tests --prefix=/built && \
    make -j$(nproc) && \
    make install

FROM debian:9-slim
RUN apt-get -y update && \
    apt-get -y install git libssl1.0-dev libevent-dev libboost-all-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev libprotobuf-dev libqrencode-dev
COPY --from=builder /built /usr/local

ENTRYPOINT ["/usr/local/bin/cryplyd"]
VOLUME ["/data"]
CMD ["-datadir=/data"]
EXPOSE 48886 48887
