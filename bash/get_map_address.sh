#!/bin/bash

#examples: 
#lat=26.26152844
#long=-81.51112916
echo "Retrieving Map..."

if [ "$#" -lt 1 ]
then
  echo "input error"
  echo "useage: $0 '<address>' <type> <zoom>"
  echo "example useage: $0 '123 5th ave new york' satellite 15"
  echo "type examples: roadmap, terrain, satellite, hybrid"
  echo "hybrid is default"
  exit 1
fi

if [ "$3" = "" ]
then
  zoom="15"
else
  zoom="$3"
fi

if [ "$2" = "" ]
then
  type="hybrid"
else
  type="$2"
fi


address=$1
output="/tmp/$RANDOM.png"

wget -q "https://maps.googleapis.com/maps/api/staticmap?center=$address&zoom=$zoom&size=512x512&maptype=$type" -O $output

display $output
rm $output
