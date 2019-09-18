#!/bin/sh

# load config
. `dirname ${0}`/devports.conf

# clean previous logs
rm -rf ${POUDRIERE_DATA}/data/logs/bulk
#
for j in `ls ${POUDRIERE_DATA}/jails/`;
do
        poudriere bulk -C -t -f ${POUDRIERE_SCRIPTS}/build -j ${j} -p ${PORTSET}
done
