#!/bin/sh

# load config
. `dirname ${0}`/devports.conf

if [ ! -d ${POUDRIERE_SCRIPTS} ]
then
	echo "Missing poudriere scripts directory."
	exit 1
fi

cd ${POUDRIERE_SCRIPTS}

if [ ! -f git_last ]
then
	touch git_last
fi

git ls-remote "${REPO_URL}" HEAD > git_current

diff -q git_last git_current

if [ $? -eq 1 ]
then
	if [ -d "${REPO}" ]
	then
		rm -rf ${REPO}
	fi
	
	git clone ${REPO_URL}

	poudriere ports -d -p ${PORTSET}
	poudriere ports -c -p ${PORTSET}

	CATEGORY=`find ${REPO}/ -depth 2 -type d | grep -v git | cut -d '/' -f 2`
	PORT=`find ${REPO}/ -depth 2 -type d | grep -v git | cut -d '/' -f 3`
	PORTPATH=${POUDRIERE_DATA}/ports/${PORTSET}/${CATEGORY}

	if [ -d ${PORTPATH} ]
	then
		mv ${PORTPATH}/${PORT} ${PORTPATH}/${PORT}.orig
	fi

	cp -rv ${REPO}/${CATEGORY}/${PORT} ${PORTPATH}/

	echo ${CATEGORY}/${PORT} > ${POUDRIERE_SCRIPTS}/build

	mv git_current git_last

	${POUDRIERE_SCRIPTS}/build.sh
#	${POUDRIERE_SCRIPTS}/copy_logs.sh ${PORT}
fi
