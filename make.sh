#!/bin/bash

# Simplifying Proportion(3%)
QUANTIZATION=1e5
PROPORTION=0.03

# Simplify the original ESRI Shapefile and generates TopoJSON.
# Map the *_name, *_code columns into name, code.
topojson -q $QUANTIZATION --simplify-proportion $PROPORTION -o topojson/regions.topojson -p code=code,name=name --shapefile-encoding utf8 -- shp/state.shp shp/city.shp shp/dong.shp

# Generates GeoJSON from TopoJSON
topojson-geojson topojson/regions.topojson -o geojson/ 

# Generates ESRI Shapefile from GeoJSON
rm simplified_shp/* > /dev/null
ogr2ogr -f "ESRI Shapefile" simplified_shp/state.shp geojson/state.json -lco ENCODING=UTF-8
ogr2ogr -f "ESRI Shapefile" simplified_shp/city.shp geojson/city.json -lco ENCODING=UTF-8
ogr2ogr -f "ESRI Shapefile" simplified_shp/dong.shp geojson/dong.json -lco ENCODING=UTF-8

# Generate SQL
rm sql/* > /dev/null
shp2pgsql simplified_shp/state.shp region >> sql/region.sql
shp2pgsql -a simplified_shp/city.shp region >> sql/region.sql
shp2pgsql -a simplified_shp/dong.shp region >> sql/region.sql

echo "create index region_geom on region using gist(geom);" >> sql/region.sql
