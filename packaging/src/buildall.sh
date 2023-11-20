#!/bin/sh
ulimit -Sn
ulimit -Hn
ulimit -Sn 1024
ulimit -Hn 524288
ulimit -Sn
ulimit -Hn
for each in $(ls -d */); do
	echo "starting $each"; 
	cd "$each"
	abuild checksum
	abuild -r
	cd -
	echo "done with $each"; 

done
