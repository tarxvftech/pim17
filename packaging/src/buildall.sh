#!/bin/sh
for each in $(ls -d */); do
	echo "starting $each"; 
	cd "$each"
	abuild checksum
	abuild -r
	cd -
	echo "done with $each"; 

done
