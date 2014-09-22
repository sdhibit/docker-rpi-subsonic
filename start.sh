#! /bin/sh

set -e

[ ! -L /data/transcode ] && ln -s /var/subsonic.transcode /data/transcode

/usr/share/subsonic/subsonic.sh
