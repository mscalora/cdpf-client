#! /bin/bash
echo "Content-type: text/html"
echo ""
echo "<h3>ifconfig</h3><pre>"
ifconfig | tail -n 60
echo "</pre><p><a href='/'>Home</a></p>"