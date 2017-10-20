version: '2'
services:
  plex:
    container_name: plex
    labels:
      io.rancher.container.hostname_override: container_name
    image: plexinc/pms-docker
    restart: unless-stopped
    ports:
      - 32400:32400/tcp
      - 3005:3005/tcp
      - 8324:8324/tcp
      - 32469:32469/tcp
      - 1900:1900/udp
      - 32410:32410/udp
      - 32412:32412/udp
      - 32413:32413/udp
      - 32414:32414/udp
    environment:
      - TZ=${TZ}
      - PLEX_CLAIM=${PLEX_CLAIM}
      - ADVERTISE_IP=http://${ADVERTISE_IP}:32400/
    volumes:
      - plex-database:/config
      - transcode-temp:/transcode
      - media:/data
volumes:
  transcode-temp:
    driver: ${VOLUME_DRIVER}
    per_container: true
  media:
    driver: ${VOLUME_DRIVER}
    per_container: true
  plex-database:
    driver: ${VOLUME_DRIVER}
    per_container: true
