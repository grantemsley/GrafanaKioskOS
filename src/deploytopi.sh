#!/bin/bash
set -e

PI_SERIAL="aeac8933"
TASMOTA_IP="192.168.5.239"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DIST_PATH=${DIR}
export CUSTOM_PI_OS_PATH=$(<${DIR}/custompios_path)
source ${CUSTOM_PI_OS_PATH}/common.sh


# Build image
echo
echo "Building image"
echo
./build_dist

# Turn pi off
echo "Turning off pi"
curl http://${TASMOTA_IP}/cm?cmnd=POWER+OFF
echo "pi is off"

# Delete existing nfsroot
echo "removing existing nfs root"
rm -rf /srv/nfs/buildtest

IMAGEFILE=$(ls -t workspace/*.img | head -1)

echo "mounting image"
mount_image ${IMAGEFILE} 2 workspace/mount

# Remove the bind mounts - we don't need to copy those
umount workspace/mount/dev/pts
umount workspace/mount/dev

# Copy files
echo "copying files to new nfs root"
cp -a workspace/mount/. /srv/nfs/buildtest

# Unmount image
echo "unmounting image"
unmount_image workspace/mount

echo "customizing nfs root boot parameters"
NEWDIR="buildtest"
OLDHOSTNAME=$(cat "/srv/nfs/${NEWDIR}/etc/hostname")
echo "Changing hostname from ${OLDHOSTNAME} to ${NEWDIR}"
sed -i "s/$OLDHOSTNAME/$NEWDIR/g" "/srv/nfs/${NEWDIR}/etc/hostname"
sed -i "s/$OLDHOSTNAME/$NEWDIR/g" "/srv/nfs/${NEWDIR}/etc/hosts"

echo "Fixing cmdline.txt to use nfsroot"
IPADDRESS=$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{print $2}')
cp "/srv/nfs/${NEWDIR}/boot/cmdline.txt" "/srv/nfs/${NEWDIR}/boot/cmdline.original"
sed -i "s#rootfstype=ext4#rootfstype=nfs#g" "/srv/nfs/${NEWDIR}/boot/cmdline.txt"
sed -i "s#root=[[:graph:]]*#root=/dev/nfs nfsroot=${IPADDRESS}:/srv/nfs/${NEWDIR},udp,v3 rw ip=dhcp rootwait#g" "/srv/nfs/${NEWDIR}/boot/cmdline.txt"
sed -i "s#init=/usrlib/raspi-config/init_resize.sh##g" "/srv/nfs/${NEWDIR}/boot/cmdline.txt"

echo "Removing SD card mount points"
# remove /boot mount
sed -i "s#.*/boot\s.*##g" "/srv/nfs/${NEWDIR}/etc/fstab"
# remove / mount (looking for / with a whitespace character after it)
sed -i "s#.*/\s.*##g" "/srv/nfs/${NEWDIR}/etc/fstab"



# Now that the image is extracted, assign it to the pi
# rpi ID aeac8933
echo "assigning image to PI serial ${PI_SERIAL}"
rm -f /srv/tftp/${PI_SERIAL}
ln -s "/srv/nfs/buildtest/boot" "/srv/tftp/${PI_SERIAL}"

# restart rpi
echo "Turning on pi"
curl http://${TASMOTA_IP}/cm?cmnd=POWER+ON
echo "Powered on"
echo_green "Image deployed to RPi."

