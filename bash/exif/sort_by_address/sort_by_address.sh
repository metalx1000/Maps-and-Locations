#!/bin/bash

# 
# This file is part of the Maps-and-Locations (https://github.com/metalx1000/Maps-and-Locations http://FilmsByKris.com).
# Copyright (c) 2017 Kris Occhipinti.
# 
# This program is free software: you can redistribute it and/or modify  
# it under the terms of the GNU General Public License as published by  
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License 
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#

if [ "$#" -lt 1 ]
then
  echo "input error"
  echo "example usage: $0 photo.jpg"
  exit 1
fi

image="$1"

function noGPS(){
  echo "No GPS Found in Image..."
  exit 1
}

exiftool "$image"|grep "GPS Position"||noGPS


lat="$(exiftool "$image"|grep "GPS Position"|cut -d\: -f2|sed 's/ deg /+(/g'|sed "s/' /\/60)+(/"|sed 's/"/\/3600)/'|awk '{print $1}'|bc -l)"
long="-$(exiftool "$image"|grep "GPS Position"|cut -d\, -f2|sed 's/ deg /+(/g'|sed "s/' /\/60)+(/"|sed 's/"/\/3600)/'|awk '{print $1}'|bc -l)"

url="http://maps.google.com/maps/api/geocode/xml?latlng=$lat,$long&sensor=false"

echo "$lat,$long"
echo "$url"

data="$(wget -O- -q "$url")"

echo "$data"|\
  grep formatted|\
  head -n1|\
  cut -d\> -f2|\
  cut -d\< -f1

street="$(echo "$data"|grep '<type>route</type>' -B 1|head -n1|cut -d\> -f2|cut -d\< -f1)"
echo "$street"

number="$(echo "$data"|grep '<type>street_number</type>' -B 1|head -n1|cut -d\> -f2|cut -d\< -f1)"
echo "$number"

mkdir -p "./photos/${street}/${number}"
echo "Moving $image to ./photos/${street}/${number}/"
mv "$image" "./photos/${street}/${number}/"

