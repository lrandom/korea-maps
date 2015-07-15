#!/bin/sh

SOURCE_DIR="output/merged_shp"

for f in $(find $SOURCE_DIR -type f -name "*.7z")
do
7z x $f -o$SOURCE_DIR/*
done