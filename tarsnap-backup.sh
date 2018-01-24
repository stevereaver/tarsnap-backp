#!/bin/sh

HOME=/home/tarsnap
EXCLUDE=$HOME/bin/exclude.list
DATE=`date +%Y-%m-%d_%H-%M-%S`
EMAIL=stevereaver@gmail.com
TARSNAP_OUTPUT_FILENAME=/home/tarsnap/log/tarsnap-output-$DATE.log
BACKUP_NAME=$(uname -n)-$(date +%Y-%m-%d_%H-%M-%S)
MAX_SIZE=10M

# Find files larger than MAX_SIZE for exclusion
find /mnt -type f -size +$MAX_SIZE > $EXCLUDE

#/usr/bin/tarsnap --dry-run --lowmem --maxbw-rate 50000 --no-quiet -X $EXCLUDE -c -v -f $BACKUP_NAME /mnt  >$TARSNAP_OUTPUT_FILENAME 2>&1
/usr/bin/tarsnap --lowmem --maxbw-rate 100000 --no-quiet -X $EXCLUDE -c -v -f $BACKUP_NAME /mnt  >$TARSNAP_OUTPUT_FILENAME 2>&1

# Send email
#if [ $? -eq 0 ]; then
#       subject="Tarsnap backup success"
#else
#       subject="Tarsnap backup FAILURE"
#fi
#mail -s "$subject" $email < $tarsnap_output_filename

/usr/bin/tarsnap --print-stats -f $BACKUP_NAME >> $TARSNAP_OUTPUT_FILENAME
gzip $TARSNAP_OUTPUT_FILENAME

# Backup the tarsnap directory
rm -rf /mnt/archive/tarsnap.bak
cp -r /home/tarsnap /mnt/archive/tarsnap.bak
