# ******
# Weekly Report Generation Script- AIX Servers
#
# This Mount script which is a calling script called by the master script will mount the report generation script in all AIX servers and execute the commands to pull the required information on the server.Once the execution is successful #the nfs will be unmounted.
#
# # # It is known to run on ksh.
#
# History:
#  07-13-2015: Original created by Karthick Priya Arumugam
# ******


#!/bin/ksh
sudo su -
[ -d /mksysbbackup/backup ] || mkdir -p /mksysbbackup/backup
mount -o soft,rw,bg 10.248.251.115:/cfg2html/wreport_AIX /mksysbbackup/backup
cd /mksysbbackup/backup
./myscript_weeklyreport_AIX >> weeklyreport_AIX.csv
 cd
umount /mksysbbackup/backup
exit
exit

