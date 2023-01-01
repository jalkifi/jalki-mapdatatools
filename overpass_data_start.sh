#!/bin/bash

if [[ -f "/data/finland-latest.osm.bz2" ]]; then
	mkdir -p /data/overpass_data
	/opt/overpass/bin/init_osm3s.sh /data/finland-latest.osm.bz2 /data/overpass_data /opt/overpass

	nohup /opt/overpass/bin/dispatcher --osm-base --db-dir=/data/overpass_data &
	nohup /opt/overpass/bin/dispatcher --areas --db-dir=/data/overpass_data &

	/opt/overpass/bin/osm3s_query --progress --rules </opt/rules/areas.osm3s
else
	echo "Error: /data/finland-latest.osm.bz2 does not exist"
	exit 1
fi
