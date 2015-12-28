#!/bin/sh
TMP=/tmp/src.conf.$$

for module in `sed -n '/__DEFAULT_YES_OPTIONS =/,/__DEFAULT_NO_OPTIONS = /p' /usr/share/mk/bsd.own.mk | sed -n 's/.* \([_A-Z0-9]*\) .*/\1/p'`
do
	echo WITHOUT_$module=YES >> $TMP
done
# TODO: ZONEINFO is the last module and sed skip it
# Find solution! 
echo WITHOUT_ZONEINFO=YES >> $TMP
