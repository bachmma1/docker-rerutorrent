# docker-rerutorrent
Linuxserver.io docker-rutorrent extended with rEmote (rtorrent-web-ui) originally from [messyo][messyourl] get back alive from [bachmma1][bachmma1url]

[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/irc/
[podcasturl]: https://www.linuxserver.io/podcast/
[appurl]: https://github.com/Novik/ruTorrent
[messyourl]: https://github.com/messyo
[bachmma1url]: https://github.com/bachmma1
[remotewikiurl]: https://github.com/bachmma1/rEmote/wiki

Find [linuxserver.io][linuxserverurl] for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

## Usage

```
docker create --name=rutorrent \
-v <path to data>:/config \
-v <path to downloads>:/downloads \
-e PGID=<gid> -e PUID=<uid> \
-e TZ=<timezone> \
-p 80:80 -p 5000:5000 \
-p 51413:51413 -p 6881:6881/udp \
linuxserver/rutorrent
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `-p 80` - the http port
* `-p 443` - the https port
* `-p 5000` - the scgi port
* `-p 51413` - the rtorrent port(s)
* `-p 6881/udp` - the dht port
* `-v /config` - where the config files should be stored
* `-v /downloads` - path to your downloads folder
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e TZ` for timezone information, eg Europe/London

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it rutorrent /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Configuration files
* php:			/config/php
* rtorrent:		/config/rtorrent
* rutorrent:	/config/rutorrent/settings
* rEmote:		/config/remote


## Setting up the application

`** It should also be noted that this container when run will create subfolders ,completed, incoming and watched in the /downloads volume.**`

** The Port Assignments and configuration folder structure has been changed from the previous ubuntu based versions of this container and we recommend a clean install **


### rTorrent

Umask can be set in the /config/rtorrent/rtorrent.rc file by changing value in `system.umask.set` 

If you are seeing this error `Caught internal_error: 'DhtRouter::get_tracker did not actually insert tracker.'.` , a possible fix is to disable dht in `/config/rtorrent/rtorrent.rc` by changing the following values.

```shell
dht = disable
peer_exchange = no
```

If after updating you see an error about connecting to rtorrent in the webui, 
remove or comment out these lines in /config/rtorrent/rtorrent.rc ,whatever value is set, yes or no.
Just setting them to no will still cause the error..

```
use_udp_trackers = yes
peer_exchange = yes
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

## Info

* Shell access whilst the container is running: `docker exec -it rutorrent /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f rutorrent`

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' rutorrent`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/rutorrent`