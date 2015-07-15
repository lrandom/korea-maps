#!/bin/sh

SOURCE_DIR="output/merged_shp"
TARGET_DIR="output/transformed_shp"

# export SHAPE_ENCODING="EUC-KR"

# GRS80_UTMK
SOURCE_PROJECTION="+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

rm -rf $TARGET_DIR &> /dev/null
mkdir $TARGET_DIR &> /dev/null

ogr2ogr -s_srs "$SOURCE_PROJECTION" -t_srs WGS84 -f "ESRI Shapefile" -skipfailures $TARGET_DIR/state.shp $SOURCE_DIR/state.shp  -sql "SELECT CTPRVN_CD as code, CTP_KOR_NM as name from state" -lco ENCODING=UTF-8
ogr2ogr -s_srs "$SOURCE_PROJECTION" -t_srs WGS84 -f "ESRI Shapefile" -skipfailures $TARGET_DIR/city.shp $SOURCE_DIR/city.shp -sql "SELECT SIG_CD as code, SIG_KOR_NM as name from city" -lco ENCODING=UTF-8
ogr2ogr -s_srs "$SOURCE_PROJECTION" -t_srs WGS84 -f "ESRI Shapefile" -skipfailures $TARGET_DIR/dong.shp $SOURCE_DIR/dong.shp  -sql "SELECT EMD_CD as code, EMD_KOR_NM as name from dong" -lco ENCODING=UTF-8


# Convert to CSV files from dbf files.		
ogr2ogr -F "CSV" $TARGET_DIR/state.csv $TARGET_DIR/state.dbf
ogr2ogr -F "CSV" $TARGET_DIR/city.csv $TARGET_DIR/city.dbf
ogr2ogr -F "CSV" $TARGET_DIR/dong.csv $TARGET_DIR/dong.dbf
rm -rf $TARGET_DIR/*.dbf &> /dev/null

iconv -f EUC-KR -t UTF-8 $TARGET_DIR/state.csv > $TARGET_DIR/state.utf-8.csv
iconv -f EUC-KR -t UTF-8 $TARGET_DIR/city.csv > $TARGET_DIR/city.utf-8.csv
iconv -f EUC-KR -t UTF-8 $TARGET_DIR/dong.csv > $TARGET_DIR/dong.utf-8.csv

# Convert back to dbf files in UTF-8.		
ogr2ogr -F "ESRI Shapefile" $TARGET_DIR/state.dbf $TARGET_DIR/state.utf-8.csv -lco ENCODING=UTF-8		
ogr2ogr -F "ESRI Shapefile" $TARGET_DIR/city.dbf $TARGET_DIR/city.utf-8.csv -lco ENCODING=UTF-8		
ogr2ogr -F "ESRI Shapefile" $TARGET_DIR/dong.dbf $TARGET_DIR/dong.utf-8.csv -lco ENCODING=UTF-8

rm -rf $TARGET_DIR/*.csv &> /dev/null