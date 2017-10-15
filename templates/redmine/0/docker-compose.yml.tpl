version: '2'

services:
  redmine:
    image: ${REDMINE_TAG}
    labels:
      {{- if .Values.DB_HOST "db"}}
      io.rancher.sidekicks: db
      {{- end}}
      io.rancher.container.hostname_override: container_name
      io.rancher.container.pull_image: always
      traefik.enable: true
      traefik.alias: ${REDMINE_HOST}
      traefik.domain: ${REDMINE_DOMAIN}
      traefik.acme: true
      traefik.port: 80
    {{- if ne .Values.host_label ""}}
      io.rancher.scheduler.affinity:host_label: ${host_label}
    {{- end}}
    environment:
    - REDMINE_HOST=${REDMINE_HOST}
    - REDMINE_DOMAIN=${REDMINE_DOMAIN}
    - PORT=${PORT}
    - VOLUME_NAME=${VOLUME_NAME}
    - PG_VOLUME_NAME=${PG_VOLUME_NAME}
    - VOLUME_DRIVER=${VOLUME_DRIVER}
    - TZ=${TZ}
    - DB_PASS=${DB_PASS}
    - DB_ADAPTER=${DB_ADAPTER}
    - DB_HOST=${DB_HOST}
    {{- if ne .Values.DB_PORT ""}}
      {{- if .Values.DB_ADAPTOR "mysql2"}}
    - DB_PORT=3306
      {{- else if .Values.db_adaptor "postgresql"}}
    - DB_PORT=5432
      {{- end}}
    {{- else}}
    - DB_PORT=${DB_PORT}
    {{- end}}
    - DB_USER=${DB_USER}
    - DB_NAME=${DB_NAME}
    - REDMINE_HTTPS=${REDMINE_HTTPS}
    - REDMINE_RELATIVE_URL_ROOT=${REDMINE_RELATIVE_URL_ROOT}
    - REDMINE_SECRET_TOKEN=${REDMINE_SECRET_TOKEN}
    - REDMINE_SUDO_MODE_ENABLED=${REDMINE_SUDO_MODE_ENABLED}
    - REDMINE_SUDO_MODE_TIMEOUT=${REDMINE_SUDO_MODE_TIMEOUT}
    - REDMINE_CONCURRENT_UPLOADS=${REDMINE_CONCURRENT_UPLOADS}
    - REDMINE_BACKUP_SCHEDULE=${REDMINE_BACKUP_SCHEDULE}
    - REDMINE_BACKUP_EXPIRY=${REDMINE_BACKUP_EXPIRY}
    - REDMINE_BACKUP_TIME=${REDMINE_BACKUP_TIME}
    - SMTP_ENABLED=${SMTP_ENABLED}
    - SMTP_HOST=${SMTP_HOST}
    - SMTP_AUTHENTICATION=${SMTP_AUTHENTICATION}
    - SMTP_METHOD=${SMTP_METHOD}
    - SMTP_DOMAIN=${SMTP_DOMAIN}
    - SMTP_PORT=${SMTP_PORT}
    - SMTP_USER=${SMTP_USER}
    - SMTP_PASS=${SMTP_PASS}
    - SMTP_STARTTLS=${SMTP_STARTTLS}
    - IMAP_ENABLED=${IMAP_ENABLED}
    - IMAP_HOST=${IMAP_HOST}
    - IMAP_PORT=${IMAP_PORT}
    - IMAP_USER=${IMAP_USER}
    - IMAP_PASS=${IMAP_PASS}
    - IMAP_SSL=${IMAP_SSL}
    - IMAP_INTERVAL=${IMAP_INTERVAL}
    volumes:
    - redmine-datavolume:/home/redmine/data
    - redmine-log-datavolume:/var/log/redmine
{{- if ne .Values.db_link ""}}
    external_links:
      - ${db_link}:db
    tty: true
{{- else}}
 {{- if .Values.DB_HOST "db"}}
  {{- if .Values.DB_ADAPTOR "mysql2"}}
  db:
    restart: always
    image: mariadb
    volumes:
    - redmine-db-datavolume:/var/lib/mysql
    labels:
      io.rancher.sidekicks: redmine-datavolume
      io.rancher.container.pull_image: always
    {{- if ne .Values.host_label ""}}
      io.rancher.scheduler.affinity:host_label: ${host_label}
    {{- end}}
    environment:
    - MYSQL_USER=${DB_USER}
    - MYSQL_PASSWORD=${DB_PASS}
    - MYSQL_ROOT_PASSWORD=${DB_PASS}
    - MYSQL_DATABASE=${DB_NAME}
  {{- else if .Values.db_adaptor "postgresql"}}
  db:
    restart: always
    image: postgres:9.6-alpine
    volumes:
    - redmine-db-datavolume:/var/lib/postgresql/data
    labels:
      io.rancher.sidekicks: redmine-datavolume
      io.rancher.container.pull_image: always
    {{- if ne .Values.host_label ""}}
      io.rancher.scheduler.affinity:host_label: ${host_label}
    {{- end}}
    environment:
    - POSTGRES_USER=${DB_USER}
    - POSTGRES_PASSWORD=${DB_PASS}
    - POSTGRES_DB=${DB_NAME}
    - PGDATA='/var/lib/postgresql/data'
  {{- end}}
 {{- end}}
{{- end}}
  memcached:
    restart: always
    image: memcached:1.5-alpine
    mem_limit: ${MEMCACHE}
volumes:
  redmine-datavolume:
    driver: ${VOLUME_DRIVER}
    per_container: true
  redmine-log-datavolume:
    driver: ${VOLUME_DRIVER}
    per_container: true
 {{- if .Values.DB_HOST "db"}}
  redmine-db-datavolume:
    driver: ${VOLUME_DRIVER}
    per_container: true
  {{- end}}
