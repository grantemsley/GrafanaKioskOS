#!/usr/bin/python3

# This script calls a bash script at /home/pi/button.sh when a GPIO button is pressed.
# The button is wired to pins 34 and 36 of the GPIO header (on the outside edge of the board, the 3rd and 4th pins away from the USB ports)
# This is ground and GPIO16.

import RPi.GPIO as GPIO
import subprocess

gpio_pin_number=16

GPIO.setmode(GPIO.BCM)
GPIO.setup(gpio_pin_number, GPIO.IN, pull_up_down=GPIO.PUD_UP)

while True:
    GPIO.wait_for_edge(gpio_pin_number, GPIO.FALLING)
    subprocess.run("sudo -u pi /home/pi/button.sh", shell=True)


GPIO.cleanup()
