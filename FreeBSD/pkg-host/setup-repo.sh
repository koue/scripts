#!/bin/sh

# load conf
. _pkg.conf

REPOPATH=${c_REPOPATH}
PJ=${c_PJ}
[ -z ${REPOPATH} ] && c_empty REPOPATH
[ -z ${PJ} ] && c_empty PJ
[ -d ${REPOPATH} ] && echo "${REPOPATH} directory already exists" && exit 1

mkdir -p ${REPOPATH}

cat << EOF >> ${REPOPATH}/FreeBSD.conf
FreeBSD: {
        enabled: no
}
EOF

cat << EOF >> ${REPOPATH}/chaosophia.conf
chaosophia: {
	url: "http://pkg.chaosophia.net/${PJ}-default",
	enabled: true
}
EOF
