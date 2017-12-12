FROM ubuntu
# MAINTAINER

# origin from @link https://libertty.org/gitlab/tnakajima/docker-squid-ssl

# set squid version on `docker build` with `--build-arg SQUID_VERSION=<version>`
ARG SQUID_VERSION=${SQUID_VERSION}

# update the system and install dependent packages
RUN sed -i s/archive.ubuntu.com/jp.archive.ubuntu.com/g /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y build-essential libssl-dev wget

# add user for squid execution
RUN useradd -m squid

# build binary from source
USER squid
RUN mkdir -p /home/squid/local/src
WORKDIR /home/squid/local/src
RUN wget http://www.squid-cache.org/Versions/v3/3.5/squid-${SQUID_VERSION}.tar.bz2
RUN tar xf squid-${SQUID_VERSION}.tar.bz2
WORKDIR /home/squid/local/src/squid-${SQUID_VERSION}
RUN ./configure --prefix=/home/squid/local --with-openssl
RUN make -j2
RUN make install

# place server certificate and private key
COPY ssl /home/squid/ssl

# place configuration files and scripts
COPY squid.conf /home/squid/local/etc/squid.conf
COPY basic-credentials /home/squid/local/etc/squid/basic-credentials
COPY start.sh /home/squid/start.sh

# fix permissions
USER root
RUN chown -R squid:squid /home/squid/ssl /home/squid/local/etc /home/squid/start.sh
RUN chmod -R 400 /home/squid/ssl/* /home/squid/local/etc/squid/basic-credentials
RUN chmod -R 700 /home/squid/ssl

# start proxy server
USER squid
WORKDIR /
EXPOSE 3128
CMD ["bash", "/home/squid/start.sh"]
