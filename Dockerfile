FROM linuxserver/rutorrent:latest

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Bachmma1 version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="bachmma1"


RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	zip && \
	unzip && \
 echo "**** install remote ****" && \
 mkdir -p /app/remote \
	/defaults/remote-conf \
	/tmp/remote/ && \
 curl -o \
 /tmp/remote.tar.gz -L \
	"https://github.com/bachmma1/rEmote/archive/v2.1.1.tar.gz" && \
 tar xf \
 /tmp/remote.tar.gz \
     -C /tmp/remote/ && \
 mv /tmp/remote/rEmote-2.1.1/remote/* \
	/app/remote/ && \
 echo "**** cleanup ****" && \
 rm -rf \
	/etc/nginx/conf.d/default.conf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config /downloads