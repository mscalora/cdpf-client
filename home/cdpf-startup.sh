#!/bin/bash

source ~/cdpf-env.sh

echo "$DATE Startup" >>"$CDPF_LOG"

sudo touch $CDPF_PID_FILE
sudo chgrp pi $CDPF_PID_FILE
sudo chmod g+w $CDPF_PID_FILE

sudo touch $CDPF_LOG
sudo chgrp pi $CDPF_LOG
sudo chmod g+w $CDPF_LOG


if [ -z "$HOME" ] ; then
	# restart, fix vars we need
	export HOME="/home/pi"
	export PWD="/home/pi"
fi

# force to main screen in case we are called form background or ssh
export DISPLAY=:0.0
eval "nohup `which $CDPF_FEH_BIN` -FZpr --hide-pointer -D $CDPF_PHOTO_DELAY $CDPF_FEH_OPTIONS \"$CDPF_BASE/sync\" &>/dev/null </dev/null &"
PID=$!
echo $PID >$CDPF_PID_FILE
