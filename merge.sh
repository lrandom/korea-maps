#!/bin/bash

SOURCE_DIR="maps"
TARGET_DIR="output/merged_shp"

export SHAPE_ENCODING="EUC-KR"

rm -rf $TARGET_DIR &> /dev/null
mkdir -p $TARGET_DIR &> /dev/null

FILE="$TARGET_DIR/state.shp"
for f in $(find $SOURCE_DIR -name "TL_SCCO_CTPRVN.shp")
do
if [ -f $FILE ]
then
echo "merging... $f"
ogr2ogr -f "ESRI ShapeFILE" -update -append "$FILE" "$f" -nln State -lco ENCODING=UTF-8
else
echo "create $FILE"
ogr2ogr -f "ESRI ShapeFILE" "$FILE" "$f" -lco ENCODING=UTF-8
fi
done

FILE="$TARGET_DIR/city.shp"
for f in $(find $SOURCE_DIR -name "TL_SCCO_SIG.shp")
do
if [ -f $FILE ]
then
echo "merging... $f"
ogr2ogr -f "ESRI ShapeFILE" -update -append "$FILE" "$f" -nln City -lco ENCODING=UTF-8
else
echo "create $FILE"
ogr2ogr -f "ESRI ShapeFILE" "$FILE" "$f" -lco ENCODING=UTF-8
fi
done

FILE="$TARGET_DIR/dong.shp"
for f in $(find $SOURCE_DIR -name "TL_SCCO_EMD.shp")
do
if [ -f $FILE ]
then
echo "merging... $f"
ogr2ogr -f "ESRI ShapeFILE" -update -append "$FILE" "$f" -nln Dong -lco ENCODING=UTF-8
else
echo "create $FILE"
ogr2ogr -f "ESRI ShapeFILE" "$FILE" "$f" -lco ENCODING=UTF-8
fi
done