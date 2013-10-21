#! /bin/bash

# when called from cgi, PWD is set to cgi-bin
source "/home/pi/cdpf-env.sh"

cd /home/pi/sync

rm -f filelist.txt

wget -mNrnd -l 1 -U CDPF "$CDPF_SYNC_URL" 2>&1 | tee rawout.txt | egrep '^--' | egrep -o '[-a-zA-Z0-9_.]*[.](jpe?g|png|gif)' | sort -u >filelist.txt

if [ -s filelist.txt ]; then

	for f in $( shopt -s nocaseglob ; ls *.jpg *.jpeg *.png *.gif 2>/dev/null ) ; do
		grep -qF "$f" filelist.txt
		if [ $? -eq 1 ] ; then
			rm "$f"
		fi
	done
	
	kill -SIGURG `cat "$CDPF_PID_FILE"` &>>"$CDPF_LOG"
	sleep 1s
	
	echo "$DATE Sync: there are `cat filelist.txt | wc -l` files, `du -ch *.[jpg]* | tail -n 1 | egrep -o \"^\\S*\"` total - $CDPF_SYNC_URL" >>"$CDPF_LOG"
	
else 
	echo "$DATE Sync failed" >>"$CDPF_LOG"
fi

PID="`cat \"$CDPF_PID_FILE\"`"

[ -n "$PID" ] && ps --pid $PID >/dev/null || {
	echo "$DATE Restarting $CDPF_FEH_BIN" >>"$CDPF_LOG"
	"$CDPF_BASE/cdpf-startup.sh"
} 
