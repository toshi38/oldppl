#!/usr/bin/bash

#dump all of the images for each... 

#Grabbing from: http://percolator.modcam.io/compose/stpln/2016-04-21%2018:00/2016-04-21%2014:30
WEBPART1=http://percolator.modcam.io/compose/stpln/2016-04-22%20

for i in 0{1..9} {10..24}
do
	
	for j in 00 15 30 
	do
	next=$((j+15))
	addr=${WEBPART1}${i}:${j}/2016-04-22%20${i}:${next}
	echo "Grabbing": $addr
	wget $addr
	done;
	
#	nexthr=$((i+1))
#	echo "Grabbing": ${WEBPART1}${i}:45/2016-04-22%20${nexthr}:00

done;