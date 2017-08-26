#!/bin/bash
TMP=$(mktemp -d --suffix=DOCKERTMP)
cat docker-compose.yml.tpl \
  |sed 's/\${\(openemr_domain\)}/{{.\1}}/g' \
  |sed 's/\${\(openemr_host\)}/{{.\1}}/g' \
  |sed 's/\${\(.*\)}/{{.\1}}/g' \
  > $TMP/inter.tpl
echo ' '
#cat $TMP/inter.tpl
#vim $TMP/inter.tpl
gotpl $TMP/inter.tpl < local.yml
rm $TMP/inter.tpl
rmdir $TMP
