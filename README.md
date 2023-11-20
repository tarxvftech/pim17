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

## TODO
* show how to start, restart services (the service files already exist!)
* add cronjob and instructions for m17hostsupdate
* easy way (tailscale?) to allow remote troubleshooting with a single command ideally


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

## Warnings
By default the _filesystems_ are quite small. This keeps the downloaded
images a bit smaller (so as packages get added they may get larger).

You can easily expand the filesystem up to the _partition_ size with `resize2fs /dev/mmcblk0p2`.
`p2` is the `/` ("root") partition. You can do this live while using
the filesystem (Mentioned only because you may have encountered other
resizing options in the past where that was _not_ supported).

You can see partition sizes with `fdisk -l` or `lsblk`. 

You can see partition free space with `df -h`.

The `/data` partition should be the correct and full size already, IIRC. 
Doing this for `/` can be automated but it's not a priority for me at
the moment. Pull requests encouraged!

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

You want 'armhf' for the pi0w and anything pi2 or below.  You want aarch64 for pi3 and greater.

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

## Usage

(See also "Warnings" up above).

To log in, `ssh root@pim17`, password is `m17project`. Make sure to change
that, copy SSH keys over, etc. doas or sudo are your own problem for
now but I do intend to add a non-root user with doas support eventually.

To install packages, it's standard alpine linux. See packaging/ for
custom packages until they get broken out into their own repos.

You'll have to `mount -o remount,rw /` to remount the root partition
read-write to change settings. `/data` is rw by default and many things in
/etc/ have a symlink to /data. This should make a system reasonably safe
against power loss while still allowing easy config file editing and such.

I'd prefer an overlay file system but don't remember why I didn't do
that to begin with. Not sure I tried, but we should look into that!

To update the list of packages (do early and often):
```
apk update
```
To install a package:
```
apk add
```
To upgrade the system ('ware disk space!! And be extra sure / and /boot are mounted rw!):
```
apk upgrade
```


Important (nonstandard) packages:
```
mmdvm_firmware_bin: A limited set of organized, precompiled firmware images for common MMDVM modems.
mmdvm_easyflash: Allows you to 'python -m mmdvm_easyflash' to upgrade firmware on modems supported by mmdvm_firmware_bin.
m17gateway, mmdvmcal, mmdvmhost: Packaged M17/MMDVM binaries and sample configs as necessary. Check /data/etc for the configs. Might only support M17 to start, more to come if there's demand.
```

## Standard openssh

Short form is that dropbear is currently handling ssh and you want to replace it with openssh/sshd.
Note that you should edit `/etc/ssh/sshd_config` to allow root logins `yes` instead of `without-password` OR add your SSH keys before continuing, lest you be locked out, requiring manual SD card intervention.
`apk add openssh`
`rc-update add sshd`
`rc-update del dropbear`
`/etc/init.d/dropbear stop`
`/etc/init.d/sshd start`


## Docker
Make sure `/` is resized and currently rw. Or you can do the following:
`cd /var/lib; ln -s /data/var/lib/docker` 
`cd /var/; mkdir /data/var/log; ln -s /data/var/log`

To add it:
`apk add docker docker-compose`
`rc-update add docker`
`/etc/init.d/docker start`

`docker ps -a` to make sure it's working.

## RW / by default
Edit /etc/fstab and change the `ro` to `rw` for / and /boot. 
Edit /boot/cmdline.txt and remove the `ro` (I think).
You're done!

# unsorted and unedited nonsense below here

## TODO

* [] MMDVM package, MMDVM_HS package renamed to account for that.
* [] make hostnames unique - pim17-XXXXXX maybe from last three octets of mac address?
* [] auto calibration of hotspot? with a known-good rtl-sdr, the good ones have excellent clocks

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
automatic HDMI output
https://github.com/sqshq/sampler

80% solution:
Minimal html page with buttons that can call tiny CGI script
to restart services. 
Web-based file manager/editor for people unwilling to CLI.  
 * https://github.com/prasathmani/tinyfilemanager
 probably needs to be edited to whitelist specific files. THat's fine!
MMDVM read-only dashboard. 
* https://github.com/do6uk/mmdvmdash
* https://github.com/dg9vh/MMDVMHost-Dashboard
* https://github.com/dg9vh/MMDVMHost-Websocketboard

or much better, w0chp's dash:
https://repo.w0chp.net/Chipster/W0CHP-PiStar-Dash


## Important packages
```
https://github.com/F5OEO/rpitx
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
