# TASMOTA_Smart_Bulb
Command-line control of an RGBWW bulb using MQTT and TASMOTA

## What is it?
This is a simple, command-line interface which will allow the user to send a limited set of commands to a smart bulb which has been loaded with Theo Arends' TASMOTA firmware, without having to worry too much about the intricacies of MQTT or the TASMOTA command structure.

It will enable a user to test the basic capabilities of a smart bulb fairly quickly and easily, without needing to install a cloud-based application or a home automation package.  Because it is a script, it is easy to understand, easy to upgrade, easy to check for security issues and only depends upon commonly available system commands.  It will run on Linux and most BSDs with just minor modifications to the PATH variable.  It should run on Macs (untested).  Windows?  ...sorry, but you're on your own with that one.

## Dependencies
The script assumes that you have the Open Source MQTT package Mosquitto installed on the machine on which the script runs (mosquitto_pub/mosquitto_sub commands should be available) and that an MQTT broker (server) is available for you to use (it doesn't have to be on the same machine as the script and doesn't even necessarily be on the same local network).

## How do I use it?
The script requires that you configure some information which is specific to your network and your smart bulb.  By default it does not require any username or password information (if your MQTT server requires a username and password then I assume that you already know how to add those into the Mosquitto command lines).

**YOU MUST** configure at least the two variables BULB_ID and MQTT_SERV at the very top of the script for it to work.

+ **BULB_ID  --**  This is the TASMOTA "Topic" identifier from the Main Menu->Configuration->Configure MQTT page.  Connect to your smart-bulb using the TASMOTA web interface.  Go to the "Configure MQTT" tab and look immediately below the "Password" line to find the "Topic" setting.  The input window will display something like "tasmota_%06X", but immediately above in the title line, you'll find your current setting displayed in paretheses.  The whole title line will look something like this:- "Topic = %topic% (tasmota_A2C9A4)" and in this case the current setting of "tasmota_A2C9A4" is what you need to set your BULB_ID variable to.

+ **MQTT_SERV  --**  This can be either the name or the IP address of the machine where your MQTT broker (server) process is running.  In either case it should be enclosed in double quotes (ie:- "192.168.1.10" or "my-local-mqtt" or "some.broker.com").

Once configured, you should immediately be able to communicate with your smart bulb.  Simply running "tsb.sh" with no options or arguments should result in the bulb turning on at full brightness, with a colour temperature mid-way between warm and cool.

Other presets are called by using single letter arguments:-

+ -c  --  "C"ool white.  Switches on the WW LEDs in the bulb with a blue hue.
+ -w  --  "W"arm white.  Switches on the WW LEDs with a yellow hue.
+ -n  --  "N"eutral white.  Switches on the WW LEDs with the hue set mid-way between cool and warm.
+ -o  or -0  -- Switches all LEDs (RGB and WW) off.
+ -s  --  "S"equence.  Turns on various colour mixes of RGB for 2 seconds before fading to the next colour.
+ -d  --  "D"ebug.  Fairly quiet debug output.
+ -D  --  "D"EBUG.  Very verbose debug output.
+ -h  --  "H"elp.  Basically this command listing.


