#!/bin/bash

PREFIX=`cat /etc/tuxdroid/tuxdroid.conf |grep PREFIX|cut -d "=" -f 2`

echo "Removing files"
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
rm -r $PREFIX/share/tuxdroid/
rm -r $PREFIX/lib/tuxdroid/
rm -r /etc/tuxdroid/
rm -r /opt/Acapela
rm -r $PREFIX/share/applications/tuxbox.desktop
rm -r $PREFIX/share/pixmaps/tuxbox.png
rm $PREFIX/bin/tuxhttpserver
rm $PREFIX/bin/tuxsh
rm $PREFIX/bin/tuxbox
rm $PREFIX/bin/tux_wifi_channel

for dir in `find $PREFIX -type d -empty`; do
    rmdir $dir
done
echo "Done."
