#!/bin/sh

### conf
PROG=${1##files.}
CVSSERVER=${2:-ftp.hostserver.de}
CVSUSER=${3:-anoncvs}
CVSDIR=CVSDIR
CVS2CL="../../../cvs2cl.pl"
ENDDATE=`date +%F`

### usage
fn_usage() {
	echo
	echo "Usage:   ${0} [prog] [cvs server] [cvs user]"
	echo "Example: ${0} httpd"
	echo "Progs list:"
	for p in `ls files.*`
	do
		PROG=${p##files.}
		printf "%11s ${PROG}\n"
	done
	echo
	exit 1
}

### Initial check
[ -z ${PROG} ] && fn_usage
[ ! -f files.${PROG} ] && echo "files.${PROG} is missing" && exit 1

### cvs checkout files
mkdir -p ${CVSDIR}/ && cd ${CVSDIR}/
for f in `cat ../files.${PROG} | grep -v "^#"`
do
	cvs -qd ${CVSUSER}@${CVSSERVER}:/cvs get -P ${f}
done

### Generate ChangeLog file
[ ! -d src ] && echo "No cvs src directory" && exit 1
cd src/
[ ! -x ${CVS2CL} ] && echo "${CVS2CL} is missing or not executable " && exit 1
# httpd project starts from 2014-07-13
[ -d usr.sbin/httpd ] && STARTDATE="2014-07-12" || STARTDATE=""
${CVS2CL} -l "-d${STARTDATE}<${ENDDATE}"
mv ChangeLog ../

### Remove CVS directories
find ./ -type d -name CVS | xargs rm -r
