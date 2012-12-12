#!/bin/sh
./barcode.pl
./image.pl
#EDIT ME
for i in `seq2 -s 1 -e 8`
do
    ./pdf.pl $i
done