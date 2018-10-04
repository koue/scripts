#!/bin/sh
if [ ! -z $1 ]; then
	SERVER=$1
else
	SERVER=ftp.hostserver.de
fi

cvs -qd anoncvs@$SERVER:/cvs get -P src/sbin/iked
cvs -qd anoncvs@$SERVER:/cvs get -P src/usr.sbin/ikectl
cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libutil/imsg.c
cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libutil/imsg-buffer.c
cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libutil/imsg.h
cvs -qd anoncvs@$SERVER:/cvs get -P src/sys/netinet/ip_ipsp.h
cvs -qd anoncvs@$SERVER:/cvs get -P src/sys/net/pfkeyv2.h
###
# create ChangeLog
./_changelog.sh
# remove CVS directories
./_rmcvsdir.sh
