#!/bin/bash

SOURCE_DIR="maps";
TARGET_DIR="output/transformed_shp";
FILENAME="TL_SPBD_BULD.shp";


# GRS80_UTMK
SOURCE_PROJECTION="+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

rm -rf $TARGET_DIR &> /dev/null
mkdir $TARGET_DIR &> /dev/null

for f in $(find $SOURCE_DIR -name "$FILENAME")
do
  SUB_DIR=$(echo $f | sed -E 's/maps\/([^\/]+)\/.*/\1/');
  DEST="$TARGET_DIR/$SUB_DIR/$FILENAME";
  echo $DEST;
  mkdir -p $TARGET_DIR/$SUB_DIR &> /dev/null
  ogr2ogr --config SHAPE_ENCODING "UTF-8" -s_srs "$SOURCE_PROJECTION" -t_srs WGS84 -f "ESRI Shapefile" -skipfailures $DEST $f -sql "SELECT BD_MGT_SN, BULD_NM, BULD_NM_DC, BULD_MNNM, BULD_SLNO, BDTYP_CD, BUL_DPN_SE, GRO_FLO_CO, UND_FLO_CO from TL_SPBD_BULD" -oo ENCODING=CP949 -lco ENCODING=UTF-8;
  shp2pgsql -a $DEST build >> "$TARGET_DIR/$SUB_DIR/build.sql";
done