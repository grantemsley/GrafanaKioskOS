Button Module
=============

This module allows you to connect a button between pins 34 and 36 (ground and GPIO 16) on the RPi which will call a script at /home/pi/button.sh as the user pi.  This gives a way for end users to have some limited interaction with the pi without having a keyboard or mouse.

I typically use it to restart a service so if something has failed to load properly end users can just press the button and make it restart.

No button.sh script is included. It can be included in another module or written yourself.

