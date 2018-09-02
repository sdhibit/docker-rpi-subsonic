FROM resin/rpi-raspbian
MAINTAINER Jeremy Bush <contractfrombelow@gmail.com>

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
 apt-get update && \
 apt-get install --no-install-recommends -qy ca-certificates wget lame locales oracle-java8-jdk && \
 apt-get clean

WORKDIR /tmp
RUN wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-32bit-static.tar.xz && \
  mkdir ffmpeg && \
  tar -C ffmpeg --strip-components=1 -xvf ffmpeg-release-armhf-32bit-static.tar.xz && \
  mv ffmpeg/ffmpeg /usr/local/bin

ENV JAVA_HOME /opt/jdk1.8.0
ENV PATH $PATH:$JAVA_HOME/bin

ADD ./startup.sh /usr/share/subsonic/startup.sh

RUN useradd --home /var/subsonic -M -K UID_MIN=10000 -K GID_MIN=10000 -U subsonic && \
 mkdir -p /var/subsonic/transcode && \
 chown -R subsonic:subsonic /var/subsonic && \
 chmod -R 0770 /var/subsonic && \
 chown -R subsonic:subsonic /usr/share/subsonic && \
 chmod +x /usr/share/subsonic/startup.sh

#Download & Install Subsonic Standalone
RUN wget -P /tmp/ "https://s3-eu-west-1.amazonaws.com/subsonic-public/download/subsonic-6.1.3-standalone.tar.gz" && \
 tar zxvf /tmp/subsonic-6.1.3-standalone.tar.gz -C /usr/share/subsonic && \
 rm -rf /tmp/subsonic-6.1.3-standalone.tar.gz

#Subsonic Web Port
EXPOSE 4040
#DLNA Discovery Port
EXPOSE 1900/udp

VOLUME ["/var/subsonic", "/var/music"]

USER subsonic

CMD []
ENTRYPOINT ["/usr/share/subsonic/startup.sh"]
