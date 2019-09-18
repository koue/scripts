#!/bin/sh

# load config
. `dirname ${0}`/devports.conf

[ -z ${1} ] && echo "Missing port name." && exit 1

for i in `find ${POUDRIERE_DATA}/data/logs/bulk | grep ${1} | grep ${PORTSET}.log`
do
	less ${i}
done
