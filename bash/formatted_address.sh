#!/bin/bash

#examples: 
#lat=26.26152844
#long=-81.51112916

if [ "$#" -lt 1 ]
then
  echo "input error"
  echo "usage: $0 <adderss>"
  echo "example useage: $0 '123 5th Ave S Naples FL'"
  exit 1
fi

address=$1

wget -O- -q "http://maps.google.com/maps/api/geocode/xml?address=$address&sensor=false"|\
  grep formatted|\
  head -n1|\
  cut -d\> -f2|\
  cut -d\< -f1
