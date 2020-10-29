#!/bin/sh
usage() {
	echo "usage: $0 [configuration_file]" >&2
}

mydir=$(cd `dirname ${0}` && pwd)

test -z "$1" && { usage && exit 1; }
. $1
touch ${mydir}/${tmp_backup_list}
#make full list
cat ${mydir}/${permanent_backup_list} ${tmp_backup_list} > ${mydir}/${archive_name}.list
