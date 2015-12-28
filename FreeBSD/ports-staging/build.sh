#!/bin/sh

# clean previous logs
rm -rf /usr/local/poudriere/data/logs/bulk
#
for j in `ls /usr/local/poudriere/jails/`;
do
        poudriere bulk -C -t -f /usr/local/etc/poudriere.d/scripts/build -j $j
done
