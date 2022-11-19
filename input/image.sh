#!/bin/bash

echo Input directory: $INPUT_PATH
echo Root FS: $ROOTFS_PATH
echo Boot FS: $BOOTFS_PATH
echo Data FS: $DATAFS_PATH

mkdir -p $DATAFS_PATH/srv
#mv $ROOTFS_PATH/srv/* $DATAFS_PATH/srv/
rmdir $ROOTFS_PATH/srv
ln -s $DATAFS_PATH/srv $ROOTFS_PATH/srv
mkdir -p $DATAFS_PATH/srv/http/
#wget https://m17-protocol-specification.readthedocs.io/_/downloads/en/latest/htmlzip/ -o $DATAFS_PATH/srv/http/

echo "https://alpine.tarxvf.tech/${ALPINE_BRANCH}/" >> $ROOTFS_PATH/etc/apk/repositories
cp $INPUT_PATH/etc/apk/keys/* $ROOTFS_PATH/etc/apk/keys/




chroot_exec apk update
chroot_exec apk add --no-cache git \
	make g++ linux-headers curl \
	vim screen bash openssh \
	wireless-tools wpa_supplicant \
	busybox-ifupdown busybox-extras \
	linux-firmware-cypress \
	mmdvmhost mmdvmcal m17gateway mmdvm_easyflash mmdvm_firmware_bin

mkdir -p $DATAFS_PATH/etc/wpa_supplicant 
cp -r $ROOTFS_PATH/etc/wpa_supplicant/* $DATAFS_PATH/etc/wpa_supplicant/ 
rm -r $ROOTFS_PATH/etc/wpa_supplicant
ln -s /data/etc/wpa_supplicant $ROOTFS_PATH/etc/wpa_supplicant
echo "#Put your wifi stanzas here!" > ${BOOTFS_PATH}/wpa_supplicant_additions.txt
cp -r $INPUT_PATH/etc/* $DATAFS_PATH/etc/


mkdir -p $ROOTFS_PATH/usr/share/pim17/examples/
cp $INPUT_PATH/etc/*.ini $ROOTFS_PATH/usr/share/pim17/examples/
for ini in $DATAFS_PATH/etc/*.ini; do
	ininame="$(basename "$ini")"
	echo $ininame
	ln -s /data/etc/$ininame ${ROOTFS_PATH}/etc/$ininame
done
rm ${ROOTFS_PATH}/etc/motd
ln -s /data/etc/motd ${ROOTFS_PATH}/etc/motd

echo "blacklist dvb_usb_rtl28xxu" >> /etc/modprobe.d/blacklist.conf


echo "brcmfmac" >> "$ROOTFS_PATH"/etc/modules
cat >> "$ROOTFS_PATH"/etc/network/interfaces.alpine-builder <<"EOF"
auto wlan0
iface wlan0 inet dhcp
EOF
cp "$ROOTFS_PATH"/etc/network/interfaces.alpine-builder "$DATAFS_PATH"/etc/network/interfaces

mkdir -p $DATAFS_PATH/var/lib/docker/

echo "dtoverlay=disable-bt" >> ${BOOTFS_PATH}/config.txt
#configure wpa_supplicant to check /boot for additional stanzas somehow
#tiny little logcat type thing for hdmi users

#bash
chroot_exec rc-update add wpa_cli default
chroot_exec rc-update add wpa_supplicant default
chroot_exec rc-update add mmdvmhost default
chroot_exec rc-update add m17gateway default
#chroot_exec rc-update add networking boot 
#do NOT do above "add networking boot", despite what wiki says, wifi will fail!

chroot_exec adduser m17 -D
#chroot_exec "echo -e 'm17project\nm17project\n' | passwd m17" 

#mqtt? email? qso.email?
#log forwarding?
#APRS software?
#MMDVM flashing? bin and builder?

