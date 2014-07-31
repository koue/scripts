#!/bin/sh
#
# Jul  4 15:58:35 chaosophia sm-mta[85826]: s64CwZgh085826: [5.39.223.33] did not issue MAIL/EXPN/VRFY/ETRN during connection to MTA 
echo "MAIL/EXPN/VRFY/ETRN"
for i in $(cat /var/log/maillog | grep MAIL/EXPN/VRFY/ETRN | sed -n 's/.*\(\[[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*/\1/p' | cut -d '[' -f 2 | sort -n | uniq)
do
	COUNT=`grep -c $i /var/log/maillog`
	if [ $COUNT -gt 0 ];
	then
		pfctl -t smtpforce -T a $i
		echo $i
	fi
done

# Jul 11 11:50:02 chaosophia sm-mta[70721]: s6B8n6u6070721: ruleset=check_mail, arg1=<noreply@ekbar.biz>, relay=ekb1.ekbar.biz [198.49.76.107] (may be forged), reject=451 4.1.8 Domain of sender address noreply@ekbar.biz does not resolve
echo "Domain of sender address does not resolve"
for i in $(cat /var/log/maillog | egrep -r "Domain of sender address .+ does not resolve" | sed -n 's/.*\(\[[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*/\1/p' | cut -d '[' -f 2 | sort -n | uniq)
do
	COUNT=`grep -c $i /var/log/maillog`
	if [ $COUNT -gt 1 ];
	then
		pfctl -t smtpforce -T a $i
		echo $i
	fi
done
# Jul 11 12:06:38 chaosophia sm-mta[71467]: s6B96b4W071467: <ujhl@koue.net>... User unknown
echo "User unknown"
for i in `grep -A1 "User unknown" /var/log/maillog | sed -n 's/.*\[\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)].*/\1/p' | sort -n | uniq`
do
	pfctl -t spamd -T add $i
	echo $i
done
