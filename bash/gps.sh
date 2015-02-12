#!/bin/bash

if [ "$#" -lt 1 ]
then
  echo "input error"
  echo "usage: $0 <adderss>"
  echo "example usage: $0 '123 5th Ave S Naples FL'"
  exit 1
fi

address=$1

wget -O- -q "https://maps.googleapis.com/maps/api/geocode/json?address=$address"|\
  grep -A2 '"location"'|\
  tail -n2|\
  cut -d\: -f2|\
  tr '\n' ' '

echo ""
