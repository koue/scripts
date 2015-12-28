#!/bin/sh
#
# All spam mails are forwarded to spamd mailbox
#
# collect spammer mails
cat /var/mail/spamd >> /var/www/chaosophia.net/spamd/spamd.txt
# create list of spammers IP
for i in $(cat /var/mail/spamd | grep -A1 -e "^Received:" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' | sed -e "s/--/\\`echo -e '\n\r'`/g" | sed -n 's/.*\(\[[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*chaosophia.net.*/\1/p' | cut -d '[' -f 2 | sort -n | uniq | grep -v 127.0.0.1)
do
        pfctl -t spamd -T add $i
        echo $i
done
# truncate spamd mailbox
cat /dev/null > /var/mail/spamd
# update spamdlist.gz
/sbin/pfctl -t spamd -T s | gzip -9 > /var/www/chaosophia.net/spamd/spamdlist.gz
# produce list with spammers wasted seconds
cat /var/log/spamd.log | grep seconds | sed -n 's/.* \([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\):.* \([0-9]*\) seconds.*/\1 \2/p' | sort -n | \
perl -nle '@a = split / /, $_; if($last eq @a[0]) { $count += @a[1]; } else { $prev = $last; $last = @a[0]; $total = $count; $count = @a[1]; print "$prev $total"} ' | sort -n -r -k2 | column -t > /var/www/chaosophia.net/spamd/spammers_wasted_seconds.txt
