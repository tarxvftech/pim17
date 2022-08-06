img:
	sudo docker pull arm32v6/alpine:latest
	sudo docker pull arm32v7/alpine:latest
	sudo docker pull arm64v8/alpine:latest
	sudo docker pull alpine:latest
	#sudo docker rm pim17 #old stuff
	echo "from arm32v6/alpine:latest" > _Dockerfile.armhf
	cat Dockerfile >> _Dockerfile.armhf
	echo "from arm32v7/alpine:latest" > _Dockerfile.armv7
	cat Dockerfile >> _Dockerfile.armv7
	echo "from arm64v8/alpine:latest" > _Dockerfile.aarch64
	cat Dockerfile >> _Dockerfile.aarch64
	echo "from alpine:latest" > _Dockerfile.x86_64
	cat Dockerfile >> _Dockerfile.x86_64
	sudo docker build . -f _Dockerfile.x86_64 -t pim17:x86_64
	sudo docker build . -f _Dockerfile.aarch64 -t pim17:aarch64
	sudo docker build . -f _Dockerfile.armv7 -t pim17:armv7
	sudo docker build . -f _Dockerfile.armhf -t pim17:armhf

dev:
	sudo docker run --rm -it \
		-v "$(PWD)"/src:/src \
		-v "$(PWD)"/packages:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:x86_64 sh 
run:
	sudo mkdir -p packages/src
	sudo docker run --rm -it \
		-v "$(PWD)"/src:/src \
		-v "$(PWD)"/packages:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:armhf sh /src/buildall.sh

	#sudo docker run --rm -it \
		-v "$(PWD)"/src:/src \
		-v "$(PWD)"/packages:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:armv7 sh /src/buildall.sh
	#sudo docker run --rm -it \
		-v "$(PWD)"/src:/src \
		-v "$(PWD)"/packages:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:aarch64 sh /src/buildall.sh
	#sudo docker run --rm -it \
		-v "$(PWD)"/src:/src \
		-v "$(PWD)"/packages:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:x86_64 sh /src/buildall.sh
qemu:
	sudo docker run --rm --privileged multiarch/qemu-user-static --reset -p yes --credential yes

prod:
	#rsync -ravzz packages/src/* murakumo:/srv/http/alpine.tarxvf.tech/v3.15/
	rsync -ravzz packages/src/* murakumo:/srv/http/alpine.tarxvf.tech/edge/
