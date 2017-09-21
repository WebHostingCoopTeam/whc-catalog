version: '2'
services:
  whmcs:
    image: webhostingcoopteam/whmcs
    restart: always
    labels:
      traefik.enable: true
      traefik.alias: ${WHMCS_HOST}
      traefik.domain: ${WHMCS_DOMAIN}
      traefik.acme: true
      traefik.port: 3000
    {{- if ne .Values.host_label ""}}
      io.rancher.scheduler.affinity:host_label: ${host_label}
    {{- end}}
    environment:
      DOMAIN: "${WHMCS_HOST}.${WHMCS_DOMAIN}"
      ROOT_URL: "http://${WHMCS_HOST}.${WHMCS_DOMAIN}"
      DB_NAME: ${DB_NAME}
      DB_USERNAME: ${DB_USERNAME}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_HOST: ${DB_HOST}
      LICENSE: ${LICENSE}
      TEMPLATES_COMPILEDIR: ${TEMPLATES_COMPILEDIR}
{{- if ne .Values.mysql_link ""}}
    external_links:
      - ${mysql_link}:mysql
    tty: true
{{- else}}
  mysql:
    image: mysql:5.7
    restart: always
    environment:
      CATTLE_SCRIPT_DEBUG: ${debug}
      DB_NAME: ${DB_NAME}
      DB_USERNAME: ${DB_USERNAME}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_HOST: ${DB_HOST}
    labels:
      io.rancher.container.hostname_override: ${WHMCS_HOST}.${WHMCS_DOMAIN}
    {{- if ne .Values.host_label ""}}
      io.rancher.scheduler.affinity:host_label: ${host_label}
    {{- end}}
    volumes:
      - mysqldata:/var/lib/mysql
volumes:
  mysqldata:
    driver: ${VOLUME_DRIVER}
    per_container: true
{{- end}}
