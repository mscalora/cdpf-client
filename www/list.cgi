#! /bin/bash
echo "Content-type: text/html"
echo ""
cd ~/sync
echo "<style>.thumb img { max-width: 400px; }</style>"
echo "<h2>CDPF Images</h2>"
for f in $( shopt -s nocaseglob ; ls *.jpg *.jpeg *.png *.gif 2>/dev/null ) ; do
	echo "<div><h4>$f</h4></div>"
	echo "<div class='thumb'><a href='/sync/$f'><img src='/sync/$f'/></a></div></div>"
done
echo "<p><a href='/'>Home</a></p>"
