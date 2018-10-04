#!/bin/sh

CVS2CL="../../cvs2cl.pl"
ENDDATE=`date +%F`

[ ! -d src ] && echo "No cvs src directory" && exit 1
cd src/
[ ! -x ${CVS2CL} ] && echo "${CVS2CL} is missing or not executable " && exit 1
# httpd project starts from 2014-07-13
[ -d usr.sbin/httpd ] && STARTDATE="2014-07-13" || STARTDATE=""

${CVS2CL} -l "-d${STARTDATE}<${ENDDATE}"
