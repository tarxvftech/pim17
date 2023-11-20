#!/bin/sh
set -x

#dir="/home/builder/packages/src/$(uname -m)/"
arched_dir="/home/builder/packages/src"
noarched_dir="/home/builder/packages_noarch/src"
for arch in $(ls $arched_dir); do
	echo $arch;
	cd $arched_dir/$arch;
	echo "Copying the following noarch packages:"
	find "$noarched_dir" -type f \
		-iname "*.apk" \
		-print \
		-exec cp '{}' "$arched_dir"/"$arch"/ \;
	echo "adding to index"
	apk index --rewrite-arch $arch --no-warnings -vU -o APKINDEX.tar.gz *.apk
	#no warnings flag is specifically for suppressing the 'missing dependencies' bit
	echo "signing index"
	abuild-sign APKINDEX.tar.gz
	echo "done with $arch"; echo
done
