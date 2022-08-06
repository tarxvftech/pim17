# pim17


## Built with
https://github.com/raspi-alpine/builder

You'll need docker. You need to `make qemu` to register cross-arch support.
Everything builds in docker. Makefiles are where to start.



# unsorted and unedited nonsense below here

## TODO
make MMDVM packages
 - need gcc,binutils,newlib-arm-none-eabi
 - git submodule init
 - git submodule update
 master branch, make dvm
 boot while shorting JP1 (a reboot is not sufficient, all power must be removed)
 make deploy-dvm
✔ disable console=serial0,115200 in /uboot/cmdline.txt
✔ add dtoverlay=disable-bt in /uboot/config.txt

 lonestar - mmdvm_hs_hat equivalent - for sure? need to test M17 mode first
 stm32-dvm - make dvm 

 M17Gateway - hostupdate script needs to have paths set
✔ add curl lol
✔ make sane default sfor M17Gateway
 TXInvert required for mmdvmhost


wifi settings should be settable from windows somehow?
  first attempt!
✔motd should be set correctly
✔  second attempt!
✔hostname already on /data!

https://github.com/sqshq/sampler

https://github.com/do6uk/mmdvmdash
https://github.com/dg9vh/MMDVMHost-Dashboard

## Important packages

* caddy caddy-openrc 
* rtl-sdr librtlsdr-dev
* python3
* pym17
* docker, docker-compose
	make sure space on disk!
	service docker start
	rc-update add docker default
  docker itself doesn't run when /var/ is a read-only filesystem!!!
  * openwebrx on docker - easy!
	docker volume create openwebrx-settings
	docker run --device /dev/bus/usb -p 8073:8073 --name openwebrx -v openwebrx-settings:/var/lib/openwebrx --tmpfs=/tmp/openwebrx jketterl/openwebrx:stable
	docker exec -it confident_lamport python3 /opt/openwebrx/openwebrx.py admin adduser admin

	kinda slow on pi3, probably not worth it by default.
  	add later:
	https://github.com/jketterl/digiham
	https://github.com/jketterl/codecserver

* partition is jsut barely big enough
	make sure to 
	mount -o remount,rw /
	resize2fs /dev/mmcblk0p2
	resize2fs /dev/mmcblk0p3
	on first boot


## Ideas
* in-band + Crossband repeater with rtl-sdr as receiver
* fast-test with rpitx and rtl-sdr?
* APRS igate using pymultimonaprs?
* Same but with M17?
* CLI auto-run: https://raymii.org/s/tutorials/Run_software_on_tty1_console_instead_of_login_getty.html
  * satellite tracking?
* GUI auto-run something maybe?

## Bugs
✔ USB Serial cdc_acm device doesn't work (fix: Include all modules)
✔ Wifi doesn't start on boot - device isn't ready in time (fix: disable networking init script on boot)
✔ Wifi has hardcoded credentials ... (now pulls from /boot on boot!)
can't emulate, have to flash a real pi https://azeria-labs.com/emulate-raspberry-pi-with-qemu/
qemu-system-arm -M vexpress-a9 -kernel zImage -initrd initramfs-grsec -dtb vexpress-v2p-ca9.dtb -hda hda.img -serial stdio

✔ couldn't get dtoverlay disable-bt to boot, appears to be uboot's fault. so i fucking removed all the uboot shit lol!

lonestar boards didn't take M17 firmware? or what? greencase one has a different firmware so they must not have flashed correctly
the clear case one definitely took correctly, reflashed with a custom version text which was part of the problem (stock version texts, non-updated version date, etc)

## Bugs with builder?
✔ builder ab_active and ab_flash don't always work? with no error messages, either
✔ ab_active shows currently booted but doesn't tell you what's going to boot next
couldn't build armhf ... kernel_packages wasnt being set, which was because arch wasn't being read correctly somehow. Suddenly started working and don't know why but related to srcme file and ARCH variable.
✔ uboot doesn't work with dtoverlay, removed uboot



https://github.com/mtlynch/picoshare/pull/164/files
