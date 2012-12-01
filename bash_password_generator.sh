#!/bin/sh <br />
/usr/bin/head -c 200 /dev/urandom | tr -cd '[:graph:]' | head -c 15 <br />
echo
