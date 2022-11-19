img:
	make -C builder
	#sudo docker pull ghcr.io/raspi-alpine/builder
	-sudo rm -r output/*
	mkdir -p input/etc/apk/keys
	cp packaging/abuild/*.pub input/etc/apk/keys/
	sudo docker run --rm -it \
		-v "$(PWD)"/input:/input \
		-v "$(PWD)"/output:/output \
		--env-file srcme_aarch64 \
		alpbuild
		#ghcr.io/raspi-alpine/builder
	sudo docker run --rm -it \
		-v "$(PWD)"/input:/input \
		-v "$(PWD)"/output:/output \
		--env-file srcme_armhf \
		alpbuild
		#ghcr.io/raspi-alpine/builder

send:
	scp output/pim17_v3.15_update.img.gz* root@pim17:
#flash: output/pim17_aarch64_edge.img
flash1: output/pim17_armhf_edge.img
	sudo dd if=$^ of=/dev/mmcblk0 bs=4096 status=progress
	echo "Adding wifi settings"
	sudo mount /dev/mmcblk0p1 /mnt/1
	sudo cp wifi.txt /mnt/1/wpa_supplicant_additions.txt
	sudo umount /mnt/1/
	echo "Done!"
flash2: output/pim17_aarch64_edge.img
	sudo dd if=$^ of=/dev/mmcblk0 bs=4096 status=progress
	echo "Adding wifi settings"
	sudo mount /dev/mmcblk0p1 /mnt/1
	sudo cp wifi.txt /mnt/1/wpa_supplicant_additions.txt
	sudo umount /mnt/1/
	echo "Done!"


	
qemu:
	sudo docker run --rm --privileged multiarch/qemu-user-static --reset -p yes --credential yes

output/%.img: output/%.img.gz
	sudo gunzip $^
boot: output/pim17_armhf_edge.img output/pim17_aarch64_edge.img
	#output/pim17_v3.15.img
	#mount -v -t ext4 output/pim17_v3.15_update.img test/
	#sudo mkdir -p output/fs
	#sudo mount -v -t ext4 output/pim17_v3.15_update.img output/fs
	#sudo docker run -it -v $(PWD)/output/fs/:/sdcard/ lukechilds/dockerpi:vm pi3
	#sudo docker run -it -v $(PWD)/output/pim17_v3.15.img:/sdcard/filesystem.img lukechilds/dockerpi:vm pi3
	#sudo docker run -it -v $(PWD)/output/pim17_v3.15.img:/sdcard/filesystem.img --entrypoint /bin/sh lukechilds/dockerpi:vm 
	echo Needs console for ttyAMA0 for easy login or it needs qemu-monitor or tweaks to network config or something.
	#sudo docker run -it -v $(PWD)/output/pim17_armhf_edge.img:/sdcard/filesystem.img lukechilds/dockerpi:vm pi1
	#sudo docker run -it -v $(PWD)/output/pim17_aarch64_edge.img:/sdcard/filesystem.img lukechilds/dockerpi:vm pi3

prod:
	rsync -ravz output/* murakumo:/srv/http/alpine.tarxvf.tech/
