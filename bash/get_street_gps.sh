#!/bin/bash

#examples: 
#lat=26.26152844
#long=-81.51112916
echo "Retrieving street view..."

if [ "$#" -lt 2 ]
then
  echo "input error"
  echo "useage: $0 <latitude> <longitude>"
  echo "example useage: $0 26.26152844 -81.51112916"
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
