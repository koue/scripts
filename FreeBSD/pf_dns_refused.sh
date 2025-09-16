#!/bin/sh

# block net/24
tcpdump -ln -i vtnet0 src port 53 | grep --line-buffered Refused | sed -ln 's/.* \([0-9]*\.[0-9]*\.[0-9]*\).*/\1/p' | ( while read line ; do pfctl -qt dnsblock -T test $line.0/24 || pfctl -vt dnsblock -T a $line.0/24; done )
