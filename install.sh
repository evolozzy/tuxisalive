#!/bin/bash

PREFIX=/usr

while getopts "p:" options; do
    case $options in
        p)
            PREFIX=$OPTARG
            ;;
    esac
done

# Cleanup the old files
rm -f /usr/bin/tuxsh
rm -f /usr/bin/tux_updater
rm -f /usr/bin/tux_control_center
rm -f /usr/bin/tuxhttpserver
rm -f /usr/bin/tuxgi
rm -f /usr/bin/tux_wifi_channel
rm -f /usr/bin/tuxup

# Cleanup the old API installations
for file in `find /usr/lib/python* -name "tuxisalive*" 2>/dev/null` ; do
    echo $file
    rm -rf $file
done
for file in `find /usr/lib/python* -name "tuxapi*" 2>/dev/null`; do
    rm -rf $file
done
for file in `find /usr/local/lib/python* -name "tuxisalive*" 2>/dev/null`; do
    rm -rf $file
done
for file in `find /usr/local/lib/python* -name "tuxapi*" 2>/dev/null`; do
    rm -rf $file
done

# Cleanup the /tmp folder in case of the server has been started as root.
if [ -d /tmp/TuxDroidServer ]; then rm -rf /tmp/TuxDroidServer; fi
if [ -d /tmp/workForAttitunes ]; then rm -rf /tmp/workForAttitunes; fi
if [ -d /tmp/workForGadgets ]; then rm -rf /tmp/workForGadgets; fi
if [ -d /tmp/workForPlugins ]; then rm -rf /tmp/workForPlugins; fi

echo Copying files
if [ ! -e $PREFIX ]; then mkdir -p $PREFIX; fi
if [ ! -e $PREFIX/lib ]; then mkdir $PREFIX/lib; fi
if [ ! -e $PREFIX/bin ]; then mkdir $PREFIX/bin; fi
if [ ! -e $PREFIX/share ]; then mkdir $PREFIX/share; fi
if [ ! -e $PREFIX/share/applications ]; then mkdir $PREFIX/share/applications; fi
if [ ! -e $PREFIX/share/pixmaps ]; then mkdir $PREFIX/share/pixmaps; fi
cp -r ./mirror/etc/* /etc/
cp -r ./mirror/opt /
cp -r ./mirror/usr/lib/* $PREFIX/lib/
cp -r ./mirror/usr/bin/* $PREFIX/bin/
cp -r ./mirror/usr/share/tuxdroid $PREFIX/share/
cp -r ./mirror/usr/share/applications/* $PREFIX/share/applications/
cp -r ./mirror/usr/share/pixmaps/* $PREFIX/share/pixmaps/

cd $PREFIX/share/tuxdroid/pyapi
python2 setup.py install
cd - > /dev/null
rm -rf $PREFIX/share/tuxdroid/pyapi

# Creating launcher for the specified PREFIX
sed s:/usr:$PREFIX:g $PREFIX/bin/tuxhttpserver > /tmp/tuxhttpserver
mv /tmp/tuxhttpserver $PREFIX/bin/tuxhttpserver

sed s:/usr:$PREFIX:g $PREFIX/bin/tuxsh > /tmp/tuxsh
mv /tmp/tuxsh $PREFIX/bin/tuxsh

sed s:/usr:$PREFIX:g $PREFIX/bin/tuxbox > /tmp/tuxbox
mv /tmp/tuxbox $PREFIX/bin/tuxbox

sed s:/usr:$PREFIX:g /etc/tuxdroid/tuxdroid.conf > /tmp/tuxdroid.conf
mv /tmp/tuxdroid.conf /etc/tuxdroid/tuxdroid.conf

# Change the permissions of the launchers
chmod 755 $PREFIX/bin/tuxhttpserver
chmod 755 $PREFIX/bin/tuxsh
chmod 755 $PREFIX/bin/tuxbox

# Change the permission on the USB device
if [ -e /dev/usb/hiddev0 ]; then
    chmod 0666 /dev/usb/hiddev*
fi

if [ -e /dev/hiddev0 ]; then
    chmod 0666 /dev/hiddev*
fi

if [ ! -e /usr/lib32/libpython2.6.so.1* ]; then
    if [ ! -d /usr/lib32/ ]; then
        mkdir -p /usr/lib32
    fi
    mkdir /tmp/py4tux
    cp /usr/share/tuxdroid/py4tux/lib/libpython2.6.a /tmp/py4tux
    cd /tmp/py4tux
    ar -x -v libpython2.6.a
    mkdir output
    gcc -m32 -o output/libpython.so.1.0 *.o -lpthread -lm -lz -ldl -lutil -pipe -shared
    cp output/libpython.so.1.0 output/libpython2.6.so.1.0
    mv output/libpython2.6.so.1.0 /usr/lib32
    cd - > /dev/null
    rm -r /tmp/py4tux
fi

# Cleanup the out of the date files
#rm -f /usr/bin/tuxsh
rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-audacious.scp
rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-facebook.scp
rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-gmail.scp
rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-hotmail.scp
rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-mail.scp
rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-pidgin.scp
rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-programsTv.scp
#rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-shortcut.scp
rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-skype.scp
#rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-totem.scp
rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-twitter.scp
rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-weather.scp
rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-webradio.scp
rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-webradio-de.scp
#rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-xmms.scp
rm -f $PREFIX/share/tuxdroid/resources/plugins/plugin-yahoo.scp

#rm -f $PREFIX/share/tuxdroid/resources/gadgets/gadget_2ba0fe92-c73f-61b5-50c5-d8de0aee9194.scg
#rm -f $PREFIX/share/tuxdroid/resources/gadgets/gadget_5c5e7e0d-89c5-8799-3175-df2bddf5653c.scg
#rm -f $PREFIX/share/tuxdroid/resources/gadgets/gadget_06d0b3ba-7781-4d2d-bd48-520cfa18e0c9.scg
#rm -f $PREFIX/share/tuxdroid/resources/gadgets/gadget_8d692b92-6de4-1ddf-c42f-b1068569d9d4.scg
#rm -f $PREFIX/share/tuxdroid/resources/gadgets/gadget_33b14aea-907e-9d9d-7e64-c40c3bbf56fb.scg
#rm -f $PREFIX/share/tuxdroid/resources/gadgets/gadget_56cdb050-3bba-d814-32c5-df4b90fee8c3.scg
#rm -f $PREFIX/share/tuxdroid/resources/gadgets/gadget_59cce412-9224-639c-d64d-9d25de84b960.scg
#rm -f $PREFIX/share/tuxdroid/resources/gadgets/gadget_69848cab-41c2-c81a-e018-84cf0adb25d3.scg
#rm -f $PREFIX/share/tuxdroid/resources/gadgets/gadget_84628d00-1e17-62dd-eaa4-7b11436f3211.scg
#rm -f $PREFIX/share/tuxdroid/resources/gadgets/gadget_d71cec40-c44e-73d7-e63f-a152986354e0.scg


echo Done.
