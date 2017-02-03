#!/bin/sh
if [ ! -z $1]; then
	SERVER=$1
else
	SERVER=ftp.hostserver.de
fi

cvs -qd anoncvs@$SERVER:/cvs get -P src/usr.sbin/slowcgi
