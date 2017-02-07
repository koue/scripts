#!/bin/sh
if [ ! -z $1 ]; then
	SERVER=$1
else
	SERVER=ftp.hostserver.de
fi

cvs -qd anoncvs@$SERVER:/cvs get -P src/usr.sbin/httpd
cvs -qd anoncvs@$SERVER:/cvs get -P src/include/blf.h
cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libc/crypt/bcrypt.c
cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libc/crypt/blowfish.c
cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libc/crypt/cryptutil.c
#cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libtls
cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libutil/imsg-buffer.c
cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libutil/imsg.c
cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libutil/imsg.h
cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libc/gen/vis.c
cvs -qd anoncvs@$SERVER:/cvs get -P src/etc/examples/httpd.conf
cvs -qd anoncvs@$SERVER:/cvs get -P src/usr.bin/htpasswd
#cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libc/string/timingsafe_bcmp.c
#cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libc/string/timingsafe_memcmp.c
#cvs -qd anoncvs@$SERVER:/cvs get -P src/lib/libcrypto/asn1/a_time_tm.c
