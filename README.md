Connected Digital Photo Frame - Client Side
====


All the files needed to put together your own *Raspberry Pi* based digital photo frame.

See: [my project blog](http://scaryprojects.blogspot.com/2013/02/connected-digital-photo-frame.html).

====

## CDPF Client Step-by-Step 

v1.4

#### What you’ll need

##### Essentials
- Raspberry Pi
- SD-Card (2GB min, 4GB-8GB better, quality brand, high speed makes a difference) 
- USB Keyboard (without integrated hub preferably) [temporary]
- USB Mouse [temporary]
- Power supply:
 - Micro USB phone charger
 - Micro USB cable from computer (high wattage) or powered hub
- Monitor or TV
- Video cable for above (HDMI to ?????)
- Wired or wireless internet connection 
- Wired: ethernet cable
- Wireless: WiFi adaptor

##### Nice To Have
- Case
- WiFi adaptor (make sure it is supported by ARM drivers)


#### Raspian Boot Drive (SD-Card) Creation

These instructions are based on the Raspian Distribution, you can get the latest image at the Raspberry Pi Foundation’s web site raspberrypi.org. Here’s the link to the download page: http://www.raspberrypi.org/downloads

Note: For the easiest setup, use the NOOB instructions and choose Raspian for the OS install.

Once you get the disk image you need to create a bootable SD-Card. This can be the trickiest part of the setup process in you are not familiar with the tools. Follow one of the many excellent sets of instructions:
http://elinux.org/RPi_Easy_SD_Card_Setup
http://www.engadget.com/2012/09/04/raspberry-pi-getting-started-guide-how-to/
http://lifehacker.com/5976912/a-beginners-guide-to-diying-with-the-raspberry-pi

#### First Boot of Raspbian – Raspi-Config

The first time you boot your freshly created SD-Card, Raspian will auto run this text based config tool.

Arrow up and down and use Enter to run a config task
- Run update - this will take a few min
- Run expand_rootfs - this will let you use all the sapce on your memory card
- Run configure_keyboard - it is set to UK by default, finding ~ will drive you crazy
- Pick “Generic 104” for an ordinary “Windows keyboard”, 
- then Other, then English (US) twice, take defaults
 - Note: Both of the Apple keyboards I have tried have an integrated USB hub and have power issues.
- Run change_timezone  
- Run ssh - enable
- Run boot_behaviour - pick Yes to auto login to desktop
- Run others if you want
- Tab to finish, press enter
- Reboot - should ask, if not, unplug power, pause, replug

#### Second Boot

You should have booted into the LXDE desktop.

If this is your first time using a Raspberry Pi, take a moment to look around. Run some apps. Besides the icons on the desktop, there is a Windows XP/7-like start menu which opens if you click on the icon on the left side of the ‘task bar’ at the bottom of the screen. Have fun, you probably won’t hurt anything.

You may find the desktop a little bit less responsive than you are used to. It takes a while to launch apps so sometimes I’m not sure my double click worked and I end up launching two or three copies of the same app.

#### Install Software

Raspian is pretty minimal linux distribution, it doesn’t have a lot of software that is usually pre-installed on more fully featured distributions.

Raspian (a Debian based distribution) uses apt-get for software installation, the usual pattern for installing a package follows this pattern:

```sudo apt-get install package```

However, before you install anything, update the installer first with:

```pi@raspberrypi ~ $ sudo apt-get update```

apt-get will usually ask if you wish to continue after it figures out what it needs to install. Be prepared to answer yes when it asks, you should see how much ‘disk’ space is need for each install.

Here’s what you should install for the full CDPF system:

 - feh
 - lighttpd
 - git

You can get it all done in one go with:

```pi@raspberrypi ~ $ sudo apt-get install feh lighttpd git```

##### Get the CDPF Client Software

In the home directory, get the latest software:

```pi@raspberrypi ~ $ git clone https://github.com/mscalora/cdpf-client.git```

There is a setup script that you can examine called setup.sh. If this is a brand new Pi, there’s not much to mess up, but just in case you can look at the setup script to see what it is doing. To run it, type:

```pi@raspberrypi ~ $ bash cdpf-client/setup.sh```

Finally, you will want to configure your photo source or leave it alone to see some test photos:

```pi@raspberrypi ~ $ nano cdpf.conf```

Set the CDPF_SYNC_URL variable to the URL of your page that has the photos. For the cdpf-server scripts, this would end in “sync”. If you are using the openshift server your URL configuration would look something like:

```CDPF_SYNC_URL="http://appname-userid.rhcloud.com/sync" ```

where appname is you openshift application name and userid is your openshift userid.

Now, you are ready to reboot.

#### Reboot 

There’s no on/off switch so you can either pull the power, wait a sec and plug to power back in or run the following command:

```pi@raspberrypi ~ $ sudo reboot```

