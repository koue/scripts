#!/bin/sh
if [ ! -z ${1} ]; then
	SERVER=${1}
else
	SERVER=ftp.hostserver.de
fi

# libutil
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libutil/imsg-buffer.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libutil/imsg.c
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libutil/imsg.h
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libutil/imsg_init.3
# dependencies
cvs -qd anoncvs@${SERVER}:/cvs get -P src/lib/libc/stdlib/recallocarray.c
###
# create ChangeLog
./_changelog.sh
# remove CVS directories
./_rmcvsdir.sh
