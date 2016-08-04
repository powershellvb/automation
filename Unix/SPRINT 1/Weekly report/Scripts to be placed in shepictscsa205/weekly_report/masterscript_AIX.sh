# ******
# Weekly Report Generation Script- AIX Servers
#
# This Master script establish ssh connection to the AIX servers which in turn calls the mount script.
#
# # # It is known to run on ksh.
#
# History:
#  07-13-2015: Original created by Karthick Priya Arumugam
# ******


#!/bin/bash
while read servername;do
sshpass -p Lem#trt1 ssh -tt qualys@$servername 'ksh -s' </usr/local/custom/bin/weekly_report/mountscript_AIX
done < /usr/local/custom/bin/weekly_report/serverlist_AIX.txt

date=`date +%Y%m%d`
#mount -o rw,bg 10.248.251.115:/cfg2html/wreport_AIX /mksysbbackup/backup
#cd /mksysbbackup/backup
cd /cfg2html/wreport_AIX
cp weeklyreport_AIX.csv weeklyreport_AIX.$date.csv
Mon=`ls -ltr | tail | grep -i weeklyreport_AIX.$date.csv  | awk '{print $6}'`
cd $Mon
cp -p /cfg2html/wreport_AIX/weeklyreport_AIX.$date.csv .
chmod 777 weeklyreport_AIX.$date.csv
echo -e "Hi All \n\n PFA, for AIX Weekly Report \n\n Regards,\n Unix Team" | mailx -s "AIX Weekly Report as on $date" -a weeklyreport_AIX.$date.csv dl-hcl-unix@stanfordhealthcare.org
cd /cfg2html/wreport_AIX
rm *.csv
echo -e "SERVER NAME,TYPE OF HOST (PHYSICAL/VIRTUAL),ENVIRONMENT,LOCATION,HARDWARE MODEL, NUMBER OF CPU/CORES,PHYSICAL MEMORY(GB),SERVER FUNCTION,OS,Version OF OS,AMOUNT OF DISK ALLOCATED(GB),SWAP SPACE(GB)" > /cfg2html/wreport_AIX/weeklyreport_AIX.csv
chmod 777 /cfg2html/wreport_AIX/weeklyreport_AIX.csv
exit
