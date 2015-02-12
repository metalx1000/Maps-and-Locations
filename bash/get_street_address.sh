#!/bin/bash

echo "Retrieving street view..."

if [ "$#" -lt 1 ]
then
  echo "input error"
  echo "usage: $0 '<address>'"
  echo "example usage: $0 '123 5th ave new york'"
  exit 1
fi

address=$1

get_view(){
  output="/tmp/$RANDOM.png"
  wget -q "https://maps.googleapis.com/maps/api/streetview?size=640x320&location=$address&heading=$1" -O $output
  display $output 
  rm $output 
}

for i in `seq 0 90 270`
do
  get_view $i &
done
