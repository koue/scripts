#!/bin/bash

if [ -z $1 ]
then
        echo "backup level is missing!"
        exit 1
fi
# backup level (0 - full, 1 - incremental from the last full backup )
LEVEL=$1

# execute backupd conf file to load variables (archive_path)
archive_path='/srv/backup'

if [ ! -d $archive_path/svn ]
then
        mkdir $archive_path/svn
else
	echo "$archive_path directory does not exist"
	exit 1
fi

# edit SVN_PATH and URL with correct values 
SVN_PATH="/srv/svn"
URL="http://url/svn"

# comment these lines or script will not work!
echo "You didn't read SVN backup script! The file is not configured!!!"
exit 1
#

for repo in `ls $SVN_PATH`
do
        /usr/bin/svn info $URL/$repo | grep Revision | cut -d ' ' -f 2 > $archive_path/svn/$repo.revision

        if [ $LEVEL -eq 0 ]
        then
                cp $archive_path/svn/$repo.revision $archive_path/svn/$repo.revision.prev
                PREV_REV=0
        fi
        if [ $LEVEL -gt 0 ]
        then
                PREV_REV=`cat $archive_path/svn/$repo.revision.prev`
        fi

        CURR_REV=`cat $archive_path/svn/$repo.revision`

        if [ `expr $PREV_REV + 1` -lt $CURR_REV ]
        then
                /usr/bin/svnadmin -q dump $SVN_PATH/$repo --revision `expr $PREV_REV + 1`:$CURR_REV --incremental > $archive_path/svn/`date '+%F'`-$repo-bkp-rev-`expr $PREV_REV + 1`-$CURR_REV.dump
                /bin/tar jcf $archive_path/svn/`date '+%F'`-$repo-bkp-rev-`expr $PREV_REV + 1`-$CURR_REV.dump.tar.bz2 $archive_path/svn/`date '+%F'`-$repo-bkp-rev-`expr $PREV_REV + 1`-$CURR_REV.dump
                rm -rf $archive_path/svn/`date '+%F'`-$repo-bkp-rev-`expr $PREV_REV + 1`-$CURR_REV.dump
        fi
done
