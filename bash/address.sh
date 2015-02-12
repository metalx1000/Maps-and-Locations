#!/bin/bash

#examples: 
#lat=26.26152844
#long=-81.51112916

if [ "$#" -lt 2 ]
then
  echo "input error"
  echo "example usage: $0 26.26152844 -81.51112916"
  exit 1
fi

lat=$1
long=$2

wget -O- -q "http://maps.google.com/maps/api/geocode/xml?latlng=$lat,$long&sensor=false"|\
  grep formatted|\
  head -n1|\
  cut -d\> -f2|\
  cut -d\< -f1
