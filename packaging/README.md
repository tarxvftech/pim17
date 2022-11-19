# Cross platform packaging environment for pim17 (alpine)

pim17 is built on Alpine Linux, which is a fairly minimal
distribution.  There aren't really cross compilation toolchains,
the easiest way to build packages for another platform is actually
to use qemu and emulate that platform.  Through some docker and
[binfmt_misc](https://en.wikipedia.org/wiki/Binfmt_misc) trickery,
we can run all these cross-platform build systems in docker on an x64 device.

With this, we can kind-of ignore architecture and just build
stuff. Granted, we rebuild it for each architecture, but that's not
really avoidable until the great WASM consumes us all.

So, let's build some packages.

## Getting Started

TODO: Need to document [generating signing
keys](https://wiki.alpinelinux.org/wiki/Abuild_and_Helpers#Setting_up_the_build_environment).
Hopefully with that link you can sort it out. The `./abuild` directory
contains both keys and `./abuild/abuild.conf` has a reference to the
privkey.

First, register cross-platform binary support:
```
make qemu
```

Second, build your build images images. 
```
make img
```

Now you have a pile of container images, all the same alpine build
image but for different architectures. Because you did `make qemu`
you can run these like any regular same-arch container.

To build all packages, just `make run`. This uses `src/buildall.sh`
in each build image. All buildall.sh does is cd to each dir in
src/ and run `abuild -r`, which is the alpine [package build
system](https://wiki.alpinelinux.org/wiki/Creating_an_Alpine_package).

After a build run, you should have packages in `./packages/src`
in their respective directories. You can publish these to an
HTTP server like in the recipe for `make prod` that I use. The
full path of an alpine package URL looks something like
`host.domain/alpine_version/arch/whatever-ve.rs.ion-rrev.apk`
and if that's not enough, make sure to checkout the
[docs](https://wiki.alpinelinux.org/wiki/Repositories).

## Editing build images
Check out the makefile to see how it's done. Generally you can just
edit Dockerfile. The makefile may need to be adjusted if you need to
add something specific to an architecture.


## Running
Packages you probably want:
* dfu-util dfu-util [requires testing repo]
* stm32flash (stm32flash) 
* stlink (st-flash) [? also testing repo maybe]
* ╳ upload-reset (doesn't exist outside stm32duino?)

If you're running pim17 images, you already have these installed by default.
If you're using the mmdvm_easyflash package, some may be pulled in as a dependency automatically.




## Add:
# https://wiki.alpinelinux.org/wiki/Creating_an_Alpine_package
* Kiosk package with firefox kiosk mode
  add user kiosk, passwd doesn't matter
  /etc/inittab tty1 to /bin/login -f kiosk (kiosk username)
    tty1::respawn:/bin/login -f kiosk
  .profile:
    #!/bin/ash
    TTY=$(tty)
    echo DISPLAY=$DISPLAY
    echo TTY=$TTY
    if [[ -z "$DISPLAY" && "$TTY" == "/dev/tty1" ]] ; then
	startx
    fi
  .xinitrc:
    #!/bin/sh
    xset -dpms
    xset s off
    xset s noblank
    unclutter-xfixes &
    #unclutter removes mouse curser after a time
    #consider also adding barrier (mouse/keyboard sharing over network) but that'll need an alpine package
    echo "https://m17project.org" > /tmp/url

    while [ 1 ]; do
	    url="$(cat /tmp/url)"
	    echo "Opening $url"
	    firefox --kiosk "$url"
	    sleep 1s
    done

   setup-xorg-base
   apk add xf86-video-fbdev (or equivalent) unclutter-xfixes firefox xset xrandr
   pimation:~# cat set_url
    #!/bin/ash

    echo "$1" > /tmp/url
    killall firefox
  problem: by default the resolution is wrong.
    https://unix.stackexchange.com/questions/227876/how-to-set-custom-resolution-using-xrandr-when-the-resolution-is-not-available-i
    doesn't seem to work
    neither does setting hdmi stuff manually in usercfg.txt (tried) /config.txt(not tried)

  for lulz: run cmatrix on tty1 :)




  

* https://github.com/drowe67/codec2.git
*  cmake

* https://github.com/F5OEO/rpitx


* https://github.com/mobilinkd/m17-cxx-demod
*  This code requires the codec2-devel, boost-devel and gtest-devel packages be installed.

* https://github.com/mobilinkd/tnc3-firmware
*  builder/ packages/ what?

* https://github.com/mobilinkd/m17-tnc3-python

* ✔ build for pi0s
* pym17, codec2
* dmr.tools usb shim
* openrtx, radio_tool, maybe a programradios firmware updater?

* https://github.com/travisgoodspeed/md380tools/wiki/MD380-Emulator natively on raspi
  * https://github.com/fventuri/codecserver-mbelib-module
  * https://github.com/knatterfunker/codecserver-softmbe

* ✔ https://github.com/jketterl/openwebrx
	* docker: note usb driver issues: https://github.com/jketterl/openwebrx/wiki/Getting-Started-using-Docker
	  * ✔ fixed with a blacklist of module in image.sh
	* could package it: https://github.com/jketterl/openwebrx/tree/develop/debian
	  * https://github.com/openwebrx/package-builder
	* ✔ Working in docker. Now need to add:
	  * https://github.com/jketterl/digiham
	  * https://github.com/jketterl/codecserver

* ✔ rtlsdr and ╳ hackrf tools
* webpage that allows transmitting/receiving M17 through the MMDVM
  KD9KCK working on this a bit 
* gundb repeater, ham license, and other database
* pymultimonaprs
* TNC3 firmware flashing capability
* M17 specification locally
* super-tiny slim dashboard
* Gopher/gemini browser?
* web to gemini proxy?

* my packet handlers for m17?

* mvoice
* mrefd
* urfd
* M17Client
* Dudestar
* hotspot/hat firmwares and flashers
* https://git.mmcginty.me/mike/env.git


* rpitx
* https://github.com/drowe67/pirip

## Bugs

