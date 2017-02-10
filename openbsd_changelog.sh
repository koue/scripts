#!/bin/sh

usage() {
	echo
	echo "`basename $0` [dhcpd|httpd|slowcgi] [date]"
	echo "`basename $0` httpd 2016-12-12"
	echo
	exit 1
}

WEBDIR="/path/to/www/data"
CVS2CL="/etc/scripts/cvs2cl.pl"
CL2HTML="/etc/scripts/cl2html.pl"
SERVER="ftp.hostserver.de"

if [ ! -d $WEBDIR ]; then
	echo "WEBDIR is missing"
	exit 1
fi

if [ -z $1 ] || [ -z $2 ];  then
	echo "Project or date is missing"
	usage
	exit 1
fi 

cd /tmp
# clean up old src directory
rm -rf src/
case "$1" in
	dhcpd)
		cvs -qd anoncvs@$SERVER:/cvs get -P src/usr.sbin/dhcpd
		cd src/
		$CVS2CL --xml -l "-d<$2"
		if [ $? -ne 0 ]; then
			exit 1
		fi
		$CL2HTML --entries 0 < ChangeLog > ChangeLog.html
		if [ ! -d $WEBDIR/dhcpd ]; then
			echo "Missing $WEBDIR/dhcpd"
			exit 1
		fi
		mv ChangeLog.html $WEBDIR/dhcpd/
		;;
	httpd)
		cvs -qd anoncvs@$SERVER:/cvs get -P src/usr.sbin/httpd
		cd src/
		$CVS2CL --xml -l "-d2014-07-13<$2"
		if [ $? -ne 0 ]; then
			exit 1
		fi
		$CL2HTML --entries 0 < ChangeLog > ChangeLog.html
		if [ ! -d $WEBDIR/httpd ]; then
			echo "Missing $WEBDIR/httpd"
			exit 1
		fi
		mv ChangeLog.html $WEBDIR/httpd/
		;;
	slowcgi)
		cvs -qd anoncvs@$SERVER:/cvs get -P src/usr.sbin/slowcgi
		cd src/
		$CVS2CL --xml -l "-d<$2"
		if [ $? -ne 0 ]; then
			exit 1
		fi
		$CL2HTML --entries 0 < ChangeLog > ChangeLog.html
		if [ ! -d $WEBDIR/slowcgi ]; then
			echo "Missing $WEBDIR/slowcgi"
			exit 1
		fi
		mv ChangeLog.html $WEBDIR/slowcgi/
		;;
	*)
		echo "Wrong project name $1"
		exit 1
		;;
esac
