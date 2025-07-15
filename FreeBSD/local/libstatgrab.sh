#!/bin/sh

V=0.92.1
VM=`echo ${V} | sed 's/\./_/g'`

fetch https://github.com/libstatgrab/libstatgrab/releases/download/LIBSTATGRAB_${VM}/libstatgrab-${V}.tar.gz
tar zxf libstatgrab-${V}.tar.gz && cd libstatgrab-${V}/
./configure --prefix=/opt/statgrab \
	--without-perl5
make && make install
