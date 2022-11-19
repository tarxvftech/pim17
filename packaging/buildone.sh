#!/bin/sh
echo build $1
for arch in armhf aarch64 x86_64; do
	echo on $arch
	sudo docker run --rm -it \
		-v "$PWD"/src:/src \
		-v "$PWD"/packages:/home/builder/packages \
		-v "$PWD"/abuild:/home/builder/.abuild \
		pim17:$arch sh /src/buildone.sh $1
done
