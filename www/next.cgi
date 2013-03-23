#! /bin/bash
echo "Location: http://$SERVER_NAME:$SERVER_PORT/"
echo ""

echo "<pre>`set`"
source ~/cdpf-env.sh

kill -SIGUSR1 `cat "$CDPF_PID_FILE"`

