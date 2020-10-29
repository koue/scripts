#!/bin/sh
set -o pipefail

niceness=17

usage() {
	echo "usage: ${0} <archive-path>"
}

archive_path=${1}

[ -z ${archive_path} ] || [ ! -d ${archive_path} ] && {
	usage
	exit 1
}

nice -n ${niceness} cat ${archive_path}/*.tar.gz.[a-z][a-z] | \
	nice -n ${niceness} gunzip -c | \
	nice -n ${niceness} gtar tvf - >${archive_path}/00INDEX
echo  $? > ${archive_path}/checked
