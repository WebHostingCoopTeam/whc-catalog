version: '2'
services:
  zoneminder:
    image: bokbot/zoneminder
    restart: always
    labels:
      traefik.enable: true
      traefik.alias: ${ZONEMINDER_HOST}
      traefik.domain: ${ZONEMINDER_DOMAIN}
      traefik.acme: true
      traefik.port: 80
    {{- if ne .Values.host_label ""}}
      io.rancher.scheduler.affinity:host_label: ${host_label}
    {{- end}}
    environment:
      ROOT_URL: "http://${ZONEMINDER_HOST}.${ZONEMINDER_DOMAIN}"
    volumes:
      - zoneimages:/var/lib/zoneminder/images
      - zoneevents:/var/lib/zoneminder/events
      - zonemysql:/var/lib/mysql
      - zonelog:/var/log/zm
volumes:
  mongodata:
    driver: ${VOLUME_DRIVER}
    per_container: true
  zoneimages:
    driver: ${VOLUME_DRIVER}
    per_container: true
  zoneevents:
    driver: ${VOLUME_DRIVER}
    per_container: true
  zonemysql:
    driver: ${VOLUME_DRIVER}
    per_container: true
  zonelog:
    driver: ${VOLUME_DRIVER}
    per_container: true
