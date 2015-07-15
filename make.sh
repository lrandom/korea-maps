#!/bin/bash

SOURCE_DIR="output/transformed_shp"
SIMPLIFIED_TARGET_DIR="output/simplified_shp"
SQL_TARGET_DIR="output/sql"
TOPOJON_TARGET_DIR="output/topojson"
GEOJSON_TARGET_DIR="output/geojson"

# export SHAPE_ENCODING="EUC-KR"

# Simplifying Proportion(3%)
QUANTIZATION=1e5
PROPORTION=0.06

# Simplify the original ESRI Shapefile and generates TopoJSON.
# Map the *_name, *_code columns into name, code.
rm -rf $TOPOJON_TARGET_DIR &> /dev/null
mkdir -p $TOPOJON_TARGET_DIR &> /dev/null
topojson -q $QUANTIZATION --simplify-proportion $PROPORTION -o $TOPOJON_TARGET_DIR/regions.topojson -p code=code,name=name --shapefile-encoding UTF-8 -- $SOURCE_DIR/state.shp $SOURCE_DIR/city.shp $SOURCE_DIR/dong.shp

# Generates GeoJSON from TopoJSON
rm -rf $GEOJSON_TARGET_DIR > /dev/null
mkdir -p $GEOJSON_TARGET_DIR > /dev/null
topojson-geojson $TOPOJON_TARGET_DIR/regions.topojson -o $GEOJSON_TARGET_DIR/ 

# Generates ESRI Shapefile from GeoJSON
rm -rf $SIMPLIFIED_TARGET_DIR &> /dev/null
mkdir -p $SIMPLIFIED_TARGET_DIR &> /dev/null
ogr2ogr -f "ESRI Shapefile" $SIMPLIFIED_TARGET_DIR/state.shp $GEOJSON_TARGET_DIR/state.json -lco ENCODING=UTF-8
ogr2ogr -f "ESRI Shapefile" $SIMPLIFIED_TARGET_DIR/city.shp $GEOJSON_TARGET_DIR/city.json -lco ENCODING=UTF-8
ogr2ogr -f "ESRI Shapefile" $SIMPLIFIED_TARGET_DIR/dong.shp $GEOJSON_TARGET_DIR/dong.json -lco ENCODING=UTF-8

# Generate SQL
rm -rf $SQL_TARGET_DIR &> /dev/null
mkdir -p $SQL_TARGET_DIR &> /dev/null
shp2pgsql $SIMPLIFIED_TARGET_DIR/state.shp region >> $SQL_TARGET_DIR/region.sql
shp2pgsql -a $SIMPLIFIED_TARGET_DIR/city.shp region >> $SQL_TARGET_DIR/region.sql
shp2pgsql -a $SIMPLIFIED_TARGET_DIR/dong.shp region >> $SQL_TARGET_DIR/region.sql

echo "create index region_geom on region using gist(geom);" >> $SQL_TARGET_DIR/region.sql