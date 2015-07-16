# STATION3 KOREAN MAPS
#
# URL: https://github.com/station3/korea-maps
#
# Version 0.1
#

# pull base image
FROM debian:jessie
MAINTAINER bad79s <scpark@station3.co.kr>

RUN apt-get update  && \
    echo "==> Install Dependences"  && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y -q --force-yes --no-install-recommends openssh-client curl git gdal-bin postgis npm python p7zip-full && \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    npm install -g topojson

RUN echo "==> Download source..."  && \
    cd ~/  && \
    git clone https://github.com/station3/korea-maps.git  && \
    cd korea-maps

EXPOSE 8000