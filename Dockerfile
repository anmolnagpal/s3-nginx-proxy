# Dockerfile

# Pull base image.
FROM debian:jessie

MAINTAINER AnmolNagpal <ianmolnagpal@gmail.com>

ENV NGINX_VERSION 1.15.1

RUN set -xe \
    && export LANG=C.UTF-8 \
    && export LC_ALL=en_US.UTF-8

# Setup
RUN set -xe \
    && apt-get -y update \
    && apt-get -y install curl build-essential libpcre3 libpcre3-dev zlib1g-dev libssl-dev git \
    && curl -LO http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    && tar zxf nginx-${NGINX_VERSION}.tar.gz \
    && cd nginx-${NGINX_VERSION} \
    && git clone -b AuthV2 https://github.com/anomalizer/ngx_aws_auth.git \
    && ./configure --with-http_ssl_module --add-module=ngx_aws_auth \
    && make install

# Remove
RUN cd /tmp \
    && rm -f nginx-${NGINX_VERSION}.tar.gz \
    && rm -rf nginx-${NGINX_VERSION}

# Cleanup
RUN set -xe \
    && apt-get purge -y curl git \
    && apt-get autoremove -y

# Create folder
RUN mkdir -p /data/cache

EXPOSE 8085 443

CMD [ "/usr/local/nginx/sbin/nginx", "-c", "/nginx.conf" ]
