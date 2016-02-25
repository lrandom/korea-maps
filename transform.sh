#!/bin/bash

SOURCE_DIR="output/merged_shp"
TARGET_DIR="output/transformed_shp"

# export SHAPE_ENCODING="EUC-KR"

# GRS80_UTMK
SOURCE_PROJECTION="+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

rm -rf $TARGET_DIR &> /dev/null
mkdir $TARGET_DIR &> /dev/null

ogr2ogr --config SHAPE_ENCODING "UTF-8" -s_srs "$SOURCE_PROJECTION" -t_srs WGS84 -f "ESRI Shapefile" -skipfailures $TARGET_DIR/state.shp $SOURCE_DIR/state.shp  -sql "SELECT CTPRVN_CD as code, CTP_KOR_NM as name from state" -oo ENCODING=CP949 -lco ENCODING=UTF-8
ogr2ogr --config SHAPE_ENCODING "UTF-8" -s_srs "$SOURCE_PROJECTION" -t_srs WGS84 -f "ESRI Shapefile" -skipfailures $TARGET_DIR/city.shp $SOURCE_DIR/city.shp -sql "SELECT SIG_CD as code, SIG_KOR_NM as name from city" -oo ENCODING=CP949 -lco ENCODING=UTF-8
ogr2ogr --config SHAPE_ENCODING "UTF-8" -s_srs "$SOURCE_PROJECTION" -t_srs WGS84 -f "ESRI Shapefile" -skipfailures $TARGET_DIR/dong.shp $SOURCE_DIR/dong.shp  -sql "SELECT EMD_CD as code, EMD_KOR_NM as name from dong" -oo ENCODING=CP949 -lco ENCODING=UTF-8