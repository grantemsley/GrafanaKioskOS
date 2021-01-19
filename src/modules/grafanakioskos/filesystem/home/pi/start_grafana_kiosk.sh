#!/bin/bash

export DISPLAY=:0


while true
do
	# Make sure screensaver and display power saving are turned off
	xset s off
	xset -dpms
	xset s noblank

	# Move mouse offscreen
	xdotool mousemove 9000 9000

	# Start grafana-kiosk
	/usr/local/bin/grafana-kiosk -c /boot/grafana-kiosk.yaml

	sleep 1
done

