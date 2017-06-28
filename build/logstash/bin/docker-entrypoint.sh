#!/bin/bash -e

# Map environment variables to entries in logstash.yml.
# Note that this will mutate logstash.yml in place if any such settings are found.
# This may be undesirable, especially if logstash.yml is bind-mounted from the
# host system.
#env2yaml /usr/share/logstash/config/logstash.yml

if [ $ELASTICSEARCH_URL ]; then
  if [ -z $DRY_RUN ]; then
    # wait for elasticsearch to start up
    ELASTIC_PATH=${ELASTICSEARCH_URL:-elasticsearch:9200}
    echo "Configure ${ELASTIC_PATH}"

    counter=0
    while [ ! "$(curl $ELASTIC_PATH 2> /dev/null)" -a $counter -lt 30  ]; do
      sleep 1
      let counter++
      echo "waiting for Elasticsearch to be up ($counter/30)"
    done

    curl -XPUT "http://$ELASTIC_PATH/_template/lcnext" -d@/usr/share/logstash/map-templates/lcnext.json
    curl -XPUT "http://$ELASTIC_PATH/_template/analytics" -d@/usr/share/logstash/map-templates/analytics.json
    curl -XPUT "http://$ELASTIC_PATH/_template/monies" -d@/usr/share/logstash/map-templates/monies.json
  fi
fi

if [[ -z $1 ]] || [[ ${1:0:1} == '-' ]] ; then
  exec logstash "$@"
else
  exec "$@"
fi

