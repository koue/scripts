#!/bin/sh
# 
# All spam mails are forwarded to spamd mailbox 
#
# collect spammer mails
cat /var/mail/spamd >> /data/www/spamd/spamd.txt
# create list of spammers IP
for i in $(cat /var/mail/spamd | grep -A1 -e "^Received:" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' | sed -e "s/--/\\`echo -e '\n\r'`/g" | sed -n 's/.*\(\[[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*chaosophia.net.*/\1/p' | cut -d '[' -f 2 | sort -n | uniq)
do
	pfctl -t spamd -T add $i
	echo $i
done
# truncate spamd mailbox
cat /dev/null > /var/mail/spamd
