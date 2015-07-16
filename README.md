Korea Maps
==========
South Korea regional boundary in simplified ESRI Shapefile, GeoJSON, and TopoJSON.


## Requirement
 - [GDAL](http://www.gdal.org)
 - [postgis](http://www.postgis.net/)
 - [topojson](https://github.com/mbostock/topojson)
 - iconv

## Usage

### Generating Simplified ESRI Shapefile, GeoJSON, and TopoJSON
The make.sh shell script simplifies the original shape files and generates to the topojson files using topojson CLI. GeoJSON and ESRI Shapefile are generated from the topojson files.
 - ./maps : Original shape file
 - ./output/transformed_shp : Transformed shape file
 - ./output/simplified_shp : Simplified shape file
 - ./output/topojson : TopoJson
 - ./output/geojson : GeoJson

```bash
$ ./merge.sh # TL_SCCO_CTPRVN.shp, TL_SCCO_SIG.shp, TL_SCCO_EMD.shp data merge
$ ./transform.sh # Encoding EUC-KR -> UTF-8 And Change column names.
$ ./make.sh # Create simplified shp, geojoin, topojson, postgresql query
```

### Simplified Regional Boundary on Google Map.
Visit here(http://www.station3.co.kr/korea-maps).

Or run on the local machine(It requires Python).

```bash
$ ./run.sh
```

### Docker
1. Download Dabasource to ./maps
 - Datasource the Station3 AWS S3 > korea-maps
2. Docker install
3. Docker run
```bash
$ docker run -it -v `pwd`/maps:/root/korea-maps/maps -v `pwd`/output:/root/korea-maps/output station3/korea-maps
```

## Note

### Encoding conversion from the Shapefiles attributes(*.dbf)
The column names and attributes are written in Korean(euc-kr). But, it's difficult to use the non-english column names in Database or JavaScript code.

 - CTPRVN_CD, CTP_KOR_NM => code, name
 - SIG_CD, SIG_KOR_NM => code, name
 - EMD_CD, EMD_KOR_NM => code, name

### We Use It in Production
An awesome real estate service in South Korea, Dabang(http://www.dabangapp.com).

## Copyrights and License

### Author
Heehong Moon, Jeahyeok Song

### Datasource
국가공간정보유통시스템(http://www.nsic.go.kr) > 공간정보 구매 > 무료 공간정보 > 도로명 전자지도

### License
Copyright 2013 Station3, Inc under the Eclipse Public License.
