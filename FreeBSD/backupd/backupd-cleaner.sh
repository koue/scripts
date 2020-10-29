#!/bin/sh

### find and delete level2 backups older than 15 days (~2weeks )
### find and delete level1 backups older than 35 days (~1 month )

bdate=`date +%F`
echo "-----------------------" >> /var/log/backupd-cleaner.log
echo "${bdate}" >> /var/log/backupd-cleaner.log

. ./backupd-HOST.conf

find ${archive_path} -type d  -name "*level2*" -mtime +15 >> /var/log/backupd-cleaner.log
find ${archive_path} -type d  -name "*level1*" -mtime +35 >> /var/log/backupd-cleaner.log
find ${archive_path} -type d  -name "*level2*" -mtime +15 -exec rm -rf {} \+
find ${archive_path} -type d  -name "*level1*" -mtime +35 -exec rm -rf {} \+

