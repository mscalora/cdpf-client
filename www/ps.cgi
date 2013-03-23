#! /bin/bash
echo "Content-type: text/html"
echo ""
echo "<h3>ps</h3><pre>"
ps -Ao pid,time,command | tail -n 30
echo "</pre><p><a href='/'>Home</a></p>"