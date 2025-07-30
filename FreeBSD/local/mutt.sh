#!/bin/sh

V=2.2.14

fetch http://ftp.mutt.org/pub/mutt/mutt-${V}.tar.gz
tar zxf mutt-${V}.tar.gz && cd mutt-${V}/
./configure --prefix=/opt/local/mutt \
	--disable-gpgme \
	--disable-pgp \
	--disable-doc \
	--without-sqlite3 \
	--without-gss \
	--without-ssl \
	--without-gnutls \
	--without-sasl
make && make install
