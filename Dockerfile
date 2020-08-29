ARG version=0.20.1

FROM debian:buster as stage1
ARG version
WORKDIR /the/workdir
ARG file=bitcoin-${version}-x86_64-linux-gnu.tar.gz
RUN apt update
RUN apt install -y wget
RUN wget https://bitcoin.org/bin/bitcoin-core-${version}/${file}
RUN tar -vxf ${file}
RUN chmod +x /the/workdir/bitcoin-${version}/bin/bitcoind

FROM photon
ARG version
COPY --from=stage1 /the/workdir/bitcoin-${version}/bin/bitcoind /app/bitcoind
EXPOSE 8332
VOLUME /data
ENTRYPOINT [ "/app/bitcoind", "-datadir=/data", "-server", "-rpcport=8332", "-rpcuser=bitcoin", "-rpcpassword=password" ]
