#!/bin/sh

cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/sbin/iked
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/usr.sbin/ikectl
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/lib/libutil/imsg.c
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/lib/libutil/imsg-buffer.c
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/lib/libutil/imsg.h
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/sys/netinet/ip_ipsp.h
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/sys/net/pfkeyv2.h
