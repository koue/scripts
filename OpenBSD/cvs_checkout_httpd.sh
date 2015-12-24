#!/bin/sh

cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/usr.sbin/httpd
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/include/blf.h
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/lib/libc/crypt/bcrypt.c
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/lib/libc/crypt/cryptutil.c
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/lib/libtls
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/lib/libutil/imsg-buffer.c
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/lib/libutil/imsg.c
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/lib/libutil/imsg.h
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/lib/libssl/src/crypto/o_time.h
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/lib/libssl/src/crypto/asn1/a_time_tm.c
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/lib/libc/gen/vis.c
cvs -qd anoncvs@ftp5.eu.openbsd.org:/cvs get -P src/etc/examples/httpd.conf
