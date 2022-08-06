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

