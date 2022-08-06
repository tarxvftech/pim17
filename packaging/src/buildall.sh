for each in $(ls -d */); do
	echo "starting $each"; 
	cd "$each"
	abuild -r
	cd -
	echo "done with $each"; 

done
