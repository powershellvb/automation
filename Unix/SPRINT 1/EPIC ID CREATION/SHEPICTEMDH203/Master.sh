# ******
# Script for EPIC ID Creation
#
#This script is master script for epic employee IDs for the respective servers opt the user to select the type of server and the type of user in which the users need to be created and what kind of users needs to be created respectively.This requires the user to enter the #username ,Gecos and password to be entered the input files
# Runs on kourne shell
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
sshpass -p ***** scp -p /usr/local/custom/bin/EPIC_ID_Create/input_epic.txt  qualys@<IP_SHEPICTEMDH203>:/tmp
sshpass -p ***** ssh -tt qualys@<IP_SHEPICTEMDH203>  'ksh -s'</usr/local/custom/bin/EPIC_ID_Create/epic_user_nc.ksh
exit
