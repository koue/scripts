#!/bin/sh

### conf
PROGS="dhcpd httpd imsg ldapd libevent slowcgi"
CVSSERVER=${2:-ftp.hostserver.de}
CVSUSER=${3:-anoncvs}
CVSDIR=CVSDIR
CVS2CL="../../../cvs2cl.pl"
WWWPATH="/var/www/htdocs/chaosophia.net/openbsd/"
STARTDATE=""
ENDDATE=`date +%F`

### Initial check
for p in ${PROGS}
do
	[ ! -f files.${p} ] && echo "files.${PROG} is missing" && exit 1
done

### cvs checkout files
[ ! -d ${CVSDIR} ] && mkdir -p ${CVSDIR}/
cd ${CVSDIR}/
for p in ${PROGS}
do
	for f in `cat ../files.${p} | grep -v "^#"`
	do
		cvs -qd ${CVSUSER}@${CVSSERVER}:/cvs get -P ${f}
	done
done

### Generate ChangeLog file
[ ! -d src ] && echo "No cvs src directory" && exit 1
cd src/
[ ! -x ${CVS2CL} ] && echo "${CVS2CL} is missing or not executable " && exit 1
${CVS2CL} -l "-d${STARTDATE}<${ENDDATE}" -f ChangeLog.txt
mv ChangeLog.txt ${WWWPATH}/
