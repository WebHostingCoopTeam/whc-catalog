version: '2'
services:
  openemr:
    restart: always
    image: ${TAG}
    ports:
    - ${PORT}:80
    labels:
      io.rancher.sidekicks: openemr-data,db
    hostname: ${openemr_host}.${openemr_domain}
    environment:
    - MYSQL_USER=${DB_USER}
    - MYSQL_DATABASE=${DB_NAME}
    - MYSQL_PASSWORD=${DB_PASS}
    - MYSQL_ROOT_PASSWORD=${DB_ROOT_PASS}
  db:
    restart: always
    image: mysql:5.7
    volumes_from:
    - openemr-data
    labels:
      io.rancher.sidekicks: openemr-data
    environment:
    - MYSQL_USER=${DB_USER}
    - MYSQL_DATABASE=${DB_NAME}
    - MYSQL_PASSWORD=${DB_PASS}
    - MYSQL_ROOT_PASSWORD=${DB_ROOT_PASS}
  openemr-data:
    labels:
      io.rancher.container.start_once: 'true'
      io.rancher.container.hostname_override: container_name
      io.rancher.container.pull_image: always
    command: /bin/true
    image: busybox
    volume_driver: ${VOLUME_DRIVER}
    volumes:
    - /var/lib/mysql
