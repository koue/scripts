#!/bin/sh
#
# Where to put builded packages
export PKGREPOSITORY=/srv/www/All
# Skip port config dialog. Recommend to execute make config-recursive before start the script.
export BATCH=yes
# Create packages for these ports and dependencies
PORTS_LIST='
/usr/ports/mail/dspam
/usr/ports/security/tor
'
#

WORKING_DIR=`pwd`

# Make copy of passwd file because some of ports add new users
cp /etc/passwd $WORKING_DIR/.passwd.backup

# Clean newly created users during ports installation
clear_users(){
	for USER in `diff $WORKING_DIR/.passwd.backup /etc/passwd | grep "^>" | sed 's/> \([_a-z0-9]*\):.*/\1/'`
	do
		pw userdel $USER -r
	done
}

# Remove all installed packages and get ready to do it again from scratch.
# Keep thttpd because I am using it to serve the packages.
clear_ports() {
	for PORT in `pkg_info | cut -d ' ' -f1 | grep -v thttpd`
	do
		pkg_delete -f $PORT
	done
	clear_users
}

for PORT_PATH in $PORTS_LIST
do
	# Enter into the port directory
	cd $PORT_PATH
	# Check if the port package already exists. If yes skip else check port dependencies
	pkg_add -r `make package-name`
	if [ $? -ne 0 ]
	then
		# Create dependencies list
		DLIST=`make missing`
		for DEP in $DLIST
		do
			# Enter into the dependencies directory
			cd /usr/ports/$DEP
			# Try to install already created packages. Skip errors for
			# missing packages. Will create them with next step package-recursive
			pkg_add -r `make package-name`
		done
		# Return back to port directory
		cd $PORT_PATH
		# Create all missing packages
		make package-recursive clean
	else
		clear_ports
	fi
done
# Clean the environment
clear_ports
rm -rf $WORKING_DIR/.passwd.backup
