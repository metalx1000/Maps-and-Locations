#!/bin/bash

#examples: 
#lat=26.26152844
#long=-81.51112916
echo "Retrieving Map..."

if [ "$#" -lt 2 ]
then
  echo "input error"
  echo "useage: $0 <latitude> <longitude> <type> <zoom>"
  echo "example useage: $0 26.26152844 -81.51112916 satellite 15"
  echo "type examples: roadmap, terrain, satellite, hybrid"
  echo "hybrid is default"
  exit 1
fi

if [ "$4" = "" ]
then
  zoom="15"
else
  zoom="$4"
fi

if [ "$3" = "" ]
then
  type="hybrid"
else
  type="$3"
fi


lat=$1
long=$2
output="/tmp/$RANDOM.png"

wget -q "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=$zoom&size=512x512&maptype=$type" -O $output

display $output
rm $output
