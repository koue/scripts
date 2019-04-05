#!/bin/sh

# clone repos
for r in libcez.git \
	 nlist.git \
	 rssroll.git \
	 httpd.git \
	 scripts.git \
	 env.git \
	 cipier.git \
	 slowcgi.git \
	 botsh.git \
	 graffer.git \
	 patches.git \
	 dhcpd.git \
	 iked.git \
	 lfde.git \
	 libimsg.git
do
	if [ -d ${r} ]
	then
		cd ${r} && git fetch --prune && cd ../
	else
		git clone --mirror https://github.com/koue/${r}
	fi
done
chown -R git:git *.git
