#!/bin/sh

[ -z ${1} ] && echo "Missing port name." && exit 1

for i in `find /usr/local/poudriere/data/logs/bulk | grep ${1} | grep devports.log`
do
	less ${i}
done
