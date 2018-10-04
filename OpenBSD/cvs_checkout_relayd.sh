#!/bin/sh
if [ ! -z ${1} ]; then
        SERVER=${1}
else
        SERVER=ftp.hostserver.de
fi

cvs -qd anoncvs@${SERVER}:/cvs get -P src/usr.sbin/relayd
cvs -qd anoncvs@${SERVER}:/cvs get -P src/usr.sbin/relayctl
cvs -qd anoncvs@${SERVER}:/cvs get -P src/include/siphash.h
###
# snmp
###
cvs -qd anoncvs@${SERVER}:/cvs get -P src/usr.sbin/snmpd/snmp.h
###
# libimsg
###
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libutil/imsg-buffer.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libutil/imsg.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libutil/imsg.h
###
# regress
###
cvs -qd anoncvs@${SERVER}:/cvs get -P src/share/mk/bsd.regress.mk
cvs -qd anoncvs@${SERVER}:/cvs get -P src/regress/usr.sbin/relayd
###
# libevent
###
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libevent
cvs -qd anoncvs@${SERVER}:/cvs get -P src/include/asr.h
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libc/stdlib/reallocarray.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libc/stdlib/recallocarray.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libc/asr/asr.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libc/asr/asr_private.h
###
# create ChangeLog
./_changelog.sh
# remove CVS directories
./_rmcvsdir.sh
