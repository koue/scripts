#!/bin/sh
PROJ=/usr/home/nkolev/dev/HASH
#
cd $PROJ
gcc -Wall -fPIC -c lib*.c
for i in `ls lib*.o`
do
	first=`echo $i | sed -e s/lib//g`
	second=`echo $first | cut -d . -f 1`
	gcc -shared -Wl,-soname,lib$second.so.1 -o lib$second.so.1.0  $i
done
#
rm -rf $PROJ/LIBS/*
mv lib*.so.1.0 $PROJ/LIBS/
cd $PROJ/LIBS
for i in `ls`
do
	lib=`echo $i | cut -d . -f 1`
	ln -s $i $lib.so
	ln -s $i $lib.so.1
done
#$ gcc -Wall -L/opt/lib kruf.c -lhashes -o kruf

