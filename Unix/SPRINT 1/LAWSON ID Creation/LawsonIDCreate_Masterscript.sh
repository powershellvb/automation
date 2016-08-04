# ******
# Chassis routing engine Test Script
#
# This script is the Master script which ssh to Lawson PROD and DR nodes to accomplish the TASK of new user account creation.
# Runs on kourne shel
# 
# 
# 
# 
#
# History:
#  13-07-2016: Original created by Karthick priya A
#  
#  
# ******



#!/bin/bash
sshpass -p ****** scp -p /usr/local/custom/bin/Lawson_UID/input.txt qualys@<PROD CLUSTER NODE>:/tmp
sshpass -p ****** scp -p /usr/local/custom/bin/Lawson_UID/input.txt qualys@<DR CLUSTER NODE>:/tmp
sshpass -p ****** ssh -tt qualys@<PROD CLUSTER NODE>  'ksh -s' </usr/local/custom/bin/Lawson_UID/lawsonid.ksh
sshpass -p ****** ssh -tt qualys@<DR CLUSTER NODE>  'ksh -s' </usr/local/custom/bin/Lawson_UID/lawsonid.ksh
exit
