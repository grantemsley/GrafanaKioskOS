#!/bin/sh
while true; do
	if [ -e "/reboot" ]; then
		echo "Rebooting..."
		rm /reboot
		reboot now
	else
		sleep 5
	fi
done
