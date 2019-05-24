# docker-rerutorrent
[Linuxserver.io docker-rutorrent][linuxsrvrutorrent] extended with rEmote (rtorrent-web-ui).

[rEmote][remoteurl] originally from [messyo][messyourl]; updated and refreshed from [bachmma1][bachmma1url]

[messyourl]: https://github.com/messyo
[bachmma1url]: https://github.com/bachmma1
[remotewikiurl]: https://github.com/bachmma1/rEmote/wiki
[linuxsrvrutorrent]: https://github.com/linuxserver/docker-rutorrent
[remoteurl]: https://github.com/bachmma1/rEmote

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=RemoteRuTorrent \
  -e PUID=1000 \
  -e PGID=1000 \
  -p 80:80 \
  -p 8080:8080 \
  -p 5000:5000 \
  -p 51413:51413 \
  -p 6881:6881/udp \
  -v </path/to/rutorrent/config>:/config \
  -v </path/to/rutorrent/downloads>:/downloads \
  --restart unless-stopped \
  bachmma1/RemoteRuTorrent
```


### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  rutorrent:
    image: bachmma1/RemoteRuTorrent
    container_name: RemoteRuTorrent
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - </path/to/rutorrent/config>:/config
      - </path/to/rutorrent/downloads>:/downloads
    ports:
      - 80:80
	  - 8080:8080
      - 5000:5000
      - 51413:51413
      - 6881:6881/udp
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 80` | ruTorrent Web UI |
| `-p 443` | ruTorrent Web UI Https
| `-p 8080` | rEmote Web UI Http
| `-p 8443` | rEmote Web UI Https
| `-p 5000` | scgi port |
| `-p 51413` | Bit-torrent port |
| `-p 6881/udp` | Bit-torrent DHT port |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-v /config` | where ruTorrent should store it's config files |
| `-v /downloads` | path to your downloads folder |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## Configuration files
* php:			/config/php
* rtorrent:		/config/rtorrent
* rutorrent:	/config/rutorrent/settings
* rEmote:		/config/remote



&nbsp;
## Application Setup

`** It should be noted that this container when run will create subfolders ,completed, incoming and watched in the /downloads volume.**`

### rTorrent

Umask can be set in the /config/rtorrent/rtorrent.rc file by changing value in `system.umask.set`

If you are seeing this error `Caught internal_error: 'DhtRouter::get_tracker did not actually insert tracker.'.` , a possible fix is to disable dht in `/config/rtorrent/rtorrent.rc` by changing the following values.

```shell
dht.mode.set = disable
protocol.pex.set = no
```

If after updating you see an error about connecting to rtorrent in the webui,
remove or comment out these lines in /config/rtorrent/rtorrent.rc ,whatever value is set, yes or no.
Just setting them to no will still cause the error..

```
trackers.use_udp.set = no
protocol.pex.set = no
```

### ruTorrent

ruTorrent can be found at `<your-ip>:80/rutorrent`

`Settings, changed by the user through the "Settings" panel in ruTorrent, are valid until rtorrent restart. After which all settings will be set according to the rtorrent config file (/config/rtorrent/rtorrent.rc),this is a limitation of the actual apps themselves.`

### rEmote

rEmote can be found at `<your-ip>:80/remote`

rEmote needs a mariadb backend to work properly. Make sure you have one set up and configured it:

```mariadb
CREATE DATABASE IF NOT EXISTS 'remoteDB';
CREATE USER 'remote'@'<ip of your rtorrent-docker-container>' IDENTIFIED BY 'remotepassword0815';
GRANT USAGE ON * . * TO 'remote'@'<ip of your rtorrent-docker-container>' IDENTIFIED BY 'remotepassword0815' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
GRANT ALL PRIVILEGES ON 'remoteDB' . * TO 'remote'@'<ip of your rtorrent-docker-container>';
FLUSH PRIVILEGES;
quit
```

`On very first run you have to install remote via <your-ip>:80/remote/install`

Link to the [wiki][remotewikiurl]

## UNRAID users

** Important note for unraid users or those running services such as a webserver on port 80, change port 80 assignment **

## Support Info

* Shell access whilst the container is running: `docker exec -it RemoteRuTorrent /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f RemoteRuTorrent`
* container version number 
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' RemoteRuTorrent`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' bachmma1/RemoteRuTorrent`


## Versions
* **23.05.19:** - Added rEmote as additional rTorrent Web UI
