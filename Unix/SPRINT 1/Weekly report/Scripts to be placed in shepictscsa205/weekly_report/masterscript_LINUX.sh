# ******
# Weekly Report Generation Script- LINUX Servers
#
# This Master script establish ssh connection to the LINUX servers which in turn calls the mount script.
#
# # # It is known to run on bash.
#
# History:
#  07-13-2015: Original created by Karthick Priya Arumugam
# ******


#!/bin/bash
while read servername;do
if [[ $servername = shepictscsa205 ]]
then
sshpass -p Lem#trt1 ssh -tt qualys@$servername  'bash -s' </usr/local/custom/bin/weekly_report/not2mountscript_LINUX.sh
else
echo "hi"
sshpass -p Lem#trt1 ssh -tt qualys@$servername 'bash -s' </usr/local/custom/bin/weekly_report/mountscript_LINUX.sh
#sshpass -p Aprwed@1211 ssh -tt s0184432@$servername 'bash -s' </usr/local/custom/bin/weekly_report/mountscript_LINUX.sh
fi
done < /usr/local/custom/bin/weekly_report/serverlist_LINUX.txt
date=`date +%Y%m%d`
#mount -o rw,bg 10.248.251.115:/cfg2html/wreport_LINUX /mksysbbackup/backup
#cd /mksysbbackup/backup
cd /cfg2html/wreport_LINUX
cp weeklyreport_LINUX.csv weeklyreport_LINUX.$date.csv
Mon=`ls -ltr | tail | grep -i weeklyreport_LINUX.$date.csv  | awk '{print $6}'`
cd $Mon
#cp -p /mksysbbackup/backup/weeklyreport_LINUX.$date.csv .
cp -p /cfg2html/wreport_LINUX/weeklyreport_LINUX.$date.csv .
chmod 777 weeklyreport_LINUX.$date.csv
echo -e "Hi All \n\n PFA, for Linux Weekly Report \n\n Regards,\n Unix Team" | mailx -s "Linux Weekly Report as on $date" -a weeklyreport_LINUX.$date.csv karumugam@stanfordhealthcare.org
#cd /mksysbbackup/backup
cd /cfg2html/wreport_LINUX
rm *.csv
echo -e "SERVER NAME,TYPE OF HOST (PHYSICAL/VIRTUAL),ENVIRONMENT,LOCATION,HARDWARE MODEL, NUMBER OF CPU/CORES,PHYSICAL MEMORY(GB),SERVER FUNCTION,OS,Version OF OS,Total Disk Size(GB),Utilized Disk Size(GB)" > /cfg2html/wreport_LINUX/weeklyreport_LINUX.csv
chmod 777 /cfg2html/wreport_LINUX/weeklyreport_LINUX.csv
#cd
#umount /mksysbbackup/backup
exit
