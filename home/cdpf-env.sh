#! /bin/bash

# base defaults - override these values in ~/cdpf.conf

#
CDPF_BASE="/home/pi"
# sync url
CDPF_SYNC_URL="http://scalora.net/test-photos"
# how many seconds between photos
CDPF_PHOTO_DELAY=6			
# extra feh options
CDPF_FEH_OPTIONS="--fontpath /home/pi"
if [ -x "`which fehplus`" ]; then
	CDPF_FEH_BIN=fehplus
	if [ -e "$CDPF_BASE/cdpf-caption.sh" ] ; then
		CDPF_FEH_OPTIONS="$CDPF_FEH_OPTIONS --center-info --autofit-info --font yudit/32 --info='$CDPF_BASE/cdpf-caption.sh \"%n %u of %l\"'"
	fi
else
	CDPF_FEH_BIN=feh
fi

# log file
CDPF_LOG=/var/log/cdpf/cdpf.log

# pid for feh
CDPF_PID_FILE=/var/run/cdpf-feh.pid

DATE="[ `date '+%Y-%m-%d %H:%M:%S'` ]"

# process overrides
if [ -f "$CDPF_BASE/cdpf.conf" ]; then
	source "$CDPF_BASE/cdpf.conf"
else
	cat >"$CDPF_BASE/cdpf.conf" <<EOF
#!/bin/bash
# on lines with ###, fill in the values and remove the ###
# sync URL
###CDPF_SYNC_URL="http://scalora.net/test-photos"
# slide show delay
###CDPF_PHOTO_DELAY=6

EOF
	echo "Edit $CDPF_BASE/cdpf.conf and run again"
	exit 1
fi

export DISPLAY=:0.0