#!/bin/bash

#examples: 
#lat=26.26152844
#long=-81.51112916
echo "Retrieving Map..."

if [ "$#" -lt 2 ]
then
  echo "input error"
  echo "useage: $0 <latitude> <longitude> <zoom>"
  echo "example useage: $0 26.26152844 -81.51112916 15"
  exit 1
fi

if [ "$3" = "" ]
then
  zoom="15"
else
  zoom="$3"
fi

lat=$1
long=$2
output="/tmp/$RANDOM.png"

wget -q "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=$zoom&size=512x512" -O $output

display $output
rm $output
