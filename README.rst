Grafana Kiosk OS
================

This combines two great projects to give you an easy to deploy image for showing Grafana dashboards on a TV.

* `CustomPiOS <https://github.com/guysoft/CustomPiOS>`
* `Grafana Kiosk <https://github.com/grafana/grafana-kiosk>`

Grafana Kiosk can handle logging into Grafana automatically and displaying a dashboard or playlist.

Configuration
-------------

Edit ``/boot/grafana-kiosk.yaml`` with your grafana server and login information. Details about configuring Grafana Kiosk are on their github page linked above.

SSH is enabled and the password for the pi user should be changed.

Optionally connect a button between GPIO16 and ground to manually restart the kiosk software if it stops working due to network hickups without having to reboot the whole RPi.


Building
--------

Build on a Ubuntu, Debian or Raspbian system with::

    sudo apt install coreutils p7zip-full qemu-user-static
    git clone https://github.comg/uysoft/CustomPiOS.git
    git clone https://github.com/grantemsley/GrafanaKioskOS.git
    cd GrafanaKioskOS/src/image
    wget -c --trust-server-names 'https://downloads.raspberrypi.org/raspios_lite_armhf_latest'
    cd ..
    ../../CustomPiOS/src/update-custompios-paths
    sudo modprobe loop
    sudo bash -x ./build_dist

Customizing
-----------

Most relevant settings are exposed in ``src/config``. Copy ``config`` to ``config.local`` and edit to your liking before building.

There are several extra modules included here where you might also change things:

The button module installs the python script that monitors a button press on GPIO16 and runs a script.

The minimize module removes unnecessary packages, utilities and documentation. It shaves about 600MB off the size of the image, but leaves you with a system missing many normal commands and all documentation. You shouldn't distribute images build with minimize enabled, since they are also missing all the license files.

The pxe module removes the swap creation and partition resizing features that aren't needed when using the images only for network booting.

deploytopi.sh
-------------

This script is probably only useful to me. It relies on my `rpi-boot-server <https://github.com/grantemsley/rpi-boot-server>` setup and a home automation relay flashed with `Tasmota <https://tasmota.github.io/docs/>` to build the image, extract it and put it on the nfs server, and reboot an actually raspberry pi for testing on real hardware.
