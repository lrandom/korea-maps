#!/bin/sh

# Transform from TM to WGS84
# false north (y_0) is 500000 (err? 306)
# false east (x_0) is 200000 (err? 72.5)

SOURCE_PROJECTION="+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=199927.5 +y_0=499694 +ellps=GRS80 +units=m +no_defs"
rm -r transformed_shp > /dev/null
mkdir transformed_shp

ogr2ogr -s_srs "$SOURCE_PROJECTION" -t_srs WGS84 -f "ESRI Shapefile" -skipfailures transformed_shp/state.shp 2013_1_0/temp.shp -lco ENCODING=UTF-8
ogr2ogr -s_srs "$SOURCE_PROJECTION" -t_srs WGS84 -f "ESRI Shapefile" -skipfailures transformed_shp/city.shp 2013_2_0/temp.shp -lco ENCODING=UTF-8
ogr2ogr -s_srs "$SOURCE_PROJECTION" -t_srs WGS84 -f "ESRI Shapefile" -skipfailures transformed_shp/dong.shp 2013_3_0/temp.shp -lco ENCODING=UTF-8