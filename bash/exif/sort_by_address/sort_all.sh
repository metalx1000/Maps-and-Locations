#!/bin/bash

for i in *.jpg
do 
  ./sort_by_address.sh "$i"
done
