#! /bin/bash
export CDPF_LOG=/var/log/cdpf/cdpf.log
echo "Content-type: text/html"
echo ""
echo "<h3>CDPF Log</h3><pre>"
cat $CDPF_LOG | tail -n 30
echo "</pre><p><a href='/'>Home</a></p>"
