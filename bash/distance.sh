#!/bin/bash

address1="571 97th Ave N, Naples, FL 34108, USA"
address2="2645 16th Ave NE, Naples, FL 34120, USA"
wget -q -O- "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$address1&destinations=$address2&units=imperial"
