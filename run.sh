#!/bin/bash

root_dir=`pwd`

# STEP 0: Download latest dataset

#wget http://download.geofabrik.de/europe/finland-latest.osm.pbf
#wget http://download.geofabrik.de/europe/finland-latest.osm.bz2


# STEP 1: OSRM data

routing_types=(car foot bicycle)
for t in ${routing_types[@]}; do
	mkdir -p $root_dir/osrm_data/$t
	cd $root_dir/osrm_data/$t
	docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-extract -p /opt/$t.lua /data/finland-latest.osm.pbf
	docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-partition /data/finland-latest.osrm
	docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-customize /data/finland-latest.osrm
done

# STEP 2: Overpass data

mkdir -p $root_dir/overpass_data
cd $root_dir/overpass_data
ln ../finland-latest.osm.pbf .
docker run -it -v "${PWD}:/data/" jalkimapdatatools overpass_data_start.sh
docker run -it -v "${PWD}:/data/" jalkimapdatatools overpass_data_stop.sh

# STEP 3: Tiles

cd $root_dir/tools/openmaptiles/data
ln $root_dir/finland-latest.osm.pbf .
cd ..
make db-start
make import-water
make import-natural-earth
make import-lakelines
make import-osm
make import-borders
make import-wikidata
make import-sql
make generate-tiles
make db-stop
cd $root_dir
docker run -it -v "${PWD}/openmaptiles/data:/data" jalkimapdatatools mbtiles2tiles.sh /data/tiles.mbtiles /data/tiles

# STEP 4: Additional tile layer

docker run -it -v "${PWD}:/data" jalkimapdatatools extract_paths.sh
