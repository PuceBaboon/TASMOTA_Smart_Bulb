#!/bin/sh

##
##   $Id: tsb.sh,v 1.1 2020/03/15 23:42:37 gaijin Exp $
##
##        TASMOTA Smart Bulb control program
##
## Simple, command-line control of an RGBWW smart bulb via
## TASMOTA and MQTT.
## 
##

export PATH=/bin:/usr/bin;

BULB_ID="YOUR-TASMOTA-TOPIC";		##  -- SET YOUR TASMOTA TOPIC NAME HERE  --
MQTT_SERV="YOUR-MQTT-SERVER";		##  -- SET YOUR MQTT SERVER NAME/IP HERE  --
SYSLOG_SERV="YOUR-SYSLOG-SERVER";	##  -- SET YOUR SYSLOG SERVER NAME/IP HERE  --

SLPTM=2;				## Sequence delay time (in seconds).


MID_WHITE="000000FFFF";		## Neutral white, full brightness.
WARM_WHITE="00000000FF";
COOL_WHITE="000000FF00";
TURQUOISE="33FFAA0000";
YELLOW="FFAA330000";
MAROON="AA33FF0000";
PINK="FF33AA0000";
BLUE="33AAFF0000";
GREEN="AAFF330000";
COL_SEQ="${TURQUOISE} ${MAROON} ${YELLOW} ${BLUE} ${PINK} ${GREEN}";


##--------------------------------------------------------------------------##

[ -z "${MQTT_SERV}" -o "YOUR-MQTT-SERVER" = "${MQTT_SERV}" \
	-o -z "${BULB_ID}" -o "YOUR-TASMOTA-TOPIC" = "${BULB_ID}" ] && \
	printf "\n\t==INFO==    You MUST set BULB_ID, MQTT_SERV variables for your network.\n\n" && \
	exit 1;


NAME=`basename ${0}`;				## Used by syslog.
MQP="/usr/bin/mosquitto_pub -h ${MQTT_SERV}";
MQS="/usr/bin/mosquitto_sub -h ${MQTT_SERV}";


## Output info, depending upon whether we have a tty or not.
Totty(){
        tty -s && printf "\n\t${*}\n\n";
}


## Syslog messages to remote machine.
Log(){
	if [ -z "${SYSLOG_SERV}" -o "YOUR-SYSLOG-SERVER" = "${SYSLOG_SERV}" ]; then
		logger --stderr "${NAME}: ${*}";
	else
		logger --server ${SYSLOG_SERV} --stderr "${NAME}: ${*}";
	fi
}


## Output warning messages to stdout and stderr/syslog.
Warn(){
        Totty "${*}";
        Log "${*}";
}


## Output tagged error message and exit with non-zero return value.
Fatal(){
        Warn "FATAL: ${*}";
        exit 254;
}


Usage(){
cat << EOHD

Options are:-

	-c		- Cool white.
	-n		- Neutral white (default).
	-w		- Warm white.
	-o or -0	- Turn off.
	-d		- Debug (quiet).
	-D		- DEBUG (noisy).
	-h		- Help (this text).

EOHD
}


b_cmnd(){
	CMND=; MSG=;
	case ${#} in
		1)
			CMND="${1}";
			MSG="-n";
			MBODY=;;
		2)
			CMND="${1}";
			MSG="-m";
			MBODY="${2}";;
		*)
			Fatal "b_cmnd(): Takes one command and one message, ie:- b_cmnd POWER ON";;
	esac;
	[ ! -z "${DEBUG}" ] && echo "${MQP} -t cmnd/${BULB_ID}/${CMND} ${MSG} ${MBODY}";
	${MQP} -t cmnd/${BULB_ID}/${CMND} ${MSG} ${MBODY};
}


Sequence(){
	b_cmnd "fade" "1";		## Enable fading.
	b_cmnd "power" "on";		## Power on before starting.
	b_cmnd "color" "0000000000";	## Zero-out colours.
	while [ true ]; do
		for COL in ${COL_SEQ}; do
			b_cmnd "color" "${COL}";
			sleep ${SLPTM};
		done
	done
}


##
## Handle a limited number of command-line arguments.
## "color" is the default command, so we need not call
## it for any of the other colour commands.
##
CMND="color";		## Default command.
MBODY="${MID_WHITE}";	## Default colour (neutral white).
while getopts cdhnoswCDHNOSW0 INP
do
	case ${INP} in
		d)		DEBUG=true;;		## These two lines should
		D)		set -x; DEBUG=true;;	## remain at the top.

		c | C)		MBODY="${COOL_WHITE}";;

		h | H)		Usage;;

		n | N)		;;			## Default, neutral white.

		o | O | 0)	CMND="power";
				MBODY="off";;		## Off.

		s | S)		Sequence;
				exit ${?};;

		w | W)		MBODY="${WARM_WHITE}";;

		\?)		Usage;;
	esac
done
shift `expr $OPTIND - 1`

[ ! -z "${DEBUG}" ] && printf "\n\tCommand: %s\n\tMsgBody: %s\n\n" ${CMND} ${MBODY};
[ -z "${CMND}" -a -z "${MBODY}" ] && ( Usage && Fatal "No Command and no Message set for MQTT" );
b_cmnd "${CMND}" "${MBODY}";

exit ${?};
