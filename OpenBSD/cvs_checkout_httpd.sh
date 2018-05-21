#!/bin/sh
if [ ! -z $1 ]; then
	SERVER=$1
else
	SERVER=ftp.hostserver.de
fi

cvs -qd anoncvs@${SERVER}:/cvs get -P src/usr.sbin/httpd
cvs -qd anoncvs@${SERVER}:/cvs get -P src/include/blf.h
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libc/crypt/bcrypt.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libc/crypt/blowfish.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libc/crypt/cryptutil.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libutil/imsg-buffer.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libutil/imsg.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libutil/imsg.h
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libc/gen/vis.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/etc/examples/httpd.conf
cvs -qd anoncvs@${SERVER}:/cvs get -P src/usr.bin/htpasswd
###
# regress
###
cvs -qd anoncvs@${SERVER}:/cvs get -P src/share/mk/bsd.regress.mk
cvs -qd anoncvs@${SERVER}:/cvs get -P src/regress/usr.sbin/httpd
###
# libevent
###
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libevent
cvs -qd anoncvs@${SERVER}:/cvs get -P src/include/asr.h
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libc/stdlib/reallocarray.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libc/stdlib/recallocarray.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libc/asr/asr.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libc/asr/asr_private.h
