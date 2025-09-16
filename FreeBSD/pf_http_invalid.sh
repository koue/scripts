#!/bin/sh

# block ip/32
tcpdump -ln -i vtnet0 dst port 80 | grep --line-buffered "(invalid)" | sed -ln 's/.*IP \([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*/\1/p' | ( while read line ; do pfctl -qt wwwblock -T test $line || pfctl -vt wwwblock -T a $line; done )
