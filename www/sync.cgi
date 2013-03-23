#! /bin/bash
echo "Content-type: text/html"
echo ""

# ~ is set to pi's home, but the $PWD var is set to the cgi-bin 
if [ -f ~/cdpf-env.sh ] ; then
	source ~/cdpf-env.sh
	"$CDPF_BASE/cdpf-sync.sh" 2>&1
else
	echo "Unable to locate cdpf-env.sh"
fi

echo "<h3>CDPF Sync</h3><pre>"
cd "$CDPF_BASE/sync"
cat "$CDPF_BASE/sync/filelist.txt" | xargs ls -lb 
echo "</pre><p><a href='/'>Home</a></p>"