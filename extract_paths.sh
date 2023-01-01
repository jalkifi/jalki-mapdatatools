#!/bin/bash

if [[ -d /data ]]; then
	path_types=(paths_0 paths_1 paths_2 paths_3 unpaved paved cobblestone)
	for t in ${path_types[@]}; do
		cat /opt/$t.query | osm3s_query --db-dir=/data/overpass_data > /tmp/$t.osm
		node --max_old_space_size=6000 osmtogeojson /tmp/$t.osm > /tmp/$t.geojson
		tippecanoe -o /data/$t.mbtiles /tmp/$t.geojson
		mbtiles2tiles.sh /data/$t.mbtiles /data/$t-tiles
	done
else
	echo "Error: /data does not exist"
	exit 1
fi
