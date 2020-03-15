# TASMOTA_Smart_Bulb
Command-line control of an RGBWW bulb using MQTT and TASMOTA

## What is it?
This is a simple, command-line interface which will allow the user to send a limited set of commands to a smart bulb which has been loaded with Theo Arends' TASMOTA firmware, without having to worry too much about the intricacies of MQTT or the TASMOTA command structure.

It will enable a user to test the basic capabilities of a smart bulb fairly quickly and easily, without needing to install a cloud-based application or a home automation package.  Because it is a script, it is easy to understand, easy to upgrade, easy to check for security issues and only depends upon commonly available system commands.  It will run on Linux and most BSDs with just minor modifications to the PATH variable.  It should run on Macs (untested).  Windows?  ...sorry, but you're on your own with that one.

## Dependencies
The script assumes that you have the Open Source MQTT package Mosquitto installed on the machine on which the script runs (mosquitto_pub/mosquitto_sub commands should be available) and that an MQTT broker (server) is available for you to use (it doesn't have to be on the same machine as the script and doesn't even necessarily be on the same local network).

## How do I use it?
The script requires that you configure some information which is specific to your network and your smart bulb.  By default it does not require any username or password information (if your MQTT server requires a username and password then I assume that you already know how to add those into the Mosquitto command lines).
