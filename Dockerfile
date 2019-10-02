FROM linuxserver/rutorrent:latest

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Bachmma1 version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="bachmma1"


RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache --upgrade \
	openrc \
	php7-xmlrpc \
	php7-gd \
	php7-pdo \
	php7-pdo_mysql \
	php7-sysvsem \
	coreutils \
	htop \
	wget \
	bzip2 \
	mktorrent \
	unzip && \
 echo "**** install remote ****" && \
 mkdir -p \ 
    /app/remote \
	/defaults/remote-conf \
	/tmp/remote/ && \
 curl -o \
 /tmp/remote.tar.gz -L \
	"https://github.com/bachmma1/rEmote/archive/v2.1.4.tar.gz" && \
 tar xf \
 /tmp/remote.tar.gz \
     -C /tmp/remote/ && \
 mv /tmp/remote/rEmote-2.1.4/remote/* \
	/app/remote/ && \
 chmod -R 777 /var/tmp/ && \
 echo "**** cleanup ****" && \
 rm -rf \
	/etc/nginx/conf.d/default.conf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443 8080 8443
VOLUME /config /downloads
