https://wiki.alpinelinux.org/wiki/ALSA

For raspis: https://wiki.alpinelinux.org/wiki/Raspberry_Pi
ignore all the bits about `lbu` and `usercfg.txt` those don't apply to us using the pim17 image.

Put `dtparam=audio=on` in /boot/config.txt (will have to remount /boot rw). 
`echo snd_bcm2835 > /etc/modules-load.d/audio.conf`

This will be done for you already for any images generated after 2022/11/19
