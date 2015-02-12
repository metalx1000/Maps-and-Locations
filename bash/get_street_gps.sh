#!/bin/bash

echo "Retrieving street view..."

if [ "$#" -lt 2 ]
then
  echo "input error"
  echo "usage: $0 <latitude> <longitude>"
  echo "example usage: $0 40.714728 -73.998672"
  exit 1
fi

lat=$1
long=$2

get_view(){
  output="/tmp/$RANDOM.png"
  wget -q "https://maps.googleapis.com/maps/api/streetview?size=640x320&location=$lat,$long&heading=$1" -O $output
  display $output 
  rm $output 
}

for i in `seq 0 90 270`
do
  get_view $i &
done
