#!/bin/sh
/usr/bin/which gtar
if [ $? -ne 0 ]
then
	echo "GNU tar (gtar) is missing!"
	echo "Abort setup."
	exit 1
fi

host=`hostname -s`
echo "===================="
for i in `ls . | grep HOST`
do
	echo "Renaming $i file."
	mv $i `echo $i | sed -e s/HOST/$host/`
done
for i in `grep -l -r HOST ./* | grep -v setup.sh`
do
	echo "Editing $i file."
	sed -i.bak "s/HOST/$host/" $i
done
echo "Create permanent-backup.list file."
touch permanent-backup.list
echo "Done!"
echo "Create exclude-backup.list file."
touch exclude-backup.list
echo "Done!"
echo "===================="
