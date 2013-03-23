#! /bin/bash

if [ -f "$PWD/cdpf-startup.sh" ] ; then
	echo "A previous cdpf installation was detected."
	echo "Any modified files may be overwritten!"
	read -p "Are you sure you wish to continue [yes/NO]?" -n 1 -r
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]] ; then
		echo "Starting installation..."
	else
		echo "Aborting installation."
		exit 1
	fi
fi

if [ ! -x "`which feh`" ] ; then
	echo "It doen't look like feh is installed, run"
	echo ""
	echo "	sudo apt-get install feh"
	echo ""
	echo "and then rerun the cdpf setup"
	exit 1
fi

if [ ! -d ~/sync ] ; then
	echo "Creating sync folder..."
	mkdir -p ~/sync
fi

if [ ! -f ~/yudit.ttf ] ; then
	echo "Creating font link..."
	ln -s /usr/share/feh/fonts/yudit.ttf ~/yudit.ttf
fi

echo "Creating log folder..."
sudo mkdir -p /var/log/cdpf
sudo chgrp pi /var/log/cdpf
sudo chmod g+w /var/log/cdpf

SETUP_PATH="`dirname \"$0\"`"

echo "Source files: $SETUP_PATH"

echo "Copying scripts..."
for f in $(ls "$SETUP_PATH/home" ) ; do
	echo "$f"
	cp "$SETUP_PATH/home/$f" "$PWD/"
	if [[ $f =~ .sh$ ]] ; then
		sudo chmod ug+x "$PWD/$f"
	fi
done

echo "Copying cgis..."
sudo chgrp pi "/var/www"
sudo chmod g+w "/var/www"
sudo mkdir -p "/var/www/cgi-bin"
sudo chgrp pi "/var/www/cgi-bin"
sudo chmod g+wx "/var/www/cgi-bin"
for f in $(ls "$SETUP_PATH/www" ) ; do
	echo "$f"
	if [[ $f =~ .cgi$ ]] ; then
		cp "$SETUP_PATH/www/$f" "/var/www/cgi-bin/"
		chmod ug+x "/var/www/cgi-bin/$f"
	else
		cp "$SETUP_PATH/www/$f" "/var/www/"
	fi
done

echo "Copying bin..."
for f in $(ls "$SETUP_PATH/bin" ) ; do
	echo "$f"
	sudo cp "$SETUP_PATH/bin/$f" "/usr/local/bin/"
	sudo chmod uga+x "/usr/local/bin/$f"
done

echo "Copying autostart item(s)..."
mkdir -p "$PWD/.config/autostart"
cp "$SETUP_PATH"/misc/*.desktop "$PWD/.config/autostart"

if [ -s "$PWD/cdpf.conf" ] ; then
	echo "Config file exists"
else
	echo "Creating config file..."
	"$PWD/cdpf-env.sh"
fi

if [ -f /etc/lighttpd/lighttpd.conf ] ; then
	echo "Updating lighttpd config as needed..."
	sudo sed -i "s/www-data/pi/" /etc/lighttpd/lighttpd.conf
	fgrep -q '/home/pi/sync'/etc/lighttpd/lighttpd.conf || {
		echo "Adding alias for image URLs
		echo 'alias.url = ( "/sync/" => "/home/pi/sync/" )' >>/etc/lighttpd/lighttpd.conf
	}	
	if [ ! -f /etc/lighttpd/conf-enabled/10-cgi.conf ] ; then
		sudo ln -s /etc/lighttpd/conf-available/10-cgi.conf /etc/lighttpd/conf-enabled/10-cgi.conf
	fi
	sudo mkdir -p /var/log/lighttpd
	sudo touch /var/log/lighttpd/error.log
	sudo chgrp pi /var/log/lighttpd /var/log/lighttpd/error.log
	sudo chmod g+w /var/log/lighttpd /var/log/lighttpd/error.log
	sudo /etc/init.d/lighttpd restart
else
	echo "The lighttpd web server does not appear to be installed, run "
	echo ""
	echo "	sudo apt-get install lighttp"
	echo ""
	echo "and then rerun the cdpf setup"
fi

echo "Configuring cron job..."
crontab -l | fgrep -q "cdpf-sync" && {
	echo "cron job already exists"
} || {
	echo "adding cron job..."
	crontab -l >/tmp/crontab-cdpf.txt
	echo "*/15 * * * * /home/pi/cdpf-sync.sh" >>/tmp/crontab-cdpf.txt
	crontab /tmp/crontab-cdpf.txt
}