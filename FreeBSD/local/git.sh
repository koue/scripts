#!/bin/sh

V=2.50.1

fetch https://www.kernel.org/pub/software/scm/git/git-${V}.tar.gz
tar zxf git-${V}.tar.gz && cd git-${V}/
./configure \
	--without-openssl \
	--without-expat \
	--without-curl  \
	--without-tcltk \
	--without-iconv \
	--prefix=/opt/git
gmake && gmake install
