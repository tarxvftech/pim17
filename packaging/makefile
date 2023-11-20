img:
	sudo docker pull arm32v6/alpine:latest
	sudo docker pull arm32v7/alpine:latest
	sudo docker pull arm64v8/alpine:latest
	sudo docker pull alpine:latest
	#sudo docker rm pim17 #old stuff
	echo -e "from arm32v6/alpine:latest" > _Dockerfile.armhf
	cat Dockerfile >> _Dockerfile.armhf
	echo -e "from arm32v7/alpine:latest" > _Dockerfile.armv7
	cat Dockerfile >> _Dockerfile.armv7
	echo -e "from arm64v8/alpine:latest" > _Dockerfile.aarch64
	cat Dockerfile >> _Dockerfile.aarch64
	echo "from alpine:latest" > _Dockerfile.x86_64
	cat Dockerfile >> _Dockerfile.x86_64
	sudo docker build . -f _Dockerfile.x86_64 -t pim17:x86_64
	sudo docker build . -f _Dockerfile.aarch64 -t pim17:aarch64
	sudo docker build . -f _Dockerfile.armhf -t pim17:armhf
	#sudo docker build . -f _Dockerfile.armv7 -t pim17:armv7

dev:
	sudo docker run --rm -it \
		--ulimit nofile=1024:8096 \
		-v "$(PWD)"/src:/src \
		-v "$(PWD)"/packages:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:x86_64 sh 
dev_noarch:
	sudo docker run --rm -it \
		--ulimit nofile=1024:8096 \
		-v "$(PWD)"/src_noarch:/src \
		-v "$(PWD)"/packages_noarch:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:x86_64 sh 
devarm:
	sudo docker run --rm -it \
		--ulimit nofile=1024:8096 \
		-v "$(PWD)"/src:/src \
		-v "$(PWD)"/src_noarch:/src_noarch \
		-v "$(PWD)"/packages:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:aarch64 sh 
devarmhf:
	sudo docker run --rm -it \
		--ulimit nofile=1024:8096 \
		-v "$(PWD)"/src:/src \
		-v "$(PWD)"/src_noarch:/src_noarch \
		-v "$(PWD)"/packages:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:armhf sh 
run: run_prereq run_armhf run_aarch64 run_x86_64 run_noarch run_index
	#for each architecture, build each package 

run_prereq:
	sudo mkdir -p packages/src packages_noarch/src
	sudo chown mike:mike -R packages packages_noarch
run_armhf:
	sudo docker run --rm -it \
		--ulimit nofile=1024:8096 \
		-v "$(PWD)"/src:/src \
		-v "$(PWD)"/packages:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:armhf sh /src/buildall.sh
run_aarch64:
	sudo docker run --rm -it \
		--ulimit nofile=1024:8096 \
		-v "$(PWD)"/src:/src \
		-v "$(PWD)"/packages:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:aarch64 sh /src/buildall.sh
run_x86_64:
	sudo docker run --rm -it \
		--ulimit nofile=1024:8096 \
		-v "$(PWD)"/src:/src \
		-v "$(PWD)"/packages:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:x86_64 sh /src/buildall.sh
run_armv7:
	sudo docker run --rm -it \
		--ulimit nofile=1024:8096 \
		-v "$(PWD)"/src:/src \
		-v "$(PWD)"/packages:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:armv7 sh /src/buildall.sh
	
run_noarch:
	#only build noarch packages (like mmdvm firmware) in x86_64 to avoid qemu overhead
	sudo docker run --rm -it \
		--ulimit nofile=1024:8096 \
		-v "$(PWD)"/src_noarch:/src \
		-v "$(PWD)"/packages_noarch:/home/builder/packages \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		pim17:x86_64 sh /src/buildall.sh
run_index:
	#https://www.erianna.com/creating-a-alpine-linux-repository/
	#cp files from noarch into each arch? will that work?
	#cd /apk/v3.6/main/x86_64
	#apk index -vU -o APKINDEX.tar.gz *.apk
	#abuild-sign -k /path/to/alpine@example.com-59ea3c02.rsa /apk/v3.6/main/x86_64/APKINDEX.tar.gz
	sudo docker run --rm -it \
		--ulimit nofile=1024:8096 \
		-v "$(PWD)"/packages:/home/builder/packages \
		-v "$(PWD)"/packages_noarch:/home/builder/packages_noarch \
		-v "$(PWD)"/abuild:/home/builder/.abuild \
		-v "$(PWD)"/scripts:/scripts \
		pim17:x86_64 /scripts/noarch_and_reindex.sh
qemu:
	sudo docker run --rm --privileged multiarch/qemu-user-static --reset -p yes --credential yes
	#credential yes is what allows suid within the containers
	#https://github.com/alpinelinux/docker-abuild/issues/47#issuecomment-569499962

prod:
	#rsync -ravzz packages/src/* murakumo:/srv/http/alpine.tarxvf.tech/v3.15/
	rsync -ravzz packages/src/* murakumo:/srv/http/alpine.tarxvf.tech/edge/
	rsync -ravzz packages/src/* shirakumo:/srv/pim17.org/repo/edge/
