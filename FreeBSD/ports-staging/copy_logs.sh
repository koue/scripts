#!/bin/sh

# $1 - port
# Usage: 
#
#       ./copy_logs.sh dhcpd

if [ -z $1 ]
then
        echo "usage: ./copy_logs.sh port"
        exit 1
fi

for j in `ls /usr/local/poudriere/jails/`;
do
        f=`ls /usr/local/poudriere/data/logs/bulk/"$j"-default/latest/logs/ | grep $1 | rev | cut -c 5- | rev`
        if [ -z $f ]
        then
                echo "Error: empty portname"
                exit 2
        fi
        cp /usr/local/poudriere/data/logs/bulk/$j-default/latest/logs/$f.log /usr/local/etc/poudriere.d/scripts/$f-$j.log.txt
done

#scp /usr/local/etc/poudriere.d/scripts/*.log koue@chaosophia.net:~/poudriere
mv /usr/local/etc/poudriere.d/scripts/*.log.txt /usr/local/www/thttpd/data/poudriere
echo "<html><head><title>poudriere</title><head><body>" > /usr/local/www/thttpd/data/poudriere/index.html
for f in `ls /usr/local/www/thttpd/data/poudriere/*.log.txt`
do
	PORT=`echo $f | cut -d '/' -f 8`
	echo "<a href='$PORT'>$PORT</a><br />" >> /usr/local/www/thttpd/data/poudriere/index.html
done
echo "</body></html>" >> /usr/local/www/thttpd/data/poudriere/index.html
