# piM17

A maximally-standard and familiar Alpine-based Linux distribution for M17,
MMDVM, and SDR purposes. The goal is to make something enduring that
can be maintained with less effort.

Building on Alpine Edge for now. Hoping to switch to a long term release later.

You could call this in development. It may be useful to you even now. 
The current audience is people with enough Linux experience to be
comfortable on the command line. The intended eventual audience may be
anyone with a hotspot or repeater, but we're a long way from there.

Forks of piM17 are expected and encouraged. piM17 is intended to be a
solid base of tools and sane configuration to build the right thing.

## Values
Standardization, common tooling, up to date software.

System packages >>> installing from source.

Minimal hacks. 

Eminently hackable. 

## If you do use this distribution:
Please file issues with any issues you encounter, including with documentation.

Insufficient or incorrect documentation is a bug.

If you find an Alpine documentation page that is helpful, please link
to it in the pim17 docs.

If you get stuck, say something.

## on systems that aren't raspberry pis
You can use almost all the included tools on standard Alpine (docs TODO).
See the repo files in `input/etc/apk/` for details for now.

## Built with
https://github.com/raspi-alpine/builder

more specifically, built with my fork of it:

https://github.com/tarxvftech/pim17_builder


## Developers
You'll need docker. You need to `make qemu` to register cross-arch support.
Everything builds in docker. Makefiles are where to start.

You must git clone the fork `pim17_builder` to `builder/` in this
directory. You must have the keys in packaging/ set up right to install
the custom packages.

Run `make img` to run the builder. You'll find the images generated in output/.
Use the one for your architecture (armhf for pi0w and pi2, aarch64 for
pi3 or better). You can ignore the _update.img. 

## Installation

Flash the img to your SD card, standard raspberry pi image instructions
just like pi-star or raspbian. You'll have to unzip the img first, of course.
```
gunzip pim17_armhf_edge.img.gz
sudo dd if=pim17_armhf_edge.img of=/dev/mmcblk0 bs=4096 status=progress
```
Wait for it to finish. If you'll be using wifi, edit
`wpa_supplicant_additions.txt` on the first partition of the SD card with
your wifi credentials in standard `wpa_supplicant` format. Only DHCP
is supported by default, sorry, but it's standard Alpine Linux so it's
[easy to change](https://wiki.alpinelinux.org/wiki/Configure_Networking)
if you need to. 

I _think_ ethernet is set to DHCP by default but I'd have to check.



# unsorted and unedited nonsense below here

## TODO
```
✔ - need gcc,binutils,newlib-arm-none-eabi
 master branch, make dvm
 boot while shorting JP1 (a reboot is not sufficient, all power must be removed)
 make deploy-dvm
```

* ✔ disable console=serial0,115200 in /uboot/cmdline.txt
* ✔ add dtoverlay=disable-bt in /uboot/config.txt

```
 lonestar - mmdvm_hs_hat equivalent - for sure? need to test M17 mode first
 stm32-dvm - make dvm 
```

 M17Gateway - hostupdate script needs to have paths set
 TXInvert required for mmdvmhost


Ideas:
https://github.com/sqshq/sampler
https://github.com/do6uk/mmdvmdash
https://github.com/dg9vh/MMDVMHost-Dashboard

## Important packages
```
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
```

## Ideas
* CLI auto-run: https://raymii.org/s/tutorials/Run_software_on_tty1_console_instead_of_login_getty.html

## Bugs
* ✔ USB Serial cdc_acm device doesn't work (fix: Include all modules)
* ✔ Wifi doesn't start on boot - device isn't ready in time (fix: disable networking init script on boot)
* ✔ Wifi has hardcoded credentials ... (now pulls from /boot on boot!)
* can't emulate, have to flash a real pi https://azeria-labs.com/emulate-raspberry-pi-with-qemu/
qemu-system-arm -M vexpress-a9 -kernel zImage -initrd initramfs-grsec -dtb vexpress-v2p-ca9.dtb -hda hda.img -serial stdio

* ✔ couldn't get dtoverlay disable-bt to boot, appears to be uboot's fault. so i fucking removed all the uboot shit lol!

* lonestar boards didn't take M17 firmware? or what? greencase one has a different firmware so they must not have flashed correctly
* the clear case one definitely took correctly, reflashed with a custom version text which was part of the problem (stock version texts, non-updated version date, etc)

## Bugs with builder?
* ✔ builder ab_active and ab_flash don't always work? with no error messages, either
* ✔ ab_active shows currently booted but doesn't tell you what's going to boot next
* couldn't build armhf ... kernel_packages wasnt being set, which was because arch wasn't being read correctly somehow. Suddenly started working and don't know why but related to srcme file and ARCH variable.
* ✔ uboot doesn't work with dtoverlay, removed uboot



https://github.com/mtlynch/picoshare/pull/164/files
