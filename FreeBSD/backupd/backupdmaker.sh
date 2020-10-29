#! /bin/sh

mydir=$(cd `dirname ${0}` && pwd)

usage() {
        echo "usage: ${0} [configuration_file] [level]" >&2
}

run_post_backup() {
	for script in ${mydir}/backupd.d/post-backupd/*; do
		[ -x "${script}" ] && {
			echo "running post-backupd script: ${script}"
			${script} "$@"
		}
	done
}

run_pre_backup() {
	for script in ${mydir}/backupd.d/pre-backupd/*; do
		[ -x ${script} ] && {
			echo "running pre-backupd script: ${script}"
			${script} "$@"
		}
	done
}

# check params
test -z "${1}" && { usage && exit 1; }
test -z "${2}" && { usage && exit 1; }

configfile=${1}
level="${2}"

if [ ! -f "${configfile}" ]; then
echo "Can't find config file!" >&2
exit 1;
fi

# load configuration file
. ${configfile}

# check level
echo "${level}" | grep -E '^[0-9]$' >/dev/null 2>&1 || { usage && exit 1; }

# check configuration
if [ -z "${archive_name}" ]; then
        echo "missing archive_name in configuration!" >&2
        exit 1;
fi
if [ -z "${archive_path}" ]; then
        echo "missing archive_path in configuration!" >&2
        exit 1;
fi
if [ ! -d "${archive_path}" ]; then
        echo "invalid archive_path!" >&2
        exit 1
fi
if [ -z "${chunk_size}" ]; then
       chunk_size=2000m
fi
if [ -z "${niceness}" ]; then
       niceness=17
fi

prepare_script=${mydir}/${archive_name}.pre.sh
if [ -x "${prepare_script}" ]; then
        ${prepare_script} ${configfile}
	if [ $? -gt 0 ]; then
        	echo "prepare script failed!" >&2
        	exit 1;
	fi
fi

archive_list=${mydir}/${archive_name}.list
if [ ! -f "${archive_list}" ]; then
        echo "missing archive filelist: ${archive_list}!" >&2
        exit 1;
fi

exclude_list=${mydir}/$exclude_backup_list
if [ ! -f "${exclude_list}" ]; then
	touch "${exclude_list}"
fi

cdate=`date +%F`
archive_name_long=${archive_name}-level${level}-${cdate}
mkdir ${archive_path}/${archive_name_long}

# copy previos list if level>0
if [ "${level}" -gt 0 ]; then
	let prev_level=$((level - 1))
	prev_level_list=${mydir}/${archive_name}-level${prev_level}.inc.list
	test ! -r "${prev_level_list}" && {
		echo "no previos incremental list found: ${prev_level_list}" >&2
		exit 1
		}
	cp ${prev_level_list} ${mydir}/${archive_name}-level${level}.inc.list
else
	if [ -f ${mydir}/${archive_name}-level${level}.inc.list ]; then
		rm ${mydir}/${archive_name}-level${level}.inc.list
	fi
fi

# run pre-backupd scripts
run_pre_backup ${mydir}/${archive_name_long}

# make backup
nice -n ${niceness} gtar -c -X ${exclude_list} -T ${archive_list} -g ${mydir}/${archive_name}-level${level}.inc.list -f - | \
nice -n ${niceness} gzip | \
nice -n ${niceness} split -b ${chunk_size} - ${archive_path}/${archive_name_long}/${archive_name_long}.tar.gz.

# run post-backupd scripts
run_post_backup ${archive_path}/${archive_name_long}
