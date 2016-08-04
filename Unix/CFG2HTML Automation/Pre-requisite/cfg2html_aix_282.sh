#!/bin/ksh93
#
# set -vx
# It is intended to put this code under GPL v3 and merge it with
# cfg2html version 6.xx (Ralph Roth, 13.03.2014)
# ----------------------------------------------------------------
# Note:
# During development, this file is sometimes edited in a Windows editor.
# In case the ^M (Carriage Return) is still in the file, use the
# following command to correct this error:
#   tr -d '\r' <cf*sh >cfg2html_aix_2.81_CORR.sh
# now make the new file executable:
#   chmod +x cfg2html_aix_2.81_CORR.sh
# try to run it:
#   ./cfg2html_aix_2.81_CORR.sh
# if everything is ok now, you can delete the corrupt one,
# and rename the new file to the original name.
# ----------------------------------------------------------------------
# Tip:
# - ENHANCED means "more commands will be executed"
# - VERBOSE  means "more output messages during normal processing"
# ----------------------------------------------------------------------
# 2002-10-15 GL 1.0  Initial release
# 2003-02-24 GL 2.2e xxx
# 2003-05-09 GL 2.5a xxx
# 2005-05-13 AW 2.6  some improvements/bug fixes
# 2005-09-30 GL 2.6c xxx
# 2005-10-01 CP 2.5b <private release>
# 2005-10-07 AW 2.7  new release number, HP OpenView support
# 2008-01-24 AW 2.71 new Option -J for JAVA checking's
# 2008-07-24 AW 2.72 add Java6 check, using /tmp/c2h
# 2010-06-15 AW 2.80 new Option -R for Compiler/Runtime checking's
# 2011-09-08 AW 2.81 AIX 7.1 support
# 2014-03-13 RR 2.82 Fixed URLs and mail address, misc. changes
# ----------------------------------------------------------------------

RCCS="@(#)Cfg2Html -AIX- Version 2.82"   # useful for what (1)
VERSION=$(echo $RCCS | cut -c5-)

echo "Starting up $VERSION\r"

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# AW Andreas Wizemann Andreas.Wizemann@FVVaG.de
# GL Gert Leerdam Gert.Leerdam@getronics.com
# CP Chris Paulheim (HP OpenView support)
# MP Michel Philipona (Veritas VCS, Veritas VxVM, HDS/Hitachi HDLM)
# RR Ralph Roth - cfg2html@htomail.com
#
# X.xx 201x-xx-xx ??? possible new functions ???
#  - ??? accept 5.2 as WPAR in 7.x ??
#  - aixpert
#  - HTML Navigation (AddHTML)
#    <a name="TOP"></a>
#    <a href="#TOP">TOP</a>
#  - add basic Oracle checking's
#  - check for latest version of Mozilla, Firefox
#    /usr/bin/firefox
#    Firefox.base.rte  2.0.0.11
#    /usr/bin/mozilla
#    Mozilla.base.rte  1.7.12.0
#
# 2.81a 2012-07-03 Ralph Roth - repacked and released, fixed mail and URLs
#
# 2.81 2011-09-08 A.Wizemann
#  - AIX 7 Support
#  - some bugs fixed
#  - internal improvements
#  - use BG-Job for long running tasks to speed up runtime
#  - remove native !? support for AIX 5.2 (End of Service xxxxx 2010)
#  - remove VAC 7 checks (EOS 30 Sep 2009)
#  - AIX 7 Toleration
#  - Power7 Toleration
#  - HMC moved from EXPERIMENTAL to HMC Collector
#  - SVC moved from EXPERIMENTAL to SVC Collector
#  - VIO moved from EXPERIMENTAL to VIO Collector
#  - aio moved from EXPERIMENTAL to KERNEL Collector
#  - sdd, sddpcm moved from EXPERIMENTAL to DEVICES Collector
#  - add lsparent
#  - collector heading in *.txt output
#  - xxx
#
# 2.80 2010-06-15 A.Wizemann
#  - some bugs fixed
#  - internal improvements
#  - remove support for AIX 5.2 (End of Service September 2008)
#  - update checks for Java142, Java5 and Java6
#  - extended output now with -e instead of -x
#  - java moved from EXPERIMENTAL to JAVA
#  - gcc moved from EXPERIMENTAL to COMPILER
#  - IBM ESS moved from EXPERIMENTAL to DEVICES
#  - FAStT moved from EXPERIMENTAL to DEVICES
#  - HDS/Hitachi (HDLM) moved from EXPERIMENTAL to DEVICES
#  - EMC PowerPath moved from EXPERIMENTAL to DEVICES
#  - Veritas moved from EXPERIMENTAL to DEVICES
#  - LUM now part of SOFTWARE
#  - add HMC to EXPERIMENTAL
#  - add SVC to EXPERIMENTAL
#  - add VIO to EXPERIMENTAL
#  - add lswpar to EXPERIMENTAL
#  - check Compiler/Runtime (gcc, xlC, vac, vacpp) fixes
#  - add du -k
#  - add ntp
#  - add last reboot
#  - add lssec (for root)
#  - add ls (Major/Minor number of hdisk)
#  - add gpfs checks
#  - add EtherChannel, VLAN >MP002<
#
# 2.72 2008-07-24 A.Wizemann
#  - some bugs fixed
#  - internal improvements
#  - remove support for AIX 5.1 (End of Service April 2005)
#  - remove pmctrl (bos.powermgt.rte)
#  - remove support for AIX 4.3.3 (End of Service December 2003)
#  - no longer tested with AIX 5.2 and below !
#  - add check for Java6
#  - update checks for Java141 and Java5
#  - use /tmp/c2h as temp directory
#  - remove Java 118,122,130 checking's
#  - Java 131 now shown as unsupported
#  - IBM ESS (Shark) moved from sdd to separate block
#  - add tunables files to list of files (vmo, ioo)
#  - vmo, ioo moved from EXPERIMENTAL to KERNEL
#  - suma, emgr, wlm moved from EXPERIMENTAL to KERNEL
#  - smtctl, cpustat, mpstat, lparstat moved from EXPERIMENTAL to KERNEL
#  - show warning if system needs to be rebooted (rc=1 from vmo)
#  - ssh, rpm moved from EXPERIMENTAL to SOFTWARE
#
# 2.71 2008-01-24 A.Wizemann
#  - AIX 6 Toleration
#  - Power6 Toleration
#  - geninv
#  - use ksh93
#  - some bugs fixed
#  - improved Java checking's
#  - enhanced OS Level checking's (ML/TL+SP)
#  - show TSM 64-Bit BA Client config files (dsm.opt, dsm.sys)
#  - add pagesize command
#  - add bindprocessor command
#  - experimental support FAStT
#  - experimental support EMC PowerPath
#  - experimental support HDS/Hitachi (HDLM)
#  - experimental support Veritas
#  - experimental support HACMP
#
# 2.7 2005-10-07 A.Wizemann
#  - some bugs fixed
#  - internal improvements
#
# 2.6 2005-05-13 A.Wizemann
#  - some bugs fixed
#  - internal improvements
#  - new: AIX 5.3 support
#  - new: ported some options from LINUX or HP version
#
# New
# --------
# >MP001< Veritas VCS, Veritas VxVM, HDS/Hitachi HDLM
# >MP002< EtherChannel, VLAN
#
# New
# --------
# >CP001< HP OpenView support (copied from 2.5b)
# >CP002< TSM 32-Bit Client
#
# BUGFIXES
# --------
# >GL001< AIX 5.3 correction in psawk
# >GL002< additions from 2.5c
#
# changes and general improvements
# --------------------------------
# >AW001< Translate German comments to English
# >AW002< Translate Dutch comments to English
# >AW003< add some more comments
# >AW004< always use option -f and 2>/dev/null on rm command
# >AW005< changed var RECHNER to NODE / ANTPROS to NO_OF_CPUS
# >AW006< code to identify CPU Type moved to function and improved
# >AW007< add more debugging capabilities
# >AW008< code restructured for better readability
# >AW009< changed tabs to spaces for better readability in some editors
# >AW010< changed internal name device_info to disk_info to fit with option name (COL_DEVICES)
# >AW011< changed internal name patch/software_info to software_info to fit with option name (COL_SOFTWARE)
# >AW012< add COL_APPL (APPLICATIONS e.g. SAMBA) (as in Linux version)
# >AW013< display warning if using AIX 4.x as this has reached end of service
# >AW014< AIX 5.3 use sysdump -Lv older releases -L
# >AW015< small corrections in HTML header to show correct oslevel
# >AW016< moved <META http-equiv=expires... to open_html, so it is only found once in the html file
# >AW017< TRAP handling
# >AW018< xexit - single exit point
# >AW019< add support for "sysinfo" file. Idea "stolen" from Linux port
# >AW020< -o OUTDIR support (as in HP Version 2.92)
# >AW021< C2H_CMDLINE (same as CFG_CMDLINE in HP Version 2.92)
# >AW022< C2H_DATE    (same as CFG_DATE in HP Version 2.92)
# >AW023< get info about package to install if cmd not found
# >AW024< check for command availability using "which <cmd>" before using them
# >AW025< add /etc/security/limits to files
# >AW026< add (internal) css style (as in LINUX 1.20)
# >AW027< add ALT= option to IMG tag
# >AW028< repquota (10) moved to "Filesystem" collector
# >AW029< passwd (13) moved to "User & Group" collector
# >AW030< defrag (11) moved to "Filesystem" collector (DDDDDD)
# >AW031< screen tips inline (same as CFG_STILINE in HP Version 2.92)
# >AW032< AIX 4.2 and lower desupported
# >AW033< small optical changes in output files
# >AW034< show arp cache
# >AW035< add COL_JAVA (move Java to its own collector)
# >AW036< AIX 6 toleration
# >AW037< Power6 toleration
# >AW038< show page size for paging
# >AW039< bindprocessor -q
# >AW040< TSM 64-Bit BA Client
# *2.72*
# >AW041< suppress error messages from which command
# >AW042< check if dsm.sys exists
# >AW043< tcbcheck removed
# >AW044< proctree -a needs userid
# >AW045< use /tmp/c2h for temp files
# >AW046< update Java checks
# >AW047< add niminv
# >AW048< add basic Oracle checking's
# >AW049< add /etc/tunables/* to files shown
# >AW050< suma (AIX 5.2 with PTF or AIX 5.3 and higher;)
# >AW051< *emgr, epkg (AIX 5.2 + IY40236 or AIX 5.3 and higher)
# >AW052< *java -version
# >AW053< *WLM* Work Load Manager (AIX 5.x)
# >AW054< smtctl (AIX 5.3 on Power5)
# >AW055< cpupstat (AIX 5.3)
# >AW056< mpstat -s (AIX 5.3)
# >AW057< lparstat (AIX 5.3)
# >AW058< DEVICES lsslot
# >AW059< aio, ASYNC I/O
# >AW060< *SDD/SDDPCM* Subsystem Device Driver (ESS, DS8000), CIM-Agent
# >AW061< ...reserved for EXPERIMENTAL Apache
# >AW062< ...reserved for EXPERIMENTAL Samba
# >AW063< Java5 checking
# >AW064< links to internet pages (e.g. IBM's Java page)
# >AW065< vmo, ioo
# >AW066< DEVICES *FAStT*
# >AW067< ssh
# >AW068< COMPILER gcc
# >AW069< rpm
# >AW070< DEVICES HDS/Hitachi (HDLM)
# >AW071< DEVICES EMC/PowerPath
# >AW072< DEVICES VERITAS (VxVM, VCS)
# >AW073< *HACMP*
# >AW074< DEVICES IBM ESS (Shark)
# >AW075< AIX 6 support
# >AW076< show sys0 attributes
# >AW077< HTML-NAV
# >AW078< show time needed for this script
# >AW079< add .rhosts, .profile, .kshrc to list of files
# >AW080< update Java checks (Java5 SR7 *)
# >AW081< update Java checks (Java142 SR11 *)
# >AW082< aio (async io) check on AIX6
# *2.80*
# >AW083< ...reserved for EXPERIMENTAL lswpar
# >AW084< update Java checks (Java5 SR8+SR8a *, Java6 SR1 *)
# >AW085< du -k
# >AW086< 2 more "lsvp" cmds for ESS
# >AW087< replace psawk with "ps -fT 0"
# >AW088< C-Compiler/Runtime checking's (xlC, vac, vacpp)
# >AW089< improved CSM,RSCT checking's
# >AW090< update Java checks (Java6 SR2 *)
# >AW091< lum (17) moved to "SOFTWARE" collector
# >AW092< sort rpm -qa output
# >AW093< last reboot
# >AW094< lparstat -iW, lparstat -h, lparstat -H
# >AW095< update Java checks (Java142 SR12 *)
# >AW096< lsvpd now EXTENDED
# >AW097< Tape info
# >AW098< add uname, lsattr, lslv, lsdev
# >AW099< add some files
# >AW100< geninv
# >AW101< lscfg
# >AW102< hw (05) moved to "DEVICES" collector
# >AW103< perl
# >AW104< ...reserved for PLUGIN
# >AW105< ...reserved for LOCK
# >AW106< 106 HPOpenView moved to APPLICATION
# >AW107< ntp
# >AW108< lssec
# >AW109< show major/minor number of hdisk
# >AW110< set LANG to en_US (this makes debugging easier)
# >AW111< gpfs
# >AW112< update Java checks (Java6 SR3 *)
# >AW113< gpfs 3.2.1-08
# >AW114< svmon -O (new in 6.1 TL02 and 5.3 TL09)
# >AW115< gpfs 3.2.1-xx
# >AW116< update Java checks (Java5 SR9 *)
# >AW117< update Java checks (Java6 SR3 *)
# >AW118< update Java checks (Java142 SR13 *)
# >AW119< AIX Hotfix (Hiper - High Impact - Highly Pervasive) checking
# >AW120< gpfs 3.3.0
# *2.81*
# >AW121< AIX 7.1 BETA Toleration
# >AW122< Power 7 Toleration
# >AW123< show NFS automount config files
# >AW124< cron (12) moved to "system" collector
# >AW125< printer (09) moved to "devices" collector
# >AW126< new collector -H HMC
# >AW127< new collector -T TSM
# >AW128< new collector -G GPFS
# >AW129< new collector -V VIO
# >AW130< new collector -? SVC (use -Y during developement)
# >AW131< rc.*
# >AW132< collector heading in *.txt output
# >AW133< add/change (aix-config)
# >AW134< XiV
# >AW135< more cron info
# >AW000< ...136
#
# Under Construction
# ------------------
# >AW104< add "PLUGIN" support
# >AW105< check that we are running only once
#
# >AW201< check for "vmtune" 5.2 knows vmtune IF UPGRADED from earlier release 5.3 uses vmo,ioo,schedo
# >AW202< skip "ps -Af..." on all aix (5.3)
# >AW203< skip "ipcs" on AIX 5.3 (aixn,...)
#
# NEW (EXPERIMENTAL)
# ---
# >AW061< *IBM HTTP Server (Apache)
# >AW062< *SAMBA
# *2.80*
# >AW083< add lswpar to EXPERIMENTAL
# >AW126< add HMC to EXPERIMENTAL
# >AW129< add VIO to EXPERIMENTAL
# >AW130< add SVC to EXPERIMENTAL
# *2.81*
# >AW126< move HMC to -H HMC
# >AW127< move TSM to -T TSM
# >AW128< move GPFS to -G GPFS
# >AW129< move VIO to -V VIO
# >AW130< move SVC to -C? SVC
# >AW...< add lsparent to EXPERIMENTAL
# >AWyyy< move LPAR to -L? LPAR -P?
# >AWyyy< move WPAR to -W? WPAR
# >AW771< ** FREE **
# >AW772< ** FREE ** FUNC_x
# >AW773< ** FREE **
#
# BUGFIXES
# --------
# >AW301< BUG: var DB_F in PrtLayout not set
# >AW302< BUG: do not use fix "proc0" ! as we may run on a different proc
# >AW303< BUG: sed will convert also for *.TXT output file, which is not necessary
# >AW303< BUG: found in: cron,lsrset,ps,ifconfig,netstat
# >AW304< BUG: change uname -n to $(uname -n)
# >AW305< BUG: do not display "<file> file not found" in *.err file !
# >AW306< BUG: ignore newly created devices which do not have a PVID (PVID is none)
# >AW307< BUG: check for "/var/ifor/i4cfg" Don't use if not available !
# >AW308< BUG: lower "f" missing in getopts list
# >AW309< BUG: if execution fails or script is interrupted output is missing !
# >AW310< BUG: out of memory error (first seen on AIX 5.3)
# >AW311< BUG: lspv none / None
# >AW312< BUG: /etc/services missing in 2.72
# >AW313< BUG: BG job geninv only started in AIX 5.3 TL08 !
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#*********************************************************************
# ToDo 000-000 alstat  emstat  gennames  truss  wimmon alog?
# ToDo 000-000 errpt -a bij -x
# ToDo 000-000 needs improvement!
#
# trap "echo Signal: Aborting!; rm $HTML_OUTFILE_TEMP"  2 13 15
#*********************************************************************
# Developer Hints:
# - echo    just write to (and only to) console
# - ERRMSG  write to console AND $ERROR_LOG
# - ERRLOG  write to $ERROR_LOG
# - DBG     write to $ERROR_LOG IF DEBUG=1, with Timestamp
# - AWCONS  write to console IF AWCONS=1
# - AWCONST write to console IF AWCONS=1, with Timestamp
# - AWTRACE write to $TRACE_DSN IF AWDEBUG=1, with Timestamp
#
# - Collector
#   a Collector can be enabled/disabled via options.
#   e.g. -H enables HMC Collector
#*********************************************************************

######################################################################
#${var:OFFSET:LENGTH}-Return a Substring of $var
#
#A substring of $var starting at OFFSET is returned.
#If LENGTH is specified, that number of characters is returned;
#otherwise, the rest of the string is returned.
#The first character is at offset 0:
#
#$ var=abcdefgh
#$ echo "${var:3:2}"
#de
#$ echo "${var:3}"
#defgh
#
#A negative offset reads from the end of the string:
#
#$ var=abcdefgh
#$ echo ${var: -3:2}
#fg
######################################################################

#----------------------------------------------------------------------------
# Thanks to:
# Olaf Morgenstern (olaf.morgenstern@web.de) for several improvements
# Jim Lane (JLane@torontohydro.com) for lsuser & lsgroup command
# "Stolen" Command-line option structure with getopts from HP-UX version from Ralph Roth
# Marco Stork for supplying the PrtLayout function
# Antonio Ferreira for the HDS/Hitachi commands
#----------------------------------------------------------------------------

######################################################################
# usage: show the options for this script
# Collectors use CAPITAL letters to enable/disable.
######################################################################
usage ()
{
   echo "\n usage: cfg2html_aix.sh [options]"
   echo "\ncreates HTML and plain ASCII host documentation"
   echo
   echo "  -o  set directory to write (or use the environment variable)"
   echo "                OUTDIR=\"/path/to/dir\" (directory must exist)"
  #echo "  -l  DIS-able: Screen tips inline"  # >AW031<
  #         ToDo. -g like LINUX port
  #         x no longer in use with eXtended (now e). use g (gif)
  #echo "  -g  don't create background images (gif)"
   echo "  -0 (zero)     append the current date+time to the output files (D-M-Y-hhmm)"  # >AW022<
   echo "  -1 (one)      append the current date to the output files (Day-Month-Year)"   # >AW022<
  #echo "  -2 modifier   like option -1, you can use date +modifier, e.g. -2%d%m"        # >AW022<
  #echo "                DO NOT use spaces for the filename, e.g. -2%c"                  # >AW022<
   echo "  -h  display this help and exit"
   echo "  -v  output version information and exit"
   echo "  -e  extended output"
   echo "  -y  Verbose (Debug) output"
   echo
   echo "use the following (case-sensitive) options to (enable/)disable collectors"
   echo
   echo "  -^  Reverse Yes/No; MUST be first option"
   echo "  -a  DIS-able: Applications"   # *col-16*a* (e.g. Apache, SAMBA, ...)
#          -A            AIX
   echo "  -C  DIS-able: Cron"           # *col-10*C* >AW124< => to be DELETED in 2.82
   echo "  -D  DIS-able: Devices"        # *col-05*D*
   echo "  -E  DIS-able: Experimental"   # *col-17*E*
   echo "  -f  DIS-able: Files"          # *col-13*f*
   echo "  -F  DIS-able: Filesystem"     # *col-04*F*
   echo "  -G  DIS-able: GPFS"           # *col-22*G* >AW128<
   echo "  -H  DIS-able: HMC"            # *col-03*H* >AW126<
   echo "  -J  DIS-able: JAVA"           # *col-18*J* >AW035<
   echo "  -K  DIS-able: Kernel"         # *col-02*K*
#  echo "  -l  DIS-able: lllll"          # *col-15*l* >AW091<
   echo "  -L  DIS-able: LVM"            # *col-06*L*
#  echo "  -L?  DIS-able: LPAR"           # *col-..* >AW...< RESERVED
#  echo "  -P?  DIS-able: LPAR"           # *col-..* >AW...< RESERVED
   echo "  -n  DIS-able: NIM"            # *col-14*n*
   echo "  -N  DIS-able: Network"        # *col-08*N*
#  echo "  -p  DIS-able: pppppp"         # *col-11*p* >AW772<
   echo "  -P  DIS-able: Printer"        # *col-09*P* >AW125< => to be DELETED in 2.82
   echo "  -R  DIS-able: Compiler"       # *col-19*R* >AW088<
   echo "  -s  DIS-able: Software"       # *col-12*s*
   echo "  -S  DIS-able: System"         # *col-01*S*
   echo "  -T  DIS-able: TSM"            # *col-23*T* >AW127<
   echo "  -U  DIS-able: Users"          # *col-07*
#  echo "  -V  DIS-able: VIO"            # *col-20* >AW777<
#  echo "  -W  DIS-able: WPAR"           # *col-..* >AW...< RESERVED
#  echo "  -C?  DIS-able: SVC"            # *col-21* >AW666<

   echo
 # echo  "\n(#) these collectors create a lot of information!"
   echo  "Example:  $0 -S   to skip SYSTEM"
   echo  "          $0 -^S  to do -ONLY- SYSTEM"
   echo
}

######################################################################
# User_Settings: define user specific vars here !
######################################################################
User_Settings ()
{
#---------------------------------------------------------------------
# These vars are specific to your installation !
# You need to define them here !
# Next version will allow to define them in a config file.
#---------------------------------------------------------------------
#
# Todo 281-000 XXX=${XXX:-debug} # default is debug
#

# HMC Settings
# ------------
 hmc1_ip=10.100.100.197 # hmcRZA
 hmc1_name="HMCRZA"
#
 hmc2_ip=10.100.100.198 # hmcRZB
 hmc2_name="HMCRZB"
#
#

# VIO Settings
# ------------
 vio1_ip=0.0.0.0 # init NO VIO-Server
 vio1_name="NONE"
 vio2_ip=0.0.0.0 # init NO VIO-Server
 vio2_name="NONE"

 if [[ ${NODE} = "aix6" ]]
 then
   vio1_ip=10.100.100.158 # VIT1
   vio1_name="p520T-VIO1"

   vio2_ip=10.100.100.159 # VIT2
   vio2_name="p520T-VIO2"
 fi
 if [[ ${NODE} = "aixw" ]] # WORK
 then
   vio1_ip=10.100.100.158 # p520T-VIO1 = VIT1
   vio1_name="p520T-VIO1"

   vio2_ip=10.100.100.159 # p520T-VIO2 = VIT2
   vio2_name="p520T-VIO2"
 fi
 if [[ ${NODE} = "aixn" ]] # NIMS
 then
   vio1_ip=10.100.100.135 # p520A-VIO1 = VIA1
   vio1_name="p520A-VIO1"

   vio2_ip=10.100.100.135 # p520A-vio2 = VIA2
   vio2_name="p520B-VIO2"
 fi
 if [[ ${NODE} = "aixt" ]]
 then
   vio1_ip=10.100.100.161 # p520B-vio1
   vio1_name="p520B-VIO1"

   vio2_ip=10.100.100.161 # p520B-vio2
   vio2_name="p520B-VIO2"
 fi
#
#

# SVC Settings
# ------------
 svc1_ip=10.100.100.116 # IP-Adress of SVC-Cluster
 svc1_name="SVC"
#
 svc2_ip=10.100.100.117
 svc2_name="SVCA"
#
}

######################################################################
# InitVars: initialize some basic variables
######################################################################
InitVars ()
{
#----------------------------------------------------------------------------
# use "yes/no" to enable/disable a collector; CASE sensitive !!
 XCFG_CSM=yes
 XCFG_LSLPP=yes

 CFG_AW=${CFG_AW:-no} # default is no
 CFG_SECURITY=OFF     # ToDo 300-00 PLANNED FOR FUTURE RELEASE

 COL_SYSTEM=yes          # S  *col-01*
 COL_KERNEL=yes          # K  *col-02*
 COL_HMC=no              # H  *col-03* >AW126<
 COL_FILESYS=yes         # F  *col-04*
 COL_DEVICES=yes         # D  *col-05*
 COL_LVM=yes             # L  *col-06*
 COL_USERS=yes           # U  *col-07*
 COL_NETWORK=yes         # N  *col-08*
 COL_PPPPPP=no           # P  *col-09*
 COL_CRON=yes            # C  *col-10*
#COL_???                 # ?  *col-11*
 COL_SOFTWARE=yes        # s  *col-12* (Patch)
 COL_FILES=yes           # f  *col-13* ! Trouble on 5.3 !
 COL_NIM=yes             # n  *col-14*
 COL_LUM=yes             # l  *col-15* >AW091< => to be DELETED
 COL_APPL=yes            # a  *col-16*
 COL_EXP=yes             # E  *col-17*
 COL_JAVA=yes            # J  *col-18* >AW035<
 COL_COMPILER=yes        # R  *col-19* >AW088<
 COL_VIO=no              # V  *col-20* >AW777<
 COL_SVC=yes             # ?  *col-21* >AW666<
 COL_GPFS=yes            # G  *col-22* >AW128<
 COL_TSM=yes             # T  *col-23* >AWxxx<
 _maxcoll=23

 FUNC_PUSH=no           # p  *func-01* >AW773<

 CFG_TEST=yes            # t  special var no collector

#typeset -u VAR=$var # convert to UPPERCASE
#typeset -l VAR=$var # convert to lowercase
 CFG2HTML=true
 MYSELF=`whence $0`
 C2H_HOME=`dirname $MYSELF`
 PLUGINS=${C2H_HOME}/plugins

 C2H_DATE="";  # >AW022<
 C2H_STINLINE="YES"  # >AW031<

# Convert illegal characters for HTML into escaped ones.
# Convert '&' first! (Peter Bisset [pbisset@emergency.qld.gov.au])
CONVSTR='
s/&/\&amp;/g
s/</\&lt;/g
s/>/\&gt;/g
s/\\/\&#92;/g
'

# ...
 SEP="================================" # 32
 SEP10="==========" #10
 SEP20="====================" #20
 SEP30=${SEP20}""${SEP10}
 SEP40=${SEP20}""${SEP20}
 SEP60=${SEP40}""${SEP20}
 SEP70=${SEP40}""${SEP20}""${SEP10}
 SEP80=${SEP40}""${SEP40}
 SEP90=${SEP40}""${SEP40}""${SEP10}
 SEP100=${SEP40}""${SEP40}""${SEP20}
 SEP120=${SEP40}""${SEP40}""${SEP40}
#
 DATE=$(date "+%Y-%m-%d")                 # ISO8601 compliant date string
 DATEFULL=$(date "+%Y-%m-%d - %H:%M:%S")  # ISO8601 compliant date and time string
 CURRDATE=$(date +"%b %e %Y")
 NODE=$(uname -n) # >AW005<
 SYSTEM=$(uname -s)
 USER=`id | cut -f2 -d"(" | cut -f1 -d")"`

# Let the (HTML) cache expire since this script runs every night
 EXPIRE_CACHE=$(date "+%a, %d %b %Y ")"23:00 GMT"

# >AW017< Define signals
 SIGNEXIT=0   ; export SIGNEXIT  # normal exit
 SIGHUP=1     ; export SIGHUP    # when session disconnected
 SIGINT=2     ; export SIGINT    # ctrl-c
 SIGTERM=15   ; export SIGTERM   # kill command
 SIGSTP=18    ; export SIGSTP    # ctrl-z
#SIG...=13    ; export SIG...    # ...

# get no of installed CPU's
 NO_OF_CPUS=$(lscfg | grep 'proc[0-9]' | awk 'END {print NR}')
#AWCONST "NO_OF_CPUs: ${NO_OF_CPUS}"

 typeset -L3 node3=${NODE} # init left 3 chars of nodename
 if [[ ${NODE} = "aixi" ]]
 then
   AWDEBUG=0 # AWdebugging 0=OFF 1=ON - on AIXI OFF
 else
   if [[ ${node3} = "aix" ]]
   then
     AWDEBUG=0 # AWdebugging 0=OFF 1=ON - on AIX* ON
   fi # node=aix*
 fi # node=aixi

# ToDo 710-710 OUTDIR, BASEFILE, ERROR_LOG needs to be set in "init1" !!
 if [ "$OUTDIR" = "" ] ; then
   OUTDIR="."  # >AW020<
 fi

#- AWTRACE "AW000I OUTDIR=${OUTDIR}"
#- AWTRACE "AW000I OUTDIR_ENV=${OUTDIR_ENV}"

 BASEFILE=`hostname`$C2H_DATE  # >AW022<

#AWCONS "AWTRACE: CBR 005 B=${BASEFILE} P=${PROCID}"
 ERROR_LOG=${OUTDIR}/${BASEFILE}.err

}

######################################################################
# Init_Part2: called AFTER options are processed
######################################################################
Init_Part2 ()
{
#%%%%%%%%%DEVELOPMENT-ONLY%%%%%%%%%
 AWDEBUG=2 # Special DEBUG
 AWDEBUG=1 # Normal  DEBUG
 AWDEBUG=0 # NO      DEBUG
#
 if [[ $AWDEBUG == 2 ]]; then
 XCFG_CSM=no
 XCFG_LSLPP=no
 XCFG_TSM="${XCFG_TSM:-no}"  # default is no

 CFG_AW=${CFG_AW:-debug} # default is debug

 COL_SYSTEM=no           # S  *col-01*
 COL_KERNEL=no           # K  *col-02*
 COL_HMC=yes             # H  *col-03* >AW126<
 COL_FILESYS=no          # F  *col-04*                    777
 COL_DEVICES=no          # D  *col-05* (DASD,TAPE,PRT)
 COL_LVM=no              # L  *col-06*
 COL_USERS=no            # U  *col-07*
 COL_NETWORK=no          # N  *col-08*
 COL_PPPPPP=no           # P  *col-09*
 COL_CRON=no             # C  *col-10*
#COL_???                 # ?  *col-11*
 COL_SOFTWARE=no         # s  *col-12* (Patch)
 COL_FILES=no            # f  *col-13* ! Trouble on 5.3 !?  777
 COL_NIM=no              # n  *col-14*
 COL_LUM=no              # l  *col-15* >AW091< => to be DELETED
 COL_APPL=no             # a  *col-16*
 COL_EXP=yes             # E  *col-17*
 COL_JAVA=no             # J  *col-18* >AW035<
 COL_COMPILER=no         # R  *col-19*
 COL_VIO=no              # V  *col-20*
 COL_SVC=yes             # ?  *col-21*
 COL_GPFS=yes            # G  *col-22* >AW128<
 COL_TSM=yes             # T  *col-23* >AWxxx<
 CFG_TEST=yes            # ?  *col-??* >AWxxx<

#FUNC_PUSH=no           # p  *func-01* >AW773<

 AWDEBUG=1
 fi;
 DisplayCFG "AWDEBUG"
#%%%%%%%%%DEVELOPMENT-ONLY%%%%%%%%%

# ToDo 000-000 write to *.err file (after file is available !)
# AWTRACE "AW SET"
#  set | grep -e CFG_ -e OUTDIR_ENV
# AWTRACE "AW SET"

# ToDo 000-000 CONF
#  CONF_STATUS="TOUCH"
# c2h.conf
# var=123
# var=$(grep var $CONF|awk -F"="{print $1}")
#

#- AWTRACE "AW000I TERM=${TERM}"
#- AWTRACE "AW000I SYSLANG=${SYSLANG}"
#- AWTRACE "AW000I LANG=${LANG}"
#- AWTRACE "AW000I DISPLAY=${DISPLAY}"

#++ >AW045< start *TMPDIR*---------------------------------------------
#...Check if /tmp/c2h dir is there
 TMPDIR=/tmp/c2h
 if [ ! -d ${TMPDIR} ]
 then
   echo "C2H011I Tmp-Dir = $TMPDIR"
   echo "C2H010W Warning, the /tmp/c2h directory is missing or execute bit is not set"
   mkdir $TMPDIR
   mkdir_rc=$?
   AWTRACE     "C2H022I mkdir /tmp/c2h rc $mkdir_rc"
   case $mkdir_rc in
     0 ) # OK
         echo "C2H012I Tmp-Dir successfully created";
         ;;
     * )
         echo "C2H013E ERROR creating Tmp-Dir ! rc=$mkdir_rc";
         ;;
   esac
 fi
#++ >AW045< end *TMPDIR* ----------------------------------------------

#++ >AW105< start *run-once*-------------------------------------------
#-AWCONS "AWTRACE: CBR 003  (run-once) MYSELF=${MYSELF} 0=${0} B=${BASEFILE} P=${PROCID}"
# ToDo 000-000 BASEFILE not set
# ps -ef | grep -v ${PROCID} | grep -v grep | grep ${BASEFILE}
# ps -ef | grep ${PROCID} | grep -v grep | grep -v "ps -ef"

#AWCONS "AWTRACE: CBR 004 B=${BASEFILE} P=${PROCID}"

#If only one instance of a script should run at a given time,
#a lock file could be used to ensure mutual exclusion:

# ToDo 280-888 check if locking works correctly
 if [[ ${DEBUG_001} = 1 ]] # if DEBUG 001 DBG locking
 then
  :
 fi # fi DEBUG 001 DBG locking
 lockfile=${TMPDIR}/cfg2html.lock
 if touch "$lockfile"
 then
    echo ${PROCID} >>${lockfile} # write our procid to lockfile
    echo >&2 "C2H070I acquired lock; continuing"
    pid_locking=0
    # Remove lock file when script terminates
    trap 'rm "$lockfile"' 0
    trap "exit 2" 1 2 3 15
 else
    read pid_locking < ${lockfile}
    echo >&2 "C2H071I lock already held"
    echo >&2 "C2H072I another script instance running?"
    echo >&2 "C2H003I delete lockfile ${lockfile} manually"
    exit 1
 fi # touch

# ToDo 285-888 read lockfile to get procid. show this procid !
# ToDo 285-888 delete our own (and only these !)  temp files !

#++ >AW105< end *run-once* --------------------------------------------

 java_LOG=${OUTDIR}/${BASEFILE}_java.info
 gpfs_LOG=${OUTDIR}/${BASEFILE}_gpfs.info
 lpar_LOG=${OUTDIR}/${BASEFILE}_lpar.info
 wpar_LOG=${OUTDIR}/${BASEFILE}_wpar.info
 gcc_LOG=${OUTDIR}/${BASEFILE}_gcc.info
 xlc_LOG=${OUTDIR}/${BASEFILE}_xlc.info
 csm_LOG=${OUTDIR}/${BASEFILE}_csm.info
 aix_LOG=${OUTDIR}/${BASEFILE}_aix.info
 svc_LOG=${OUTDIR}/${BASEFILE}_svc.info
 hmc_LOG=${OUTDIR}/${BASEFILE}_hmc.info
 vio_LOG=${OUTDIR}/${BASEFILE}_vio.info
 tsm_LOG=${OUTDIR}/${BASEFILE}_tsm.info

# *.out for command output
# *.err for command error

 AWTRACE_DSN=${ERROR_LOG}
 set -A TRACE_DSN
 typeset -i dsn_lvl
 dsn_lvl=0
#
#AWTRACE_DSN_BASE=${ERROR_LOG}
#AWTRACE_DSN_LVL=0
#AWTRACE_DSN_LVL=$(expr $AWTRACE_DSN_LVL + 1)
#

 HTML_OUTFILE=${OUTDIR}/${BASEFILE}.html
 HTML_OUTFILE_x=${OUTDIR}/${BASEFILE}
 HTML_OUTFILE_TEMP=${TMPDIR}/${BASEFILE}.html.$$
 TEXT_OUTFILE=${OUTDIR}/${BASEFILE}.txt
 TEXT_OUTFILE_x=${OUTDIR}/${BASEFILE}
 TEXT_OUTFILE_TEMP=${TMPDIR}/${BASEFILE}.txt.$$

 TMP_EXEC_COMMAND_ERR=${TMPDIR}/exec_cmd.tmp.$$
 SSH_OUT=${TMPDIR}/ssh_out.tmp.$$

#++ >AWccc< start *cleanupe* ------------------------------------------
 #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if [[ ${DEBUG_010} = 1 ]] # if DEBUG 010 DBG cleanup
 then
   AWCONS "AWTRACE: CCC 001 ls"
   testdsn=/tmp/${BASEFILE}.html.[0-9]*
   ls -la ${testdsn} 2>/dev/null
   rc=$?
   if [[ $_rc = 0 ]]
   then
     :  # OK
   else
     AWTRACE "C2H000I ls ${testdsn} RC=${rc}"
     TEXT_STATUS="ERROR"
     HTML_STATUS="ERROR"
   fi
   ls -la /tmp/${BASEFILE}.txt.[0-9]*  2>/dev/null
   ls -la /tmp/exec_cmd.tmp.[0-9]* 2>/dev/null
   ls -la /tmp/ssh_out.tmp.[0-9]* 2>/dev/null
   AWCONS "AWTRACE: CCC 002 ls"
 fi # fi DEBUG 010 DBG cleanup
 #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 #-----------------------------------------------------
 if [[ ${DEBUG_010} = 1 ]] # if DEBUG 010 DBG cleanup
 then
 testdsn=${TMPDIR}/${BASEFILE}.html.[0-9]*
 ls -la ${testdsn} 2>/dev/null
 rc=$?
 if [[ $_rc = 0 ]]
 then
   :  # OK
 else
   AWTRACE "C2H000I ls ${testdsn} RC=${rc}"
   TEXT_STATUS="ERROR"
   HTML_STATUS="ERROR"
 fi
 ls -la ${TMPDIR}/${BASEFILE}.txt.[0-9]* 2>/dev/null
 ls -la ${TMPDIR}/exec_cmd.tmp.[0-9]* 2>/dev/null
 ls -la ${TMPDIR}/ssh_out.tmp.[0-9]* 2>/dev/null
 fi # fi DEBUG 010 DBG cleanup
 #-----------------------------------------------------

# remove dump
 rm -f /tmp/${BASEFILE}.html.[0-9]* 2>/dev/null
 rm -f ${TMPDIR}/${BASEFILE}.html.[0-9]* 2>/dev/null
 rm -f /tmp/${BASEFILE}.txt.[0-9]* 2>/dev/null
 rm -f ${TMPDIR}/${BASEFILE}.txt.[0-9]* 2>/dev/null
 rm -f /tmp/exec_cmd.tmp.[0-9]* 2>/dev/null
 rm -f ${TMPDIR}/exec_cmd.tmp.[0-9]* 2>/dev/null
 rm -f /tmp/ssh_out.tmp.[0-9]* 2>/dev/null
 rm -f ${TMPDIR}/ssh_out.tmp.[0-9]* 2>/dev/null
#++ >AWccc< end *cleanupe* --------------------------------------------

 if [ ! -d $OUTDIR ] ; then
  echo "cannot create ${HTML_OUTFILE}, ${OUTDIR} does not exist"
  xexit 1
 fi

 cmdout=$(touch $HTML_OUTFILE 2>/dev/null)
 touch_rc=$?
 if [[ $touch_rc = 0 ]]
 then
   :  # OK
   HTML_STATUS="TOUCH"
 else
   banner "Error"
   ERRMSG "C2H007S Cannot create ${HTML_OUTFILE} RC=${touch_rc}"
   HTML_STATUS="ERROR"
   xexit 1
 fi


 AWTRACE "AWDBG777I C2H_ROTATE=${C2H_ROTATE}"
 AWTRACE "AWDBG777I C2H_ROTATE_LVL=${C2H_ROTATE_LVL}"
 _rotate="${C2H_ROTATE:-"YES"}"      # default is YES for rotation
 _rotate_lvl="${C2H_ROTATE_LVL:-9}"  # default is 9
 if [[ $AWDEBUG == 1 ]]
 then
   _rotate="YES" # always rotate in debug mode
   _rotate_lvl=9 # always lvl 9  in debug mode
 fi;

 if [[ ${_rotate} = "YES" ]]
 then
   #-AWTRACE "AWDBG777I ROTATE=${_rotate}"
   #-AWTRACE "AWDBG777I C2H_DATE_TYP=${C2H_DATE_TYP}"
   if [[ ${C2H_DATE_TYP} = 9 ]]
   then
     # rotate only if date_typ is 9 (which is the default)
     # ToDo 282-000 _rotate_lvl
     rm ${TEXT_OUTFILE_x}"_9.txt" 2>/dev/null
     mv ${TEXT_OUTFILE_x}"_8.txt" ${TEXT_OUTFILE_x}"_9.txt" 2>/dev/null
     mv ${TEXT_OUTFILE_x}"_7.txt" ${TEXT_OUTFILE_x}"_8.txt" 2>/dev/null
     mv ${TEXT_OUTFILE_x}"_6.txt" ${TEXT_OUTFILE_x}"_7.txt" 2>/dev/null
     mv ${TEXT_OUTFILE_x}"_5.txt" ${TEXT_OUTFILE_x}"_6.txt" 2>/dev/null
     mv ${TEXT_OUTFILE_x}"_4.txt" ${TEXT_OUTFILE_x}"_5.txt" 2>/dev/null
     mv ${TEXT_OUTFILE_x}"_3.txt" ${TEXT_OUTFILE_x}"_4.txt" 2>/dev/null
     mv ${TEXT_OUTFILE_x}"_2.txt" ${TEXT_OUTFILE_x}"_3.txt" 2>/dev/null
     mv ${TEXT_OUTFILE_x}"_1.txt" ${TEXT_OUTFILE_x}"_2.txt" 2>/dev/null
     mv ${TEXT_OUTFILE}           ${TEXT_OUTFILE_x}"_1.txt" 2>/dev/null
   else
     :
   fi
 fi


 cmdout=$(touch $TEXT_OUTFILE 2>/dev/null)
 touch_rc=$?
 if [[ $touch_rc = 0 ]]
 then
   :  # OK
   TEXT_STATUS="TOUCH"
 else
   banner "Error"
   ERRMSG "C2H007S Cannot create ${TEXT_OUTFILE} RC=${touch_rc}"
   TEXT_STATUS="ERROR"
   xexit 1
 fi

# clear error_log
 [ -s "$ERROR_LOG" ] && rm -f $ERROR_LOG 2> /dev/null
 [ -s "$java_LOG" ] && rm -f $java_LOG 2> /dev/null
 [ -s "$gpfs_LOG" ] && rm -f $gpfs_LOG 2> /dev/null
 [ -s "$lpar_LOG" ] && rm -f $lpar_LOG 2> /dev/null
 [ -s "$wpar_LOG" ] && rm -f $wpar_LOG 2> /dev/null
 [ -s "$gcc_LOG" ] && rm -f $gcc_LOG 2> /dev/null
 [ -s "$xlc_LOG" ] && rm -f $xlc_LOG 2> /dev/null
 [ -s "$svc_LOG" ] && rm -f $svc_LOG 2> /dev/null
 [ -s "$csm_LOG" ] && rm -f $csm_LOG 2> /dev/null
 [ -s "$aix_LOG" ] && rm -f $aix_LOG 2> /dev/null
 [ -s "$hmc_LOG" ] && rm -f $hmv_LOG 2> /dev/null
 [ -s "$vio_LOG" ] && rm -f $vio_LOG 2> /dev/null
 [ -s "$tsm_LOG" ] && rm -f $tsm_LOG 2> /dev/null

 User_Settings # set the user specific vars

 cleanup_at_start

 ERRMSG ${DATEFULL}" "${VERSION} # First entry in new *.err file

 AWTRACE "User.......: ${USER}"
 AWTRACE "Node.......: ${NODE}"
 AWTRACE "ProcID.....: ${PROCID}"
 AWTRACE "TERM.......: ${TERM}"
 AWTRACE "SYSLANG....: ${SYSLANG}"
 AWTRACE "LANG.......: ${LANG}"
 AWTRACE "DISPLAY....: ${DISPLAY}"
 AWTRACE "MYSELF.....: ${MYSELF}"
 AWTRACE "PLUGINS....: ${PLUGINS}"
 AWTRACE "PWD........: ${PWD}"
 AWTRACE "OLDPWD.....: ${OLDPWD}"
 AWTRACE "PATH.......: ${PATH}"
 AWTRACE "OUTDIR.....: ${OUTDIR}"
 AWTRACE "OUTDIR_ENV.: ${OUTDIR_ENV}"
 if [[ $AWDEBUG == 1 ]]
 then
   # "set" shows all vars (may be useful in debugging)
   #AWTRACE "%%% set %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
   #set >>${AWTRACE_DSN}
   #AWTRACE "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
   #
   # "env" shows the environment vars (useful for debugging)
   AWTRACE "%%% env %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
   env | grep -v "DTHELP" | grep -v "DTDATAB" | grep -v "DTAPPS" | grep -v "DTSCREEN" >>${AWTRACE_DSN}
   AWTRACE "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
 fi;

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 DSN_oslevel="${TMPDIR}/c2h_oslevel_${PROCID}.tmp"        # %BG006
 DSN_oslevel_r="${TMPDIR}/c2h_oslevel-r_${PROCID}.tmp"    # %BG007
 DSN_oslevel_s="${TMPDIR}/c2h_oslevel-s_${PROCID}.tmp"    # %BG008
 DSN_oslevel_rq="${TMPDIR}/c2h_oslevel-rq_${PROCID}.tmp"  # %BG009
 DSN_oslevel_sq="${TMPDIR}/c2h_oslevel-sq_${PROCID}.tmp"  # %BG010
 DSN_oslevel_g="${TMPDIR}/c2h_oslevel-g_${PROCID}.tmp"    # %BG011
 DSN_arp_a="${TMPDIR}/c2h_arp-a_${PROCID}.tmp"            # %BG012
 DSN_lppchk_f="${TMPDIR}/c2h_lppchk-f_${PROCID}.tmp"      # %BG013
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#%%% start BG jobs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 oslevel     >${DSN_oslevel}    2>/dev/null &  # %BG006 cmd file oslevel
 PID_osl=$!
 BGRC_osl=99
 BGSTART_osl=date
 oslevel -r  >${DSN_oslevel_r}  2>/dev/null &  # %BG007 cmd file oslevel -r
 PID_osl_r=$!
 BGRC_osl_r=99
 oslevel -s  >${DSN_oslevel_s}  2>/dev/null &  # %BG008 cmd file oslevel -s
 PID_osl_s=$!
 BGRC_osl_s=99
 oslevel -rq >${DSN_oslevel_rq} 2>/dev/null &  # %BG009 cmd file oslevel -rq
 PID_osl_rq=$!
 BGRC_osl_rq=99
 oslevel -sq >${DSN_oslevel_sq} 2>/dev/null &  # %BG010 cmd file oslevel -sq
 PID_osl_sq=$!
 BGRC_osl_sq=99
 oslevel -g  >${DSN_oslevel_g}  2>/dev/null &  # %BG011 cmd file oslevel -g
 PID_osl_g=$!
 BGRC_osl_g=99

 if [ "$COL_NETWORK" = "yes" ] # *col-??*
 then
   #AWTRACE "%%%%% COL_NETWORK=yes => start arp -a in BG %%%%%%%%%%%"
   arp -a | grep -v bucket:  >${DSN_arp_a}  2>/dev/null &          # %BG012 cmd file arp -a
   PID_arp_a=$!
   BGRC_arp_a=99
 else
   #AWTRACE "%%%%% COL_NETWORK=no => do not start arp -a in BG %%%%%%%%%%%"
   : # dummy - DO NOT DELETE
 fi
 if [ "$COL_SOFTWARE" = "yes" ] # *col-??*
 then
   #AWTRACE "%%%%% COL_SOFTWARE=yes => start lppchk -f in BG %%%%%%%%%%%"
   lppchk -f  >${DSN_lppchk_f}  2>&1             # %BG013 cmd file lppchk -f
   PID_lppc_f=$!
   BGRC_lppc_f=99
 else
   #AWTRACE "%%%%% COL_SOFTWARE=no => do not start lppchk -f in BG %%%%%%%%%%%"
   : # dummy - DO NOT DELETE
 fi
# ToDo 282-000 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# ToDo 282-000 -e enhanced is active ! Start BG Jobs here !!
# ToDo 282-000 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%% end BG jobs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# ToDo 281-010 oslevel -rl xxx / -sl xxx => missing for TL or SP

#%%% wait for end of BG jobs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 Wait4BG $PID_osl    "BG006" "osl" # %BG006 wait for specific process
 BGRC_osl=$?

 Wait4BG $PID_osl_r  "BG007" "osl_r" # %BG007 wait for specific process
 BGRC_osl_r=$?

 Wait4BG $PID_osl_s  "BG008" "osl_s" # %BG008 wait for specific process
 BGRC_osl_s=$?

 Wait4BG $PID_osl_rq "BG009" "osl_rq" # %BG009 wait for specific process
 BGRC_osl_rq=$?

 Wait4BG $PID_osl_sq "BG010" "osl_sq" # %BG010 wait for specific process
 BGRC_osl_sq=$?

 Wait4BG $PID_osl_g  "BG011" "osl_g" # %BG011 wait for specific process
 BGRC_osl_g=$?

#Wait4BG "BG012" "arp -a"    # %BG012 wait for in Collector !
#Wait4BG "BG013" "lppchk -f" # %BG013 wait for in Collector !

 if [[ ${DEBUG_100} = 1 ]] # if DEBUG 100 DBG BG-Jobs
 then
   :
 fi # fi DEBUG 100 DBG BG-Jobs
#%%% wait for end of BG jobs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#-----------------------------------------------------------------
 os_vr="$(uname -v)$(uname -r)" # init e.g. 53  cmd os_vr
 os_v="$(uname -v)"             # init e.g. 5   cmd os_v
 OSLEVEL=$(oslevel)             # init => 5.3.0.0          OS LEVEL (with DOTS)
 OSLEVEL_S=$(oslevel -s)        # init => 5300-04-CSP      format until AIX 5.3 TL04
#OSLEVEL_S=$(oslevel -s)        # init => 5300-05-CSP-0000 format from  AIX 5.3 TL05
 OSLEVEL_R=$(oslevel -r)        # init => 5300-04          .
 mltl="TL"                      # init
 typeset -L4 osl=$OSLEVEL_R     # init e.g. 5300
 typeset -R2 ml=$OSLEVEL_R      # init e.g. 04
 typeset -R2 tl=$OSLEVEL_R      # init e.g. 04 # tl same value as ml, just another name
 sp=$(echo ${OSLEVEL_S} | cut -d "-" -f3) # init e.g. 01 or CSP

 typeset -L2 ml                 # corr use 2 char from left (AIX6 Beta gives "XX BETA")
 maxtl=$tl                      # init maximum TL known (as of oslevel -rq)
 maxsp=$sp                      # init maximum SP known (as of oslevel -sq)
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# SP on 5.3 ONLY if TL is 05 or higher !!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if [[ "$os_vr" -eq 53 && "$tl" -lt 05 ]]
then
  sp="00"     # corr if os < 5.3-05
  maxsp="00"  # corr if os < 5.3-05
fi
#-----------------------------------------------------------------

 check_os

 check_basic_req  # check for some basic requirements...

# ToDo 280-100 check if dir exist before adding to path
# set Path to be used in this script
 set -A newdir
 typeset -i ii
 ii=0
 newdir[0]="/local/bin"                       # NA6EWI=NO
 newdir[1]="/local/sbin"                      # NA6EWI=NO
 newdir[2]="/usr/bin"                         # NA6EWI=YES
 newdir[3]="/usr/sbin"                        # NA6EWI=YES
 newdir[4]="/local/gnu/bin"                   # NA6EWI=NO
 newdir[5]="/usr/ccs/bin"                     # NA6EWI=YES
 newdir[6]="/local/X11/bin"                   # NA6EWI=NO
 newdir[7]="/usr/openwin/bin"                 # NA6EWI=NO
 newdir[8]="/usr/dt/bin"                      # NA.EWI=YES 6=NO => no GRAFIC-Card
 newdir[9]="/usr/proc/bin"                    # NA6EWI=NO
 newdir[10]="/usr/ucb"                        # NA6EWI=YES
 newdir[11]="/local/misc/openv/netbackup/bin" # NA6EWI=NO
#
 for ii in 0 1 2 3 4 5 6 7 8 9 10 11
 do
 if [[ -d ${newdir[${ii}]} ]]
 then
  AWTRACE "Dir '${newdir[${ii}]}' found. Will be added"
 else
  AWTRACE "Dir '${newdir[${ii}]}' NOT found. Could NOT be added"
 fi
 done
#
#
 PATH00=$PATH:/usr/bin:/usr/sbin:/usr/ccs/bin:
 PATH01=/usr/dt/bin:/usr/ucb:
 PATH02=""
 PATH=${PATH00}""${PATH01}""${PATH02}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# start long running cmds as background tasks here
#---------------------------------------------------------------------------
# when you background a job, save the value of $! which will be the pid
# of the background job. The background job will eventually finish and
# become a zombie. It will stay a zombie until the parent waits for
# it and retrieves the exit code.
# In ksh, this is done with the "wait" command.
# The exit code of the wait command will be the exit code
# of the process that was waited for.
#---------------------------------------------------------------------------
 DSN_geninv="${TMPDIR}/c2h_geninv_${PROCID}.tmp"          # %BG001
 DSN_prtconf="${TMPDIR}/c2h_prtconf_${PROCID}.tmp"        # %BG002
 DSN_prtconf_c="${TMPDIR}/c2h_prtconf-c_${PROCID}.tmp"    # %BG003
 DSN_prtconf_k="${TMPDIR}/c2h_prtconf-k_${PROCID}.tmp"    # %BG004
 DSN_lsattr_l="${TMPDIR}/c2h_lsattr-l_${PROCID}.tmp"      # %BG005

# ToDo 282-025 start bg-jobs for EXTENDED

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# geninv on 5.3 ONLY if TL is 08 or higher !!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# >AW313< BUG: BG job geninv only started in AIX 5.3 TL08 !
 run_geninv="no" # init 1
BGRC_gi=99  # init rc of background job ! set when using wait
if [[ "$os_vr" -eq 53 && "$tl" -ge 08 ]] ; then
 run_geninv="yes"
fi
if [[ "$os_vr" -ge 60 ]] ; then
 run_geninv="yes"
fi
if [[ "$run_geninv" = "yes" ]] ; then
 #AWTRACE "%%%%% run_geninv=${run_geninv} => start geninv -l in BG %%%%%%%%%%%"
 # ToDo 282-025 start bg-job only if CFG_xxxxx=yes
 geninv -l >${DSN_geninv}   2>/dev/null &   # %BG001
 PID_gi=$! # get processid of background job
else
 :
 #AWTRACE "%%%%% run_geninv=${run_geninv} => do not start geninv -l in BG %%%%%%%%%%%"
fi

 prtconf    >${DSN_prtconf}   2>/dev/null & # %BG002
 PID_pc=$!
 BGRC_pc=99
# prtconf -c >${DSN_prtconf_c} 2>/dev/null & # %BG003
# PID_pc_c=$!
# BGRC_pc_c=99
# prtconf -k >${DSN_prtconf_k} 2>/dev/null & # %BG004
# PID_pc_k=$!
# BGRC_pc_k=99

# ToDo 282-001 check for SYNTAX ERROR of lsattr cmd
 lsattr -El >${DSN_lsattr_l} 2>/dev/null & # %BG005
 PID_lsattr=$!
 BGRC_lsattr=99

 DSN_oslevel_x="${TMPDIR}/c2h_oslevel-x_${PROCID}.tmp"    # %BG900
 DSN_oslevel_x_err="${TMPDIR}/c2h_oslevel-x_err_${PROCID}.tmp"
# oslevel -x >${DSN_oslevel_x} 2>${DSN_oslevel_x_err} &  # %BG900
# PID_osl_x=$!
# BGRC_osl_x=99

 DSN_oxlevel_x="${TMPDIR}/c2h_oxlevel-x_${PROCID}.tmp"    # %BG901
 DSN_oxlevel_x_err="${TMPDIR}/c2h_oslevel-x_err_${PROCID}.tmp"
# oxlevel -x >${DSN_oxlevel_x} 2>${DSN_oxlevel_x_err} &  # %BG901
# PID_oxl_x=$!
# BGRC_oxl_x=99

#- ShowBGrc

#- echo "%%%%%%%%%%"
#- echo "%%%%%%%%%%"
#- aw_command "ps -fT $PROCID"
#- echo "%%%%%%%%%%"

#::::::::::::::::::::::::::::::::::::::::::::::::
#if [[ ${DEBUG_100} = 1 ]] # if DEBUG 100 DBG BG-Jobs
#then
#- ERRMSG "xxx jobs"
#- aw_command "jobs"
#fi
#::::::::::::::::::::::::::::::::::::::::::::::::

#::::::::::::::::::::::::::::::::::::::::::::::::
#- ERRMSG "xxx jobs -l (1)"
#- jobs -l >xxjobs_l1.out
#- jobs_rc=$?
#- ERRMSG "xxx jobs -l (1) RC=$jobs_rc"
#::::::::::::::::::::::::::::::::::::::::::::::::


#::::::::::::::::::::::::::::::::::::::::::::::::
#- ERRMSG "xxx jobs -l (2)"
#- jobs -l >xxjobs_l2.out
#- jobs_rc=$?
#- ERRMSG "xxx jobs -l (2) RC=$jobs_rc"
#::::::::::::::::::::::::::::::::::::::::::::::::

#::::::::::::::::::::::::::::::::::::::::::::::::
#- ERRMSG "xxx jobs -l (3)"
#- jobs -l >xxjobs_l3.out
#- jobs_rc=$?
#- ERRMSG "xxx jobs -l (3) RC=$jobs_rc"
#::::::::::::::::::::::::::::::::::::::::::::::::


 wait4bg_date="YES"
 Wait4BG ${PID_lsattr} "BG005" "lsattr" # %BG005 wait for specific process
 BGRC_lsattr=$?

 #Wait4BG $PID_osl_x "BG901" "osl_x" # %BG900 wait for specific process
 #BGRC_osl_x=$?

 #Wait4BG $PID_oxl_x "BG901" "oxl_x" # %BG901 wait for specific process
 #BGRC_oxl_x=$?

 #Wait4BG $PID_pc_c "BG004" "pc_c" # %BG004 wait for specific process
 #BGRC_pc_c=$?

 if [[ ${DEBUG_100} = 1 ]] # if DEBUG 100 DBG BG-Jobs
 then
   ShowBGrc
 fi # fi DEBUG 100 DBG BG-Jobs

 #Wait4BG $PID_pc_k "BG004" "pc_k" # %BG004 wait for specific process
 #BGRC_pc_k=$?

 wait4bg_date="YES"
 Wait4BG $PID_pc "BG002" "pc" # %BG002 wait for specific process
 BGRC_pc=$?

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 DATEFULL=$(date "+%Y-%m-%d - %H:%M:%S")     # ISO8601 compliant date and time string
 AWTRACE "DT-0 "${DATEFULL}
# may take up to 30 sec
 get_ProcessorInfo

 DATEFULL=$(date "+%Y-%m-%d - %H:%M:%S")     # ISO8601 compliant date and time string
 AWTRACE "DT-1 "${DATEFULL}

 DATEFULL=$(date "+%Y-%m-%d - %H:%M:%S")     # ISO8601 compliant date and time string
 AWTRACE "DT-2 "${DATEFULL}
}

######################################################################
# Wait4BG: wait for completion of a BG job
######################################################################
Wait4BG ()
{
# ToDo 280-005 WAIT for BG Job
# ...0=OK 1=xx 127= 255=
 bg_procid="${1:-0}"
 bg_intno="${2:-"BG000"}"
 bg_intnam="${3:-"Undefined"}"

# ToDo 280-005 if VERBOSE then wait4bg_date=YES
 wait4bg_date="${wait4bg_date:-"NO"}"

# if [[ ${bg_procid} = 0 ]] ; then return 0;

 if [[ ${wait4bg_date} = "YES" ]]
 then
   dt=$(date)
   echo "${dt} waiting for ${bg_intno}"
 fi

 wait $bg_procid # %BG000 wait for specific process
 wait_rc=$?
 if [[ ${DEBUG_100} = 1 ]] # if DEBUG 100 DBG BG-Jobs
 then
   ERRMSG "AWDBG001I wait $bg_intno $bg_intnam $bg_procid RC=$wait_rc"
 fi # fi DEBUG 100 DBG BG-Jobs

 if [[ ${wait4bg_date} = "YES" ]]
 then
   date
 fi

 return $wait_rc
}

######################################################################
# ShowBGrc: show PID and RC of bg jobs
######################################################################
ShowBGrc ()
{
 ERRMSG "AWDBG000I ----------------------------------------------"
 ERRMSG "AWDBG000I (BG001) PID_gi=$PID_gi BGRC_gi=$BGRC_gi"                 # %BG001
 ERRMSG "AWDBG000I (BG002) PID_pc=$PID_pc BGRC_pc=${BGRC_pc}"               # %BG002
# ERRMSG "AWDBG000I PID_pc_c=$PID_pc_c BGRC_pc_c=${BGRC_pc_c}"         # %BG003
# ERRMSG "AWDBG000I PID_pc_k=$PID_pc_k BGRC_pc_k=${BGRC_pc_k}"         # %BG004
 ERRMSG "AWDBG000I (BG005) PID_lsattr=$PID_lsattr BGRC_lsattr=$BGRC_lsattr" # %BG005
 ERRMSG "AWDBG000I (BG006) PID_osl=$PID_osl RC=$BGRC_osl"                   # %BG006
 ERRMSG "AWDBG000I (BG007) PID_osl_r=$PID_osl_r BGRC_osl_r=$BGRC_osl_r"     # %BG007
 ERRMSG "AWDBG000I (BG008) PID_osl_s=$PID_osl_s BGRC_osl_s=$BGRC_osl_s"     # %BG008
 ERRMSG "AWDBG000I (BG009) PID_osl_rq=$PID_osl_rq BGRC_osl_rq=$BGRC_osl_rq" # %BG009
 ERRMSG "AWDBG000I (BG010) PID_osl_sq=$PID_osl_sq BGRC_osl_sq=$BGRC_osl_sq" # %BG010
 ERRMSG "AWDBG000I (BG011) PID_osl_g=$PID_osl_g BGRC_osl_g=$BGRC_osl_g"     # %BG011
 ERRMSG "AWDBG000I (BG012) PID_arp_a=$PID_arp_a BGRC_arp_a=$BGRC_arp_a"     # %BG012
 ERRMSG "AWDBG000I (BG013) PID_lppc_f=$PID_lppc_f BGRC_lppc_f=$BGRC_lppc_f" # %BG013
# ERRMSG "AWDBG000I PID_osl_x=$PID_osl_x BGRC_osl_x=$BGRC_osl_x"     # %BG900
# ERRMSG "AWDBG000I PID_oxl_x=$PID_oxl_x BGRC_oxl_x=$BGRC_oxl_x"     # %BG901
 ERRMSG "AWDBG000I ----------------------------------------------"
}

######################################################################
# SetOSver: set specific OS Version info. FOR DEVELOPMENT ONLY
######################################################################
SetOSver ()
{
# OSLEVEL    => 5.3.0.0          OS LEVEL (with DOTS)
# OSLEVEL_S  => 5300-04-01       format until AIX 5.3 TL04
# OSLEVEL_S  => 5300-04-CSP      format until AIX 5.3 TL04
# OSLEVEL_S  => 5300-05-01-0000  format from  AIX 5.3 TL05
# OSLEVEL_S  => 5300-05-CSP-0000 format from  AIX 5.3 TL05
# OSLEVEL_R  => 5300-04          .
# osl        => 5300             OS Level (NO DOTS)
# os_v       => 5                Version
# os_vr      => 53               Version+Release
# ml         => 03               Maintenance Level (old name!)
# tl         => 03               Technology Level
# maxtl      => 03               Highest Known Technology Level
# sp         => 01               ServicePac
# maxsp      => 01               Highest Known ServicePac
# mltl       => TL               x to indicate if ML or TL

#--------------------------
OSLEVEL="5.3.0.0"
OSLEVEL_S="5300-09-01"
OSLEVEL_S="5300-09-01-0000"
OSLEVEL_R="5300-09"
osl="5300"
os_v="5"
os_vr="53"
ml="09"
tl="09"
maxtl="09"
sp="01"
maxsp="01"
mltl="TL"
#--------------------------
#--------------------------
OSLEVEL="5.3.0.0"
OSLEVEL_S="5300-04-CSP"
OSLEVEL_S="5300-04-CSP"
OSLEVEL_R="5300-04"
osl="5300"
os_v="5"
os_vr="53"
ml="04"
tl="04"
maxtl="08"
sp="CSP"
maxsp="CSP"
mltl="TL"
#--------------------------
#--------------------------
OSLEVEL="6.1.0.0"
OSLEVEL_S="6100-02-01"
OSLEVEL_S="6100-02-01-0000"
OSLEVEL_R="6100-02"
osl="6100"
os_v="6"
os_vr="61"
ml="02"
tl="02"
maxtl="03"
sp="01"
maxsp="01"
mltl="TL"
#--------------------------
#--------------------------
OSLEVEL="V7BETA"
OSLEVEL_S="7100-00-00"
OSLEVEL_S="7100-00-00-0000"
OSLEVEL_R="7100-00"
osl="7100"
os_v="7"
os_vr="71"
ml="00"
tl="00"
maxtl="00"
sp="00"
maxsp="00"
mltl="TL"
#--------------------------
#--------------------------
OSLEVEL="7.1.0.0"
OSLEVEL_S="7100-00-00"
OSLEVEL_S="7100-00-00-0000"
OSLEVEL_R="7100-00"
osl="7100"
os_v="7"
os_vr="71"
ml="00"
tl="00"
maxtl="00"
sp="00"
maxsp="00"
mltl="TL"
#--------------------------

AWCONST "DEBUGGING: Original OSLEVEL"
AWCONST "VAR OSLEVEL_S: ${OSLEVEL_S}"
AWCONST "DSN OSLEVEL_S: ${DSN_oslevel_s}"
echo ${OSLEVEL_S} >${DSN_oslevel_s}
AWCONST "VAR OSLEVEL_R ${OSLEVEL_R}"
AWCONST "DSN OSLEVEL_R ${DSN_oslevel_r}"
echo ${OSLEVEL_R} >${DSN_oslevel_r}
lsp=${#sp}  # LENGTH
lsp2=${#sp} # LENGTH
AWTRACE "SP=${SP} LSP=${LSP} LSP2=${LSP2}"
}

######################################################################
# check_os: check for correct (supported) os level and dependencies
######################################################################
check_os ()  # >AW018<
{
# OSLEVEL checks
# --------------

 AWDEBUG="${AWDEBUG:-0}"
#- if [[ $AWDEBUG == 1 ]]; then
#-   ShowOSver "Before"
#- fi;

#%%%%%%%%%DEVELOPMENT-ONLY%%%%%%%%%
#SetOSver
#ShowOSver "After"
#%%%%%%%%%DEVELOPMENT-ONLY%%%%%%%%%

#----------------------------------------------------------

#----------------------------
# 7.1.0 ALWAYS TL
# 6.1.0 ALWAYS TL
# 6.0.0 ALWAYS TL (AIX6 Beta)
# 5.3.0 ML4=TL4
#----------------------------
# mltl="TL" # ML or TL  # init
 case $osl in
   7100 ) mltl="TL"
          ;;
   6100 ) mltl="TL"
          ;;
   6000 ) mltl="TL"
          ;;
   5300 )
      case ${ml} in
       00 ) mltl="ML";;
       01 ) mltl="ML";;
       02 ) mltl="ML";;
       03 ) mltl="ML";;
        * ) mltl="TL";;
      esac;
          ;;
   * )
     echo "C2H030I Unknown AIX Level";
     ERRLOG "C2H203I Internal error checking oslevel (ID=001)";
     ;;
 esac;

 case $mltl in
   "ML" ) ERRLOG "You are at MAINTENANCE LEVEL ${ml}"
          ;;
   "TL" ) ERRLOG "OSLEVEL_S="${OSLEVEL_S}
          ERRLOG "You are at TECHNOLOGY  LEVEL ${tl}"
          # if running at TL we also know a sp
          ERRLOG "You are at SERVICE PACK ${sp}"
          ;;
   * )
     echo "C2H031E Unexpected value ${mltl} for var mltl";
     ;;
 esac;
 echo ""

#  OSVER6CHAR=`oslevel -r | sed 's/-//'`
#  OSVER3CHAR=`oslevel -r | awk '{print substr($1,1,3)}'`
#-------------------------------------------------------------
# The following vars are now available throughout this script !
# DO NOT use the oslevel function on any other place in this
# script ! This makes it possible to 'fake' the os level
# in case we need it during development.
#
# VAR           Sample           Description
# ----------    ---------------- ------------------------------
# OSLEVEL    => 5.3.0.0          OS LEVEL (with DOTS)
# OSLEVEL_S  => 5300-04-01       format until AIX 5.3 TL04
# OSLEVEL_S  => 5300-04-CSP      format until AIX 5.3 TL04
# OSLEVEL_S  => 5300-05-01-0000  format from AIX 5.3 TL05
# OSLEVEL_S  => 5300-05-CSP-0000 format from AIX 5.3 TL05
# OSLEVEL_R  => 5300-04          .
# osl        => 5300             OS Level (NO DOTS)
# os_v       => 5                Version
# os_vr      => 53               Version+Release
# ml         => 03               Maintenance Level (old name!)
# tl         => 03               Technology Level
# maxtl      => 03               Highest Known Technology Level
# sp         => 01               ServicePac
# maxsp      => 01               Highest Known ServicePac
# mltl       => TL               x to indicate if ML or TL
#-------------------------------------------------------------

# ToDo 710-710 AIX7 better use case

  if [ "$os_vr" -gt 71 ] ; then  # >AW...<
     banner "Warning"
     echo "C2H032I Unsupported AIX Version (${os_vr}) ! Please contact developer!\n"
     #xexit 1 # >AW018<
  fi

  if [ "$os_vr" -eq 71 ] ; then  # >AW...<
     # VALID AIX Release
     :
  fi

#  if [ "$os_vr" -eq 71 ] ; then  # >AW121<
#     banner "Warning"
#     echo "C2H033I Note: You are running AIX 7 BETA (${oslevel} ${os_vr}) ! Please contact developer !\n"
#     #xexit 1 # >AW018<
#  fi

  if [ "$os_vr" -eq 62 ] ; then  # >AW...<
     echo "C2H033I Note: This Version of AIX (${os_vr}) has NEVER been tested with this version of the script !\n"
    #exit 1 # >AW018<
  fi

  if [ "$os_vr" -eq 53 ] ; then  # >AW...<
     if [ "$tl" -ge 10 ] ; then  # >AW...<
       :
     else
       banner "Sorry"
       ERRMSG "C2H037I Note: This script needs at least AIX 5.3 TL 10 !\n"
       ERRMSG "C2H038I Your OSLEVEL_S="${OSLEVEL_S}
       xexit 1 # >AW018<
     fi
  fi

  if [ "$os_vr" -eq 61 ] ; then  # >AW...<
     if [ "$tl" -lt 04 ] ; then  # >AW...<
       #banner "Sorry"
       ERRMSG "C2H037I Note: This script has not been fully tested on AIX 6.1 TL ${tl} !"
       ERRMSG "C2H037I Please report any bugs\n"
       ERRMSG "C2H038I Your OSLEVEL_S="${OSLEVEL_S}
       #xexit 1 # >AW018<
     fi
  fi

  if [ "$os_vr" -eq 53 ] ; then  # >AW...<
     if [ "$tl" -lt 10 ] ; then  # >AW...<
       #banner "Sorry"
       ERRMSG "C2H037I Note: This script has not been fully tested on AIX 5.3 TL ${tl} !"
       ERRMSG "C2H037I Please report any bugs\n"
       ERRMSG "C2H038I Your OSLEVEL_S="${OSLEVEL_S}
       #xexit 1 # >AW018<
     fi
  fi

  if [ "$os_vr" -lt 53 ] ; then  # >AW032<
     banner "Sorry"
     echo "C2H036E Requires AIX 5.3 or better!\n"
     xexit 1 # >AW018<
  fi

 #AWCONS "Check OSLEVEL  : ${OSLEVEL}"
 #AWCONS "Check OSLEVEL_S: ${OSLEVEL_S}"
 case $OSLEVEL in
   7.1.0.0 ) # WARNING
             AWCONS "C2H037I Supported OS \"${OSLEVEL_S}\" "
             #AWCONS "CURRENTLY NOT FULLY TESTESD ON AIX 7.1"
             ;;
   6.1.0.0 ) # OK
             AWCONS "C2H037I Supported OS \"${OSLEVEL_S}\" "
             ;;
   6.0.0.0 ) # WARNING
             AWCONS "WARNING NOT FULLY TESTESD ON AIX 6 BETA"
             ;;
   5.3.0.0 ) # OK
             AWCONS "C2H037I Supported OS \"${OSLEVEL_S}\" "
             ;;
         * ) # ERROR
             if [ "$os_vr" -eq 61 ] ; then  # >AW...<
                if [ "$tl" -gt 04 ] ; then  # >AW...<
                  ERRMSG "C2H037I Note: This script has not been fully tested on AIX 6.1 TL ${tl} !"
                  ERRMSG "C2H037I Please report any bugs\n"
                  ERRMSG "C2H038I Your OSLEVEL_S="${OSLEVEL_S}
                  #xexit 1 # >AW018<
                fi
             else
               AWCONS "C2H037E UnSupported AIX version \"${OSLEVEL}\" (\"${OSLEVEL_S}\")"
             fi
             ;;
 esac

}

######################################################################
# ShowOSver: show the vars containing os level info
######################################################################
ShowOSver ()  # >AW...<
{
# SHOW OSLEVEL
# ------------
 AWCONS "OSLEVEL: ${1}"
 AWCONS "os_v       = ${os_v}"
 AWCONS "os_vr      = ${os_vr}"
 AWCONS "osl        = ${osl}"
 AWCONS "OSLEVEL    = ${OSLEVEL}"
 AWCONS "OSLEVEL_S  = ${OSLEVEL_S}"
 AWCONS "OSLEVEL_R  = ${OSLEVEL_R}"
 AWCONS "mltl       = ${mltl}"
 AWCONS "ml         = ${ml}"
 AWCONS "tl         = ${tl}"
 AWCONS "maxtl      = ${maxtl}"
 AWCONS "sp         = ${sp}"
 AWCONS "maxsp      = ${maxsp}"

 if [[ $AWDEBUG == 1 ]]; then
   echo "DSN_oslevel_r:"${DSN_oslevel_r}
   if [[ -f ${DSN_oslevel_r} ]]
   then
     cat ${DSN_oslevel_r}
   else
     AWCONS "File not available !"
   fi
   echo "DSN_oslevel_s:"${DSN_oslevel_s}
   if [[ -f ${DSN_oslevel_s} ]]
   then
     cat ${DSN_oslevel_s}
   else
     AWCONS "File not available !"
   fi
 fi
}

######################################################################
# check_basic_req: check for some basic requirements...
######################################################################
check_basic_req ()
{
# echo "\n"
#AWCONS "AWTRACE: CBR 000"
  if [ $(id -u) != 0 ] ; then
     banner "Sorry"
     line
     echo "You must run this script as Root\n"
     xexit 1 # >AW018<
  fi

#AWCONS "AWTRACE: CBR 001 "$HTML_OUTFILE
  if [ ! -f $HTML_OUTFILE ]
  then
     banner "Error"
     echo "C2H008S You have not the rights to create ${HTML_OUTFILE}! (NFS?)\n"
     xexit 1 # >AW018<
  fi
#AWCONS "AWTRACE: CBR 002"

#++ >AW104< start *PLUGIN*---------------------------------------------
#...Check if /plugins dir is there
  PLUGINS=${C2H_HOME}/plugins
  if [ ! -d ${PLUGINS} ]
  then
    echo "C2H700I Plugin-Dir = $PLUGINS"
    echo "C2H701W Warning, the plugin directory is missing or execute bit is not set"
#   xexit 1 # >AW018<
    mkdir $PLUGINS
    mkdir_rc=$?
    AWTRACE     "C2H009I mkdir rc $mkdir_rc"
    case $mkdir_rc in
      0 ) # OK
          echo "C2H702I Plugin-Dir successfully created";
          ;;
      * )
          echo "C2H703E ERROR creating Plugin-Dir ! rc=$mkdir_rc";
          ;;
    esac
  fi
#++ >AW104< end *plugin* ----------------------------------------------

#++ >AW310< start *out of memory*--------------------------------------
# 128K - 131.072
# 256K - 262.144
# 384K - 393.216
# 512K - 524.288
#...Check if ulimit -d is at least 524288
 curr_ulimit_d=$(ulimit -d) # -d => data area
 if [[ $curr_ulimit_d = "unlimited" ]]
 then
   verbose_out "C2H020I ulimit -d is set to 'unlimited'. No action required."
   AWTRACE     "C2H020I ulimit -d is set to 'unlimited'. No action required."
 elif [[ $curr_ulimit_d -lt 524288 ]]
 then
   verbose_out "C2H020I ulimit -d was "$curr_ulimit_d" now set to 524288"
   AWTRACE     "C2H020I ulimit -d was "$curr_ulimit_d" now set to 524288"
   ulimit -d 524288  # set the new ulimit
 else
   verbose_out "C2H020I ulimit -d is set to "$curr_ulimit_d". No action required."
   AWTRACE     "C2H020I ulimit -d is set to "$curr_ulimit_d". No action required."
 fi

 curr_ulimit_c=$(ulimit -c) # -c => core dumps
 AWTRACE "C2H021I ulimit -c is "$curr_ulimit_c
 curr_ulimit_f=$(ulimit -f) # -f => file size
 AWTRACE "C2H021I ulimit -f is "$curr_ulimit_f
 curr_ulimit_m=$(ulimit -m) # -m => memory
 AWTRACE "C2H021I ulimit -m is "$curr_ulimit_m
 curr_ulimit_n=$(ulimit -n) # -n => number of file descriptors
 AWTRACE "C2H021I ulimit -n is "$curr_ulimit_n
 curr_ulimit_s=$(ulimit -s) # -s => stack
 AWTRACE "C2H021I ulimit -s is "$curr_ulimit_s
 curr_ulimit_t=$(ulimit -t) # -t => number of seconds to be used by each proc
 AWTRACE "C2H021I ulimit -t is "$curr_ulimit_t

# new ulimits in AIX6: threads, processes  # >AW075<
 case $osl in
   7100|6100 ) # new ulimits
          curr_ulimit_r=$(ulimit -r) # -r => number of threads a process can have
          AWTRACE "C2H021I ulimit -r is "$curr_ulimit_r
          curr_ulimit_u=$(ulimit -u) # -u => number of process a user can create
          AWTRACE "C2H021I ulimit -u is "$curr_ulimit_u
          ;;
   5300 ) # nop
          ;;
   * ) # nop
          AWCONST "C2H203I Internal error checking oslevel (ID=002)";
          ;;
 esac;

#++ >AW310< end *out of memory*----------------------------------------

#++ >AW019< start *SYSINF*---------------------------------------------
#...Check if file *SYSINF* is there
# SYSINF may contain any info about your system you wish to be displayed
# ToDo 281-000 sysinf.html
  SYSINF=c2h_sysinfo
  if [[ ! -f $SYSINF ]]
  then
    ERRMSG "C2H030I sysinfo file '${SYSINF}' not found."
    ERRMSG "C2H030I PWD '${PWD}'"
  else
    ERRMSG "C2H030I sysinfo file '${SYSINF}' found."
    echo ${SEP70}
    cat $SYSINF
    echo "\n"
    echo ${SEP70}
  fi
#++ >AW019< end *SYSINF* ----------------------------------------------

#++ >AWxxx< start *CFG*------------------------------------------------
#...Check if file *CFG* is there
# C2HCFG contains configuration data for this script
 C2HCFG="c2h_cfg"
 if [[ ! -f $C2HCFG ]]
 then
   ERRMSG "C2H030W Warning, the c2hcfg file '${C2HCFG}' is missing. Using internal defaults"
 else
   :
   ERRMSG "C2H030I c2hcfg file '${C2HCFG}' found. Now reading..."
   read_c2hcfg
 fi
#...Check if file *CFG_SAMPLE* is there
 C2HCFG_SAMP="c2h_cfg_samp"
 if [[ ! -f $C2HCFG_SAMP ]]
 then
   : # sample file is missing, so create it "
   create_c2hcfg_samp
 else
   :
 fi
#++ >AWxxx< end *CFG* -------------------------------------------------

#++ >AWxxx< start *C2HINFO*--------------------------------------------
#...Check if file *C2HINFO* is there
# C2HINF contains information data for this script
 C2HINF=".c2h_info"
 if [[ ! -f $C2HINF ]]
 then
   # show only when in debug mode
   ERRMSG "C2H030I Note, the c2hinfo file '${C2HINF}' not found."
 else
   :
   ERRMSG "C2H030I c2hinfo file '${C2HINF}' found."
   # ToDo 281-000 show timestamp of c2h_info file
   read_c2hinf # ToDo 280-999 (later write_c2hinf !!)
 fi
#++ >AWxxx< end *C2HINFO* ---------------------------------------------

#++ >AWxxx< start *ssh check*------------------------------------------
 ssh_knownhost="$HOME/.ssh/known_hosts"
 wx=$(which ssh >/dev/null 2>&1)
 which_rc=$?
 if [[ $which_rc = 0 ]]
 then
   ssh_status="OK"
   if [[ -f ${ssh_knownhost} ]]
   then
     :
     # ToDo 281-000 show timestamp of ssh_knownhost file
   else
     ssh_status="KO"
     AWTRACE "C2H000E ssh 'known_hosts' file not found ! "
     # ToDo 281-000 ssh_status
     # ToDo 281-000 cannot ssh 'known_hosts' file missing
   fi
 else
   ssh_status="KO"
   AWTRACE "C2H000E ssh not found in path (Internal Error) ${which_rc} wx=${wx}"
 fi
#++ >AWxxx< end *ssh_check* -------------------------------------------

AWCONS "AWTRACE: CBR 999"
}

######################################################################
# read_c2hcfg: execute the cfg file. This will set the vars
######################################################################
read_c2hcfg ()
{
AWCONS "AWTRACE: CFG 000"

c2hcfg_cons="c2h_cfg.cons"
c2hcfg_err="c2h_cfg.err"

ShowC2H "Default"

# Note: EXECUTE Bit must be set
 if [[ ! -x $C2HCFG ]]
 then
   # show only when in debug mode
   AWCONS "C2H030I Note, execute bit not set for c2hcfg file '${C2HCFG}' ."
   cfg_rc=99
 else
   : OK, we may now execute the file
   AWCONS "C2H030I c2hcfg is executable '${C2HCFG}'."
   . ${C2HCFG} >${c2hcfg_cons} 2>${c2hcfg_err}
   cfg_rc=$?
 fi

# ToDo ELSEIF rc=99 !!!
if [[ ${cfg_rc} = 0 ]]
then
  # fine. everything was OK
  validate_c2hcfg
elif [[ ${cfg_rc} = 99 ]]
then
  # something went wrong !
  AWTRACE "C2H000E Problem cannot execute '${C2HCFG}' RC=${cfg_rc}"
else
  # something went wrong !
  AWTRACE "C2H000E Problem while executing '${C2HCFG}' RC=${cfg_rc}"
  if [[ -f ${c2hcfg_cons} ]]
  then
    AWTRACE "Show C2HCFG.cons:"
    cat ${c2hcfg_cons}
  fi
  if [[ -f ${c2hcfg_err} ]]
  then
    AWTRACE "Show C2HCFG.err:"
    cat ${c2hcfg_err}
  fi
fi

ShowC2H "Ext"

AWCONS "AWTRACE: CFG 999"
}

######################################################################
# read_c2hinf: execute the inf file. This will set the vars
######################################################################
read_c2hinf ()
{
AWCONS "AWTRACE: INF 000"

c2hinf_cons="c2h_inf.cons"
c2hinf_err="c2h_inf.err"

rm -f ${c2hinf_err} 2>/dev/null

if [[ -r ${C2HINF} ]]
then
  AWTRACE "C2H000E read bit for c2hinf not set."
  inf_rc=16
fi

#AWCONS "AWTRACE: INF 100"
if [[ -x ${C2HINF} ]]
then
  #AWCONS "AWTRACE: INF 110"
  AWTRACE "C2H000E execute bit for c2hinf not set."
  inf_rc=16
else
  #AWCONS "AWTRACE: INF 120"
  . ${C2HINF} >${c2hinf_cons} 2>${c2hinf_err}
  inf_rc=$?
fi

#AWCONS "AWTRACE: INF 200"
if [[ ${inf_rc} = 0 ]]
then
  # fine. everything was OK
  #AWCONS "AWTRACE: INF 201"
  validate_c2hinf
  #AWCONS "AWTRACE: INF 202"
else
  # something went wrong !
  #AWCONS "AWTRACE: INF 203"
  AWTRACE "C2H000E Problem while executing '${C2HINF}' RC=${inf_rc}"
  if [[ -f ${c2hinf_cons} ]]
  then
    #AWCONS "AWTRACE: INF 204"
    AWTRACE "Show C2HINF.cons:"
    cat ${c2hinf_cons}
    cat ${c2hinf_cons} > $ERRLOG
  fi
  #AWCONS "AWTRACE: INF 205"
  if [[ -f ${c2hinf_err} ]]
  then
    #AWCONS "AWTRACE: INF 206"
    AWTRACE "Show C2HINF.err:"
    cat ${c2hinf_err}
    #AWCONS "AWTRACE: INF 207"
    cat ${c2hinf_err} > $ERRLOG
    #AWCONS "AWTRACE: INF 208"
  fi
fi

AWCONS "AWTRACE: INF 999"
}

######################################################################
# create_c2hcfg_samp: create cfg_sample file
######################################################################
create_c2hcfg_samp ()
{
AWCONS "AWTRACE: CFG_SAMP 000"

# ToDo 281-000 update sample file (delete and create new...)

#echo "#" > ${C2H_CFG_SAMP}

#echo "# @(#)C2H_CFG_SAMP Version 2.80b00" >> ${C2H_CFG_SAMP}

#echo "# C2H_CFG_SAMPle"      >> ${C2H_CFG_SAMP}
#echo "# --------------"      >> ${C2H_CFG_SAMP}
#echo "#"                     >> ${C2H_CFG_SAMP}

#echo "#=============================" >> ${C2H_CFG_SAMP}
#echo "# Correct Syntax"               >> ${C2H_CFG_SAMP}
#echo "# --------------"               >> ${C2H_CFG_SAMP}
#echo "#"                              >> ${C2H_CFG_SAMP}
#echo "# C2H_VAR_OK='ABC'              >> ${C2H_CFG_SAMP}
#echo "#"                              >> ${C2H_CFG_SAMP}
#echo "# Wrong Syntax"                 >> ${C2H_CFG_SAMP}
#echo "# ------------"                 >> ${C2H_CFG_SAMP}
#echo "#"                              >> ${C2H_CFG_SAMP}
#echo "# C2H_VAR_KO = '123'            >> ${C2H_CFG_SAMP}
#echo "#=============================" >> ${C2H_CFG_SAMP}

#echo "#"                              >> ${C2H_CFG_SAMP}
#echo "# rotate *.txt outputfile ?"    >> ${C2H_CFG_SAMP}
#echo "# -------------------------"    >> ${C2H_CFG_SAMP}
#echo "# C2H_ROTATE='YES' # YES or NO" >> ${C2H_CFG_SAMP}
#echo "# C2H_ROTATE_LVL=9 # 0-9"       >> ${C2H_CFG_SAMP}
#echo "#"                              >> ${C2H_CFG_SAMP}

#echo "# Debugging"                    >> ${C2H_CFG_SAMP}
#echo "# ---------"                    >> ${C2H_CFG_SAMP}
#echo "# AWDEBUG=1"                    >> ${C2H_CFG_SAMP}
#echo "#"                              >> ${C2H_CFG_SAMP}

#echo "#>>> EOF <<<"                   >> ${C2H_CFG_SAMP}

AWCONS "AWTRACE: CFG_SAMP 999"
}

######################################################################
# validate_c2hcfg: check C2H vars for valid values
######################################################################
validate_c2hcfg ()
{
 AWCONS "AWTRACE: CFG_VAL 000"

# ToDo 281-000 ...

# AWDEBUG
# -------
 var="AWDEBUG"
 val=${AWDEBUG}

 case ${AWDEBUG} in
  0 ) AWDEBUG=0 ;
              ;;
  1 ) AWDEBUG=1 ;
              ;;
          * ) ERRMSG "C2H999E Invalid value '${val}' for ${var}"
              unset AWDEBUG
              ;;
 esac

# C2H_DEBUG
# ---------
 var="C2H_DEBUG"
 val=${C2H_DEBUG}

 case ${C2H_DEBUG} in
   0 ) C2H_DEBUG=0 ;
       ;;
   1 ) C2H_DEBUG=1 ;
       ;;
  '' ) unset C2H_DEBUG;
       ;;
   * ) ERRMSG "C2H999E Invalid value '${val}' for ${var}"
       unset C2H_DEBUG
       ;;
 esac

# C2H_ROTATE
# ----------
 var="C2H_ROTATE"
 val=${C2H_ROTATE}

 case ${C2H_ROTATE} in
  YES | yes ) C2H_ROTATE="YES" ;
              ;;
  NO | no   ) C2H_ROTATE="NO" ;
              ;;
          * ) ERRMSG "C2H999E Invalid value '${val}' for ${var}"
              unset C2H_ROTATE
              ;;
 esac

# C2H_ROTATE_LVL
# --------------
 var="C2H_ROTATE_LVL"
 val=${C2H_ROTATE_LVL}

 if [[ ${C2H_ROTATE_LVL} = "" ]]
 then
   C2H_ROTATE_LVL=0
 fi

 if [[ ${C2H_ROTATE_LVL} -ge 0 && ${C2H_ROTATE_LVL} -le 9 ]]
 then
   : # OK
 else
   ERRMSG "C2H999E Invalid value '${val}' for ${var}"
   unset C2H_ROTATE_LVL
 fi

 AWCONS "AWTRACE: CFG_VAL 999"
}

######################################################################
# validate_c2hinf: check C2H_INF vars for valid values
######################################################################
validate_c2hinf ()
{
 AWCONS "AWTRACE: INF_VAL 000"

# ToDo 281-000 ...

# C2H_LASTRUN
# -----------
 var="C2H_LASTRUN"
 val=${C2H_LASTRUN}

 AWCONS "AWTRACE: INF_VAL 999"
}

######################################################################
# show_cfg: show c2h_ vars
######################################################################
ShowC2H ()
{
 AWCONS "AWTRACE: SHOW_C2H 000"
 AWCONS "ShowC2H: ${1}"

# ToDo 281-000 ...

 env | grep "AWDEBUG"
 env | grep "C2H_"

 AWCONS "AWTRACE: SHOW_C2H 999"
}

######################################################################
# Display_cfg: show config vars
######################################################################
DisplayCFG ()
{
 AWCONS "AWTRACE: SHOW_CFG 000"
 AWCONS "ShowC2H: ${1}"

# ToDo 281-000 ...

 AWCONS "XCFG_CSM    : ${XCFG_CSM}"
 AWCONS "XCFG_LSLPP  : ${XCFG_LSLPP}"
 AWCONS "XCFG_TSM    : ${XCFG_TSM}"
 AWCONS ""
 AWCONS "CFG_AW      : ${CFG_AW}"
 AWCONS ""
 AWCONS "COL_SYSTEM  : ${COL_SYSTEM}"   # col-01*S*
 AWCONS "COL_KERNEL  : ${COL_KERNEL}"   # col-02*K*
 AWCONS "COL_HMC     : ${COL_HMC}"      # col-03*H*
 AWCONS "COL_FILESYS : ${COL_FILESYS}"  # col-04*F*
 AWCONS "COL_DEVICES : ${COL_DEVICES}"  # col-05*D*
 AWCONS "COL_LVM     : ${COL_LVM}"      # col-06*L*
 AWCONS "COL_USERS   : ${COL_USERS}"    # col-07*U*
 AWCONS "COL_NETWORK : ${COL_NETWORK}"  # col-08*N*
 AWCONS "COL_PPPPPP  : ${COL_PPPPPP}"   # col-09*P*
 AWCONS "COL_CRON    : ${COL_CRON}"     # col-10*C*
#AWCONS "COL_?       : ${COL_?   }"     # col-11*?*
 AWCONS "COL_SOFTWARE: ${COL_SOFTWARE}" # col-12*s*
 AWCONS "COL_FILES   : ${COL_FILES}"    # col-13*f*
 AWCONS "COL_NIM     : ${COL_NIM}"      # col-14*n*
 AWCONS "COL_LUM     : ${COL_LUM}"      # col-15*l*
 AWCONS "COL_APPL    : ${COL_APPL}"     # col-16*a*
 AWCONS "COL_EXP     : ${COL_EXP}"      # col-17*E*
 AWCONS "COL_JAVA    : ${COL_JAVA}"     # col-18*J*
 AWCONS "COL_COMPILER: ${COL_COMPILER}" # col-19*R*
 AWCONS "COL_VIO     : ${COL_VIO}"      # col-20*V*
 AWCONS "COL_SVC     : ${COL_SVC}"      # col-21*?*
 AWCONS "COL_GPFS    : ${COL_GPFS}"     # col-22*G*
 AWCONS "COL_TSM     : ${COL_TSM}"      # col-23*T*
 AWCONS "CFG_TEST    : ${CFG_TEST}"     # col-..*?*

#AWCONS "FUNC_PUSH  : ${FUNC_PUSH}"   # func-01

 AWCONS "AWTRACE: SHOW_CFG 999"
}

######################################################################
# getProcessorInfo: called AFTER basic requirements
######################################################################
get_ProcessorInfo ()
{
# removed in 2.80: Get_CPU_Type  # >AW006<

#----------------------------------------------------------
# IPADRES=$(cut -d"#" -f1 /etc/hosts | awk '{for (i=2; i<=NF; i++) if ("'$HOSTNAME'" == $i) {print $1; exit}}') # n.u.
#----------------------------------------------------------
#----------------------------------------------------------
# CPU=$(lscfg | grep Architecture | cut -d: -f2)     # n.u.
#----------------------------------------------------------

# set PROC_Type e.g. PowerPC_POWER6
# some commands may be available only on specific hardware
# e.g. smt (Simultaneous Multi-Threading) with AIX 5.3 on POWER5
# ToDo 283-000 check only first proc (all procs are the same !)
# ToDo 283-000 Machine has n-proc / LPAR has n-proc
 procs=$(lscfg | grep proc | awk '{print $2}')
 for proc in $(echo $procs)
 do
   proctype=$(lsattr -El $proc | grep type | awk '{print $2}')
 done
 AWTRACE ": PROC_Type="$proctype
 POWER5="NO"
 if [[ $proctype = "PowerPC_POWER5" ]] ; then
   POWER5="YES"
 fi
 AWTRACE ": POWER5="$POWER5

# >AW037< Power6 toleration
 POWER6="NO"
 if [[ $proctype = "PowerPC_POWER6" ]] ; then
   POWER5="YES" # Power6 has same functionality than Power5
   POWER6="YES"
 fi
 AWTRACE ": POWER6="$POWER6

# >AW122< Power7 toleration
 POWER7="NO"
 if [[ $proctype = "PowerPC_POWER7" ]] ; then
   POWER5="YES" # Power7 has same functionality than Power5
   POWER6="YES" # Power7 has same functionality than Power6
   POWER7="YES"
 fi
 AWTRACE ": POWER7="$POWER7

# NOTE prtconf without options runs about 5 sec

# ToDo 280-000 Wait4BG "PRTCONF" PID
#
#+ AWCONST "waiting for BG process: geninv"
#+Wait4BG $PID_gi "BG001" "geninv" # %BG001 wait for specific process
#+BGRC_gi=$?

# set SysModel:
# e.g. IBM,7038-6M2 (p650)
# e.g. IBM,9111-520 (Power5-p520)
# e.g. IBM,9117-570 (Power5-p570)
# if rc=0 then use file else try command
 if [[ -f $DSN_prtconf ]]
 then
  AWCONST "\nC2H000I File DSN_prtconf available"
  SysModel=$(grep "System Model" ${DSN_prtconf} | awk '{print $3}')
 else
  AWCONST "\nC2H000I File DSN_prtconf NOT available. RC=${BGRC_pc}"
  SysModel=$(prtconf 2>/dev/null | grep "System Model" | awk '{print $3}')
 fi
 AWTRACE ": SysModel="$SysModel

# set PROC_Type
# e.g. PowerPC_POWER5
# e.g. PowerPC_POWER6
 if [[ -f $DSN_prtconf ]]
 then
  AWCONST "\nC2H000I File DSN_prtconf available"
  proctype2=$(grep "Processor Type" ${DSN_prtconf} | awk '{print $3}')
 else
  AWCONST "\nC2H000I File DSN_prtconf NOT available"
  proctype2=$(prtconf 2>/dev/null | grep "Processor Type" | awk '{print $3}')
 fi
 AWTRACE ": PROC_Type2="$proctype2

# set CPU_Type e.g. 64-bit
 CPU_TYPE=$(prtconf -c | grep "CPU Type" | awk '{print $3}')
 AWTRACE ": CPU_Type="$CPU_TYPE

# set KERNEL_Type e.g. 64-bit
 KERNEL_TYPE=$(prtconf -k | grep "Kernel Type" | awk '{print $3}')
 AWTRACE ": KERNEL_Type="$KERNEL_TYPE

 BIT64="NO"
 if [[ $KERNEL_TYPE = "64-bit" ]] ; then
   BIT64="YES"
 fi
 AWTRACE ": 64BIT="$BIT64

 if [[ "$KERNEL_TYPE" = "$CPU_TYPE" ]]
 then
   :
   #ERRMSG "\nC2H050 I OK ! You are running a ${KERNEL_TYPE}-Kernel on a ${CPU_TYPE}-CPU !"
 else
   ERRMSG "\nC2H051W Warning ! You are running a ${KERNEL_TYPE}-Kernel on a ${CPU_TYPE}-CPU !"
 fi

}

######################################################################
# check_CSM_Fix: ...
######################################################################
check_CSM_Fix ()
{
 # use same code as for JAVA
 check_JAVA_Fix
}

######################################################################
# check_RSCT_Fix: ...
######################################################################
check_RSCT_Fix ()
{
 # use same code as for JAVA
 check_JAVA_Fix
}

######################################################################
# xexit: extended exit (e.g. run cleanup)
######################################################################
xexit ()  # >AW018<
{
 set +x # stop ksh debugging
 if [ -z "$1" ] ; then      # if string 1 is zero/empty (no rc given)
   #ERRMSG "C2H951I no rc at call to xexit. Set to ZERO."
   xrc=0
 else
   xrc=$1
 fi

# write HTML_OUTFILE_TEMP to HTML_OUTFILE !!
 close_html

 cleanup

 DATEFULL=$(date "+%Y-%m-%d - %H:%M:%S")     # ISO8601 compliant date and time string
 echo "Finished ${VERSION} at ${DATEFULL}. RC=${xrc}";
 exit $xrc
}

######################################################################
# cleanup_at_start: remove tmp files from previous runs
######################################################################
cleanup_at_start ()
{
# ToDo 280-001 !!! Cleanup_at_start !!!

 if [[ ${DEBUG_010} = 1 ]] # if DEBUG 010 DBG cleanup
 then
  echo "================"
  echo "PROCID=$PROCID $$"
  echo "List files in ${TMPDIR}:"
  ls ${TMPDIR}/* | grep -v $PROCID >${TMPDIR}/ls.out 2>&1
  ERRMSG ls -la ${TMPDIR}/*
  echo "================"
  ERRMSG ${TMPDIR}/ls.out
  echo "================"
  echo "Show content of ls.out:"
  cat ${TMPDIR}/ls.out
  echo "================"
 fi # fi DEBUG 010 DBG cleanup

 ls ${TMPDIR}/* | grep -v $$ | grep -v $lockfile | awk '{print $1}' | while read DELFILE
 do
  rm $DELFILE 2>/dev/null
 done

 if [[ ${DEBUG_010} = 1 ]] # if DEBUG 010 DBG cleanup
 then
   echo "================"
   ERRMSG ls -la ${TMPDIR}/*
   echo "================"
 fi # fi DEBUG 010 DBG cleanup

# clean files of BG JObs %BG000
 rm -f ${TMPDIR}/c2h_lsattr-*  2>/dev/null
 rm -f ${TMPDIR}/c2h_geninv_*  2>/dev/null
 rm -f ${TMPDIR}/c2h_prtconf-* 2>/dev/null
 rm -f ${TMPDIR}/c2h_prtconf_* 2>/dev/null
 rm -f ${TMPDIR}/c2h_oxlevel-* 2>/dev/null
 rm -f ${TMPDIR}/c2h_oslevel*  2>/dev/null
 rm -f ${TMPDIR}/c2h_xlc*      2>/dev/null
 rm -f ${TMPDIR}/c2h_arp*      2>/dev/null
 rm -f ${TMPDIR}/c2h_lppchk*   2>/dev/null

 rm -f ${TMPDIR}/ls.out 2>/dev/null
}

######################################################################
# cleanup_at_end: remove tmp files from previous runs
######################################################################
cleanup_at_end ()
{
# ToDo 280-001 !!! Cleanup_at_end !!!

# ToDo 280-001 Cleanup files !!
# list temp files for this process
#-1 echo "================"
#-1 ls -la ${TMPDIR}/*$$ >${TMPDIR}/ls.out 2>&1
#-1 ERRMSG ls -la ${TMPDIR}/*$$
#-1 echo "================"
#-1 ERRMSG ${TMPDIR}/ls.out
#-1 echo "================"
#-1 echo "Show content of ls.out:"
#-1 cat ${TMPDIR}/ls.out
#-1 echo "================"

 if [[ $AWDEBUG == 1 ]]
 then
  : # DO NOT CLEAN if in DEBUG MODE ! files could be found in TEMPDIR for further checking !
 else
  # clean files of BG JObs %BG000
  rm -f ${TMPDIR}/c2h_lsattr-*  2>/dev/null
  rm -f ${TMPDIR}/c2h_geninv_*  2>/dev/null
  rm -f ${TMPDIR}/c2h_prtconf-* 2>/dev/null
  rm -f ${TMPDIR}/c2h_prtconf_* 2>/dev/null
  rm -f ${TMPDIR}/c2h_oxlevel-* 2>/dev/null
  rm -f ${TMPDIR}/c2h_oslevel*  2>/dev/null
  rm -f ${TMPDIR}/c2h_xlc*      2>/dev/null
  rm -f ${TMPDIR}/c2h_arp*      2>/dev/null
  rm -f ${TMPDIR}/c2h_lppchk*   2>/dev/null
 fi

 rm -f ${TMPDIR}/ls.out 2>/dev/null
}

######################################################################
# cleanup: remove some files
######################################################################
cleanup ()
{
 set +x # stop ksh debugging
 CLEAN=CLEAN+1
 echo ${SEP120} >> $ERROR_LOG
 ERRMSG "C2H950I now performing cleanup...(${CLEAN})"

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# ToDo 280-001 if in DEBUG mode do not cleanup files created in this run
# ToDo 280-001 do cleanup at startup ! clean files of previous run !
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 if [[ $AWDEBUG == 1 ]]; then
  :
 fi

# list process
 if [[ ${DEBUG_100} = 1 ]] # if DEBUG 100 DBG BG-Jobs
 then
   AWCONST "PROCID=${PROCID}"
   echo "======"
   ERRMSG2 ps -ef | grep $PROCID | grep -v grep
   ps -ef | grep $PROCID | grep -v grep | grep -v "ps -ef"
   echo "======"
 fi # fi DEBUG 100 DBG BG-Jobs

# +++jobs+++

#::::::::::::::::::::::::::::::::::::::::::::::::
#- ERRMSG "xxx jobs -l (9)"
#- jobs -l >xxjobs_l9.out
#- jobs_rc=$?
#- ERRMSG "xxx jobs -l (9) RC=$jobs_rc"
#::::::::::::::::::::::::::::::::::::::::::::::::

# be sure all our background jobs are finished !
 AWCONST "Final wait for BG processes"
 date >> $ERROR_LOG
 PID_ALL=""
 Wait4BG $PID_ALL "BG999" "ALL" # %BG999 wait for ALL process
 BGRC_all=$?
 date >> $ERROR_LOG

 if [[ ${DEBUG_100} = 1 ]] # if DEBUG 100 DBG BG-Jobs
 then
   ShowBGrc
 fi # fi DEBUG 100 DBG BG-Jobs

 cleanup_at_end

# remove dump
 rm -f core 2>/dev/null  # >AW004<

 # remove the error.log if it has size zero
 [ ! -s "$ERROR_LOG" ] && rm -f $ERROR_LOG 2> /dev/null

 C2H_END_HMS=$(date "+%H:%M:%S")  # >AW078<
 if [[ ${DEBUG_999} > 0 ]] # SCRIPT
 then
   TimeDiff ${C2H_START_HMS} ${C2H_END_HMS} "CONS" "RUNT" "SCRIPT" # >AW078<
 fi
}

######################################################################
# TimeDiff: calc diff of 2 times # >AW078<
######################################################################
TimeDiff ()
{
# 1=start=end 3=out 4=typ 5=txt1 6=txt2
#
# DEBUG_999=0 will NOT call this function
# DEBUG_999=1 will call this function for SCRIPT Timeing
# DEBUG_999=2 will call this function for COLLECTOR Timeing
# DEBUG_999=3 will call this function for BG-Job Timeing
# DEBUG_999=4 will call this function for CMD Timeing
# DEBUG_999=1 ONLY shows message if runtime is greater than X

 set +x # stop ksh debugging

 integer seconds
 integer hh1 mm1 ss1 time1
 integer hh2 mm2 ss2 time2

# convert time to seconds

 echo "${1}" | IFS=":" read hh1 mm1 ss1
 echo "${2}" | IFS=":" read hh2 mm2 ss2

 (( time1 = hh1*3600 + mm1*60 + ss1 ))
 (( time2 = hh2*3600 + mm2*60 + ss2 ))

# get diff in seconds
 (( seconds = time1 - time2 ))
 (( seconds < 0 )) && (( seconds = -seconds ))

# parm3 tells us where the output goes to
 diffout="${3:-CONS}" # if not set, use CONS

# parm4 tells us which type of message to show
 difftyp="${4:-DIFF}" # if not set, use DIFF

# parm5 is for additional text1
 difftxt1="${5:-unset}" # if not set, use "unset"

# parm6 is for additional text2
 difftxt2="${6:-unset}" # if not set, use "unset"

 if [[ ${difftyp} = "SCRIPT" ]]
 then
   DEBUG_999=1
 fi

 if [[ ${DEBUG_999} > 1 ]] # out
 then
  if [[ ${difftyp} = "DIFF" ]]
  then
    txt="C2H090I Duration in seconds: ${seconds} (${difftxt1} ${difftxt2})"
    if [[ ${diffout} = "CONS" ]]
    then
      ERRMSG ${txt}
    else
      ERRLOG ${txt}
    fi
  fi
 fi

 cmd_max_duration=7
 if [[ ${difftxt1} = "CMD" && ${seconds} > ${cmd_max_duration} ]]
 then
   txt1="C2H090I CMD '${difftxt2}' runs longer than ${cmd_max_duration} seconds ! Duration was ${seconds}"
   txt2="C2H090I Please report this to developement."
   ERRLOG ${txt1}
   ERRLOG ${txt2}
 fi

# convert diff to hh:mm:ss
 (( hh1 = seconds / 3600 ))
 (( mm1 = seconds / 60 % 60 ))
 (( ss1 = seconds % 60 ))

 RT=$(printf "C2H091I Runtime %02d:%02d:%02d (${difftxt1})\n" $hh1 $mm1 $ss1)

 if [[ ${DEBUG_999} > 1 ]] # out
 then
  if [[ ${difftyp} = "RUNT" ]]
  then
    if [[ ${diffout} = "CONS" ]]
    then
      ERRMSG ${RT}
    else
      ERRLOG ${RT}
    fi
  fi
 fi

# ToDo 286-000 write to .xxx file to be displayed at next run
}

######################################################################
# line: ...
######################################################################
line ()
{
# ToDo 280-004 tput not available in dtterm and xterm
#- AWTRACE "AW000I TERM=${TERM}"
  echo "--=[ "$(tput smso)"http://cfg2html.sourceforge.net"$(tput sgr0)" ]=------------------------------------------------"
}

######################################################################
# txtline: ...
######################################################################
txtline ()
{
  echo "--=[ http://cfg2html.sourceforge.net ]=------------------------------------------------"
}

######################################################################
# DBG: write DEBUG information to error log
######################################################################
DBG ()
{
 DEBUG="${DEBUG:-0}"
 if [[ $DEBUG == 1 ]]; then
   DATEFULL=$(date "+%Y-%m-%d - %H:%M:%S")     # ISO8601 compliant date and time string
   # tee -a will "add" the output to a file
   dbgline="${DATEFULL} $*"
  #echo $dbgline | tee -a $ERROR_LOG
   echo $dbgline >> $ERROR_LOG
 fi
}

######################################################################
# AWCONS: write line to console
######################################################################
AWCONS ()
{
 # ToDo 280-000 same handling for \n as in ERRMSG
 AWDEBUG="${AWDEBUG:-0}"
 if [[ $AWDEBUG == 1 ]]; then
  echo "$*"
 fi
}

######################################################################
# AWCONST: write line to console (WITH TIMESTAMP)
######################################################################
AWCONST ()
{
# if left($1) = "\n"
# then: cut off from text and put in front of DATE
 AWDEBUG="${AWDEBUG:-0}"
 if [[ $AWDEBUG == 1 ]]; then
  outstring=$*
  _crlf=""
  len=${#outstring}  # LENGTH
  typeset -L2 crlf=${outstring}
  DATEFULL=$(date "+%Y-%m-%d - %H:%M:%S")     # ISO8601 compliant date and time string
  if [[ ${crlf} = "\n"  ]]
  then
    crlf_status="FOUND"
    #echo "AW-CRLF found (1) L=${len}"
    #if [[ ${len} -ge 36 ]]
    #then
    #  echo "AWCONST INTERNAL ERROR L=${len} !! MAX=99 reached ! (ID=001)"
    #fi
    #new_text=$(echo ${outstring} | cut -c 3-99)
    typeset -i RX=${len}-2
    typeset -R${RX} nx=${outstring}
    new_text=${nx}
    new_outstring="\n${DATEFULL} ${new_text}"
  else
    crlf_status="NOT_FOUND"
    if [[ ${cons_continue} = "ON" ]]
    then
      # add CRLF ! to get a new_line
      _crlf="\n"
      cons_continue="OFF" # OFF - during debugging
    else
      _crlf=""
    fi # cons_continue
    new_outstring="${_crlf}${DATEFULL} ${outstring}"
  fi # crlf=\n

  echo "${new_outstring}"
 fi # AWDEBUG == 1
}

######################################################################
# AWTRACE: write line to error log
######################################################################
AWTRACE ()
{
# if left($1) = "\n"
# then: cut off from text and put in front of DATE

 AWDEBUG="${AWDEBUG:-0}"
 TRACE_TIME="${TRACE_TIME:-0}"
 TRACE_DSN="${AWTRACE_DSN:-$ERROR_LOG}"  # use AWTRACE_DSN if set, else use ERROR_LOG
 if [[ $AWDEBUG == 1 ]]; then
  outstring=$*
  len=${#outstring}  # LENGTH
  typeset -L2 crlf=${outstring}
  if [[ ${crlf} = "\n"  ]]
  then
    crlf_status="FOUND"
    #echo "AW-CRLF found (2) L=${len}"
    #if [[ ${len} -ge 39 ]]
    #then
    #  echo "AWCONST INTERNAL ERROR L=${len} !! MAX=99 reached ! (ID=002)"
    #fi
    #new_text=$(echo ${outstring} | cut -c 3-99)
    typeset -i RX=${len}-2
    typeset -R${RX} nx=${outstring}
    new_text=${nx}
    if [[ $TRACE_TIME == 1 ]]; then
      DATEFULL=$(date "+%Y-%m-%d - %H:%M:%S")     # ISO8601 compliant date and time string
      new_outstring="\n${DATEFULL} ${new_text}"
    else
      new_outstring="${outstring}"
    fi # TRACE_TIME
    cons_continue="OFF" # OFF - during debugging
  else
    crlf_status="NOT_FOUND"
    new_outstring="${outstring}"
  fi # "\n"

  echo "${new_outstring}" >> $TRACE_DSN
 fi # AWDEBUG == 1
}

######################################################################
# ERRMSG: write line to error log AND console
######################################################################
ERRMSG ()
{
  outstring=$*
  len=${#outstring}  # LENGTH
  typeset -L2 crlf=${outstring}
  if [[ ${crlf} = "\n"  ]]
  then
    crlf_status="FOUND"
    #echo "AW-CRLF found (2) L=${len}"
  else
    crlf_status="NOT_FOUND"
  fi # crlf=\n

  if [[ ${cons_continue} = "ON" ]]
  then
    cons_continue="OFF" # OFF - during debugging
    # add CRLF if not already present
    if [[ ${crlf_status} = "FOUND"  ]]
    then
      new_outstring="${outstring}"
    else
      new_outstring="\n${outstring}"
    fi # crlf_status
  else
    new_outstring="${outstring}"
  fi # cons_continue

  echo "${new_outstring}"
  echo "${new_outstring}" >> $ERROR_LOG
}

######################################################################
# ERRMSG2: write line to error log AND console (with AWTRACE)
######################################################################
ERRMSG2 ()
{
  AWTRACE "0=$0 1=$1 2=$2 3=$3 4=$4 5=$5"
  echo "$*"
  echo "$*" >> $ERROR_LOG
}

######################################################################
# ERRLOG: write line to error log
######################################################################
ERRLOG ()
{
  echo "$*" >> $ERROR_LOG
}

######################################################################
# verbose_out: display text if verbose is on
######################################################################
verbose_out ()
{
 # ToDo 281-000 TEST same handling for \n as in ERRMSG
 VERBOSE="${VERBOSE:-0}"
 if [[ VERBOSE == 1 ]] ; then
  outstring=$*
  len=${#outstring}  # LENGTH
  typeset -L2 crlf=${outstring}
  if [[ ${crlf} = "\n"  ]]
  then
    crlf_status="FOUND"
    #echo "AW-CRLF found (2) L=${len}"
  else
    crlf_status="NOT_FOUND"
  fi # crlf=\n

  if [[ ${cons_continue} = "ON" ]]
  then
    cons_continue="OFF" # OFF - during debugging
    # add CRLF if not already present
    if [[ ${crlf_status} = "FOUND"  ]]
    then
      new_outstring="${outstring}"
    else
      new_outstring="\n${outstring}"
    fi # crlf_status
  else
    new_outstring="${outstring}"
  fi # cons_continue

  echo "${new_outstring}"
 fi
}

######################################################################
# infofile_header: header for info files
######################################################################
infofile_header ()
{
  AWDEBUG_SAVE=${AWDEBUG} # save AWDEBUG
  AWDEBUG=1 # need to see complete *.info file

  AWTRACE "c2h: $1 Info for node ${NODE}"
  date >>${AWTRACE_DSN}
  AWTRACE "Collector: ${collector_name}"
  AWTRACE "***************"
  AWTRACE "AIX ${OSLEVEL}"
  cat ${DSN_oslevel_s} >>${AWTRACE_DSN}
  AWTRACE "***************"
  AWTRACE " "

  AWDEBUG=${AWDEBUG_SAVE} # restore AWDEBUG
}

#*********************************************************************
# start of HTML file with heading and title
#
# Note: there is only ONE HTML and TXT file after the script has
#       finished. This file contains an index and all command output,
#       so this file might be quite large.
#       While this script is running we are writing the index
#       (directory)" entries directly to the main output file.
#       Command output is written to a temp file, which will then
#       be copied to the end of the main output file when the script
#       finishes.
#*********************************************************************

######################################################################
# open_html: create the HTML file...
######################################################################
open_html ()
{
# >AW015< show correct oslevel in "GENERATOR"
# >AW015< show correct version in "DESCRIPTION"
# >AW026< add (internal) css style (as in LINUX 1.20)

# >AW016< moved <META http-equiv=expires... here, so it is only found once in the html file
  HTML_STATUS="OPEN"

   echo " \
<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2 Final //EN\">
<HTML> <HEAD>
 <META NAME="GENERATOR" CONTENT=\"Selfmade-$RCCS-vi AIX ${OSLEVEL_R}\">
 <META NAME="AUTHOR" CONTENT=\"Andreas.Wizemann@FVVaG.de,Gert.Leerdam@getronics.com\">
 <META NAME="CREATED" CONTENT="\"Andreas Wizemann, Gert Leerdam\"">
 <META NAME="CHANGED" CONTENT=\"${USER} \">
 <META NAME="DESCRIPTION" CONTENT=\"$Header: ${VERSION} $DATE root Exp $\">
 <META NAME="ROBOTS" CONTENT="noindex">
 <META NAME="subject" CONTENT=\"$VERSION on $NODE by Andreas.Wizemann@FVVaG.de, Gert.Leerdam@getronics.com\">
 <META http-equiv=\"expires\" content=\"${EXPIRE_CACHE}\">


<style type=\"text/css\">
<!--
/* (c) 2001-2014 by ROSE SWE, Ralph Roth - http://rose.rult.at/
 * CSS for cfg2html.sh, 12.04.2001, initial creation
 */
-->
Pre             {Font-Family: Courier-New, Courier;Font-Size: 10pt}
BODY            {FONT-FAMILY: Arial, Verdana, Helvetica, Sans-serif; FONT-SIZE: 12pt;}
A               {FONT-FAMILY: Arial, Verdana, Helvetica, Sans-serif}
A:link          {text-decoration: none}
A:visited       {text-decoration: none}
A:hover         {text-decoration: underline}
A:active        {color: red; text-decoration: none}

H1              {FONT-FAMILY: Arial, Verdana, Helvetica, Sans-serif;FONT-SIZE: 20pt}
H2              {FONT-FAMILY: Arial, Verdana, Helvetica, Sans-serif;FONT-SIZE: 14pt}
H3              {FONT-FAMILY: Arial, Verdana, Helvetica, Sans-serif;FONT-SIZE: 12pt}
DIV, P, OL, UL, SPAN, TD
                {FONT-FAMILY: Arial, Verdana, Helvetica, Sans-serif;FONT-SIZE: 11pt}

</style>

<TITLE>${NODE} - Documentation - $VERSION</TITLE>
</HEAD>
<BODY LINK=\"#0000ff\" VLINK=\"#800080\" BACKGROUND="cfg2html_back.jpg">
<HR><H1><CENTER><FONT COLOR=blue>
<P><B>$NODE - AIX "${OSLEVEL_R}" - System Documentation</B></P></FONT></CENTER></H1>
<hr><FONT COLOR=blue><small>Created: - "$DATEFULL" - with: " $VERSION "</small></font>
<HR><H1>Contents\n</H1>\n\
" >$HTML_OUTFILE

# add to TEXT file
 AddText "Used command line was=$C2H_CMDLINE"  # >AW021<
# at least now, the TEXT file is open
 TEXT_STATUS="OPEN"

 copyright="(c) 2005-2014 by Andreas Wizemann, 2000-2002 by Gert Leerdam, SysSupp;"
 echo "\n\nCreated "$DATEFULL" with " $VERSION" "$copyright" \n" >> $TEXT_OUTFILE

 (txtline;echo $VERSION;banner $NODE;txtline) > $TEXT_OUTFILE
# ToDo 280-000 write c2h_sysinfo to textfile
# ToDo 280-000 show timestamp of c2h_sysinfo
  if [ ! -f $SYSINF ]
  then
    AWCONS "C2H030I sysinfo file '${SYSINF}' not found.(banner)"
  fi
 echo "\n" >> $TEXT_OUTFILE
 echo "\n" >  $TEXT_OUTFILE_TEMP

}

######################################################################
# inc_heading_level: increases the heading level
######################################################################
inc_heading_level ()
{
   HEADL=HEADL+1
#  echo "<UL>\n" >> $HTML_OUTFILE
   echo "<UL> <!-- ${HEADL} -->\n" >> $HTML_OUTFILE
}

######################################################################
# dec_heading_level: decreases the heading level
######################################################################
dec_heading_level ()
{
#  echo "</UL>\n" >> $HTML_OUTFILE
   echo "</UL> <!-- ${HEADL} -->\n" >> $HTML_OUTFILE
   HEADL=HEADL-1
}

######################################################################
# paragraph_start: Creates an own paragraph, $1 = heading
######################################################################
paragraph_start ()
{
  DBG ":---------------------------------------"
  DBG ": $1 >>>"

# ToDo 289-000 HTML2   writeTF # >AW309< BUG: write temp output to final file

  collector_name=$1
  collector_start=$(date "+%Y-%m-%d - %H:%M:%S")  # ISO8601 compliant date and time string
  collector_start_HMS=$(date "+%H:%M:%S")
  collector_cmd_count=0 # (increment on exec_command)

  echo "<!--${SEP80}-->" >> $HTML_OUTFILE

  if [ "$HEADL" -eq 1 ] ; then
     echo "\n<HR>\n" >> $HTML_OUTFILE_TEMP
  fi

 #echo "\n<table WIDTH="90%"><tr BGCOLOR="#CCCCCC"><td>\n" >> $HTML_OUTFILE_TEMP
  echo "<A NAME=\"$1\">" >> $HTML_OUTFILE_TEMP
  echo "<A HREF=\"#Content-$1\"><H${HEADL}> $1 </H${HEADL}></A><P>" >> $HTML_OUTFILE_TEMP
 #echo "<A HREF=\"#Content-$1\"><H${HEADL}> $1 </H${HEADL}></A></table><P>" >> $HTML_OUTFILE_TEMP

# ToDo 284-000 try using jpg instead of gif !
# ToDo 284-000 profbul => c2h_profbul

  if [ "$HEADL" -eq 1 ]
  then
     echo "<!--${SEP80}-->" >> $HTML_OUTFILE
     # >AW027< add ALT= option to IMG tag
     echo '<IMG ALT="profbull.gif" SRC="profbull.gif" WIDTH=14 HEIGHT=14>' >> $HTML_OUTFILE
  else
     echo "<LI>\c" >> $HTML_OUTFILE
  fi

  echo "<A NAME=\"Content-$1\"></A><A HREF=\"#$1\">$1</A>" >> $HTML_OUTFILE

  if [ "$HEADL" -eq 1 ]
  then
    if [[ ${paragraph_count} = 0 ]]
    then
      : for the first call...
      echo "\nCollecting: $1 .\c"
    else
      : for any other call...
      echo " done.\nCollecting: $1 .\c"
    fi
    # " done." for the LAST paragraph must be handled separately !
    paragraph_count=${paragraph_count}+1
    cons_continue="ON" # "\c" is continuation character
    if [[ VERBOSE == 1 ]] ; then
      echo " +++"
    fi
  fi

  echo "    $1" >> $TEXT_OUTFILE
  echo "${SEP80}" >> $TEXT_OUTFILE_TEMP # >AW132<
  echo "    $1"   >> $TEXT_OUTFILE_TEMP # >AW132<
  echo "${SEP80}" >> $TEXT_OUTFILE_TEMP # >AW132<
}

######################################################################
# paragraph_end: ends an own paragraph, $1 = heading
######################################################################
paragraph_end ()
{
 if [[ $1 = "*LAST*" ]]
 then
   echo " done."
   cons_continue="OFF"
 else
   DBG ": $1 <<<"
   DBG ":---------------------------------------"

   collector_name=$1
   collector_end=$(date "+%Y-%m-%d - %H:%M:%S")  # ISO8601 compliant date and time string
   collector_end_HMS=$(date "+%H:%M:%S")

  # ToDo 285-000 Internal Statistics for collector

  # AWTRACE "Collector_NAME.: ${collector_name}"
  # AWTRACE "Collector_START: ${collector_start}"
  # AWTRACE "Collector_END..: ${collector_end}"
  # AWTRACE "Collector_CMD..: ${collector_cmd_count}"

  if [[ ${DEBUG_999} > 1 ]] # COLLECTOR
  then
    TimeDiff ${collector_start_HMS} ${collector_end_HMS} "LOG" "DIFF" "COL" ${collector_name} # >AW078<
  fi
 fi
}

######################################################################
# writeTF: write temp output to final file
######################################################################
writeTF ()
{
# >AW309< BUG: write temp output to final file
# write temp output to final file, so we don't loose the whole
# information in case script fails.
  cat $HTML_OUTFILE_TEMP >> $HTML_OUTFILE
  if [ -f $TEXT_OUTFILE_TEMP ]
  then
    cat $TEXT_OUTFILE_TEMP >> $TEXT_OUTFILE
  fi
  rm -f $HTML_OUTFILE_TEMP $TEXT_OUTFILE_TEMP 2>/dev/null  # >AW004<
}

######################################################################
# AddText: adds a 'text' to the *.txt AND *.html output files.
######################################################################
AddText ()
{
  echo "<p>$*</p>" >> $HTML_OUTFILE_TEMP
  echo "$*\n"      >> $TEXT_OUTFILE_TEMP
}

######################################################################
# AddHTML: adds a text to the HTML output file.
######################################################################
AddHTML ()
{
  # &#91; [
  # &#124; |
  # &#93; ]
  echo "<p>$*</p>" >> $HTML_OUTFILE_TEMP
}

######################################################################
# close_html: end of html document
######################################################################
close_html ()
{
  echo "<hr>" >> $HTML_OUTFILE
  echo "</P><P>\n<hr><FONT COLOR=blue>Created "$DATEFULL" with " $VERSION " by
  <A HREF="mailto:Andreas.Wizemann@FVVaG.de?subject=${VERSION}_">Andreas Wizemann, SysAdm</A>&nbsp;
  <!--
  <A HREF="mailto:Gert.Leerdam@getronics.com?subject=${VERSION}_">Gert Leerdam, SysAdm</A>&nbsp;
  -->
  </P></font>" >> $HTML_OUTFILE_TEMP
# echo "</P><P>\n<FONT COLOR=blue>Based on the original script by <A HREF="mailto:cfg2html@hotmail.com?subject=${VERSION}_">Ralph Roth</A></P></font>" >> $HTML_OUTFILE_TEMP
  echo "<hr><center>\
  <A HREF="http://cfg2html.sourceforge.net">  [ download cfg2html from the sourceforge home page ] </A> and \
  <a href="http://www.cfg2html.com"> [ cfg2html main page ] </a> \
  </center></P><hr></BODY></HTML>\n" >> $HTML_OUTFILE_TEMP

#AWCONS "AWTRACE: CLO 001"
  writeTF # >AW309< BUG: write temp output to final file
#AWCONS "AWTRACE: CLO 002"
  copyright="(c) 2005-2014 by Andreas Wizemann, 2000-2002 by Gert Leerdam, SysSupp;"
  echo "\n\nCreated "$DATEFULL" with " $VERSION" "$copyright" \n" >> $TEXT_OUTFILE

  HTML_STATUS="CLOSE"
#AWCONS "AWTRACE: CLO 999"
}

######################################################################
# aw_command: run cmd and write cmd to cons and error_log
######################################################################
aw_command ()
{
   EXECRES="INIT"
   EXECRES=$(eval $1 2> $TMP_EXEC_COMMAND_ERR | expand | cut -c 1-150)

   if [ -z "$EXECRES" ] ; then
     EXECRES="n/a or not configured!"
   fi
   ERRMSG $EXECRES
   if [ -s $TMP_EXEC_COMMAND_ERR ] ; then
      echo ${SEP120} >> $ERROR_LOG
      echo "stderr output from \"$1\":" >> $ERROR_LOG
      cat $TMP_EXEC_COMMAND_ERR | sed 's/^/    /' >> $ERROR_LOG
      echo " " >> $ERROR_LOG
   fi
   rm -f $TMP_EXEC_COMMAND_ERR  2>/dev/null
}

######################################################################
# exec_command: Documents the single commands and their output
#  $1 = unix command,  $2 = parm/opt for cmd $3 = text for the heading
######################################################################
exec_command ()
{

  collector_cmd_count=$collector_cmd_count+1 # (increment on exec_command)

   if [ -z "$3" ] ; then      # if string 3 is zero
      TiTel="$1"
   else
      TiTel="$3"
   fi
#
# ToDo 289-000 Convert BLANK => UNDERSCORE and & => &amp;
#ERROR $TiTel=$(echo $TiTel | sed "s/ /_/g")
#ERROR  $TiTel=$(echo $TiTel | sed "$CONVSTR")
#
#
   if [[ VERBOSE == 1 ]] ; then
      echo "$(date '+ %b-%d %T') - $TiTel +++"
   else
      echo ".\c"
   fi

   echo "\n---=[ $2 ]=----------------------------------------------------------------" |
      cut -c1-74 >> $TEXT_OUTFILE_TEMP

   echo "       - $2" >> $TEXT_OUTFILE

   # >AW023< get info about package to install if cmd not found
   # >AW024< check for command availability using "which <cmd>" before using them
   #         to prevent unnecessary error messages
   fullcmd=$1 # <path>/<cmd> <opt>
#AWTRACE "FULL=${fullcmd}<"
   typeset -L6 cmdx # use 6 char from left
   cmd=$(echo ${fullcmd} | cut -f 1 -d " ")
   cmdx=$cmd
#AWTRACE "CMDX=${cmdx}<"
#AWTRACE "CMD=${cmd}<"
   if [[ ${cmdx} = "printf" ]]
   then
     cmd=${cmdx}
   fi
   if [[ ${external} = "ON" ]]
   then
     : # NOP
   else
   package $cmd  # set package info
   # get first char of var: cmd_only=$(echo $1 | cut -c 1-1)
   fi

   cmdrc=77 # init rc with a dummy value
   case $package in
     *INTERNAL* ) : # OK
                    cmdrc=9
                    ;;
     *EXTERNAL* ) : # OK (Reserved for future use)
                    cmdrc=8
                    ;;
     *DUMMY*    ) : # OK - DUMMY
                    cmdrc=7
                    ;;
     *          ) which ${cmd} > /dev/null 2>&1; # >AW024< >AW041<
                    cmdrc=$?
                    ;;
   esac

   runcmd="YES"
   case $cmdrc in
     0) : # OK cmd found
        # now call the "real working horse" IF cmd is available...
        ;;
     9) : # OK this is an INTERNAL cmd (function)
        ;;
     8) : # OK this is an EXTERNAL cmd (function)
        ;;
     7) : # OK this is an DUMMY    cmd (function)
        ;;
     1) runcmd="NO";
        txt="C2H040I CMD '${cmd}' not found in path.";
        verbose_out $txt;
        AWTRACE     $txt;
# ToDo 280-999 test package: if found we need to update the path, if not we need to install package
        txt="C2H041I You need to install package '${package}' to use cmd '${cmd}'";
        verbose_out $txt;
        AWTRACE     $txt;
        ;;
     *) runcmd="NO";
        verbose_out "\nC2H042E UNEXPECTED RC ${cmdrc} from 'which ${cmd}'\n";
        AWTRACE     "\nC2H042E UNEXPECTED RC ${cmdrc} from 'which ${cmd}'\n";
        ;;
   esac

#}
#
#ec2 ()
#{
if [[ "$runcmd" = "NO" ]]
then
  verbose_out "C2H043I CMD '${cmd}' NOT EXECUTED!"
  AWTRACE     "C2H043I CMD '${cmd}' NOT EXECUTED!"
else
 #AWCONS "AW E_C2 $1="$1" $2="$2
   ######========================##########
   ###### the real working horse ##########
   ######========================##########
   TMP_EXEC_COMMAND_ERR=${TMPDIR}/exec_cmd.tmp.$$

   #--- START EXECUTION OF CMD ---
   execrc=99 # init
   cmd_start=$(date "+%Y-%m-%d - %H:%M:%S")  # ISO8601 compliant date and time string
   cmd_start_HMS=$(date "+%H:%M:%S")
   # >AW303< BUG: sed will convert also for *.TXT output file, which is not necessary
   # >AW303< BUG: ToDo 281-000 check with lsrset
   AW303="YES"
   if [[ $AW303 = "YES" ]]
   then
     EXECRES=$(eval $1 2> $TMP_EXEC_COMMAND_ERR | expand | cut -c 1-150 | sed "$CONVSTR")
     execrc=$?
     converted="YES"
     # ToDo 280-000 correct for HTML / wrong for TXT (=> &lt; instead of <)
   else
     EXECRES=$(eval $1 2> $TMP_EXEC_COMMAND_ERR | expand | cut -c 1-150)
     execrc=$?
     converted="NO"
     # ToDo 280-000 correct for TXT / wrong for HTML (=> no CRLF !)
   fi
   cmd_end=$(date "+%Y-%m-%d - %H:%M:%S")  # ISO8601 compliant date and time string
   cmd_end_HMS=$(date "+%H:%M:%S")
   if [[ ${DEBUG_999} > 3 ]] # CMD
   then
     TimeDiff ${cmd_start_HMS} ${cmd_end_HMS} "LOG" "DIFF" "CMD" ${TiTel} # >AW078<
   fi

# ToDo 280-000 dumpcheck on AIXA RC=0 but NO OUTPUT which is OK result in "n/a not conf!"

   if [ -z "$EXECRES" ] ; then
     EXECRES="n/a or not configured!"
   fi
   #--- END   EXECUTION OF CMD ---

   #--- START handle error-output OF CMD ---
   # ToDo 280-002 $1 is cmd => sed...
   if [ -s $TMP_EXEC_COMMAND_ERR ] ; then
      echo ${SEP120} >> $ERROR_LOG
      echo "stderr output from \"$1\":" >> $ERROR_LOG
      cat $TMP_EXEC_COMMAND_ERR | sed 's/^/    /' >> $ERROR_LOG
      echo " " >> $ERROR_LOG
   fi
   rm -f $TMP_EXEC_COMMAND_ERR  2>/dev/null  # >AW004<
   #--- END   handle error-output OF CMD ---

   #--- START HTML heading OF CMD ---
   # write header above output
   echo "\n" >> $HTML_OUTFILE_TEMP

   # write title with or without screentips
   if [ "$C2H_STINLINE" = "YES" ]   # >AW031<
   then
     echo "<A NAME=\"$2\"></A> <H${HEADL}><A HREF=\"#Content-$2\" title=\"$TiTel\"> $2 </A></H${HEADL}>\n" >> $HTML_OUTFILE_TEMP     # orig screentips by Ralph
   else
     # or more Netscape friendly inline?
     echo "<A NAME=\"$2\"></A>            <A HREF=\"#Content-$2\"             ><H${HEADL}> $2 </H${HEADL}></A>\n" >>$HTML_OUTFILE_TEMP
   fi
   #--- END   HTML heading OF CMD ---

# ToDo 280-007 who cmd not shown !

   #--- START TEXT+HTML heading OF CMD ---
   #--------------------------------------
   # show cmd used to produce the output
   if [ "X$1" = "X$2" ]
   then    : #no need to duplicate, do nothing
   else
     excmd=$1
     # ToDo 283-000 remove more !! e.g. awk
     excmdX=$(echo ${excmd}  | sed "s/2>\&1//g")
     excmdX=$(echo ${excmdX} | sed "s/2>\/dev\/null//g")

     echo "<h6>${excmdX}</h6>" >>$HTML_OUTFILE_TEMP

   case $package in
     *INTERNAL* ) : # OK
                  ctxt1="Internal-Function:"
                  ctxt2="=================="
                  ;;
     *EXTERNAL* ) : # OK (Reserved for future use)
                  ctxt1="External-Function:"
                  ctxt2="=================="
                  ;;
     *DUMMY*    ) : # OK - DUMMY
                  ctxt1="DUMMY:"
                  ctxt2="======"
                  ;;
     *          ) : # OK - All other
                  ctxt1="Cmd: "${USER}"@"${NODE}" "
                  ctxt2="==== "
                  ;;
   esac

     echo "${ctxt1} ${excmdX}" >>$TEXT_OUTFILE_TEMP
     echo "${ctxt2}"           >>$TEXT_OUTFILE_TEMP
     echo "        "           >>$TEXT_OUTFILE_TEMP
   fi
   #--- END   TEXT+HTML heading OF CMD ---

   #--- START TEXT+HTML cmd-output ---
   #----------------------------------
   # write output to text file
   echo "$EXECRES\n" >> $TEXT_OUTFILE_TEMP

   if [[ $converted = "YES" ]]
   then
     :
   else
     # now convert special char for HTML output
     EXECRES=$(echo $EXECRES | sed "$CONVSTR")
   fi

   # display content of ($EXECRES)
   echo "<PRE><B>$EXECRES</B></PRE>\n"  >> $HTML_OUTFILE_TEMP     # write contents
   #--- END   TEXT+HTML cmd-output ---

   # >AW016< moved <META http-equiv=expires... to open_html, so it is only found once in the html file

   #--- START HTML content ---
   #--------------------------
   echo "<LI><A NAME=\"Content-$2\"></A><A HREF=\"#$2\" title=\"$TiTel\">$2</A>\n" >> $HTML_OUTFILE     # writes header of index
   #--- END   HTML content ---
fi
}

#*********************************************************************
#  end of HTML file with heading and title
#*********************************************************************

######################################################################
# KillOnHang: Schedule a job for killing commands
######################################################################
#*********************************************************************
# Schedule a job for killing commands
# may hang under special conditions. <mortene@sim.no>
# Argument 1: regular expression to search processlist for. Be careful
# when specifying this so you don't kill any more processes than
# those you are looking for!
# Argument 2: number of minutes to wait for process to complete.
#*********************************************************************
KillOnHang ()
{
   TMP_KILL_OUTPUT=${TMPDIR}/kill_hang.tmp.$$
   at now + $2 minutes 1>$TMP_KILL_OUTPUT 2>&1 <<EOF
   ps -ef | grep root | grep -v grep | egrep $1 | awk '{print \$2}' | sort -n -r | xargs kill
EOF
   AT_JOB_NR=$(egrep '^job' $TMP_KILL_OUTPUT | awk '{print \$2}')
   rm -f $TMP_KILL_OUTPUT 2>/dev/null  # >AW004<
}

######################################################################
# CancelOnHang: ...
######################################################################
#*********************************************************************
# You should always match a KillOnHang() call with a matching call
# to this function immediately after the command which could hang
# has properly finished.
#*********************************************************************
CancelKillOnHang ()
{
  at -r $AT_JOB_NR
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# General-Functions
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

######################################################################
# package: get package name for command
######################################################################
package ()
{

# ToDo 282-000 multiple cmds separated by semicolon
 echo ${*} | IFS=";" read cmd1 cmd2 cmd3
 if [[ ${cmd2} = "" ]]
 then
   :
 else
   AWTRACE "C2H902I A: CMD1=${cmd1}< CMD2=${CMD2}< CMD3=${CMD3}<"
 fi
 if [[ ${2} = "" ]]
 then
   :
 else
   AWTRACE "C2H902I B: CMD1=${1}< CMD2=${2}< CMD3=${3}<"
 fi

# exec_command "cmd parm text"
 package="*UNKNOWN*"
 desc="*?*"
 cmdpath_cmd=$1
 cmdpath=$(dirname ${cmdpath_cmd})
 cmd_only=$(basename ${cmdpath_cmd})

# ToDo 285-000 do only once per cmd. Store info in array
# ToDo 285-000 check if cmd found in list, then use values from array
# ToDo 285-000 and set usage_counter

 case $cmd_only in
  "(("            ) package="*DUMMY*"                    ; desc="*DUMMY*"       ;; # DUMMY - DO NOT DELETE
  "[["            ) package="*DUMMY*"                    ; desc="*DUMMY*"       ;; # DUMMY - DO NOT DELETE
  "aioo"          ) package="bos.rte.aio"                ; desc="?"             ;; # 280 ...
  "arp"           ) package="bos.net.tcp.client"         ; desc="?"             ;; # ...
  "at"            ) package="bos.rte.cron"               ; desc="*at*"          ;; # Base OS
  "audit"         ) package="bos.rte.security"           ; desc="?"             ;; # 281
  "bindprocessor" ) package="bos.rte.misc_cmds"          ; desc="?"             ;; # >AW039< ...
  "bootinfo"      ) package="bos.rte.boot"               ; desc="?"             ;; # ...
  "bootlist"      ) package="bos.rte.boot"               ; desc="?"             ;; # ...
  "bosdebug"      ) package="bos.rte.boot"               ; desc="?"             ;; # 281
  "cat"           ) package="bos.rte.commands"           ; desc="?"             ;; # ...
  "chcod"         ) package="bos.rte.methods"            ; desc="?"             ;; # ...
  "cpupstat"      ) package="bos.rte.commands"           ; desc="?"             ;; # AIX 5.3
  "crontab"       ) package="bos.rte.cron"               ; desc="?"             ;; # 281
  "datapath"      ) package="*sdd"                       ; desc="IBM SDD"       ;; # ... SDD
  "db2ls"         ) package="*EXTERNAL*"                 ; desc="TSM"           ;; # TSM 6.x
  "df"            ) package="bos.rte.filesystems"        ; desc="?"             ;; # ...
  "dlmchkdev"     ) package="*HDS/Hitachi*"              ; desc="HDS/Hitachi"   ;; # HDS/Hitachi
  "dlmodmset"     ) package="*HDS/Hitachi*"              ; desc="HDS/Hitachi"   ;; # HDS/Hitachi
  "dlnkmgr"       ) package="*HDS/Hitachi*"              ; desc="HDS/Hitachi"   ;; # HDS/Hitachi
  "domainname"    ) package="bos.net.nis.client"         ; desc="?"             ;; # ... NIS
  "du"            ) package="bos.rte.commands"           ; desc="?"             ;; # ...
  "dumpcheck"     ) package="bos.sysmgt.serv_aid"        ; desc="?"             ;; # ...
  "echo"          ) package="bos.rte.shell"              ; desc="?"             ;; # ...
  "egrep"         ) package="bos.rte.commands"           ; desc="?"             ;; # ...
  "emgr"          ) package="bos.rte.install"            ; desc="?"             ;; # ...
  "env"           ) package="bos.rte.shell"              ; desc="?"             ;; # 281
  "exportfs"      ) package="bos.net.nfs.client"         ; desc="?"             ;; # ...
  "fcstat"        ) package="devices.common.IBM.fc.rte"  ; desc="?"             ;; # 281
  "find"          ) package="bos.rte.commands"           ; desc="?"             ;; # ...
  "finger"        ) package="bos.net.tcp.client"         ; desc="?"             ;; # ...
  "fget_config"   ) package="devices.fcp.disk.array.rte" ; desc="FAStT"         ;; # ... FAStT
  "gcc"           ) package="freeware.gcc.rte"           ; desc="gcc"           ;; # gcc
#  "gcc"           ) package="freeware.gnu.gcc.rte"      ; desc="gcc 2.95        ;; # gcc 2.95
#  "gcc"           ) package="*rpm gcc"                   ; desc="gcc compiler"  ;; # gcc compiler
  "geninv"        ) package="bos.rte.install"            ; desc="?"             ;; # ...
  "genkex"        ) package="bos.perf.tools"             ; desc="?"             ;; # ...
  "grep"          ) package="bos.rte.commands"           ; desc="?"             ;; # ...
  "grpck"         ) package="bos.rte.seurity"            ; desc="?"             ;; # ...
  "hostname"      ) package="bos.rte.net"                ; desc="?"             ;; # ...
#  "i4blt"         ) package="bos.?"                      ; desc="?"             ;; # ...
  "ifconfig"      ) package="bos.net.tcp.client"         ; desc="?"             ;; # ...
  "instfix"       ) package="bos.rte.install"            ; desc="?"             ;; # ...
  "inulag"        ) package="bos.rte.install"            ; desc="?"             ;; # ...
  "ioo"           ) package="bos.perf.tune"              ; desc="?"             ;; # ...
  "iostat"        ) package="bos.acct"                   ; desc="?"             ;; # ...
  "ipcs"          ) package="bos.rte.control"            ; desc="?"             ;; # ...
  "java"          ) package="*java"                      ; desc="JAVA"          ;; # ... JAVA
  "last"          ) package="bos.rte.misc_cmds"          ; desc="last"          ;; # ...
  "locktrace"     ) package="bos.perf.tools"             ; desc="?"             ;; # ...
  "lparstat"      ) package="bos.acct"                   ; desc="?"             ;; # AIX 5.3
  "lppchk"        ) package="bos.rte.install"            ; desc="?"             ;; # ...
  "lpq"           ) package="bos.rte.printers"           ; desc="?"             ;; # ...
#  "lpstat"        ) package="bos.rte.printers"           ; desc="AIX Print subsystem" ;; # ...
  "ls"            ) package="bos.rte.commands"           ; desc="?"             ;; # ...
  "lsattr"        ) package="bos.rte.methods"            ; desc="?"             ;; # ...
  "lscfg"         ) package="bos.rte.diag"               ; desc="?"             ;; # ...
  "lsclass"       ) package="bos.rte.control"            ; desc="?"             ;; # 281
  "lsclient"      ) package="bos.net.nis.client"         ; desc="?"             ;; # ... NIS
  "lsconf"        ) package="bos.rte.diag"               ; desc="?"             ;; # 281
  "lsdev"         ) package="bos.rte.methods"            ; desc="?"             ;; # ...
  "lsess"         ) package="*ESSUTIL"                   ; desc="ESSUTIL"       ;; # ... ESSUTIL
  "ls2105"        ) package="*ESSUTIL"                   ; desc="ESSUTIL"       ;; # ... ESSUTIL
  "lsvp"          ) package="*ESSUTIL"                   ; desc="ESSUTIL"       ;; # ... ESSUTIL
  "lssdd"         ) package="*ESSUTIL"                   ; desc="ESSUTIL"       ;; # ... ESSUTIL
  "lsfilt"        ) package="bos.net.ipsec.rte"          ; desc="?"             ;; # 281
  "lsfs"          ) package="bos.rte.filesystems"        ; desc="File Systems"  ;; # Base OS
  "lslpp"         ) package="bos.rte.install"            ; desc="?"             ;; # ...
  "lslv"          ) package="bos.rte.lvm"                ; desc="?"             ;; # Volume Groups
  "lsmcode"       ) package="bos.diag.util"              ; desc="?"             ;; # 281
  "lsnamsv"       ) package="bos.net.tcp.smit"           ; desc="?"             ;; # ...
  "lsnfsexp"      ) package="bos.net.nfs.client"         ; desc="?"             ;; # ...
  "lsnfsmnt"      ) package="bos.net.nfs.cient"          ; desc="?"             ;; # ...
  "lsnim"         ) package="bos.sysmgt.nim.master"      ; desc="NIM"           ;; # NIM Master (NIM Server)
  "lsparent"      ) package="bos.rte.methods"            ; desc="?"             ;; # ...
  "lspath"        ) package="bos.rte.methods"            ; desc="?"             ;; # ...
  "lspcmcfg"      ) package="devices.sddpcm.71.rte"      ; desc="SDDPCM"        ;; # ...
  "lsps"          ) package="bos.rte.lvm"                ; desc="?"             ;; # ...
  "lspv"          ) package="bos.rte.lvm"                ; desc="?"             ;; # Physical Volumes
  "lsrole"        ) package="bos.rte.security"           ; desc="?"             ;; # ...
  "lsrset"        ) package="bos.rte.control"            ; desc="?"             ;; # ...
  "lsrsrc"        ) package="rsct.core.rmc"              ; desc="?"             ;; # ...
  "lssec"         ) package="bos.rte.security"           ; desc="?"             ;; # 280 ...
  "lsslot"        ) package="bos.rte.methods"            ; desc="?"             ;; # ...
  "lssrc"         ) package="bos.rte.SRC"                ; desc="?"             ;; # ...
  "lsuser"        ) package="bos.rte.security"           ; desc="?"             ;; # ...
  "lsvg"          ) package="bos.rte.lvm"                ; desc="?"             ;; # Volume Groups
# "lsvpcfg"       ) package="bos.rte.?"                  ; desc="?"             ;; # 281
  "lsvpd"         ) package="bos.rte.methods"            ; desc="?"             ;; # ...
  "lswpar"        ) package="bos.wpars"                  ; desc="WPAR"          ;; # WPAR (>=AIX 6.1)
  "lvmo"          ) package="bos.rte.lvm"                ; desc="?"             ;; # 281
  "mmlscluster"   ) package="gpfs.base"                  ; desc="GPFS"          ;; # ...
  "mount"         ) package="bos.rte.filesystems"        ; desc="?"             ;; # ...
  "mpstat"        ) package="bos.acct"                   ; desc="?"             ;; # AIX 5.3
  "namerslv"      ) package="bos.net.tcp.client"         ; desc="?"             ;; # ...
  "netstat"       ) package="bos.net.tcp.client"         ; desc="?"             ;; # ...
  "nfso"          ) package="bos.net.nfs.client"         ; desc="?"             ;; # ...
  "nfsstat"       ) package="bos.net.nfs.client"         ; desc="?"             ;; # ...
  "niminv"        ) package="bos.sysmgt.nim.master"      ; desc="?"             ;; # ...
  "no"            ) package="bos.net.tcp.client"         ; desc="?"             ;; # ...
  "nslookup"      ) package="bos.net.tcp.client"         ; desc="?"             ;; # ...
  "ntpq"          ) package="bos.net.tcp.client"         ; desc="NTP"           ;; # 280 ...
  "oslevel"       ) package="bos.rte.install"            ; desc="?"             ;; # ...
  "pagesize"      ) package="bos.rte.misc_cmds"          ; desc="?"             ;; # >AW038< ...
  "pcmpath"       ) package="*sddpcm"                    ; desc="IBM SDDPCM"    ;; # ... SDDPCM
  "perl"          ) package="perl.rte"                   ; desc="Perl"          ;; # 280 ...
  "pmcycles"      ) package="bos.pmapi.tools"            ; desc="?"             ;; # ... Processor Speed
  "powermt"       ) package="*EMC-PowerPath*"            ; desc="EMC PowerPath" ;; # EMC PowerPath
  "printf"        ) package="bos.rte.commands"           ; desc="?"             ;; # ...
  "proctree"      ) package="bos.rte.commands"           ; desc="?"             ;; # ...
  "prtconf"       ) package="bos.rte.diag"               ; desc="?"             ;; # ...
  "ps"            ) package="bos.rte.control"            ; desc="?"             ;; # ...
  "pstat"         ) package="bos.sysmgt.serv_aid"        ; desc="?"             ;; # ...
  "pwdck"         ) package="bos.rte.security"           ; desc="?"             ;; # ...
  "qchk"          ) package="printers.rte"               ; desc="?"             ;; # ...
  "repquota"      ) package="bos.sysmgt.quota"           ; desc="?"             ;; # ...
  "rwho"          ) package="bos.net.tcp.cient"          ; desc="?"             ;; # ...
# "rpm"           ) package="freeware.rpm.rte"           ; desc="rpm"           ;; # rpm
  "rpm"           ) package="rpm.rte"                    ; desc="rpm"           ;; # rpm
  "rpcinfo"       ) package="bos.net.tcp.client"         ; desc="?"             ;; # ...
  "ruptime"       ) package="bos.net.tcp.client"         ; desc="?"             ;; # ...
  "sar"           ) package="bos.acct"                   ; desc="?"             ;; # ...
  "schedo"        ) package="bos.perf.tune"              ; desc="?"             ;; # 281
  "showmount"     ) package="bos.net.nfs.client"         ; desc="?"             ;; # 281
# "ssh"           ) package="freeware.openssh.rte"       ; desc="ssh"           ;; # ssh
  "ssh"           ) package="openssh.base.client"        ; desc="ssh"           ;; # ssh
  "smbstatus"     ) package="*SAMBA*"                    ; desc="SAMBA"         ;; # SAMBA
  "smtctl"        ) package="bos.rte.methods"            ; desc="?"             ;; # AIX 5.3 + Power5
  "suma"          ) package="bos.suma"                   ; desc="SUMA"          ;; # SUMA
  "svmon"         ) package="bos.perf.tools"             ; desc="?"             ;; # 280
  "sysdumpdev"    ) package="bos.rte.serv_aid"           ; desc="?"             ;; # ...
  "tail"          ) package="bos.rte.commands"           ; desc="?"             ;; # ...
  "tcbck"         ) package="bos.rte.security"           ; desc="?"             ;; # ...
  "uname"         ) package="bos.rte.misc_cmds"          ; desc="?"             ;; # ...
  "uptime"        ) package="bos.rte.misc_cmds"          ; desc="?"             ;; # ...
  "usrck"         ) package="bos.rte.security"           ; desc="?"             ;; # ...
  "vmstat"        ) package="bos.acct"                   ; desc="?"             ;; # ...
#  "vmtune"        ) package="bos.?"                      ; desc="?"             ;; # 5.2 only
  "vmo"           ) package="bos.perf.tune"              ; desc="?"             ;; # ...
#  "xiv_devlist"   ) package="*XiV*"                      ; desc="XiV"           ;; # XiV >AW134<
#  "vxdisk"        ) package="*Veritas VolumeMgr*"        ; desc="Veritas VxVM"  ;; # Veritas VxVM
  "vxdg"          ) package="*Veritas VolumeMgr*"        ; desc="Veritas VxVM"   ;; # Veritas VxVM
  "vxprint"       ) package="*Veritas VolumeMgr*"        ; desc="Veritas VxVM"   ;; # Veritas VxVM
#  "lltstat"       ) package="*Veritas ClusterServer*"    ; desc="Veritas VCS"   ;; # Veritas VCS
  "gabconfig"     ) package="*Veritas ClusterServer*"    ; desc="Veritas VCS"    ;; # Veritas VCS
  "hastatus"      ) package="*Veritas ClusterServer*"    ; desc="Veritas VCS"    ;; # Veritas VCS
  "w"             ) package="bos.rte.misc_cmds"          ; desc="?"             ;; # ...
  "who"           ) package="bos.rte.misc_cmds"          ; desc="who"           ;; # ...
  "which"         ) package="bos.rte.shell"              ; desc="which"         ;; # 280 ...
  "which_fileset" ) package="bos.rte.install"            ; desc="which_fileset" ;; # 280 ...
  "wlmstat"       ) package="bos.rte.control"            ; desc="WLM - Workload Manager" ;; # WLM Workload Manager
  "wlmcntrl"      ) package="bos.rte.control"            ; desc="?"             ;; # 281
  "ypwhich"       ) package="bos.net.nis.client"         ; desc="?"             ;; # ... NIS
  "lslicense"     ) package="bos.sysmgt.loginlic"        ; desc="?"             ;; # ...
  "PrtLayout"     ) package="*INTERNAL*"                 ; desc="?"             ;; # ...
  "PrintLVM"      ) package="*INTERNAL*"                 ; desc="?"             ;; # ...
  "bdf_collect"   ) package="*INTERNAL*"                 ; desc="?"             ;; # ...
  "cpu_info"      ) package="*INTERNAL*"                 ; desc="?"             ;; # ...
  "cpu_speed"     ) package="*INTERNAL*"                 ; desc="?"             ;; # ...
  "c2h_errpt"     ) package="*INTERNAL*"                 ; desc="?"             ;; # ...
  "cron_tabs"     ) package="*INTERNAL*"                 ; desc="?"             ;; # ...
  "xlc"           ) package="vac.C"                      ; desc="IBM C/C++"     ;; # ... IBM C/C++ Compiler
  "xyz"           ) package="*EXTERNAL*"                 ; desc="?"             ;; # ...
  "*"             ) ERRMSG "C2H006W cmd '${cmd_only}' not defined.";
                  package="*UNKNOWN*" ; desc="*unknown*"
                  ;; # NOT DEFINED
 esac

# >AW023< get info about package to install if cmd not found
 if [[ ${package} = "*UNKNOWN*" ]]
 then
   AWTRACE "%%%%% package -start- %%%%%%%%%%%"
   # ToDo 280-999 if rc=1 from lslpp, then try if it is a rpm package
   # ToDo 280-999 if rc=1 from lslpp, check if it is a link
   AWTRACE "C2H000I cmdpath_cmd '${cmdpath_cmd}'."
   awp=$(lslpp -qwc $(which ${cmdpath_cmd})|awk -F":" '{print $2}')
   awp_rc=$?
##   if [[ ${awp_rc} = "1" ]]
##   then
     #AWCONST "\nC2H000I check if it is a link."
     get_package_info
#--------
     if [[ -f ${base_fn} ]]
     then
       #AWCONST "\nC2H000I base_fn -f true"
       : # dummy - DO NOT DELETE
     else
       AWCONST "\nC2H000I base_fn -f NOT true"
     fi
#--------
     if [[ -f ${link_fn} ]]
     then
       #AWCONST "C2H000I link_fn -f true"
       : # dummy - DO NOT DELETE
     else
       AWCONST "C2H000I link_fn -f NOT true"
     fi
#--------
##   fi
   AWTRACE "C2H903I package for cmd '${cmd_only}' not set."
   typeset -L30 awp30=${awp}     # first 30 char of awp
   AWTRACE "C2H904I RC=${awp_rc} lslpp -qwc shows '${awp30}'."
   AWTRACE "C2H000I Please inform developement."
   awp=$(which_fileset ${cmd_only} 2>&1)
   awp_rc=$?
   AWTRACE "C2H904I which_fileset RC=${awp_rc} shows '${awp}'."
   AWTRACE "%%%%% package -end- %%%%%%%%%%%"
 fi

}

######################################################################
# get_package_info: get info about package
######################################################################
get_package_info ()
{
 AWCONST "AWAW_cmd=${cmdpath_cmd}"
 awaw=$(which ${cmdpath_cmd})
 awaw_rc=$?
 AWCONST "AWAW_RC=${awaw_rc}"
 AWCONST "AWAW=${awaw}"

 if [[ ${awaw_rc} = "0" ]]
 then
  awls=$(ls -la ${awaw})

  link_fn="?" # init
  base_fn="?" # init

 # wc gives: lines words chars
 # we expect w=9  (if it is a cmd)
 # -r-xr-xr-x    1 root     security      55906 Jul 09 2009  /usr/sbin/lsparent
 # we expect w=11 (if it is a link)
 # lrwxrwxrwx    1 root     system           16 Feb 26 01:05 /usr/bin/lpq -> /usr/aix/bin/lpq
 #
  xxx=$(echo ${awls}| wc)
  echo "${xxx}" | read l w c # l=line(s) w=words c=chars
  pkg_type="INIT" # init
 else
  w=0 # cmd NOT FOUND
 fi

 case $w in
      0 ) : # ERROR => cmd NOT FOUND
          pkg_type="CMD_NOT_AVAIL"
          ;;
      9 ) : # OK  => cmd
          pkg_type="CMD"
          ;;
     11 ) : # OK => link
          pkg_type="LINK"
          ;;
      * ) : # ERROR - All other
          pkg_type="OTHER"
          AWTRACE "AWGPI: Error ! Output line contains unexpected number of words"
          AWTRACE "AWGPI: Line=${awls}"
          AWTRACE "AWGPI: w<>11 w=${w} (l=${l} c=${c})"
          AWTRACE "AWGPI: "
          #exit 1
          ;;
   esac

 if [[ ${pkg_type} = "LINK" ]]
 then
   # get original filename for link
   set -A Als $(echo ${awls})
   # AWTRACE "Als.0=${Als[0]}" # lrwxrwxrwx
   # AWTRACE "Als.1=${Als[1]}" # 1
   # AWTRACE "Als.2=${Als[2]}" # root
   # AWTRACE "Als.3=${Als[3]}" # system
   # AWTRACE "Als.4=${Als[4]}" # 16
   # AWTRACE "Als.5=${Als[5]}" # Feb
   # AWTRACE "Als.6=${Als[6]}" # 26
   # AWTRACE "Als.7=${Als[7]}" # 01:05
   # AWTRACE "Als.8=${Als[8]}" # /usr/bin/lpq
   # AWTRACE "Als.9=${Als[9]}" # ->
   # AWTRACE "Als.10=${Als[10]}" # /usr/aix/bin/lpq
    link_fn=${Als[8]}
    base_fn=${Als[10]}
    link=${Als[9]}
    if [[ ${link} = "->" ]]
    then
      :
    else
      AWTRACE "AWGPI: WARNING ! Internal error. link (${link}) found. '->' expected"
    fi
 fi # pkg_type=LINK
}

#*********************************************************************
# *INTERNAL FUNCTIONS*
#*********************************************************************

######################################################################
# ShowLVM: get Logical Volume Manager information
######################################################################
ShowLVM ()
{
# ToDo 280-999 save DEBUG / restore DEBUG
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON

 export PATH=$PATH:/usr/sbin

 pvs=${TMPDIR}/lvm.pvs_$$  # ToDo: Delete tmp-file after usage
 # mnttab=${TMPDIR}/lvm.mnttab_$$  # var NOT used

 echo "Primary:Altern:Tot.PPs:FreePPs:PPsz:Group / Volume:Filesys:LVSzPP:Cpy:Mount-Point:HW-Path / Product"

 pvs=$(lsvg -p $(lsvg) | egrep -v ':$|^PV' | awk '{printf "%s:%s:%s:%s\n",$1,"",$3,$4}')

 #  process for each physical volume (Prim. Link)
 for line in $(echo $pvs)
 do
    dev=$(echo $line | cut -d':' -f1 )
  DBG "ShowLVM 001 lspv "
    vg=$(lspv | grep "^$dev " | awk '{print $3}')
    hwpath=$(echo $(lscfg -l $dev | tail -1) | cut -d' ' -f2- | sed 's- - / -')
  DBG "ShowLVM 002 lspv -l ${dev}"
    lspvs=$(lspv -l $dev | egrep -v ':$|^LV')
    lvs=$(echo "$lspvs" | awk '{print $1}')

    #  search for mount points of logical volumes
    n=1
    for lv in $(echo $lvs)
    do
      mnt=$(echo "$lspvs" | grep "^$lv " | awk '{print $5}')
      lvsiz=$(echo "$lspvs" | grep "^$lv " | awk '{print $2}')
      lslv=$(lslv $lv)
      mir=$(echo "$lslv" | grep "^COPIES:" | awk '{print $2}')
      fstyp=$(echo "$lslv" | grep "^TYPE:" | awk '{print $2}')
      ppsiz=$(echo "$lslv" | grep "PP SIZE" | awk '{print $6}')

      if [[ $n = 1 ]] ; then
         echo "$line:${ppsiz}MB:$vg/$lv:$fstyp:$lvsiz:$mir:$mnt:$hwpath"
      else
         echo ":::::$vg/$lv:$fstyp:$lvsiz:$mir:$mnt:"
      fi

      let n=$n+1
    done
 done

 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# PrintLVM: print Logical Volume Manager information
######################################################################
PrintLVM ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON

 ShowLVM | awk '
  BEGIN { FS=":" }
   {
    printf("%-7s %-7s ", $1, $2);          # prim, alt
    printf("%-18s ", $6);                  # vg/lvol
    printf("%7s %-7s %4s ", $3, $4, $5);   # tot, free, size
    printf("%7s %7s %3s ", $8, $7, $9);    # size, fs, mir
    printf("%-20s %s", $10, $11);          # mnt, hwpath/prod
    printf("\n");
    }'

 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# PrtLayout: ...
######################################################################
PrtLayout ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON

 VGS="$1"
 if [[ $# == 0 ]]; then
    VGS=$(lsvg | awk '{print $1}')
 fi

 if [[ "$2" != "" ]]; then
    MAN_LV="$2"
 fi

 DB ()
 {
 if [[ $DEBUG == 1 ]]; then
    # tee -a will "add" the output to a file
    # BUG >AW301< DB_F currently NOT DEFINED
    echo $* | tee -a $DB_F
 fi
 }  ## DEBUG MODE ##

 COL ()   ########## ( put var on positions )
 {
    case $1 in
    1)
     shift
     echo $* | awk '{printf("%10s%10s%9s%9s%16s%23s\n",$1,$2,$3,$4,$5,$6 )}'
     ;;
    2)
     shift
     echo $* | awk '{printf("%10s%5s%7s%9s%5s%2s%-17s\n",$1,$2,$3,$4,$5," ",$6 )}'
     ;;
    3)
     shift
     echo $* | awk '{printf("%47s%8s%22s\n",$1,$2,$3 )}'
     ;;
    esac
 }

 DB [-]  running on debug mode

 L0="=========================================================================="
 L1="--------------------------------------------------------------------------"
 PID=$(echo $$)
 PDD=$(date "+%y%m%d")

 DB [1] $PID $PDD

 ## create PHD list ###
 if lsdev -Cc pdisk | grep pdisk >/dev/null
 then
    >${TMPDIR}/PHD.tmp
    lsdev -Cc pdisk | awk '{print $1}' | while read PHD
    do
     echo " $PHD $(lsattr -l $PHD -E -a=connwhere_shad 2>/dev/null | awk '{print $2}') " >> /tmp/PHD.tmp
    done
 fi  ##############

 for VG in $VGS    ### check per Volume group #########
 do
    D=$(date "+%D")
    NAME=$(uname -n)
    PP=$(lsvg $VG 2>/dev/null | awk '/SIZE/ {print $6}')

    ######### PRINT VG #####
    echo "-*-"$L0
    echo " | $VG    PPsize:$PP	          date: $D 	from: $NAME "
    echo " + $L1"
    #######################
    HDS=$(lspv 2>/dev/null | grep $VG | awk '{print $1}')

    DB [2] HDS= $HDS

    COL 1 Logical Physical  Tot_Mb Used_Mb location [Free_distribution]

    for HD in $HDS
    do
     CAP=$(lspv $HD 2>/dev/null | awk '/PPs/{print $4}' | cut -c2-)
     echo $CAP | read TOT_MB USED_MB USE_C  ## CAP p/ disk
     lsvg -p $VG 2>/dev/null | awk "/$HD/{print \$5}" | sed s'/\.\./:/g' | \
     awk -F: '{printf("%.3d:%.3d:%.3d:%.3d:%.3d\n",$1,$2,$3,$4,$5)}' | read FREE_DISTR
     ### convert HDS PDS
     if lsattr -l $HD -E -a=connwhere_shad 2>/dev/null >/dev/null
     then
        CWiD=$(lsattr -l $HD -E -a=connwhere_shad | awk '{print $2}')
        awk "/$CWiD/{print \$1}" <${TMPDIR}/PHD.tmp | read ITEM
        PD=$(lsdev -Cc pdisk | grep "$ITEM " | awk '{print $1}')
     else
        PD="$HD"
     fi
     #### end convert ###

     lsdev -Cc disk | awk "/$HD/{print \$3}" | read LOC

     #####  HD  info #########################################
     COL 1 $HD $PD $TOT_MB $USE_C $LOC $FREE_DISTR
     #############################################################

     DB [3]  "${PID}_${PDD} ${VG}_${HD} $PD  $TOT_MB $USED_MB $LOC $FREE_DISTR "
    done

    if [[ "$MAN_LV" = "" ]]; then
     LVS=$(lsvg -l $VG 2>/dev/null | egrep -v "$VG|NAM"| awk '{print $1"_"$2"_"$3}') # gen LVS
    else
     if lsvg -l $VG | grep "$MAN_LV" >/dev/null ; then
        LVS=$(lsvg -l $VG | egrep -v "$VG|NAM"| grep "$MAN_LV" | awk '{print $1"_"$2"_"$3}') # gen LVS
     else
        echo " \n ERROR :  $MAN_LV   not on $VG ! \n"
        xexit  # >AW018<
     fi
    fi

    echo "   $L1 \n"

    ########################################## show ############
    COL 2 LVname LPs FStype Size used FS
    ############################################################

    for RLV in $LVS
    do
     echo  $RLV | awk -F_ '{print $1,$2,$3}' | read LV TLV LP
     B_SZ=$(expr $LP \* $PP)
     case $TLV in
        jfs|jfs2)
           lsfs | awk "/$LV/{print \$5,\$3}" | read SZK MP
           if [[ "$SZK" = "" ]]; then
            SZ="${B_SZ}MB"
            TLV="-"
           else
            SZ=$(expr $SZK / 2048 2>/dev/null)
            if [[ "$B_SZ" != "$SZ" ]]; then
             SZ="->${SZ}MB"  ## warning: fs-size < lv-size
            else
             SZ="${SZ}MB"
            fi
           fi
           df | awk "/$LV/{print \$4}" | read PRC

           if [[ "$PRC" = "" ]]; then
            PRC="n/a"
           fi
           ;;
        paging)
           lsps -a | grep "$LV" | grep "$VG" | awk '{print $4,$5"%"}' | read SZ PRC
           ;;
        *)
           SZ=" "
           PRC=" "
           MP=" "
           ;;
     esac

     ############### show LV  info ####################
     COL 2 $LV  $LP  $TLV  $SZ  $PRC $MP
     ##################################################

     lslv -m $LV 2>/dev/null | egrep -v "LP" | awk '{print $3,$5,$7}' | sort | uniq | while read A B C
     do
        echo $A >>${TMPDIR}/PV_1
        echo $B >>${TMPDIR}/PV_2
        echo $C >>${TMPDIR}/PV_3
     done

     for C in 1 2 3
     do
        cat ${TMPDIR}/PV_${C} | sort | uniq | while read PV
        do
           if [[ "$PV" != "" ]]; then
           lslv -l $LV 2>/dev/null | awk "/$PV/{print \$4}" | sed 's/000/---/g' | read PPP

           DB [4]  " PPP = $PPP "

           if [[ "$C" = "1" ]]; then
            Y="+"
            PRE_PV="$PV"
           else
            Y="copy_$C"
            if [[ "$PRE_PV" = "$PV" ]]; then
               PPP=$(echo $PPP | tr "0-9" "|||||||||")
            fi
           fi

           if lspv | grep $PV >/dev/null ; then  ## if hdisk not avail
            :
           else
            PV="N/A"
           fi

           ########## show PV position  #####
           COL 3  $Y   $PV   $PPP
           ######################################

           DB [5]  "${PID}_${PDD} ${VG}_${PV} $LV $LP $TLV $SZ $PRC $MP $Y $PV $PPP "
           fi
        done
     done

     rm -f ${TMPDIR}/PV_? 2>/dev/null  # >AW004<
    done

    echo
 done

 rm -f ${TMPDIR}/PHD.tmp 2>/dev/null  # >AW004<

 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# bdf_collect: ...
######################################################################
bdf_collect ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON

 # Stolen from: cfg2html for HP-UX
 # Revision 1.2  2001/04/18  14:51:34  14:51:34  root (Guru Ralph)

 # echo "Total Used Local Diskspace\n"
 df -Pk | grep ^/ | grep -v '^/proc' | awk '
    {
     alloc += $2;
     used  += $3;
     avail += $4;
    }

    END {
     print  "Allocated\tUsed \t \tAvailable\tUsed (%)";
     printf "%ld \t%ld \t%ld\t \t%3.1f\n", alloc, used, avail, (used*100.0/alloc);
 }'

 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# cpu_info: ...
######################################################################
cpu_info ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON

 v1=$(lsattr -El $proc | grep type | awk '{print $2}')
 echo "CPU's: "${NO_OF_CPUS}" of type: "${v1}

 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# cpu_speed: ...
######################################################################
cpu_speed ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON

 cspeed=$(lsattr -El $proc -a frequency -F value)
 speed_mhz=$(expr ${cspeed:-1} / 1000000)
 echo "${speed_mhz} MHz"

 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# c2h_errpt: ...
######################################################################
c2h_errpt ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON

# printf '%-10s %s %2s %s %-14s %s\n' IDENTIFIER DATE/TIMESTAMP T C RESOURCE_NAME DESCRIPTION; \
#    errpt | tail +2 | awk '{printf \"%-10s %s-%s-%s %s:%s %2s %s %-14s %s %s %s %s %s %s %s %s %s %s\n\",
#    \$1, substr(\$2,3,2), substr(\$2,1,2), substr(\$2,9,2), substr(\$2,5,2), substr(\$2,7,2),
#    \$3, \$4, \$5, \$6, \$7, \$8, \$9, \$10, \$11, \$12, \$13, \$14, \$15}'

 printf '%-10s %s %2s %s %-14s %s\n' IDENTIFIER DATE/TIMESTAMP T C RESOURCE_NAME DESCRIPTION \
    errpt | tail +2 | awk '{printf \"%-10s %s-%s-%s %s:%s %2s %s %-14s %s %s %s %s %s %s %s %s %s %s\n\", \
    \$1, substr(\$2,3,2), substr(\$2,1,2), substr(\$2,9,2), substr(\$2,5,2), substr(\$2,7,2), \
    \$3, \$4, \$5, \$6, \$7, \$8, \$9, \$10, \$11, \$12, \$13, \$14, \$15}'

 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# c2h_lspv: ...
######################################################################
c2h_lspv ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON

# exec_command "lspv | awk '{print \$1}' | while read i; \
# do echo \"Physical Volume: \$i\"; lqueryvg -At -p \$i; echo \$SEP; done | uniq | sed '\$d'" \
#    "Query Physical Volumes (EXTENDED)" "lqueryvg -At -p <pvol>"

 lspv | awk '{print \$1}' | while read i; \
 do echo \"Physical Volume: \$i\"; lqueryvg -At -p \$i; echo \$SEP; done | uniq | sed '\$d'

 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# cron_tabs: ...
######################################################################
cron_tabs ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON

 # >AW303< BUG: sed will convert also for *.TXT output file, which is not necessary
 # >AW303< BUG: 0 * * * * /usr/lpp/diagnostics/bin/run_ssa_healthcheck 1&gt;/dev/null 2&gt;/dev/null
 CRON_PATH=/var/spool/cron/crontabs
 for ct in `ls $CRON_PATH`; do
    echo "\n-=[ Crontab entry for user $ct ]=-\n"
   #cat $CRON_PATH/$ct | grep -v "^#"
    cat $CRON_PATH/$ct | egrep -v "^#|^[ 	]*$"     # remove comment and empty lines
 done

 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# LsConfig: ...
######################################################################
LsConfig ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON

 for lc in $(lsvg)
 do
    lsvg $lc
 done | awk '
    BEGIN      { printf("%10s\t%10s\t%10s\t%10s\t%10s\n","VG","Total(MB)","Free","USED","Disks") }
    /VOLUME GROUP:/ { printf("%10s\t", $3)  }
    /TOTAL PP/ {    B=index($0,"(") + 1
                E=index($0," megaby")
                D=E-B
                printf("%10s\t", substr($0,B,D) )
               }
    /FREE PP/  {    B=index($0,"(") + 1
                E=index($0," megaby")
                D=E-B
                printf("%10s\t", substr($0,B,D) )
               }
    /USED PP/  {    B=index($0,"(")  + 1
                E=index($0," megaby")
                D=E-B
                printf("%10s\t", substr($0,B,D) )
               }
    /ACTIVE PV/ { printf("%10s\t\n", $3)  } '

 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# COLLECTIONS
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

######################################################################
# collect_system: *col-01*S* System-Information
######################################################################
collect_system ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "SYSTEM 001"

 _collno="01"           # *col-01*S*
 _collkey="S"           # *col-01*S*
 _colltitel="Sys_Info"  # *col-01*S*
 _partitel="AIX/System" # *col-01*S*

 verbose_out "\n-=[ ${_collno}/${_maxcoll} ${_colltitel} ]=-\n"
 paragraph_start ${_partitel}
 inc_heading_level
 #////////////////////////////////////////////////////////////////////

  exec_command "uname -a" "System name, nodename, version, machine ID"  # >AW098<

  exec_command "uname -M" "Machine_Type"  # >CP001< add

  exec_command "uname -p" "Chip_Type"  # >AW098<

  exec_command "lscfg -vpl sysplanar0 | grep Machine/Cabinet | awk '{print \$2,\$3}'" "Serial_Number"

  exec_command "uname -m" "machine ID"  # >AW098<

  exec_command "uname -u" "system ID"  # >AW098<

  exec_command "hostname" "Display the name of the current host system"

  if [ "$EXTENDED" = 1 ]
  then
    AWCONS "\nAWTRACE EXTENDED START"
    AWTRACE "EXTENDED START"
    exec_command "uname -n" "Display the name of the current operating system (EXTENDED)"
    AWCONS "\nAWTRACE EXTENDED STOP"
    AWTRACE "EXTENDED STOP"
  fi

  exec_command "finger root" "info about root"  # >AW098<

  exec_command "lssec -f/etc/security/lastlog -s root -a unsuccessful_login_count" "unsuccessful root logins"  # >AW108<
# ToDo 282-900 more lssec info

# ToDo 281-003 use output of BG job
  exec_command "prtconf" "Print Configuration"
  DBG "SYSTEM 005"

   # -- OSLEVEL --
   # -- ******* --

   #------------------------------------------------------------------------
   #
   # AIX 5.3.0 ML03 5300-03         Oct 2005
   # AIX 5.3.0 TL07 5300-07-10-0943 Nov 2009 EOS 30 Oct 2009 <<< Current 5.3.0-07-10
   # AIX 5.3.0 TL08 5300-08-09-1013 Mar 2010 EOS 30 Apr 2010
   # AIX 5.3.0 TL08 5300-08-10-1015 May 2010 <<< Current 5.3.0-08-10
   # >>> 5.3.0 TLxx 5300-xx ---------------- >>> Supported TL for 5.3.0 <<<
   # AIX 5.3.0 TL09 5300-09
   # AIX 5.3.0 TL09 5300-09-00-0846 Nov 2008 Support P6 5.0GHz
   # AIX 5.3.0 TL09 5300-09-01-0847 Nov 2008
   # AIX 5.3.0 TL09 5300-09-02-0849 Dec 2008
   # AIX 5.3.0 TL09 5300-09-03-0918 Apr 2009 Support NPIV
   # AIX 5.3.0 TL09 5300-09-04-0920 Jul 2009
   # AIX 5.3.0 TL09 5300-09-05-0943 Nov 2009
   # AIX 5.3.0 TL09 5300-09-06-1013 Mar 2010 EOS 1 Oct 2010
   # AIX 5.3.0 TL09 5300-09-07-1015 May 2010 P7 <<< Current 5.3.0-09-07
   # AIX 5.3.0 TL10 5300-10
   # AIX 5.3.0 TL10 5300-10-00-0920 May 2009
   # AIX 5.3.0 TL10 5300-10-01-0921 May 2009
   # AIX 5.3.0 TL10 5300-10-02-0943 Nov 2009
   # AIX 5.3.0 TL10 5300-10-03-1013 Mar 2010 <<< Current 5.3.0-10-03
   # AIX 5.3.0 TL10 5300-10-04-1015 May 2010 P7 <<< Current 5.3.0-10-04
   # AIX 5.3.0 TL11 5300-11
   # AIX 5.3.0 TL11 5300-11-00-0943 Oct 2009
   # AIX 5.3.0 TL11 5300-11-01-0944 Oct 2009
   # AIX 5.3.0 TL11 5300-11-02-1009 Feb 2010 P7
   # AIX 5.3.0 TL11 5300-11-03-1013 Mar 2010
   # AIX 5.3.0 TL11 5300-11-04-1015 May 2010 <<< Current 5.3.0-11-04
   # AIX 5.3.0 TL12 5300-12
   # AIX 5.3.0 TL12 5300-12-00-1015 Apr 2010
   # AIX 5.3.0 TL12 5300-12-01-1016 Apr 2010 <<< Current 5.3.0-12-01
   #
   # AIX 6.1.0 TL00 6100-00
   # AIX 6.1.0 TL00 6100-00-01-0748 Nov 2007
   # AIX 6.1.0 TL00 6100-00-xx      ??? ???? EOS 30 Oct 2009
   # AIX 6.1.0 TL01 6100-01-xx      ??? ???? EOS 30 Apr 2010
   # >>> 6.1.0 TLxx 6100-xx ---------------- >>> Supported TL for 6.1.0 <<<
   # AIX 6.1.0 TL01 6100-02
   # AIX 6.1.0 TL02 6100-02-00-0846 Nov 2008 Support P6 5.0GHz
   # AIX 6.1.0 TL02 6100-02-01-0847 Nov 2008
   # AIX 6.1.0 TL02 6100-02-02-0849 Dec 2008
   # AIX 6.1.0 TL02 6100-02-03-0909 Feb 2009 Support NPIV
   # AIX 6.1.0 TL02 6100-02-04-0920 Jun 2009
   # AIX 6.1.0 TL02 6100-02-05-0939 Sep 2009
   # AIX 6.1.0 TL02 6100-02-06-0943 Dec 2009
   # AIX 6.1.0 TL02 6100-02-07-1014 Apr 2010
   # AIX 6.1.0 TL02 6100-02-08-1015 Jun 2010
   # AIX 6.1.0 TL02 6100-02-09-1034 ??? ???? <<< Current 6.1.0-02-09
   # AIX 6.1.0 TL02 6100-02-10-???? ??? ???? EOS 30 Oct 2010  <<< Current 6.1.0-02-09
   # AIX 6.1.0 TL03 6100-03
   # AIX 6.1.0 TL03 6100-03-00-0920 May 2009
   # AIX 6.1.0 TL03 6100-03-01-0921 May 2009
   # AIX 6.1.0 TL03 6100-03-02-0939 Sep 2009
   # AIX 6.1.0 TL03 6100-03-03-0943 Dez 2009
   # AIX 6.1.0 TL03 6100-03-04-1014 Apr 2010
   # AIX 6.1.0 TL03 6100-03-05-1015 Jun 2010
   # AIX 6.1.0 TL03 6100-03-06-1034 Aug 2010 <<< Current 6.1.0-03-06
   # AIX 6.1.0 TL04 6100-04
   # AIX 6.1.0 TL04 6100-04-00-0943 Oct 2009
   # AIX 6.1.0 TL04 6100-04-01-0944 Oct 2009
   # AIX 6.1.0 TL04 6100-04-02-1007 Jan 2010
   # AIX 6.1.0 TL04 6100-04-03-1009 Feb 2010 P7
   # AIX 6.1.0 TL04 6100-04-04-1014 Apr 2010
   # AIX 6.1.0 TL04 6100-04-05-1015 Jun 2010
   # AIX 6.1.0 TL04 6100-04-06-1034 Aug 2010 <<< Current 6.1.0-04-03
   # AIX 6.1.0 TL05 6100-05
   # AIX 6.1.0 TL05 6100-05-00-1015 Apr 2010
   # AIX 6.1.0 TL05 6100-05-01-1016 Apr 2010
   # AIX 6.1.0 TL05 6100-05-02-1034 Aug 2010 <<< Current 6.1.0-05-02
   # AIX 6.1.0 TL06 6100-06
   # AIX 6.1.0 TL05 6100-06-00-1036 Sep 2010
   # AIX 6.1.0 TL05 6100-06-01-1043 Sep 2010 <<< Current 6.1.0-06-01
   #
   # AIX 7.1.0 TL00 7100-00
   # AIX 7.1.0 TL00 7100-00-01-1037 Sep 2010 <<< Current 7.1.0-00-01
   #
   #------------------------------------------------------------------------

   # ToDo 280-100 check for Version / Release / ML
   # ToDo 280-100 check for maxtl maxsp - TL must be <= maxtl / SP must be <= maxsp

# ToDo 281-003 use output of BG job
   exec_command "oslevel" "OS Version (Version.Release.Modification.Fix)"

   if [[ $mltl = "TL" ]]; then
     mltl_txt="Technology"
   else
     mltl_txt="Maintenance"
   fi;
   exec_command "oslevel -r" "OS ${mltl_txt} Level (oslevel -r)"
   if [[ $mltl = "TL" ]]; then
     exec_command "oslevel -rq 2>&1" "Highest Known OS ${mltl_txt} Level (oslevel -rq)"
     exec_command "oslevel -s"       "Current ServicePac (oslevel -s)"
     exec_command "oslevel -sq 2>&1" "Highest Known ServicePac (oslevel -sq)"
   fi;

# ToDo 280-100 info what is missing if not at highest possible level
# ToDo 288-000 html: ATTENTION picture + Box with RED background
  fileset="bos.rte.install"
  lslpp -l ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|awk '{print $2}'|while read vv
  do
    bri_installed=${vv}
  done
  AWTRACE "%%% bos.rte.install ${bri_installed} %%%%%%%%%"

  DBG "SYSTEM 010"

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#
 SUBCOL_aix
#
 if [ "$XCFG_CSM" = "yes" ]
 then
   SUBCOL_csm_rsct
 fi # end XCFG_CSM
#
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 DBG "SYSTEM 100"
   exec_command "instfix -i |grep ML" "OS Maintenance Level (instfix)"  # >CP001< add

# ToDo 280-003 use fileoutput
   if [ "$EXTENDED" = 1 ] ; then
    exec_command "oslevel -g 2>&1" "OS TL higher" # To determine the filesets at levels later than the current TL
   fi

 DBG "SYSTEM 110"
   # -- BOOTINFO --
   # -- ******** --
   exec_command "bootinfo -T" "Hardware Platform Type"
   exec_command "bootinfo -p" "Model Architecture"

   mem_kb=$(bootinfo -r)
   mem_mb=$(echo $mem_kb/1024 | bc)
   mem_gb=$(echo $mem_mb/1024 | bc)
   exec_command "echo $mem_kb KB / $mem_mb MB / $mem_gb GB" "Memory Size (KB/MB/GB)"
   exec_command "echo \"$(bootinfo -r) KB / $(echo $(bootinfo -r)/1024 | bc) MB\"" \
      "Memory Size (KBytes/MBytes)" "bootinfo -r"
   exec_command "lsattr -El sys0 -a realmem"   "show sys0 attributes" # >AW098<

   exec_command "lslv -m hd5" "show hdisk for boot logical volume"  # >AW098<

   exec_command "bootinfo -y" "CPU 32/64 bit"

   exec_command "bootinfo -K" "Installed Kernel 32/64 bit"
 # AWTRACE "%%%%% multiproc -start- %%%%%%%%%"
   exec_command "(( $(bootinfo -z) == 0 )) && echo No || echo Yes" "Multi-Processor Capability" "bootinfo -z"
 # AWTRACE "%%%%% multiproc -end- %%%%%%%%%%%"

   # COMMAND: bootinfo -K
   #     Reports whether the system is running a 32-bit or 64-bit KERNEL.
   #     - Only one [1] can be active on a system [or within a LPAR] at a time.
   #
   # COMMAND: bootinfo -y:
   #     Reports whether the CPU is 32-bit or 64-bit.

   # cputype=`getsystype -y`  # only 5.x (will be used by prtconf)
   # kerntype=`getsystype -K` # only 5.x

   exec_command "lscfg | grep Implementation | cut -d: -f2 | tr -d ' '" \
      "Model Implementation" "lscfg | grep Implementation"

   exec_command "bootlist -m normal -o" "Boot Device List"
   exec_command "bootinfo -m" "Machine Model Code"
   exec_command "bootinfo -b" "Boot device (booted from)"

   exec_command "last reboot | head -5" "last reboot"  # >AW093<

   exec_command "bindprocessor -q" "Bindprocessor"  # >AW039< add

   NO_OF_CPUS=$(lscfg | grep 'proc[0-9]' | awk 'END {print NR}')
   # BUG >AW302< proc0
   COUNT=0     # ...
   procs=$(lscfg | grep proc | awk '{print $2}')
   for proc in $(echo $procs)
   do
     if [[ ${COUNT} = 0 ]]
     then
      CPU_TYPE=$(lsattr -El $proc | grep type | awk '{print $2}')
      CPU_TYPE2=$(lsattr -El $proc | grep type)
AWTRACE "CPU: NO_OF_CPU=${NO_OF_CPUS}"
AWTRACE "CPU: CPU_TYPE=${CPU_TYPE}"
AWTRACE "CPU: CPU_TYPE2=${CPU_TYPE2}"
      exec_command "echo 'CPU's:' ${NO_OF_CPUS} of type: $(lsattr -El $proc | \
         grep type | awk '{print $2}')" "CPU's" "lsattr -El $proc | grep type"
      exec_command cpu_info "Info about CPU"

      #piet=$(lsattr -El $proc -a frequency -F value)
      #exec_command "echo $(expr ${piet:-1} / 1000000) MHz" "CPUs Speed" "lsattr -El $proc | grep freq"
      exec_command cpu_speed "CPU's Speed"
      COUNT=$(expr $COUNT + 1)
     fi
   done

   # >AW303< BUG: sed will convert also for *.TXT output file, which is not necessary
   # >AW303< BUG: CPU: &lt;empty&gt;
   exec_command "lsrset -av" "Display System Rset Contents"

 DBG "SYSTEM 120"
   # -- SAR --
   # -- *** --
   #-------------------------------------------------------------------
   # ToDo 280-999 xxx
   # stderr output from "sar -b":
   #     sar: 0551-201 Cannot open /var/adm/sa/sa18.
   #     sar: 0551-213 Try running /usr/lib/sa/sa1 <increment> <number>
   #-------------------------------------------------------------------
   #DBG "start sar"
   exec_command "w ; sar 1" "Uptime, Who, Load & Sar Cpu"
  #exec_command "sar -b 1 9" "Buffer Activity"  # sar -b ???? # ToDo 282-000 ??
   sar -b >/dev/null 2>&1
   sar_rc=$?
   if [[ $sar_rc = 0 ]]
   then
     exec_command "sar -b" "Sar: Buffer Activity"
   else
     AWTRACE "C2H110W sar not setup correct"
   fi
   #DBG "end   sar"

 DBG "SYSTEM 130"
   # -- VMSTAT --
   # -- ****** --
   #DBG "start vmstat"
   exec_command "vmstat" "Display Summary of Statistics since boot"
   exec_command "vmstat -f" "Display Fork statistics"
   exec_command "vmstat -i" "Displays the number of Interrupts"
   exec_command "vmstat -s" "List Sum of paging events"
   exec_command "vmstat -v" "xxx" # >AW133<
   #DBG "end   vmstat"

   # -- IOSTAT --
   # -- ****** --
   exec_command "iostat" "Report CPU and I/O statistics"
   # Check HERE command RC ! If RC=1 then SYSTEM REBOOT necessary !!
   iostat >/dev/null 2>&1
   iostat_rc=$?
   if [[ $iostat_rc -ne 0 ]]
   then
     txt0="!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
     txt1="C2H999W WARNING ! SYSTEM NEEDS REBOOT !"
     echo "\n"$(tput smso)" "${txt1}" "$(tput sgr0)
     ERRLOG $txt0
     ERRLOG $txt1
     ERRLOG $txt0
     NEED_REBOOT="YES"
   fi;

   # -- LSPATH --
   # -- ****** --
   exec_command "lspath"    "Display the status of MultiPath I/O (MPIO) capable devices"
   exec_command "lspath -H" "Display the status of MultiPath I/O (MPIO) capable devices" # >AW133<

   # -- LOCKTRACE --
   # -- ********* --
   exec_command "locktrace -l" "List Kernel Lock Tracing current Status"

 #++ >AW050< start *SUMA*-----------------------------------------------
 DBG "SYSTEM 150"
   #-------------------------------------------
   # SUMA - Service Update Management Assistant
   # available with fileset bos.suma
   # needs perl.rte and perl.libext
   # AIX 5.3 Base or higher
   #-------------------------------------------
     verbose_out "\n== SUMA =="
     SUMA="UNKNOWN"
     # >AW036< AIX 6.1 Toleration
     # >AW121< AIX 7.1 Toleration
     case $osl in
       7100|6100|5300 ) : # OK - AIX 5.3 and higher always contains SUMA
                   SUMA="YES";
                   ;;
       *         ) : # OK
                   SUMA="CHECK";
                   ;;
     esac

     if [[ $SUMA = "CHECK" ]]
     then
       lslpp -lc | grep "bos.suma";
       if [[ $? = "0" ]]
       then
         SUMA="YES";
       else
         SUMA="NO";
       fi;
     fi

     case $SUMA in
      "YES" ) : # OK
              AWTRACE "C2H200I SUMA available";
              exec_command "suma -c" "SUMA Configuration";
              exec_command "suma -l" "SUMA Tasks";
              ;;
      "NO"  ) : # OK
              AWTRACE "C2H201I SUMA NOT available";
              AddText "C2H201I SUMA NOT available";
              ;;
      "UNKNOWN"  ) : # OK
              AWTRACE "C2H202I SUMA status unknown";
              AddText "C2H202I SUMA status unknown";
              ;;
      "*"  ) : # OK
              AWTRACE "C2H203I Internal error checking SUMA";
              AddText "C2H203I Internal error checking SUMA";
              ;;
     esac
 #++ >AW050< end *SUMA*-------------------------------------------------

 #++ >AW051< start *efix*-----------------------------------------------
 DBG "SYSTEM 160"
   #----------------------------------------------------------
   # efix - Interim fix management (former name emergency fix)
   # AIX 5.3.0 Base or higher
   #----------------------------------------------------------
     verbose_out "\n== efix/ifix =="
     efix="UNKNOWN"
   #   FIX=IY12345
   #   instfix -ivk $FIX
   #   if [[ $? -ne 0 ]]
   #   then
   #     echo "Instfix RC="$?" ==> FIX (${FIX}) NOT Installed !"
   #   fi
     exec_command "emgr -l 2>&1" "Filesets locked by EFIX manager (-l)"
     exec_command "emgr -P 2>&1" "Filesets locked by EFIX manager (-P)"
 #++ >AW051< end *efix*-------------------------------------------------

 #++ >AW053< start *WLM*------------------------------------------------
     verbose_out "\n== WLM =="
     exec_command "wlmcntrl -q 2>&1" "WLM Control" # >AW133<
     exec_command "wlmstat 2>&1" "WLM Workload Manager"
 #++ >AW053< end *WLM*--------------------------------------------------

 #++ >AW114< start *svmon*----------------------------------------------
     verbose_out "\n== svmon =="
 #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 # svmon -O on 6.1 ONLY if TL is 02 or higher !!
 # svmon -O on 5.3 ONLY if TL is 09 or higher !!
 #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  run_svmon="NO"
  if [[ "$os_vr" -ge 53 && "$tl" -ge 09 ]]
  then
    run_svmon="YES"
  fi
  if [[ "$os_vr" -ge 61 && "$tl" -ge 02 ]]
  then
    run_svmon="YES"
  fi

  if [[ $run_svmon = "YES" ]]
  then
    exec_command "svmon -O summary=basic,unit=auto" "svmon summary" # >AW114<
    exec_command "svmon -G" "svmon -G" # >AW133<
  fi

 #++ >AW114< end *svmon*------------------------------------------------

 #++ >AW054< start *smtctl*---------------------------------------------
     verbose_out "\n== smtctl =="
     SMTCTL="UNKNOWN"
     case $osl in
     # >AW036< AIX 6.1 Toleration
     # >AW121< AIX 7.1 Toleration
       7100|6100|5300 ) : # OK - AIX 5.3 and higher always contains SMTCTL
                  SMTCTL="YES";
                  ;;
       *         ) # KO
                   SMTCTL="UNKNOWN";
                   ;;
     esac

     if [[ $SMTCTL = "YES" ]]
     then
       if [[ $POWER5 = "YES" ]]
       then
         exec_command "smtctl" "SMT Simultaneous Multi-Threading"
       else
         SMTCTL="NO" # ! Only Possible on Power5 and higher
   # ToDo 000-000 call HTML_Title
         AddText "SMT available on Power5 or higher"
       fi
     fi
 #++ >AW054< end *smtctl*-----------------------------------------------

 #++ >AW055< start *cpupstat*-------------------------------------------
     verbose_out "\n== 5.3 =="
     CPUSTAT="UNKNOWN"
     case $osl in
     # >AW036< AIX 6.1 Toleration
     # >AW121< AIX 7.1 Toleration
       7100|6100|5300 ) : # OK - AIX 5.3 and higher always contains CPUSTAT
                   CPUSTAT="YES";
                   ;;
       *         ) : # KO
                   CPUSTAT="UNKNOWN";
                   ;;
     esac

     if [[ $CPUSTAT = "YES" ]]
     then
       exec_command "cpupstat -vi 0" "CPUPSTAT"
     fi
 #++ >AW055< end *cpupstat*---------------------------------------------

 #++ >AW056< start *mpstat*---------------------------------------------
     verbose_out "\n== mpstat =="
     MPSTAT="UNKNOWN"
     case $osl in
     # >AW036< AIX 6.1 Toleration
     # >AW121< AIX 7.1 Toleration
       7100|6100|5300 ) : # OK - AIX 5.3 and higher always contains MPSTAT
                   MPSTAT="YES";
                   ;;
       *         ) : # KO
                   MPSTAT="UNKNOWN";
                   ;;
     esac

     if [[ $MPSTAT = "YES" ]]
     then
       exec_command "mpstat" "MPSTAT"
     fi
 #++ >AW056< end *mpstat*-----------------------------------------------

 #++ >AW057< start *lparstat*-------------------------------------------
     verbose_out "\n== lparstat =="
     LPARSTAT="UNKNOWN"
     case $osl in
     # >AW036< AIX 6.1 Toleration
     # >AW121< AIX 7.1 Toleration
       7100 ) : # OK - AIX 7.1 and higher always contains LPARSTAT
              LPARSTAT="YES";
              WPAR="YES";
              ;;
       6100 ) : # OK - AIX 5.3 and higher always contains LPARSTAT
              LPARSTAT="YES";
              WPAR="YES";
              ;;
       5300 ) : # OK - AIX 5.3 and higher always contains LPARSTAT
              LPARSTAT="YES";
              WPAR="NO";
              ;;
       *    ) : # KO
              LPARSTAT="UNKNOWN";
              WPAR="UNKNOWN";
              ;;
     esac

     if [[ $LPARSTAT = "YES" ]]
     then
       exec_command "lparstat"     "LPARSTAT"
       if [[ $osl = 5300 ]]
       then
         exec_command "lparstat -i" "LPARSTAT -i"  # >AW094<
       else
         exec_command "lparstat -iW" "LPARSTAT -iW"  # >AW094<
       fi
       exec_command "lparstat -h"  "LPARSTAT -h"   # >AW094<
       exec_command "lparstat -H"  "LPARSTAT -H"   # >AW094<
     fi
 #++ >AW057< end *lparstat*---------------------------------------------

  DBG "SYSTEM 200 CRON"
#++ >AW124< end *CRON* -----------------------------------------------
# !! moved to SYSTEM to free C for xxx ( s.c system.cron ??)
  verbose_out "\n== CRON =="

# AWTRACE "...checking for CRON"
# ToDo 282-000 CRON

  for FILE in cron.allow cron.deny queuedefs # >AW135<
  do
     if [ -r /var/adm/cron/$FILE ]
     then
      exec_command "cat /var/adm/cron/$FILE" "/var/adm/cron/$FILE"
   # else
   #  exec_command "echo /var/adm/cron/$FILE not found!" "$FILE"
     fi
  done

  #------------------------------------------------------------------------------------
  # ls /var/spool/cron/crontabs/* >/dev/null 2>&1
  # if [ $? -eq 0 ]
  # then
  #    echo "\n\n<B>Crontab files:</B>" >> $HTML_OUTFILE_TEMP
  #    for FILE in /var/spool/cron/crontabs/*
  #    do
  #     exec_command "cat $FILE" "Crontab for user '$(basename $FILE)'"
  #    done
  # else
  #    echo "No crontab files." >> $HTML_OUTFILE_TEMP
  # fi
  #------------------------------------------------------------------------------------

  exec_command cron_tabs "Crontab for all users" "cat /var/spool/cron/crontabs/* | grep -v '^#'"

  for FILE in at.allow at.deny
  do
     if [ -r /var/adm/cron/$FILE ]
     then
      exec_command "cat /var/adm/cron/$FILE " "/var/adm/cron/$FILE"
     else
      verbose_out "No At jobs present" "$FILE"
     fi
  done

  exec_command "crontab -l" 'CRON Tab' # >AW133<
  exec_command "ls -la /var/adm/cron/log" 'Show info about Cron Log' # >AW135<
  exec_command "tail -30 /var/adm/cron/log" 'Show Cron Log entries' # >AW135<
  exec_command "at -l" 'AT Scheduler'
#++ >AW124< end *CRON* --------------------------------------------

#++ >AW107< start *NTP*-----------------------------------------------
  DBG "SYSTEM 300 NTP"
  verbose_out "\n== NTP =="

# show NTP info
  exec_command "ps -ef | grep ntp | grep -v grep"  "Show NTP process"
  exec_command "ntpq -pn"  "NTP"

# ToDo 282-001 More info about NTP

#++ >AW107< end *NTP*-------------------------------------------------

  DBG "SYSTEM 301 proctree"
  exec_command "proctree"    "Proctree"
  exec_command "proctree -a root" "Proctree -a root" # >AW044<

  DBG "SYSTEM 302 uptime"
  exec_command "uptime"  "Uptime"
  exec_command "ruptime" "rUptime"
  exec_command "rwho"    "rwho"
  exec_command "pmcycles -dm"    "pmcycles"

  DBG "SYSTEM 303 lslpp"
  exec_command "lslpp -hc bos.rte|sort" "System Install Time"

  DBG "SYSTEM 400 WHO"
  exec_command "who -a"    "who -a"
  exec_command "who -bl"   "who -bl" # >AW133<
  exec_command "who -r"    "who -r"
  exec_command "who -b;who -r"    "who -b;who -r"

#++ >AW444< start *which*---------------------------------------------
  DBG "SYSTEM 500 which"
  verbose_out "\n== which =="

  exec_command "which which"          "which which"
  exec_command "which which_fileset"  "which which_fileset"

  bcl=$(lslpp -l bos.content_list >/dev/null 2>&1)
  bcl_rc=$?
  if [[ $bcl_rc = 0 ]]
  then
    exec_command "which_fileset which"          "which_fileset which"
    exec_command "which_fileset which_fileset"  "which_fileset which_fileset "
  else
    AWTRACE "C2H000I Fileset 'bos.content_list' missing ! Please install before using 'which_fileset'"
  fi

#++ >AW444< end *which*-----------------------------------------------

#++ >AW100< start *geninv*--------------------------------------------
  DBG "SYSTEM 600 geninv"
  verbose_out "\n== geninv =="
  #AWTRACE "%%%%% geninv -start- %%%%%%%%%"

# Note: 'geninv' could be a "Long running" task.
# Check for successful finish of BG Job
# then use outputfile
if [[ -f $DSN_geninv ]]
then
  #AWCONST "\nC2H000I File DSN_geninv available"
  : # dummy - DO NOT DELETE
else
  AWCONST "\nC2H000I File DSN_geninv NOT available"
  AWCONST "\nC2H000I DSN_geninv=${DSN_geninv}"
  ls -la ${DSN_geninv}
fi

 #AWCONST "waiting for BG process: geninv (PID=${PID_gi})"
 wait $PID_gi # %BG001 wait for specific process
 wait_rc=$?
 BGRC_gi=$wait_rc
 #ERRMSG "AWDBG001I wait cmd 'geninv' PID=$PID_gi RC=$wait_rc"


#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# geninv on 5.3 ONLY if TL is 05 or higher !!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
run_geninv="no" # init 2
if [[ "$os_vr" -ge 61 ]]
then
 run_geninv="yes"
fi # os_vr = 61
if [[ "$os_vr" -eq 53 ]]
then
  if [[ "$tl" -ge 05 ]]
  then
    run_geninv="yes"
  fi # tl >= 05
fi # os_vr = 53

if [[ $run_geninv = "yes" ]]
then
  #AWTRACE "AWDBG000I checking for DSN_geninv"
  if [[ -f $DSN_geninv ]]
  then
    #AWCONST "C2H000I File DSN_geninv available"
    exec_command "cat ${DSN_geninv}" "geninv -l (BG-Job Fileoutput)"
  else
    AWCONST "C2H000I File DSN_geninv NOT available. Now running COMMAND"
    AWCONST "\nC2H000I DSN_geninv=${DSN_geninv}"
    ls -la ${DSN_geninv}
    exec_command "geninv -l"  "geninv -l"
  fi
  #date
else
  AWTRACE "AWDBG000I geninv ONLY on 5.3-TL05 or higher"
fi # run_geninv

  #AWTRACE "%%%%% geninv -end- %%%%%%%%%%%"
#++ >AW100< end *geninv*----------------------------------------------

#++ >AW083< start *lswpar*-------------------------------------------
  DBG "SYSTEM 700 lswpar"
  verbose_out "\n== lswpar =="
  AWTRACE "%%%%% lswpar -start- %%%%%%%%%"

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# lswpar on 6.1 ONLY if TL is 00 or higher !!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if [[ "$os_vr" -ge 61 && "$tl" -ge 00 ]]
then
  # show WPAR info
    exec_command "lswpar"  "lswpar"

  # ToDo 281-001 More info for wpar found
  # ToDo 281-001 lswapr -L <name>
fi

  AWTRACE "%%%%% lswpar -end- %%%%%%%%%%%"
#++ >AW083< end *lswpar*----------------------------------------------

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end ${_partitel}

 DBG "SYSTEM 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

#.....................................................................
# SUBCOL_aix
#.....................................................................
SUBCOL_aix ()
{
 #:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+
 dsn_lvl=dsn_lvl+1
 TRACE_DSN[$dsn_lvl]=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${aix_LOG}  # set AWTRACE_DSN
 AWDEBUG=1 # AWdebugging 0=OFF 1=ON (789 COMPILER =>ON
 ERRLOG ">>>> output > ${AWTRACE_DSN} LVL=${dsn_lvl}"
 infofile_header "AIX"

#-----------------------------------------------------------------------
# Display filesets missing to reach AIX Maintenance Level
# oslevel -rq
# oslevel -r
# oslevel -rl 5300-04
#-----------------------------------------------------------------------

#
#++++++++++++++++++++++++++++++
 TRACE_TIME=1 # TIME in TRACE Output 0=OFF 1=ON
 AWTRACE "OSLEVEL=${OSLEVEL} OSLEVEL_R=${OSLEVEL_R} maxtl=${maxtl}"
 TRACE_TIME=0 # TIME in TRACE Output 0=OFF 1=ON
 typeset -Z2 TL=0
 while [[ $TL -le $maxtl ]]
 do
   let TL=$TL+1
   LVL=${osl}-${TL}_AIX_ML
   AWTRACE "Checking for TL${TL} (${LVL})"
   instfix -ik $LVL >/dev/null 2>&1
   irc=$?
   case $irc in
       0 ) AWTRACE "+++ OK info for TL${TL} available" ;
           ;;
       1 ) AWTRACE "Files missing for TL${TL} ! RC=${irc}" ;
           maxtl=-1
 AWTRACE "CMD: instfix -ciqk $LVL | grep :-:"
 instfix -ciqk $LVL | grep ":-:" >/tmp/awqml.$$
 missrc=$?
 if [[ $missrc = 0 ]]
 then
  AWTRACE " "
  AWTRACE "Following Filesets are missing for TL: "$LVL
  AWTRACE "-----------------------------------------------------"
  cat /tmp/awqml.$$ >>${AWTRACE_DSN}
  rm  /tmp/awqml.$$
 else
  AWTRACE "MISSRC="$missrc
 fi
           ;;
     249 ) AWTRACE "+++ Sorry, NO info for TL${TL} available RC=${irc}" ;
           maxtl=-249
           ;;
       * ) AWTRACE "Unknown RC ${irc} while checking TL" ;
           #exit 16 ;
           ;;
   esac
 done
 let TL=$TL-1
 LVL=${osl}-${TL}_AIX_ML
 AWTRACE "Highest successfully installed TL is TL${TL}"
#++++++++++++++++++++++++++++++++++++++++
# maxtl is Highest KNOWN TL !
# check against Highest installed
# check bos.install also
# bos.rte.install:5.3.0.1  = ML00
#++++++++++++++++++++++++++++++++++++++++
  DBG "SYSTEM 020"
AWTRACE " "
AWTRACE "Show info about bos.rte.install"
lslpp -lc | grep bos.rte.install >>${AWTRACE_DSN}
AWTRACE " "
#++++++++++++++++++++++++++++++

#
 AWTRACE "Show info for TL: "$LVL
 AWTRACE "------------------"
 instfix -ik $LVL >>${AWTRACE_DSN} 2>&1
 irc=$?
 AWTRACE "RC="$irc
 AWTRACE " "
 AWTRACE " "

 case $irc in
     0 ) AWTRACE "All Files for TL ${LVL} found." ;
         ;;
     1 ) AWTRACE "Files missing" ;
         ;;
   249 ) AWTRACE "No info for this TL found !!" ;
         ;;
     * ) AWTRACE "Unknown RC ${irc} while checking TL" ;
         #exit 16 ;
         ;;
 esac

  DBG "SYSTEM 030"
# Display MISSING filesets for specific TL
# ----------------------------------------
if [[ $irc = 1 ]]
then
 instfix -ciqk $LVL | grep ":-:" >/tmp/awqml.$$ 2>&1
 missrc=$?
 if [[ $missrc = 0 ]]
 then
  AWTRACE " "
  AWTRACE "Following Filesets are missing for TL: "$LVL
  AWTRACE "-----------------------------------------------------"
  cat /tmp/awqml.$$ >>${AWTRACE_DSN}
  rm  /tmp/awqml.$$
 else
  AWTRACE "MISSRC="$missrc
 fi
fi

#
  DBG "SYSTEM 040"
 AWTRACE " "
 AWTRACE "Display Technology Level info"
 AWTRACE "-----------------------------"
 AWTRACE "highest TL level known:"
 cat ${DSN_oslevel_rq} >>${AWTRACE_DSN}
 AWTRACE "highest TL level installed:"
 cat ${DSN_oslevel_r} >>${AWTRACE_DSN}
 AWTRACE "use oslevel -rl <level> to see filesets missing for TL level"


#
  DBG "SYSTEM 050"
 AWTRACE " "
 AWTRACE "Display ServicePac info"
 AWTRACE "-----------------------"
 AWTRACE "highest SP level known:"
 cat ${DSN_oslevel_sq} >>${AWTRACE_DSN}
 AWTRACE "highest SP level installed:"
 cat ${DSN_oslevel_s} >>${AWTRACE_DSN}
 AWTRACE "use oslevel -sl <level> to see filesets missing for SP level"

#
# Display Filesets newer than TL-LVL !
# ------------------------------------
  DBG "SYSTEM 060"
 if [[ $irc = 0 ]]
 then
  AWTRACE " "
  instfix -ciqk $LVL | grep ":+:" >/tmp/awqml.$$
  newrc=$?
  if [[ $newrc = 0 ]]
  then
    AWTRACE "Following Filesets are newer than TL: "$LVL
    AWTRACE "-----------------------------------------------------"
    cat /tmp/awqml.$$ >>${AWTRACE_DSN}
    rm  /tmp/awqml.$$
  else
    AWTRACE "NEWRC="$newrc
  fi
  AWTRACE " "

  AWTRACE " "

 DBG "SYSTEM 070"
#
  instfix -ciq | grep ":-:" | >/tmp/awfix.$$
  fixrc=$?
  if [[ $fixrc = 0 ]]
  then
   AWTRACE "Following Filesets are missing for PTFxxx"
   AWTRACE "-----------------------------------------------------"
   cat /tmp/awfix.$$ >>${AWTRACE_DSN}
   rm  /tmp/awfix.$$
  else
   AWTRACE "FIXRC="$fixrc
  fi
  AWTRACE " "
 fi

#
 DBG "SYSTEM 080"
 AWTRACE " "
 AWTRACE "Display Filesets locked by EFIX manager"
 AWTRACE "---------------------------------------"
 /usr/sbin/emgr -P >>${AWTRACE_DSN} 2>&1

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# get info about SDD/SDDPCM and HOSTATTCH here to be able to check
# for AIX related fixes !
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 AWTRACE " "
 AWTRACE "Display SDD/SDDPCM info"
 AWTRACE "-----------------------"
  SDD="NO"
  SDDPCM="NO"

  exec_command "lslpp -lc | grep mpio"     "SDD: lslpp mpio"
  exec_command "lslpp -lc | grep .sdd"     "SDD: lslpp .sdd"

  DBG "SYSTEM 081"
  sdd_old_u=$(lslpp -l | grep devices.sdd.[567] | uniq)
  sdd_old_inst=$(echo "$sdd_old_u" | awk '{print $2}')
  sdd_old=$(lslpp -l | grep devices.sdd.[567])
  sdd_rc=$?
  if [[ $sdd_old = "" ]]
  then
    sdd_old="Not Installed"
  fi
  if [[ $sdd_rc = 0 ]]
  then
    SDD="YES"
    txt="\nC2H270I You are using SDD [ ${sdd_old_u} ] (before aix_hotfix)"
    #AWTRACE ${txt}
    AWTRACE "C2H272I SDD installed: ${sdd_old_inst}";
  else
    dummy=dummy
    AWTRACE "SDD sdd_rc=${sdd_rc} sdd_old=${sdd_old}"
  fi

  DBG "SYSTEM 082"
  sdd_pcm_u=$(lslpp -l | grep devices.sddpcm.[567] | uniq)
  sdd_pcm_inst=$(echo "$sdd_pcm_u" | awk '{print $2}')
  sdd_pcm=$(lslpp -l | grep devices.sddpcm.[567])
  pcm_rc=$?
  if [[ $sdd_pcm = "" ]]
  then
    sdd_pcm="Not Installed"
  fi
  if [[ $pcm_rc = 0 ]]
  then
    SDDPCM="YES"
    txt="\nC2H271I You are using SDDPCM [ ${sdd_pcm_u} ]"
    #AWTRACE ${txt}
    AWTRACE "C2H273I SDDPCM installed: ${sdd_pcm_inst}";
  else
    dummy=dummy
    AWTRACE "SDDPCM pcm_rc=${pcm_rc} sdd_pcm=${sdd_pcm}"
  fi

# ToDo 000-000 check sddpcm version (2.4.0.3)
# ToDo 000-000 check sddpcm version (2.5.0.0)
# ToDo 000-000 check for problem S1003579 (as of 10/13/09)
# ToDo 000-000 SDDPCM 2405 with host attach 1.0.0.17
# ToDo 000-000 SDDPCM 2501 with host attach 1.0.0.19

# check HOSTATTACHMENT
  DBG "SYSTEM 083"
  HOSTATT="INIT"
  # instead of "echo ... IFS" also "...uniq|awk -F":"'{print $2}'|..."
  # possible
  fileset="devices.fcp.disk.ibm.mpio.rte" # IBM MPIO FCP Disk Device
  lslpp -lc ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|while read line
  do
    echo ${line} | IFS=":" read a b c d e f g h i
    hostatt_installed=${c}
  done
#
  hostatt_base_u=$(lslpp -l ${fileset} 2>/dev/null)
  hostatt_base=$(lslpp -l ${fileset} >/dev/null 2>&1)
  hostatt_rc=$?
  #ERRMSG "HOSTATT_BASE RC=${hostatt_rc}"
  case $hostatt_rc in
  0 )
    HOSTATT="YES"
    AWTRACE "C2H274I HOSTATTACHMENT installed: ${hostatt_installed}";
    #AWTRACE "${hostatt_base_u}";
    ;;
  1 )
    HOSTATT="NO"
    AWTRACE "C2H275W HOSTATTACHMENT NOT installed RC=${hostatt_rc}";
    ;;
  * )
    HOSTATT="UNKNOWN"
    AWTRACE "C2H276E HOSTATTACHMENT error RC=${hostatt_rc}";
    ;;
  esac

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# AIX HOTFIX checks
 DBG "SYSTEM 090"
 AWTRACE " "
 AWTRACE "check for AIX Hotfixes"
 AWTRACE "----------------------"

# ToDo xxxcfg_AIX_Hotfix

 aix_hotfix_check   # >AW119< HIPER

# AIX SECURITY checks
 DBG "SYSTEM 095"
# ToDo 289-000 check security fixes
#aix_security_check   # >AW000<

 AWTRACE "*>>> EOF <<<"
 AWTRACE_DSN_OLD=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${TRACE_DSN[$dsn_lvl]} # restore AWTRACE_DSN
 AWDEBUG=0 # AWdebugging 0=OFF 1=ON (789 COMPILER =>OFF
 #:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-
 dsn_lvl=dsn_lvl-1
 ERRLOG "<<<< output > ${AWTRACE_DSN} was ${AWTRACE_DSN_OLD}"
}

#.....................................................................
# aix_hotfix_check: check for AIX Hotfixes
#.....................................................................
aix_hotfix_check ()
{
#++ >AW999< start *AIX_HOTFIX_CHECK*----------------------------------
  DEBUG_SAVE=${DEBUG} # SAVE DEBUG
  DEBUG=1  # debugging 0=OFF 1=ON
  if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

  DBG ":---------------------------------------"
  DBG "AIX_HOTFIX 001"

 AWTRACE "check AIX HOT Fixes (HIPER)"

#---------------------------------------------------------------------
# AIX V.R.M EOS
# --------- ---
# AIX 5.3.x n/a
#----------------------------------------------------------------------

check="INIT"
case $osl in
     # >AW036< AIX 6.1 Toleration
     # >AW121< AIX 7.1 Toleration
  7100 )
       case ${tl} in
         99 ) check="YES";;
          * )
             check="NO"
             AWTRACE "C2H000I No AIX-HotFix checks needed for TL ${tl} of AIX 7.1"
             ;;
       esac;
       ;;
  6100 )
       case ${tl} in
         00 ) check="YES";;
         01 ) check="YES";;
         02 ) check="YES";;
         03 ) check="YES";;
         04 ) check="YES";;
          * )
             check="NO"
             AWTRACE "C2H000I No AIX-HotFix checks needed for TL ${tl} of AIX 6.1";
             ;;
       esac;
       ;;
  5300 )
       case ${tl} in
         00 ) check="UNAVAILABLE";;
         01 ) check="UNAVAILABLE";;
         02 ) check="UNAVAILABLE";;
         03 ) check="UNAVAILABLE";;
         04 ) check="UNAVAILABLE";;
         05 ) check="UNAVAILABLE";;
         06 ) check="YES";;
         07 ) check="YES";;
         08 ) check="YES";;
         09 ) check="YES";;
         10 ) check="YES";;
         11 ) check="YES";;
          * )
             check="NO"
             AWTRACE "C2H000I No AIX-Fix checks needed for ${mltl} ${tl} of AIX 5.3";
             ;;
       esac;
       ;;
     * )
       check="NO"
       AWTRACE "C2H000I No AIX checks necessary for this AIX Level";
esac;

if [[ ${check} = "UNAVAILABLE" ]]
then
  check="NO"
  AWTRACE "C2H000I No AIX-HotFix available for TL ${tl} of AIX 5.3";
  AWTRACE "C2H039E Unsupported AIX ${mltl}-Level (${osl}-${tl})";
fi
#----------------------------------------------------------------------
AWTRACE " "
AWTRACE "CHECK=${check}"

#*********************************************************************

iFIX="NO"

# AIX 5.3
# =======
if [[ "$os_vr" -eq 53 && "$tl" -eq 10 ]] ; then
  aixhotfix_53_10
fi

if [[ "$os_vr" -eq 53 && "$tl" -eq 11 ]] ; then
  aixhotfix_53_11
fi

# AIX 6.1
# =======
if [[ "$os_vr" -eq 61 && "$tl" -eq 03 ]] ; then
  aixhotfix_61_03
fi

if [[ "$os_vr" -eq 61 && "$tl" -eq 04 ]] ; then
  aixhotfix_61_04
fi

# >AW121< AIX 7.1 Toleration

# AIX 7.1 BETA
# ============
if [[ "$os_vr" -eq 70 && "$tl" -eq 00 ]] ; then
  aixhotfix_70_00
fi

# AIX 7.1
# =======
if [[ "$os_vr" -eq 71 && "$tl" -eq 00 ]] ; then
  aixhotfix_71_00
fi

#
#

#*********************************************************************

  DBG "AIX_HOTFIX 998"
  DBG ":---------------------------------------"
  DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
#++ >AW999< end *AIX_HOTFIX_CHECK*------------------------------------
}

#.....................................................................
# check_AIX_Fix: ...
#.....................................................................
check_AIX_Fix ()
{
# 1=FIX 2=iFIX 3=FIXTXT
#echo "\n-=[ check_AIX_Fix ]=-\n"
 AWTRACE $OSLVLML $FIX "*" $TXT
 check_fix="NEXT"

 instfix -ivk $FIX  2>/dev/null >>${AWTRACE_DSN} # Type=AIX
 fix_rc=$?
 if [[ ${fix_rc} = 0 ]]
 then
   txt="FIX ${FIX} installed."
   AWTRACE $txt
   #We need to check for ALL fixes, so don't set DONE
   #check_fix="DONE" # Type=AIX
 else
   txt="FIX ${FIX} NOT installed ! (iFIX ${iFIX})"
   AWTRACE $txt
 fi

#Do iFIX checking if necessary
#if [[ $fix_rc > 0 && $iFIX = "YES" ]]
 if [[ $iFIX = "YES" ]]
 then
   iFIX="NO"
   AWTRACE "FIX ${FIX} may be installed as iFIX. instfix-rc was ${fix_rc} "
   AWTRACE " "
   AWTRACE "Display Filesets locked by EFIX manager"
   AWTRACE "---------------------------------------"
   /usr/sbin/emgr -P >>${AWTRACE_DSN} 2>&1
   AWTRACE " "
   /usr/sbin/emgr -l >>${AWTRACE_DSN} 2>&1

   exec_command "emgr -l 2>&1" "Filesets locked by EFIX manager (-l)"
   exec_command "emgr -P 2>&1" "Filesets locked by EFIX manager (-P)"
   AWTRACE " "
 fi
}

#.....................................................................
# aixhotfix_53_10: AIX HOTFixes for AIX 5.3 TL10
#.....................................................................
aixhotfix_53_10 ()
{
 AWTRACE "*******************************"
 AWTRACE "AIX HOTFIXES for AIX 5.3.0 TL10"
 AWTRACE "*******************************"
 #AWTRACE "NOTE ! AIX 5.3 TL10 End of Support ??? 20??"

#
#AIX53  TL10: APAR IZ?????
#

 AWTRACE " "
 AWTRACE "SINGLE fix check"
 AWTRACE "----------------"

 check_fix="NEXT" # global INIT Type=AIX

 if [[ "${check_fix}" = "NEXT" ]]
 then
  AWTRACE "Currently no Hotfixes known for AIX 5.3 TL10"
  #FIX=IZ????? ; iFIX="NO";  FIXTXT="AIX 5.3-10 ?????"
  #check_AIX_Fix
 fi

 AWTRACE " "
 AWTRACE "SPECIAL fix check"
 AWTRACE "-----------------"

 if [[ "${check_fix}" = "NEXT" ]]
 then
  #AWTRACE "Currently no Hotfixes known for AIX 5.3 TL10"
  FIX=IZ62462 ; iFIX="NO";  FIXTXT="AIX 5.3-10 Special SDD/SDDPCM Fix"
  check_AIX_Fix
  FIX=IZ53813 ; iFIX="NO";  FIXTXT="AIX 5.3-10 Special SDD/SDDPCM Fix"
  check_AIX_Fix
  FIX=IZ44846 ; iFIX="NO";  FIXTXT="AIX 5.3-10 Special SDD/SDDPCM Fix"
  check_AIX_Fix
  if [[ ${SDDPCM} = "YES" ]]
  then
    AWTRACE "-----------------"
    txt="\nC2H271I You are using SDDPCM [ ${sdd_pcm_u} ]"
    #AWTRACE ${txt}
    AWTRACE "C2H273I SDDPCM installed: ${sdd_pcm_inst}";
    if [[ ${sdd_pcm_inst} = "2.4.0.3" ]]
    then
      FIX=IZ54856 ; iFIX="NO";  FIXTXT="AIX 5.3-10 Special SDDPCM 2.4.0.3 Fix"
      check_AIX_Fix
    fi
    if [[ ${sdd_pcm_inst} = "2.5.0.0" ]]
    then
      FIX=IZ60980 ; iFIX="NO";  FIXTXT="AIX 5.3-10 Special SDDPCM 2.5.0.0 Fix"
      check_AIX_Fix
    fi
  fi
  if [[ ${HOSTATT} = "YES" ]]
  then
    AWTRACE "C2H274I HOSTATTACHMENT installed: ${hostatt_installed}";
  fi
 fi

}

#.....................................................................
# aixhotfix_53_11: AIX HOTFixes for AIX 5.3 TL11
#.....................................................................
aixhotfix_53_11 ()
{
 AWTRACE "*******************************"
 AWTRACE "AIX HOTFIXES for AIX 5.3.0 TL11"
 AWTRACE "*******************************"
 #AWTRACE "NOTE ! AIX 5.3 TL11 End of Support ??? 20??"

#
#AIX53  TL11: APAR IZ63808, IZ65095, IZ65325
#

 AWTRACE " "
 AWTRACE "SINGLE fix check"
 AWTRACE "----------------"

 check_fix="NEXT" # global INIT Type=AIX

 if [[ "${check_fix}" = "NEXT" ]]
 then
  #AWTRACE "Currently no Hotfixes known for AIX 5.3 TL11"
  #
  FIX=IZ69977 ; iFIX="YES"; FIXTXT="AIX 5.3-11 LDAP failure"
  check_AIX_Fix
  #
  FIX=IZ65427 ; iFIX="NO";  FIXTXT="AIX 5.3-11 possible DB2 crash"
  check_AIX_Fix
  #
  FIX=IZ63808 ; iFIX="YES"; FIXTXT="AIX 5.3-11 non-MPIO FC disks"
  check_AIX_Fix
  FIX=IZ65095 ; iFIX="NO";  FIXTXT="AIX 5.3-11 non-MPIO FC disks"
  check_AIX_Fix
  FIX=IZ65325 ; iFIX="NO";  FIXTXT="AIX 5.3-11 non-MPIO FC disks"
  check_AIX_Fix
 fi

 AWTRACE " "
 AWTRACE "SPECIAL fix check"
 AWTRACE "-----------------"

 if [[ "${check_fix}" = "NEXT" ]]
 then
  #AWTRACE "Currently no Hotfixes known for AIX 5.3 TL11"
  FIX=IZ62309 ; iFIX="NO";  FIXTXT="AIX 5.3-11 Special SDD/SDDPCM Fix"
  check_AIX_Fix
  FIX=IZ56557 ; iFIX="NO";  FIXTXT="AIX 5.3-11 Special SDD/SDDPCM Fix"
  check_AIX_Fix
  FIX=IZ44851 ; iFIX="NO";  FIXTXT="AIX 5.3-11 Special SDD/SDDPCM Fix"
  check_AIX_Fix
  if [[ ${SDDPCM} = "YES" ]]
  then
    AWTRACE "-----------------"
    txt="\nC2H271I You are using SDDPCM [ ${sdd_pcm_u} ]"
    #AWTRACE ${txt}
    AWTRACE "C2H273I SDDPCM installed: ${sdd_pcm_inst}";
    if [[ ${sdd_pcm_inst} = "2.4.0.3" ]]
    then
      FIX=IZ50064 ; iFIX="NO";  FIXTXT="AIX 5.3-11 Special SDDPCM 2.4.0.3 Fix"
      check_AIX_Fix
    fi
    if [[ ${sdd_pcm_inst} = "2.5.0.0" ]]
    then
      FIX=IZ59403 ; iFIX="NO";  FIXTXT="AIX 5.3-11 Special SDDPCM 2.5.0.0 Fix"
      check_AIX_Fix
    fi
  fi
  if [[ ${HOSTATT} = "YES" ]]
  then
    AWTRACE "C2H274I HOSTATTACHMENT installed: ${hostatt_installed}";
  fi
 fi

}

#.....................................................................
# aixhotfix_61_03: AIX HOTFixes for AIX 6.1 TL03
#.....................................................................
aixhotfix_61_03 ()
{
 AWTRACE "*******************************"
 AWTRACE "AIX HOTFIXES for AIX 6.1.0 TL03"
 AWTRACE "*******************************"
 #AWTRACE "NOTE ! AIX 6.1 TL03 End of Support ??? 20??"

#
#AIX61  TL03: APAR IZ?????
#

 AWTRACE " "
 AWTRACE "SINGLE fix check"
 AWTRACE "----------------"

 check_fix="NEXT" # global INIT Type=AIX

 if [[ "${check_fix}" = "NEXT" ]]
 then
  AWTRACE "Currently no Hotfixes known for AIX 6.1 TL03"
  #FIX=IZ????? ; iFIX="NO";  FIXTXT="AIX 6.1-03 ?????"
  #check_AIX_Fix
 fi

 AWTRACE " "
 AWTRACE "SPECIAL fix check"
 AWTRACE "-----------------"

 if [[ "${check_fix}" = "NEXT" ]]
 then
  #AWTRACE "Currently no Hotfixes known for AIX 6.1 TL03"
  FIX=IZ62592 ; iFIX="NO";  FIXTXT="AIX 6.1-03 Special SDD/SDDPCM Fix"
  check_AIX_Fix
  FIX=IZ57216 ; iFIX="NO";  FIXTXT="AIX 6.1-03 Special SDD/SDDPCM Fix"
  check_AIX_Fix
  FIX=IZ44323 ; iFIX="NO";  FIXTXT="AIX 6.1-03 Special SDD/SDDPCM Fix"
  check_AIX_Fix
  AWTRACE "SDDPCM=${SDDPCM}"
  if [[ ${SDDPCM} = "YES" ]]
  then
    AWTRACE "-----------------"
    txt="\nC2H271I You are using SDDPCM [ ${sdd_pcm_u} ]"
    #AWTRACE ${txt}
    AWTRACE "C2H273I SDDPCM installed: ${sdd_pcm_inst}";
    if [[ ${sdd_pcm_inst} = "2.4.0.3" ]]
    then
      FIX=IZ52470 ; iFIX="NO";  FIXTXT="AIX 6.1-03 Special SDDPCM 2.4.0.3 Fix"
      check_AIX_Fix
    fi
    if [[ ${sdd_pcm_inst} = "2.5.0.0" ]]
    then
      FIX=IZ63238 ; iFIX="NO";  FIXTXT="AIX 6.1-03 Special SDDPCM 2.5.0.0 Fix"
      check_AIX_Fix
    fi
  fi
  AWTRACE "HOSTATT=${HOSTATT}"
  if [[ ${HOSTATT} = "YES" ]]
  then
    AWTRACE "C2H274I HOSTATTACHMENT installed: ${hostatt_installed}";
  fi
 fi

}

#.....................................................................
# aixhotfix_61_04: AIX HOTFixes for AIX 6.1 TL04
#.....................................................................
aixhotfix_61_04 ()
{
 AWTRACE "*******************************"
 AWTRACE "AIX HOTFIXES for AIX 6.1.0 TL04"
 AWTRACE "*******************************"
 #AWTRACE "NOTE ! AIX 6.1 TL04 End of Support ??? 20??"

#
#AIX61  TL04: APAR IZ63813, IZ64056 and IZ64133
#

 AWTRACE " "
 AWTRACE "SINGLE fix check"
 AWTRACE "----------------"

 check_fix="NEXT" # global INIT Type=AIX

 if [[ "${check_fix}" = "NEXT" ]]
 then
  #AWTRACE "Currently no Hotfixes known for AIX 6.1 TL04"
  #
  FIX=IZ68635 ; iFIX="YES"; FIXTXT="AIX 6.1-04 LDAP failure"
  check_AIX_Fix
  #
  FIX=IZ65501 ; iFIX="NO";  FIXTXT="AIX 6.1-04 possible DB2 crash"
  check_AIX_Fix
  #
  FIX=IZ63813 ; iFIX="YES"; FIXTXT="AIX 6.1-04 non-MPIO FC disks"
  check_AIX_Fix

  FIX=IZ64056 ; iFIX="NO";  FIXTXT="AIX 6.1-04 non-MPIO FC disks"
  check_AIX_Fix

  FIX=IZ64133 ; iFIX="NO";  FIXTXT="AIX 6.1-04 non-MPIO FC disks"
  check_AIX_Fix
 fi

 AWTRACE " "
 AWTRACE "SPECIAL fix check"
 AWTRACE "-----------------"

 if [[ "${check_fix}" = "NEXT" ]]
 then
  #AWTRACE "Currently no Hotfixes known for AIX 6.1 TL04"
  FIX=IZ62301 ; iFIX="NO";  FIXTXT="AIX 6.1-04 Special SDD/SDDPCM Fix"
  check_AIX_Fix
  FIX=IZ56859 ; iFIX="NO";  FIXTXT="AIX 6.1-04 Special SDD/SDDPCM Fix"
  check_AIX_Fix
  FIX=IZ44417 ; iFIX="NO";  FIXTXT="AIX 6.1-04 Special SDD/SDDPCM Fix"
  check_AIX_Fix
  if [[ ${SDDPCM} = "YES" ]]
  then
    AWTRACE "-----------------"
    txt="\nC2H271I You are using SDDPCM [ ${sdd_pcm_u} ]"
    #AWTRACE ${txt}
    AWTRACE "C2H273I SDDPCM installed: ${sdd_pcm_inst}";
    if [[ ${sdd_pcm_inst} = "2.4.0.3" ]]
    then
      FIX=IZ49804 ; iFIX="NO";  FIXTXT="AIX 6.1-04 Special SDDPCM 2.4.0.3 Fix"
      check_AIX_Fix
    fi
    if [[ ${sdd_pcm_inst} = "2.5.0.0" ]]
    then
      FIX=IZ59305 ; iFIX="NO";  FIXTXT="AIX 6.1-04 Special SDDPCM 2.5.0.0 Fix"
      check_AIX_Fix
    fi
  fi
  if [[ ${HOSTATT} = "YES" ]]
  then
    AWTRACE "C2H274I HOSTATTACHMENT installed: ${hostatt_installed}";
  fi
 fi

}

#.....................................................................
# aixhotfix_71_00: AIX HOTFixes for AIX 7.1 TL00
#.....................................................................
aixhotfix_71_00 ()
{
 AWTRACE "*******************************"
 AWTRACE "AIX HOTFIXES for AIX 7.1.0 TL00"
 AWTRACE "*******************************"
 #AWTRACE "NOTE ! AIX 7.1 TL00 End of Support ??? 20??"

}

#.....................................................................
# SUBCOL_csm_rsct
#.....................................................................
SUBCOL_csm_rsct ()
{
######################################################################
# getCSM_RSCT_Info: ...
######################################################################
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 #:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+
 dsn_lvl=dsn_lvl+1
 TRACE_DSN[$dsn_lvl]=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${csm_LOG}  # set AWTRACE_DSN
 ERRLOG ">>>> output > ${AWTRACE_DSN} LVL=${dsn_lvl}"
 infofile_header "CSM-RSCT"

# check CSM
  CSM="INIT"
  MIN_RSCT="0.0.0" # init
  fileset="csm.core"
  lslpp -l ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|awk '{print $2}'|while read vv
  do
    csm_installed=${vv}
  done
#
  csm_base_u=$(lslpp -l csm.core 2>/dev/null)
  csm_base=$(lslpp -l csm.core >/dev/null 2>&1)
  csm_rc=$?
  #ERRMSG "CSM_BASE RC=${csm_rc}"
  case $csm_rc in
  0 )
    CSM="YES"
    AWTRACE "C2H100I CSM installed: ${csm_installed}";
    #AWTRACE "${csm_base_u}";
    lslpp -l | grep csm. >>${AWTRACE_DSN} 2>&1
    ;;
  1 )
    CSM="NO"
    AWTRACE "C2H101W CSM NOT installed RC=${csm_rc} (csm.core missing)";
    ;;
  * )
    CSM="UNKNOWN"
    AWTRACE "C2H102 CSM error RC=${csm_rc}";
    ;;
  esac

  if [[ "$CSM" = "YES" ]]
  then
    verbose_out "\n== check Fixes for CSM =="
    check_fix="NEXT" # INIT for CSM Type=CSM
    typeset -L5 csm_vrm=$csm_installed

    # CSM 1.7.1
    # =========

    if [[ "$csm_vrm" = "1.7.1" ]]
    then
      #------------------------------------------------
      # CSM 1.7.1-07
      # 5.3-TL10 / Requires IZxxxxx RSCT 2.4.13 AIX 5.3
      # 6.1-TL03 / Requires IZxxxxx RSCT 2.5.5  AIX 6.1
      # CSM 1.7.1-06
      # 5.3-TL10 / Requires IZxxxxx RSCT 2.4.12 AIX 5.3
      # 6.1-TL03 / Requires IZxxxxx RSCT 2.5.4  AIX 6.1
      # CSM 1.7.1-05
      # 5.3-TL10 / Requires IZxxxxx RSCT 2.4.11 AIX 5.3
      # 6.1-TL03 / Requires IZxxxxx RSCT 2.5.3  AIX 6.1
      #------------------------------------------------
      if [[ "$os_vr" -eq 53 && "$tl" -ge 10 ]] ; then
       MIN_RSCT="2.4.12.0"
      fi
      if [[ "$os_vr" -eq 61 && "$tl" -ge 03 ]] ; then
       MIN_RSCT="2.5.4.0"
      fi
      #
      if [[ "${check_fix}" = "NEXT" ]]
      then
# CSM 171-07 IZ72980 IZ73089                           April 29, 2010
# csm.server ONLY
       FIX=IZ72980 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.07 for AIX 5.3/6.1" # >AW000<
       check_CSM_Fix
       FIX=IZ73089 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.07 for AIX 5.3/6.1" # >AW000<
       check_CSM_Fix
       :
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
# CSM 171-06 IZ66739 IZ69943                           March 15, 2010
# csm.server ONLY
#      FIX=IZ66739 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.06 for AIX 5.3/6.1" # >AW000<
#      check_CSM_Fix
#      FIX=IZ69943 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.06 for AIX 5.3/6.1" # >AW000<
#      check_CSM_Fix
       :
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
# CSM 171-05 IZ67540 IZ58284                           January 10, 2010
# csm.server ONLY
#      FIX=IZ67540 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.05 for AIX 5.3/6.1" # >AW000<
#      check_CSM_Fix
#      FIX=IZ58284 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.05 for AIX 5.3/6.1" # >AW000<
#      check_CSM_Fix
       :
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
# CSM 171-04 IZ55597 IZ57962 IZ58359                   October 26, 2009
       FIX=IZ55597 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.04 for AIX 5.3/6.1" # >AW000<
       check_CSM_Fix
#      FIX=IZ57962 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.04 for AIX 5.3/6.1" # >AW000<
#      check_CSM_Fix
       FIX=IZ58359 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.04 for AIX 5.3/6.1" # >AW000<
       check_CSM_Fix
# csm.server
#      FIX=IZ5xxxx ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.04 for AIX 5.3/6.1" # >AW000<
#      check_CSM_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
# CSM 171-03 IZ54837 IZ54838 IZ54839                   August 13, 2009
       FIX=IZ54837 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.03 for AIX 5.3/6.1" # >AW000<
       check_CSM_Fix
       FIX=IZ54838 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.03 for AIX 5.3/6.1" # >AW000<
       check_CSM_Fix
       FIX=IZ54839 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.03 for AIX 5.3/6.1" # >AW000<
       check_CSM_Fix
# csm.server
#      FIX=IZ5xxxx ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.03 for AIX 5.3/6.1" # >AW000<
#      check_CSM_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
# CSM 171-02 IZ50520 IZ52840                           June 25, 2009
       FIX=IZ50520 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.02 for AIX 5.3/6.1" # >AW000<
       check_CSM_Fix
# csm.server
#      FIX=IZ52840 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.02 for AIX 5.3/6.1" # >AW000<
#      check_CSM_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
# CSM 171-01 IZ48411 IZ49810                           May 18, 2009
       FIX=IZ48411 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.01 for AIX 5.3/6.1" # >AW000<
       check_CSM_Fix
# csm.server
#      FIX=IZ49810 ; iFIX="NO"  ; FIXTXT="CSM 1.7.1.01 for AIX 5.3/6.1" # >AW000<
#      check_CSM_Fix
      fi
    fi # csm_vrm = 1.7.1

    # CSM 1.7.0
    # =========

    if [[ "$csm_vrm" = "1.7.0" ]]
    then
      #------------------------------------------------
      # 5.3-TL09 / Requires IZ23830 RSCT 2.4.10 AIX 5.3
      # 6.1-TL02 / Requires IZ23832 RSCT 2.5.2  AIX 6.1
      #------------------------------------------------
      if [[ "$os_vr" -eq 53 && "$tl" -ge 09 ]] ; then
       MIN_RSCT="2.4.10"
      fi
      if [[ "$os_vr" -eq 61 && "$tl" -ge 02 ]] ; then
       MIN_RSCT="2.5.2"
      fi
      #
      if [[ "${check_fix}" = "NEXT" ]]
      then
# CSM 170-19 IZ42536 IZ47932 IZ47935                   April 16, 2009
#         18 IZ41004 IZ42902 IZ43362 IZ43614           March 5, 2009
#         17 IZ38648 IZ39065 IZ39066 IZ39067           January 26, 2009
# CSM 170-16 IZ31725 IZ33415 IZ34163 IZ35702 IZ34290   November 13, 2008
       FIX=IZ42536 ; iFIX="NO"  ; FIXTXT="CSM 1.7.0.19 for AIX 6.1" # >AW000<
       check_CSM_Fix
       FIX=IZ47932 ; iFIX="NO"  ; FIXTXT="CSM 1.7.0.19 for AIX 6.1" # >AW000<
       check_CSM_Fix
       FIX=IZ47935 ; iFIX="NO"  ; FIXTXT="CSM 1.7.0.19 for AIX 6.1" # >AW000<
       check_CSM_Fix
      fi
      #-----------------------------------------------
      # 5.3-TL07 / Requires IZ23830 RSCT 2.4.9 AIX 5.3
      # 6.1-TL00 / Requires IZ23832 RSCT 2.5.1 AIX 6.1
      #-----------------------------------------------
      if [[ "$os_vr" -eq 53 && "$tl" -ge 07 ]] ; then
       MIN_RSCT="2.4.9"
      fi
      if [[ "$os_vr" -eq 61 && "$tl" -ge 00 ]] ; then
       MIN_RSCT="2.5.1"
      fi
      #
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ34163 ; iFIX="NO"  ; FIXTXT="CSM 1.7.0.16 for AIX 5.3" # >AW089<
       check_CSM_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ29205 ; iFIX="NO"  ; FIXTXT="CSM 1.7.0.15 for AIX 5.3" # >AW089<
       check_CSM_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ29195 ; iFIX="NO"  ; FIXTXT="CSM 1.7.0.14 for AIX 5.3" # >AW089<
       check_CSM_Fix
      fi

      #-----------------------------------------------
      # 5.3-TL07 / Requires IZ12204 RSCT 2.4.8 AIX 5.3
      # 6.1-TL00 / Requires IZ12979 RSCT 2.5.0 AIX 6.1
      #-----------------------------------------------
      if [[ "$os_vr" -eq 53 && "$tl" -ge 07 ]] ; then
        if [[ "$csm_installed" = "1.7.0.16" ]]
        then
          MIN_RSCT="2.4.9"
        else
          MIN_RSCT="2.4.8"
        fi
      fi
      if [[ "$os_vr" -eq 61 && "$tl" -ge 00 ]] ; then
        if [[ "$csm_installed" = "1.7.0.16" ]]
        then
          MIN_RSCT="2.5.1"
        else
          MIN_RSCT="2.5.0"
        fi
      fi
      #
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ14050 ; iFIX="NO"  ; FIXTXT="CSM 1.7.0.4  for AIX 5.3" # >AW089<
       check_CSM_Fix
      fi
    fi # csm_vrm = 1.7.0

  fi

# check RSCT
  RSCT="INIT"
# fileset="rsct.basic.rte" # might not be installed !
  fileset="rsct.core.utils"
  lslpp -l ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|awk '{print $2}'|while read vv
  do
    rsct_installed=${vv}
  done
#
  rsct_base_u=$(lslpp -l ${fileset} 2>/dev/null)
  rsct_base=$(lslpp -l ${fileset} >/dev/null 2>&1)
  rsct_rc=$?
  #ERRMSG "RSCT_BASE RC=${rsct_rc}"
  case $rsct_rc in
  0 )
    RSCT="YES"
    AWTRACE "C2H103I RSCT installed: ${rsct_installed}";
    if [[ "$CSM" = "YES" ]]
    then
      AWTRACE "C2H000I for CSM ${csm_installed} MIN_RSCT needed is ${MIN_RSCT}";
    fi
    lslpp -l | grep rsct. >>${AWTRACE_DSN} 2>&1
    #AWTRACE "\n${rsct_base_u}";
    ;;
  1 )
    RSCT="NO"
    AWTRACE "C2H104W RSCT NOT installed RC=${rsct_rc} (${fileset} missing)";
    ;;
  * )
    RSCT="UNKNOWN"
    AWTRACE "C2H105E RSCT error RC=${rsct_rc}";
    ;;
  esac

  if [[ "${RSCT}" = "YES" ]]
  then
    verbose_out "\n== check Fixes for RSCT =="
    check_fix="NEXT" # INIT for RSCT Type=RSCT
    typeset -L5 rsct_vrm=$rsct_installed

#   #************************************************************************
#   # RSCT 2.5.x for AIX 6.1
#   # RSCT 2.5.4 for AIX 6.1 TL 04
#   #************************************************************************
    if [[ "$rsct_vrm" = "2.5.4" ]]
    then
#   #------------------------------------------------------------------------
#   # 6.1-TL00 / Requires XX00000 RSCT 0.0.0 AIX 6.1
#   #
#   # 2010/08/00 RSCT 2.5.5.2  APAR:  x
#   # 2010/02/01 RSCT 2.5.4.2  APAR:  IZ67750 IZ67867 IZ67789 IZ66741 IZ67493
#   # 2009/11/06 RSCT 2.5.4.1  APAR:  IZ59217 IZ60631 IZ63820 IZ63821
#   #
#   #------------------------------------------------------------------------
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ67750 ; iFIX="NO"  ; FIXTXT="RSCT 2.5.4.2 for AIX 6.1" # >AW000<
     check_RSCT_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ59217 ; iFIX="NO"  ; FIXTXT="RSCT 2.5.4.1 for AIX 6.1" # >AW000<
     check_RSCT_Fix
    fi
    fi # rsct_vrm = 2.5.4

    if [[ "$rsct_vrm" = "2.5.3" ]]
    then
#   #------------------------------------------------------------------------
#   # 6.1-TL00 / Requires XX00000 RSCT 0.0.0 AIX 6.1
#   #
#   # 2009/09/21 RSCT 2.5.3.4  APAR:  IZ52683 IZ53470 IZ54527 IZ59695 IZ59697
#   # 2009/07/31 RSCT 2.5.3.3  APAR:  ??
#   # 2009/06/26 RSCT 2.5.3.2  APAR:  IZ51176 IZ51778 IZ52179 IZ52384 IZ52451
#   # 2009/05/21 RSCT 2.5.3.1  APAR:  IZ48407 IZ48441 IZ50185 IZ49869 IZ50194 IZ50314
#   #
#   #------------------------------------------------------------------------
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ52683 ; iFIX="NO"  ; FIXTXT="RSCT 2.5.3.4 for AIX 6.1" # >AW000<
     check_RSCT_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ51176 ; iFIX="NO"  ; FIXTXT="RSCT 2.5.3.2 for AIX 6.1" # >AW000<
     check_RSCT_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ48407 ; iFIX="NO"  ; FIXTXT="RSCT 2.5.3.1 for AIX 6.1" # >AW000<
     check_RSCT_Fix
    fi
    fi # rsct_vrm = 2.5.3

#   #************************************************************************
#   # RSCT 2.4.x  for AIX 5.3
#   # 2010/08/00 RSCT 2.4.13.2 APARs: x
#   # 2010/02/01 RSCT 2.4.12.2 APARs: IZ67749 IZ67490 IZ64848 IZ66768 IZ67866
#   # 2009/11/06 RSCT 2.4.12.1 APARs: IZ59218 IZ63177 IZ61339
#   # RSCT 2.4.12 for AIX 5.3 TL 11
#   # RSCT 2.4.11 for AIX 5.3 TL 10
#   #************************************************************************
    if [[ "$rsct_vrm" = "2.4.12" ]]
    then
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ67749 ; iFIX="NO"  ; FIXTXT="RSCT 2.4.12.2 for AIX 5.3" # >AW000<
     check_RSCT_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ59218 ; iFIX="NO"  ; FIXTXT="RSCT 2.4.12.1 for AIX 5.3" # >AW000<
     check_RSCT_Fix
    fi
    fi # rsct_vrm = 2.4.12

    if [[ "$rsct_vrm" = "2.4.11" ]]
    then
#   #------------------------------------------------------------------------
#   # 5.3-TL07 / Requires XX00000 RSCT 0.0.0 AIX 5.3
#   #
#   # 2009/09/21 RSCT 2.4.11.4 APAR:  IZ55327 IZ56547 IZ59226 IZ59227 IZ59228
#   # 2009/07/31 RSCT 2.4.11.3 APAR:  ??
#   # 2009/05/21 RSCT 2.4.11.2 APARs: IZ49578 IZ49793 IZ50764 IZ51178
#   # 2009/05/21 RSCT 2.4.11.1 APARs: IZ48408 IZ41812 IZ45681 IZ49870 IZ86616 IZ50315
#   #
#   #------------------------------------------------------------------------
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ49578 ; iFIX="NO"  ; FIXTXT="RSCT 2.4.11.2 for AIX 5.3" # >AW000<
     check_RSCT_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ48408 ; iFIX="NO"  ; FIXTXT="RSCT 2.4.11.1 for AIX 5.3" # >AW000<
     check_RSCT_Fix
    fi
    fi # rsct_vrm = 2.4.11

 fi

 AWTRACE "*>>> EOF <<<"
 AWTRACE_DSN_OLD=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${TRACE_DSN[$dsn_lvl]} # restore AWTRACE_DSN

 #:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-
 dsn_lvl=dsn_lvl-1
 ERRLOG "<<<< output > ${AWTRACE_DSN} was ${AWTRACE_DSN_OLD}"
#
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
}

######################################################################
# collect_kernel: *col-02*K* Kernel Information
######################################################################
collect_kernel ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "KERNEL 001"

  verbose_out "\n-=[ 02/${_maxcoll} Kernel_info ]=-\n"
  paragraph_start "Kernel"
  inc_heading_level
 #////////////////////////////////////////////////////////////////////

  exec_command "ls -al /unix"   "ls -al /unix" # >AW133<
  exec_command "ls -al /usr/lib/boot/uni*"   "ls -al /usr/lib/boot/uni*" # >AW133<

  if [ "$EXTENDED" = 1 ] ; then
    AWCONS "\nAWTRACE EXTENDED START"
    AWTRACE "EXTENDED START"
     exec_command "genkex" "Loaded Kernel Modules (EXTENDED)"
    AWCONS "\nAWTRACE EXTENDED STOP"
    AWTRACE "EXTENDED STOP"
  fi

  exec_command "lsattr -El sys0"   "show sys0 attributes" # >AW076<

  #++ >AW201< start *vmtune* -----------------------------------------
  # Note: 5.2/5.3 use vmo and ioo
  #       vmtune available in 5.2 only if migrated and in
  #       compatibility mode
  #       vmtune obsolete in 5.3 and higher

  if [ "$os_vr" -eq 52 ]   # >AW...<
  then
    # >AW304< BUG: change uname -n to $(uname -n)
    # >AW304< BUG: uname -n will produce entry in *.err file !
    NODE=$(uname -n)

    cmd="/usr/samples/kernel/vmtune"
    if [ -x /usr/samples/kernel/vmtune ] ; then
      DBG "KERNEL 010 vmtune "
      AWTRACE ": vmtune **"
      exec_command "/usr/samples/kernel/vmtune" "Virtual Memory Manager Tunable Parameters"
    else
      verbose_out "\nC2H005W CMD 'vmtune' not found.";
      AWTRACE     "\nC2H005W CMD 'vmtune' not found.";
      verbose_out "C2H043I CMD '${cmd}' NOT EXECUTED!"
      AWTRACE     "C2H043I CMD '${cmd}' NOT EXECUTED!"
    fi
  fi
  #++ >AW201< end *vmtune* -------------------------------------------

  #++ >AW065< start *vmo,ioo*-------------------------------------------
  VMO_IOO="UNKNOWN"
  case $osl in
    # >AW121< AIX 7.1 Toleration
    7100|6100|5300 ) : # OK - AIX 5.3 and higher always contains VMO_IOO
                 VMO_IOO="YES";
                 ;;
    *          ) : # KO
                 VMO_IOO="UNKNOWN";
                 ;;
  esac

  if [[ $VMO_IOO = "YES" ]]
  then
    verbose_out "\n== vmo =="
    exec_command "vmo -a"   "vmo: vmo -a"
    # Check HERE command RC ! If RC=1 then SYSTEM REBOOT necessary !!
    NEED_REBOOT="NO"
    vmo -a >/dev/null 2>&1
    vmo_rc=$?
    if [[ $vmo_rc = 1 ]]
    then
      txt0="!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      txt1="C2H999W WARNING ! SYSTEM NEEDS REBOOT !"
      echo "\n"$(tput smso)" "${txt1}" "$(tput sgr0)
      ERRLOG $txt0
      ERRLOG $txt1
      ERRLOG $txt0
      NEED_REBOOT="YES"
    fi;

    if [[ ${NEED_REBOOT} = "NO" ]]
    then
      exec_command "vmo -ra"  "vmo: vmo -ra"
      exec_command "vmo -pa"  "vmo: vmo -pa"
      exec_command "vmo -L"   "vmo: vmo -L"
      verbose_out "\n== ioo =="
      verbose_out "\n  == ioo -a =="
      exec_command "ioo -a"   "ioo: ioo -a"
      verbose_out "\n  == ioo -ra =="
      exec_command "ioo -ra"  "ioo: ioo -ra"
      verbose_out "\n  == ioo -pa =="
      exec_command "ioo -pa"  "ioo: ioo -pa"
      verbose_out "\n  == ioo -L =="
      exec_command "ioo -L"  "ioo: ioo -L"
    fi
  fi
  #++ >AW065< end *vmo,ioo*---------------------------------------------

  exec_command "lssrc -a" "List current status of all defined subsystems"
  exec_command "chcod"    "List Capacity upgrade On Demand values"

  #++ >AW096< start *lsvpd now EXTENDED* -----------------------------
  if [ "$EXTENDED" = 1 ] ; then
    AWCONS "\nAWTRACE EXTENDED START"
    AWTRACE "EXTENDED START"
  DBG "KERNEL 980"
  exec_command "lsvpd -v" "List Vital Product Data"
  DBG "KERNEL 981"
    AWCONS "\nAWTRACE EXTENDED STOP"
    AWTRACE "EXTENDED STOP"
  fi
  #++ >AW096< end *lsvpd now EXTENDED* -------------------------------

  exec_command "lsrsrc"   "List Resources"
  exec_command "lsrsrc IBM.ManagementServer"   "List Resource: IBM.ManagementServer"

  # >AW303< BUG: sed will convert also for *.TXT output file, which is not necessary
  # >AW303< BUG: root  5200  4668   0   Jun 21      -  0:00 dtlogin &lt;:0&gt;        -daemon
  # >AW303< BUG: root 18084 17434   1 11:31:24  pts/3  0:00 sed ?s/&amp;/&#92;&amp;amp;/g?s/&lt;/&#92;&amp;lt;/g?s/&gt;/&#92;&amp;gt;/g?s/&#92;&#92;/&#92;&amp;#92;/g?
  if [ "$EXTENDED" = 1 ] ; then
    AWCONS "\nAWTRACE EXTENDED START"
    AWTRACE "EXTENDED START"
# ToDo 000-000 ps -ef | grep -v aioserver !! Don't show aio here !!
     exec_command "ps -lAf | grep -v aioserver" "List Processes (EXTENDED)"  # unfortunately no -H (XPG4) as in HP-UX
    AWCONS "\nAWTRACE EXTENDED STOP"
    AWTRACE "EXTENDED STOP"
  else
     exec_command "ps -Af | grep -v aioserver"  "List Processes"             # unfortunately no -H (XPG4) as in HP-UX
  fi

  #++ >AW202< start *ps* ---------------------------------------------
    exec_command "ps -fT 0" "List Processes hierarchically" # >AW087<
  #++ >AW202< end *ps* -----------------------------------------------
  exec_command "ps -ko THREAD" "List Process THREAD" # >AW133<

  #++ >AW059< start *aio*-----------------------------------------------
  DBG "KERNEL 982"
  verbose_out "\n== aio =="
  AWTRACE "%%%%% aio -start- %%%%%%%%%"

# ToDo 281-001 check aio for correct settings ! warn if too less or too much
# ToDo 281-001 AIX6 ioo aio_active = 0 / 1
# ToDo 281-001 AIX6 has no aioo command ??
  AIO_IOO="INIT"
  AIO="INIT"
  case $osl in
    7100|6100      ) : # OK - AIX 6.1 and higher - use ioo
                AIO_IOO="YES";
                ;;
    5300|5200 ) : # KO - AIX 5.3 and less - use lsattr
                AIO_IOO="NO";
                ;;
    *         ) : # KO
                AIO_IOO="UNKNOWN";
                ;;
  esac

  if [[ $AIO_IOO = "YES" ]]
  then
     exec_command "ioo -a | grep aio"    "ASYNC I/O"  # >AW082<
     exec_command "ps -ef | grep aio | grep -v grep" "List aioserver Processes"
     exec_command "pstat -a | grep aio | grep -v grep" "List aioserver Processes"
     exec_command "pstat -T" "pstat" # >AW133<
    AIO="UNKNOWN"
  else
    aio_chk=$(lsattr -El aio0 2>/dev/null)
    aio_rc=$?
    if [[ $aio_rc = 0 ]]
    then
      AIO="YES"
      exec_command "lsattr -El aio0"    "ASYNC I/O"
      exec_command "lsattr -Rl aio0 -a minservers"    "ASYNC I/O minservers"
      exec_command "lsattr -Rl aio0 -a maxservers"    "ASYNC I/O maxservers"
      exec_command "aioo -a"            "ASYNC I/O"
      # ToDo 000-000 ps -ef | grep aioserver !! But show aio here !!
      exec_command "ps -ef | grep aioserver | grep -v grep" "List aioserver Processes"
  # ToDo 000-000 show WARNING if aio is used ! In AIX6 aio configured via ioo !!
    else
      AIO="NO"
      AWTRACE "C2H231W AIO (async I/O) n/a or not configured!"
    fi
  fi

  if [[ $AIO_IOO = "YES" ]]
  then
    AWTRACE "C2H232I AIO (async I/O) Status ${AIO}"
  fi
  AWTRACE "%%%%% aio -end- %%%%%%%%%%%"
  #++ >AW059< end *aio*-------------------------------------------------

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "Kernel"

 DBG "KERNEL 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_hmc: *col-03*H* HMC Information
######################################################################
collect_hmc ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=1  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "HMC 001"

 verbose_out "\n-=[ 03/${_maxcoll} HMC ]=-\n"
 paragraph_start "HMC"
 inc_heading_level
 #////////////////////////////////////////////////////////////////////

#
 AWCONST "\nCheck for HMC =="
 DBG "HMC 200 HMC"

 C2H_CHECK_HMC="YES"

 if [[ ${C2H_CHECK_HMC} = "YES" ]]
 then

# ToDo 281-000 ping to HMCRZA  >AW126<
# ToDo 281-000 ping to HMCRZB
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# ToDo 280-000 Set these values in external cfg file !!
 hmc1_user="hscroot"
 hmc1_pass="no_pass_use_sshkey"
 hmc1_auth="passwd"
 hmc1_status="UNKNOWN"

 hmc2_user="hscroot"
 hmc2_pass="no_pass_use_sshkey"
 hmc2_auth="passwd"
 hmc2_status="UNKNOWN"
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 DBG "HMC 201 ping HMC1"
 ping_test "HMC" ${hmc1_ip} ${hmc1_name}
 hmc1_status=${host_status}

 if [[ ${hmc1_status} = "OK" ]]
 then
   #-----------
   txt="HMC: IP=${hmc1_ip} HOSTNAME=${hmc1_name}"
   AddText "\n${txt}"
   echo "<h6>$txt<h6>" >>$HTML_OUTFILE_TEMP
#   echo "Cmd: $txt"    >>$TEXT_OUTFILE_TEMP
   #-----------
   ssh_cmd "HMC" ${hmc1_ip} ${hmc1_name} ${hmc1_auth} ${hmc1_user} ${hmc1_pass}
   hmc1_ssh=${host_status}
 fi

 DBG "HMC 202 ping HMC2"
 ping_test "HMC" ${hmc2_ip} ${hmc2_name}
 hmc2_status=${host_status}

 if [[ ${hmc2_status} = "OK" ]]
 then
   #-----------
   txt="HMC: IP=${hmc2_ip} HOSTNAME=${hmc2_name}"
   AddText "\n${txt}"
   echo "<h6>$txt<h6>" >>$HTML_OUTFILE_TEMP
#   echo "Cmd: $txt"    >>$TEXT_OUTFILE_TEMP
   #-----------
   ssh_cmd "HMC" ${hmc2_ip} ${hmc2_name} ${hmc2_auth} ${hmc2_user} ${hmc2_pass}
   hmc2_ssh=${host_status}
 fi

 else
   AWCONST "HMC check disabled !"
 fi # if C2H_CHECK_HMC

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "HMC"

 DBG "HMC 998"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_filesys: *col-04*F* Filesystem Information
######################################################################
collect_filesys ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "FILESYS 001"

 verbose_out "\n-=[ 04/${_maxcoll} Filesystems ]=-\n"
 paragraph_start "Filesystems, Dump- and Paging-configuration"
 inc_heading_level
 #////////////////////////////////////////////////////////////////////

 DBG "FILESYS 010"
 # -- FILE-SYSTEMS --
 # -- ************ --
  exec_command "lsfs -l"   "List Filesystems"
  exec_command "lsfs -q"   "List Filesystems (extended)"
  exec_command "mount"     "Mounted Filesystems"
  exec_command "df -vk"    "Filesystems and Usage"
  exec_command "du -k /home"     "Filesystems and Usage" # >AW085<
  exec_command bdf_collect "Total Used Local Diskspace" "df -Pk | count \$2, \$3, \$4"

 #lsfs -l | xargs lsattr -El <lv>  # e.g. lsattr -El hd3, better getlvcb, same info...

# ToDo 280-010 use internal functions for long command lines !
# Show as: Cmd: C2H_Function bdf_collect


  if [ "$EXTENDED" = 1 ] ; then
 AWCONS "\nAWTRACE EXTENDED START"
 AWTRACE "EXTENDED START"
     exec_command "lspv | awk '{print \$1}' | while read i; \
     do echo \"Physical Volume: \$i\"; lqueryvg -At -p \$i; echo \$SEP; done | uniq | sed '\$d'" \
        "Query Physical Volumes (EXTENDED)" "lqueryvg -At -p <pvol>"

     exec_command c2h_lspv "lspv" "lspv | awk {...}"

     # output=$(lsfs | grep '^/' | awk '{print $1}' | cut -d/ -f3 | while read i
     output=$(lsvg -l $(lsvg -o) | grep -v 'LV NAME' | grep -v '.*:' | \
     awk '{print $1}' | while read i
     do
      echo "Logical Volume: $i"
      getlvcb -AT $i | sed 's/^[ ]*	/ -/g' | grep -v '^ $'
      echo $SEP
     done)
     exec_command "echo \"\$output\" | uniq | sed '\$d'" "Get Logical Volume Control Block (EXTENDED)" "getlvcb -AT <lvol>"
 AWCONS "\nAWTRACE EXTENDED STOP"
 AWTRACE "EXTENDED STOP"
  fi

  DBG "FILESYS 020"
  # -- NFS --
  # -- *** --

  #--- start show NFS Automount files ---
  files ()
  {
     ls /etc/automount.direct 2>/dev/null # >AW123<
     ls /etc/auto.master      2>/dev/null # >AW123<
  }

  for FILE in $(files)
  do
     exec_command "cat ${FILE}" "${FILE}"
  done
  #--- end show NFS Automount files ---

  exec_command "exportfs"   "Exported NFS Filesystems"          # ToDo 281-000 explanation correct?
#AWCONS "\nAW: ls /etc/exports"
  AWX=$(ls -la /etc/exports 2>/dev/null)
  rc=$?
# RC=0 OK
# RC=2 > No NFS exports available <
  case $rc in
    0) :  # OK
       exec_command "lsnfsexp"   "Exported NFS Filesystems"          # ToDo 281-000 explanation correct? (same as exportfs)
       ;;
    2) :  # NO NFS exports
       #AWTRACE "\nC2H210W lsnfsexp /etc/exports RC="$rc" File NOT found"
       AddText "Note: No NFS exports done on this system"
       ;;
    *) AWTRACE "\nC2H211E lsnfsexp /etc/exports RC="$rc" AWX="$AWX
       ;;
  esac

 #exec_command "nfsstat -m" "Mounted Exported NFS Filesystems"  # ToDo 281-000 is option correct?
  exec_command "lsnfsmnt"   "Mounted Exported NFS Filesystems"  # ToDo 281-000 same as by MYSELF mounted fs?

  DBG "FILESYS 030"
  # -- PAGING --
  # -- ****** --
  exec_command "lsps -a"      "Paging"
  exec_command "lsps -s"      "Pageing Space uesd" # >AW133<
  exec_command "pagesize -af" "Page Size" # >AW038<
  exec_command "vmstat -s"    "Kernel paging events"

  DBG "FILESYS 040"
  # -- SYSDUMP --
  # -- ******* --
  # >AW014< AIX 5.3 -Lv / others -L
  # >AW036< AIX 6.1 Toleration
   opt=""
   case $osl in
     7100|6100|5300 ) : # OK
                 opt="-Lv"
                 ;;
     5200      ) : # OK
                 opt="-L"
                 ;;
     *         ) # OK
                 opt="-Lv"
                 ;;
   esac
  exec_command "sysdumpdev -l 2>&1" "List current value of dump devices" "sysdumpdev -l"
  exec_command "sysdumpdev -e 2>&1" "show estimated dump size" "sysdumpdev -e" # >AW133<
  # ToDo 282-007 ...show error if dump area is too small !!!
  exec_command "/usr/lib/ras/dumpcheck -p" "Check dump resources"
  exec_command "sysdumpdev ${opt} 2>&1" "Most recent system dump" "sysdumpdev ${opt}"

  DBG "FILESYS 050"
  # -- ERRPT --
  # -- ***** --
# ToDo 281-000 => *INTERNAL*
  exec_command "printf '%-10s %s %2s %s %-14s %s\n' IDENTIFIER DATE/TIMESTAMP T C RESOURCE_NAME DESCRIPTION; \
     errpt | tail +2 | awk '{printf \"%-10s %s-%s-%s %s:%s %2s %s %-14s %s %s %s %s %s %s %s %s %s %s\n\",
      \$1, substr(\$2,3,2), substr(\$2,1,2), substr(\$2,9,2), substr(\$2,5,2), substr(\$2,7,2),
      \$3, \$4, \$5, \$6, \$7, \$8, \$9, \$10, \$11, \$12, \$13, \$14, \$15}'" "Error Report" "errpt | awk {...}"
  DBG "FILESYS 051"
  exec_command c2h_errpt "Error Report" "errpt | awk {...}"
  DBG "FILESYS 052"

  DBG "FILESYS 060"
  # -- REPQUOTA --  >AW0028<
  # -- ******** --
  exec_command "repquota -a" "Display Disk Quota"  # >AW028<

  DBG "FILESYS 070"
  # -- DEFRAG --  >AW030<
  # -- ****** --
  output=""
  if [ "$EXTENDED" = 1 ]
  then
    AWCONS "\nEXTENDED defrag report currently not supported"
    # AWCONS "\nAWTRACE EXTENDED START"
    # AWTRACE "EXTENDED START"
    #     mount | grep '^ ' | egrep -v "node| /proc " | awk '{print $2}' | while read i
    #     do
    #       output="$output-- Status of $i --\n$(defragfs -r $i)\n$SEP80\n"
    #     done
    #     exec_command "echo \"\$output\" | uniq | sed '\$d' | sed '\$d'" \
    #      "Filesystem Fragmentation status (EXTENDED)" "defragfs -r <vol>"
    # AWCONS "\nAWTRACE EXTENDED STOP"
    # AWTRACE "EXTENDED STOP"
  else
    # ToDo 280-000 => *INTERNAL*
     mount | grep '^ ' | egrep -v "node| /proc " | awk '{print $2}' | while read i
     do
       output="$output-- Status of $i --\n$(defragfs -q $i)\n$SEP60\n"
     done
     exec_command "echo \"\$output\" | uniq | sed '\$d' | sed '\$d'" \
      "Filesystem Fragmentation status" "defragfs -q <vol>"
  fi

  # ToDo 000-000 ...
  # defragfs -s: Reports the fragmentation in the file system. This option causes defragfs
  #    to pass through meta data in the file system which may result in degraded performance.

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "Filesystems, Dump- and Paging-configuration"

 DBG "FILESYS 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_devices: *col-05*D* Device Information
######################################################################
collect_devices ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "DEVICES 001"

  verbose_out "\n-=[ 05/${_maxcoll} Device-Info ]=-\n"
  paragraph_start "Devices"
  inc_heading_level
 #////////////////////////////////////////////////////////////////////

  exec_command "lsdev -C -H -S a" "Available Physical Devices"
  exec_command "lsdev -C -H -S d" "Defined Physical Devices"

#++ >AW109< start *ls* (Major/Minor number)---------------------------
  # -- ls (Major/Minor number) --
  # -- *********************** --
  exec_command "ls -l /dev | grep rhdisk"     "Show Major/Minor Number of hdisks"
#++ >AW109< end *ls* (Major/Minor number)-----------------------------

#++ >AW101< start *lscfg*---------------------------------------------
# !! moved to DEVICES to free H for HMC ( s.h system.hardware ??)
  # -- lscfg --
  # -- ***** --
  exec_command "lscfg"     "Hardware Configuration"
  exec_command "lscfg -pv" "Hardware Configuration with VPD"

# ToDo 280-000 => *INTERNAL*
  exec_command "lsdev -C | while read i j; \
     do lsresource -l \$i | grep -v \"no bus resource\"; done" \
     "Display Bus Resources for available Devices" "lsresource -l <Name>"
#++ >AW101< end *lscfg*-----------------------------------------------

  if [ "$EXTENDED" = 1 ] ; then
     AWCONS "\nAWTRACE EXTENDED START"
     AWTRACE "EXTENDED START"
      DBG "DEVICES 010 ALL Physical Devices"
      exec_command "lsdev -C | sort" "All Physical Devices (EXTENDED)"       # ??
      DBG "DEVICES 011 Predefined Physical Devices"
      exec_command "lsdev -P -H" "Predefined Physical Devices (EXTENDED)"  # ????
    # exec_command "lsdev -C -H" "Customized Physical Devices (EXTENDED)"  # ????

      #-----------------------------------------------------------------------
      xxcn=$collector_name
      paragraph_start "Devices by Class"
      inc_heading_level
      #////////////////////////////////////////////////////////////////////
      DBG "DEVICES 020 Devices by Class"
      for CLASS in $(lsdev -Pr class) ; do
       exec_command "lsdev -Cc $CLASS" "Devices of Class: $CLASS (EXTENDED)"
      done
      #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
      dec_heading_level
      collector_name=$xxcn
      #-----------------------------------------------------------------------

      #-----------------------------------------------------------------------
      xxcn=$collector_name
      paragraph_start "Device Attributes"
      inc_heading_level
      #////////////////////////////////////////////////////////////////////
      DBG "DEVICES 030 Device Attributes"
      for DEV in $(lsdev -C | awk '{print $1}') ; do
       exec_command "lsattr -EHl $DEV" "Attributes of Device: $DEV (EXTENDED)"
      done
      #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
      dec_heading_level
      collector_name=$xxcn
      #-----------------------------------------------------------------------
     AWCONS "\nAWTRACE EXTENDED STOP"
     AWTRACE "EXTENDED STOP"
  fi # if EXTENDED

  DBG "DEVICES 035 lsslot"
#++ >AW058< start *lsslot*--------------------------------------------
  verbose_out "\n== lsslot =="
  exec_command "lsslot -c pci    2>/dev/null" "List all PCI hot plug slots"
  exec_command "lsslot -c pci -a 2>/dev/null" "List all available PCI hot plug slots"
  exec_command "lsslot -c phb    2>/dev/null" "List all assigned PCI Host Bridges"
  if [ "$EXTENDED" = 1 ] ; then
    AWCONS "\nAWTRACE EXTENDED START"
    AWTRACE "EXTENDED START"
    exec_command "lsslot -c phb -a 2>/dev/null" "List all available PCI Host Bridges"
    AWCONS "\nAWTRACE EXTENDED STOP"
    AWTRACE "EXTENDED STOP"
  fi
#++ >AW058< end *lsslot*-----------------------------------------------

#AWCONST "\nCheck for DEVICES =="
 DBG "TEST 050 Devices"
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# ToDo 280-888 hdiskX if "MPIO FC 2145" found in lsdev, we are using an SVC !
# ToDo 280-888 hdiskX if "IBM MPIO FC 2105" found in lsdev, we are using an ESS !
# ToDo 280-777 vscsiX if "Virtual SCSI Client Adapter" found in lsdev, we are using an VIO !
# ToDo 280-777 hdiskX if "Virtual SCSI Disk Drive" found in lsdev, we are using an VIO !
# ToDo 280-777 entX   if "Virtual I/O Ethernet Adapter" found in lsdev, we are using an VIO !
# ToDo 280-666 vio0   if "Virtual I/O Bus" found in lsdev, we are running in an LPAR !
# ToDo 280-666 vsaX   if "LPAR Virtual Serial Adapter" found in lsdev, we are running in an LPAR !
# ToDo 280-777 Note! vsa0 must not be present
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  mpio_2145=$(lsdev | grep 'MPIO FC 2145')  # SVC
  rc_2145=$?
  mpio_2105=$(lsdev | grep 'MPIO FC 2105')  # ESS/Shark
  rc_2105=$?
  mpio_vdisk=$(lsdev | grep 'Virtual SCSI Disk Drive') # VIO-SCSI-Device
  rc_vdisk=$?
  mpio_vscsi=$(lsdev | grep 'Virtual SCSI Client Adapter') # VIO-SCSI Adapter
  rc_vscsi=$?
  mpio_vbus=$(lsdev | grep 'Virtual SCSI Disk Drive') # VIO-Bus
  rc_vbus=$?
  mpio_veth=$(lsdev | grep 'Virtual SCSI Disk Drive') # VIO-ETH
  rc_veth=$?
  mpio_vsa=$(lsdev | grep 'LPAR Virtual Serial Adapter') # LPAR Virtual Serial Adapter
  rc_vsa=$?
  if [[ $rc_2145 = 0 ]]  ; then AWTRACE "SVC devices found" ; fi
  if [[ $rc_2105 = 0 ]]  ; then AWTRACE "ESS devices found" ; fi
  if [[ $rc_vdisk = 0 ]] ; then AWTRACE "VDISK devices found" ; fi
  if [[ $rc_vscsi = 0 ]] ; then AWTRACE "VSCSI adapter found" ; fi
  if [[ $rc_vbus = 0 ]]  ; then AWTRACE "VBUS  devices found" ; fi
  if [[ $rc_veth = 0 ]]  ; then AWTRACE "VETH  devices found" ; fi
  if [[ $rc_vsa = 0 ]]   ; then AWTRACE "VSA   devices found" ; fi

  #AWTRACE "%%%%% Device Check 2145(SVC),2105(ESS) -start- %%%%%%%%%"
  # ESS - 2105
  # SVC - 2145
  # DS4000 - 1722,1724,1742,1814,815
  # DS5000 - 1818
  # DS6000 - 1750
  # DS8000 - 2107
  mpio_2145=$(lsdev | grep 'MPIO FC 2145') # SVC
  rc_2145=$?
  mpio_2105=$(lsdev | grep 'MPIO FC 2105') # ESS
  rc_2105=$?
  mpio_2107=$(lsdev | grep 'MPIO FC 2107') # DS8000
  rc_2107=$?
  mpio_1750=$(lsdev | grep 'MPIO FC 1750') # DS6000
  rc_1750=$?
  mpio_1818=$(lsdev | grep 'MPIO FC 1818') # DS5000
  rc_1818=$?
  mpio_vscsi=$(lsdev | grep 'Virtual SCSI Disk Drive')
  rc_vscsi=$?
  if [[ $rc_2145 = 0 ]]  ; then AWTRACE "SVC devices found" ; fi
  if [[ $rc_2105 = 0 ]]  ; then AWTRACE "ESS devices found" ; fi
  if [[ $rc_2107 = 0 ]]  ; then AWTRACE "DS8000 devices found" ; fi
  if [[ $rc_1750 = 0 ]]  ; then AWTRACE "DS6000 devices found" ; fi
  if [[ $rc_1818 = 0 ]]  ; then AWTRACE "DS5000 devices found" ; fi
  if [[ $rc_vscsi = 0 ]] ; then AWTRACE "VSCSI devices found" ; fi
  #AWTRACE "RC 2145=${rc_2145} 2105=${rc_2105}"
  #AWTRACE "%%%%% Device Check 2145(SVC),2105(ESS) -end- %%%%%%%%%%%"

#::::::::::::::::::::::::::::
  DBG "DEVICES 036 Tape info"
#::::::::::::::::::::::::::::

#++ >AW097< start *Tape info*---------------------------------------------
# !! ... ( d.t devices.tape ??)
  verbose_out "\n== Tape info =="

  AWTRACE "...checking for ATape driver"
  ATAPE="NO"
  fileset="Atape.driver"
  lslpp -l ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|awk '{print $2}'|while read vv
  do
    atape_installed=${vv}
  done
#
  atape_base_u=$(lslpp -l ${fileset} 2>/dev/null)
  atape_base=$(lslpp -l ${fileset} >/dev/null 2>&1)
  atape_rc=$?
  if [[ ${atape_rc} = 0 ]]
  then
    ATAPE="YES"
    AWTRACE "C2H120I Atape found: ${atape_installed}"
    # ToDo 281-000 check version.release
    # ToDo 281-000 if r < new_r => new_r available
    # ToDo 281-000 if v < new_v => new_v available
    # ToDo 281-000 if v = new_v AND r=new_r => latest known by this script. Check FTP-Site
    # ToDo 281-000 10.6.1.0 min for AIX 6.1
    # ToDo 281-000 11.6.0.0 latest as of 07/23/09
  else
    ATAPE="NO"
    AWTRACE "C2H121I Atape NOT found"
  fi

  lsdev -Cc tape | awk '{print $1}' | while read rmt;
  do
    exec_command "lscfg -vl $rmt" "Tape $rmt info"
    exec_command "lsattr -l $rmt -E" "CURRENT attributes of tape $rmt"
    exec_command "lsattr -l $rmt -D" "DEFAULT attributes of tape $rmt"
  done
#++ >AW097< end *Tape info*-----------------------------------------------

#::::::::::::::::::::::::::
  DBG "DEVICES 040 DASD"
#::::::::::::::::::::::::::

  DBG "DEVICES 040 Physical Volumes"
  exec_command "lspv" "Physical Volumes"

  # >AW306< BUG: ignore newly created devices which do not have a PVID (PVID is none)
  # >AW311< BUG: ignore newly created devices which do not belong to a VG (VG is None)
  # new device is "none None" or "00000000 None" so grep for "None" with Capital "N"
# ToDo 280-000 => *INTERNAL*
  DBG "DEVICES 041"
  exec_command "lspv | grep -v None | awk '{print $1}' | while read hd ; \
      do lspv \$hd; echo \$SEP90; done | uniq | sed '\$d'" "Physical Volumes per Volume Group" "lspv <hdisk>"

  # >AW306< BUG: ignore newly created devices which do not have a PVID (PVID is none)
  # >AW311< BUG: ignore newly created devices which do not belong to a VG (VG is None)
# ToDo 280-000 => *INTERNAL*
  DBG "DEVICES 042"
  exec_command "lspv | grep -v None | awk '{print $1}' | while read hd ; \
      do lspv -p \$hd; echo \$SEP100; done | uniq | sed '\$d'" "Layout Physical Volumes" "lspv -p <hdisk>"

   #----------------------------------------------------------------------------
   # [AIX433] /tmp # getlvodm -w
   # getlvodm: A flag requires a parameter: w
   # Usage: getlvodm [-a LVdescript] [-B LVdesrcript] [-b LVid] [-c LVid]
   #         [-C] [-d VGdescript] [-e LVid] [-F] [-g PVid] [-h] [-j PVdescript]
   #         [-k] [-L VGdescript] [-l LVdescript] [-m LVid] [-p PVdescript]
   #         [-r LVid] [-s VGdescript] [-t VGid] [-u VGdescript] [-v VGdescript]
   #         [-w VGid] [-y LVid] [-G LVdescript]
   # [AIX433] /tmp #
   #
   # getlvodm -C ( == +/- lspv)      # ToDo 282-000: ...
   # getlvodm -u | -d | -v | -L <vg> # ToDo 282-000: ...
   #----------------------------------------------------------------------------

# ToDo 280-000 => *INTERNAL*
  DBG "DEVICES 043"
   lsvg | while read vg
   do
      lvs=$(\
       lsvg -l $vg | egrep -v ':$|^LV' | awk '{print $1}' | while read lv
       do
          lslv -l $lv
          echo $SEP70
       done)
      exec_command "echo \"\$lvs\" | uniq | sed '\$d'" "List Volume Distribution: $vg" "lslv -l <lvol>"
   done
#----
# ToDo 280-000 => *INTERNAL*
  DBG "DEVICES 044"
   h2p=$(\
      for i in $(lsdev -Csssar -thdisk -Fname)
      do
       echo $i" ---> "$(ssaxlate -l $i 2>&1)
      done)
   exec_command "echo \"\$h2p\"" "Mapping of hdisk to pdisk" \
      "lsdev -Csssar -thdisk -Fname | ssaxlate -l <dev>"

# ToDo 280-000 => *INTERNAL*
  DBG "DEVICES 045"
   p2h=$(\
      for i in $(lsdev -Csssar -cpdisk -Fname)
      do
       echo $i" ---> "$(ssaxlate -l $i 2>&1)
      done)
   exec_command "echo \"\$p2h\"" "Mapping of pdisk to hdisk" \
      "lsdev -Csssar -cpdisk -Fname | ssaxlate -l <dev>"

# ToDo 280-000 => *INTERNAL*
  DBG "DEVICES 046"
   conndata=$(\
      for pdisk in $(lsdev -Csssar -cpdisk -Fname)
      do
       for adap in $(ssaadap -l $pdisk 2>/dev/null)
       do
         ssaconn -l $pdisk -a $adap
       done
      done)
   exec_command "echo \"\$conndata\"" "SSA Connection Data" \
      "lsdev -Csssar -cpdisk -Fname | ssaadap -l <pdisk>"

  DBG "DEVICES 050 SDD/SDDPCM MPIO"
#++ >AW060< start *sdd*-----------------------------------------------
  DBG "DEVICES SDD 051"
  verbose_out "\n== SDD/SDDPCM =="
  #AWTRACE "%%%%% SDD/SDDPCM -start- %%%%%%%%%"

  SDD="NO"
  SDDPCM="NO"

  exec_command "lslpp -lc | grep mpio"     "SDD: lslpp mpio"
  exec_command "lslpp -lc | grep .sdd"     "SDD: lslpp .sdd"

  DBG "DEVICES SDD 052"
  sdd_old_u=$(lslpp -l | grep devices.sdd.[567] | uniq)
  sdd_old_inst=$(echo "$sdd_old_u" | awk '{print $2}')
  sdd_old=$(lslpp -l | grep devices.sdd.[567])
  sdd_rc=$?
  if [[ $sdd_old = "" ]]
  then
    sdd_old="Not Installed"
  fi
  if [[ $sdd_rc = 0 ]]
  then
    SDD="YES"
    txt="\nC2H270I You are using SDD [ ${sdd_old_u} ]"
    #AWTRACE ${txt}
    AWTRACE "C2H272I SDD installed: ${sdd_old_inst}";
    exec_command "datapath query adapter"    "SDD: q adapter"
    exec_command "datapath query wwpn"       "SDD: q wwpn"
    exec_command "datapath query adaptstats" "SDD: q adaptstats"
    exec_command "datapath query portmap"    "SDD: q portmap"
    exec_command "datapath query essmap"     "SDD: q essmap"
    exec_command "datapath query device"     "SDD: q device"
    exec_command "datapath query devstats"   "SDD: q devstats"
  else
    dummy=dummy
    AWTRACE "SDD sdd_rc=${sdd_rc} sdd_old=${sdd_old}"
  fi

  DBG "DEVICES SDD 053"
  sdd_pcm_u=$(lslpp -l | grep devices.sddpcm.[567] | uniq)
  sdd_pcm_inst=$(echo "$sdd_pcm_u" | awk '{print $2}')
  sdd_pcm=$(lslpp -l | grep devices.sddpcm.[567])
  pcm_rc=$?
  if [[ $sdd_pcm = "" ]]
  then
    sdd_pcm="Not Installed"
  fi
  if [[ $pcm_rc = 0 ]]
  then
    SDDPCM="YES"
    txt="\nC2H271I You are using SDDPCM [ ${sdd_pcm_u} ]"
    #AWTRACE ${txt}
    AWTRACE "C2H273I SDDPCM installed: ${sdd_pcm_inst}";
    exec_command "pcmpath query version"    "SDDPCM: q version"
    AWTRACE "EXECRC=${execrc}"
    exec_command "pcmpath query adapter"    "SDDPCM: q adapter"
    exec_command "pcmpath query wwpn"       "SDDPCM: q wwpn"
    exec_command "pcmpath query adaptstats" "SDDPCM: q adaptstats"
    exec_command "pcmpath query portmap"    "SDDPCM: q portmap"
    exec_command "pcmpath query essmap"     "SDDPCM: q essmap"
    exec_command "pcmpath query device"     "SDDPCM: q device"
    exec_command "pcmpath query devstats"   "SDDPCM: q devstats"
  else
    dummy=dummy
    AWTRACE "SDDPCM pcm_rc=${pcm_rc} sdd_pcm=${sdd_pcm}"
  fi

# ToDo 000-000 check sddpcm version (2.4.0.3)
# ToDo 000-000 check sddpcm version (2.5.0.0)
# ToDo 000-000 check for problem S1003579 (as of 10/13/09)
# ToDo 000-000 SDDPCM 2405 with host attach 1.0.0.17
# ToDo 000-000 SDDPCM 2501 with host attach 1.0.0.19

# check HOSTATTACHMENT
  DBG "DEVICES SDD 054"
  HOSTATT="INIT"
  # instead of "echo ... IFS" also "...uniq|awk -F":"'{print $2}'|..."
  # possible
  fileset="devices.fcp.disk.ibm.mpio.rte" # IBM MPIO FCP Disk Device
  lslpp -lc ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|while read line
  do
    echo ${line} | IFS=":" read a b c d e f g h i
    hostatt_installed=${c}
  done
#
  hostatt_base_u=$(lslpp -l ${fileset} 2>/dev/null)
  hostatt_base=$(lslpp -l ${fileset} >/dev/null 2>&1)
  hostatt_rc=$?
  #ERRMSG "HOSTATT_BASE RC=${hostatt_rc}"
  case $hostatt_rc in
  0 )
    HOSTATT="YES"
    AWTRACE "C2H274I HOSTATTACHMENT installed: ${hostatt_installed}";
    #AWTRACE "${hostatt_base_u}";
    ;;
  1 )
    HOSTATT="NO"
    AWTRACE "C2H275W HOSTATTACHMENT NOT installed RC=${hostatt_rc}";
    ;;
  * )
    HOSTATT="UNKNOWN"
    AWTRACE "C2H276E HOSTATTACHMENT error RC=${hostatt_rc}";
    ;;
  esac

  # ToDo 281-000 1.0.0.16 latest as of 07/23/09

# Only "SDD" OR "SDDPCM" possible. Not BOTH !
  DBG "DEVICES SDD 055"
  if [[ "$SDD" = "YES" && "$SDDPCM" = "YES" ]]
  then
    txt="\nC2H900I Internal error checking SDD/SDDPCM";
    echo ${txt}
    AddText ${txt}
    ERRMSG ${txt}
    txt="\nC2H252I SDD=${SDD} SDDPCM=${SDDPCM}";
    echo ${txt}
    AddText ${txt}
    ERRMSG ${txt}
  fi

  if [[ "$SDD" = "NO" && "$SDDPCM" = "NO" ]]
  then
    AWTRACE "C2H253I neither SDD nor SDDPCM installed"
  fi

  if [[ "$SDD" = "YES" ]]
  then
    exec_command "datapath query adapter"   "SDD: q adapter"
  fi
  if [[ "$SDDPCM" = "YES" ]]
  then
    exec_command "pcmpath query adapter"    "SDDPCM: q adapter"
  fi

  #AWTRACE "%%%%% SDD/SDDPCM -end- %%%%%%%%%%%"
#++ >AW060< end *sdd*-------------------------------------------------
  DBG "DEVICES SDD 056"


  DBG "DEVICES 060 IBM ESS"
#++ >AW074< start *IBM ESS*-------------------------------------------
# ToDo 281-000 (d.e devices.ESS ??)
  verbose_out "\n== IBM ESS =="

  AWTRACE "...checking for IBM ESS"
  IBMESS="NO"
  exec_command "lslpp -lc | grep .ibm2105" "SDD: lslpp .ibm2105"
  exec_command "lslpp -lc | grep essutil"  "SDD: lslpp essutil"
  exec_command "lslpp -lc | grep ibmcim"   "SDD: lslpp ibmcim"

  essutil=$(lslpp -l | grep essutil)
  ess_rc=$?
  if [[ $ess_rc = 0 ]]
  then
    IBMESS="YES"
  else
    IBMESS="NO"
    AWTRACE "C2H121I IBM ESS (Shark) Not Found !"
  fi

  if [[ "$IBMESS" = "YES" ]]
  then
    exec_command "lsess"    "ESS: lsess"
    exec_command "ls2105"   "ESS: ls2105"
    exec_command "lssdd"    "ESS: lssdd"
    exec_command "lsvp -a"  "ESS: lsvp -a"
    exec_command "lsvp -d"  "ESS: lsvp -d"
    exec_command "lsvp | grep -i none" "ESS: Unused DASD"  # >AW086<
    exec_command "lsvp | sort vg hd"   "ESS: Dasd sorted by VG, hdisk" # >AW086<
  fi

# Note: *SDDPCM* 2105=ESS / 1750=DS6000 / 2107=DS8000
#       *SDD*    2105=ESS / 2105F=ESS F models / 2105800=ESS 800 model
#       *SDD*    2145=SVC / 2062=SVCCISCO

#++ >AW074< end *IBM ESS*---------------------------------------------

  DBG "DEVICES 070 FAStT"
#++ >AW066< start *FAStT*---------------------------------------------
# ToDo 281-000 (d.e devices.FAStT ??)
  verbose_out "\n== FAStT =="

  AWTRACE "...checking for FAStT"
  FASTT="NO"
  sm_rt=$(lslpp -l | grep SMruntime.aix. >/dev/null 2>&1)
  smr_rc=$?
  if [[ $smr_rc = 0 ]]
  then
    FASTT="YES"
    ERRMSG "\nC2H131I You have SMruntime installed [ ${sm_rt} ]"
  else
    FASTT="NO"
    AWTRACE "C2H121I FAStT Not Found !"
    # AWTRACE "SMruntime smr_rc=${smr_rc} sm_rt=${sm_rt}"
  fi

  if [[ "$FASTT" = "YES" ]]
  then
    sm_cl=$(lslpp -l | grep SMclient.aix. >/dev/null 2>&1)
    smc_rc=$?
    if [[ $smc_rc = 0 ]]
    then
      ERRMSG "\nC2H141I You have SMclient installed [ ${sm_cl} ]"
    else
      AWTRACE ": SMclient smc_rc=${smc_rc} sm_cl=${sm_cl}"
    fi

    sm_ag=$(lslpp -l | grep SMagent.aix. >/dev/null 2>&1)
    sma_rc=$?
    if [[ $sma_rc = 0 ]]
    then
      ERRMSG "\nC2H142I You have SMagent installed [ ${sm_ag} ]"
    else
      AWTRACE ": SMagent sma_rc=${sma_rc} sm_ag=${sm_ag}"
    fi

    exec_command "lsattr -El dar0 2>/dev/null" "FAStT dar0"
    exec_command "lsattr -El dac0 2>/dev/null" "FAStT dac0"

    exec_command "fget_config -A" "Show FAStT configuration"
  fi

#++ >AW066< end *FAStT*-----------------------------------------------

  DBG "DEVICES 080 HDS/Hitachi (HDLM)"
#++ >AW070< start *HDS/Hitachi (HDLM) *-------------------------------
# ToDo 281-000 (d.M devices.HDLM ??)
  verbose_out "\n== HDS/Hitachi (HDLM) =="

  AWTRACE "...checking for HDS/Hitachi (HDLM)"
  HDS="YES"

  if [ -x /usr/DynamicLinkManager/bin/dlmodmset ]
  then
    HDS="YES"
  else
    HDS="NO"
    AWTRACE "C2H121I HDS dlmodmset Not Found !"
  fi

  if [[ "$HDS" = "YES" ]]
  then
    exec_command "/usr/DynamicLinkManager/bin/dlmodmset -o" "HDLM Execution Environment (dlmodmset)"

    exec_command "/usr/DynamicLinkManager/bin/dlmchkdev"    "HDLM Checking the Device Configuration (dlmchkdev)"

    exec_command "/usr/DynamicLinkManager/bin/dlnkmgr view -sys" "HDLM Configuration"

    exec_command "/usr/DynamicLinkManager/bin/dlnkmgr view -lu -item all" "Hitachi Disks Configuration"
  fi

#++ >AW070< end *HDS/Hitachi*-----------------------------------------

  DBG "DEVICES 090 EMC PowerPath"
#++ >AW071< start *EMC PowerPath*-------------------------------------
# ToDo 281-000 (d.e devices.emc ??)
  verbose_out "\n== EMC PowerPath =="

  AWTRACE "...checking for EMC/Powerpath"
  EMC="NO"

  if [ -x /usr/sbin/powermt ]
  then
    EMC="YES"
  else
    AWTRACE "C2H121I EMC/Powerpath powermt Not Found !"
  fi

  if [[ "$EMC" = "YES" ]]
  then
    exec_command "/usr/sbin/powermt display dev=all" "EMC PowerPath"
  fi

#++ >AW071< end *EMC PowerPath*---------------------------------------

  DBG "DEVICES 100 VERITAS"
#++ >AW072< start *Veritas*-------------------------------------------
# ToDo 281-000 (d.v devices.veritas ??)
  verbose_out "\n== Veritas VolumeManager =="

  AWTRACE "...checking for Veritas VolumeManager"
  VxVM="NO"
#
# txt="\nC2H160I Veritas - Don't know how to check ! Please help."
# AWTRACE ${txt}
# ERRMSG  ${txt}
# verbose_out ${txt}
#

# ToDo 280-006 CHECK for VxVM missing !!!
  if [ -x /usr/sbin/vxdisk ]
  then
    VxVM="YES"
  else
    VxVM="NO"
    AWTRACE "C2H121I Veritas VxVM Not Found !"
  fi

  if [[ "$VxVM" = "YES" ]]
  then
   exec_command "/usr/sbin/vxdisk list" "VxVM Physical Volumes"

   exec_command "/usr/sbin/vxdg -q list" "VxVM Volumegroup Overview"

   exec_command "/usr/sbin/vxprint -ht" "VxVM Volumegroup Details"

   exec_command "df -vk | grep Filesystem ;df -vk | grep /dev/vx" "VxVM Volumes"

   for i in `/usr/sbin/vxdg -q list | awk '{ print $1 }'`
   do
     #exec_command "echo '\nVolumegroup $i';/usr/sbin/vxstat -g $i" "Veritas Volume Statistic"
      exec_command "/usr/sbin/vxstat -g $i" "VxVM Volume Statistic: VG $i"
   done
  fi
#++ >AW072< end *Veritas*---------------------------------------------

  DBG "DEVICES 110 VCS"
#++ >AW072< start *VCS*-----------------------------------------------
# ToDo 281-000 (d.v devices.vcs ??)
# !! moved to DEVICES to free c for xxx ( d.c devices.VCS ??)
  verbose_out "\n== VCS =="

  AWTRACE "...checking for Veritas ClusterServer"
  VCS="NO"
#
# txt="\nC2H162I VCS - Don't know how to check ! Please help."
# AWTRACE ${txt}
# ERRMSG  ${txt}
# verbose_out ${txt}
#

# ToDo 280-006 CHECK for VCS missing !!!
  if [ -x /opt/VRTSvcs/bin/hastart ]
  then
    VCS="YES"
  else
    VCS="NO"
    AWTRACE "C2H121I Veritas VCS Not Found !"
  fi

  if [[ "$VCS" = "YES" ]]
  then
   exec_command "/sbin/lltstat -vvn" "LLT - Status"

   exec_command "/sbin/gabconfig -a" "GAB - Status"

   exec_command "/opt/VRTSvcs/bin/hastatus -summary" "VCS - Status"

   exec_command "cat /etc/VRTSvcs/conf/config/main.cf" "VCS - main.cf"

   exec_command "cat /etc/VRTSvcs/conf/config/types.cf" "VCS - types.cf"
  fi
#++ >AW072< end *VCS*-------------------------------------------------

#::::::::::::::::::::::::::
  DBG "DEVICES 200 PRINTER"
#::::::::::::::::::::::::::

#++ >AW125< end *PRINTER* --------------------------------------------
# !! moved to DEVICES to free P for xxx ( d.p devices.printer ??)
  verbose_out "\n== PRINTER =="

  AWTRACE "...checking for PRINTER"
# ToDo 281-000 PRINTER

# Note: this may be a long running task, if remote printers do not answer

#exec_command "lpstat -s"  "Configured printers"  # ToDo 281-000 ?? ( == enq -A)
 exec_command "lpq"        "AWTEST Printer"       # ToDo 281-000 check
 exec_command "qchk -W -q" "Default printer"
 exec_command "qchk -W -A" "Printer Status"
#lsallq / lsque ... # ToDo 281-000
#++ >AW125< end *PRINTER* --------------------------------------------

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "Devices"

 DBG "DEVICES 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_lvm: *col-06*L* LVM - Logical Volume Manager Information
######################################################################
collect_lvm ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG "LVM 001"

 verbose_out "\n-=[ 06/${_maxcoll} LVM-Info ]=-\n"
 paragraph_start "LVM"
 inc_heading_level
 #////////////////////////////////////////////////////////////////////

 DBG "LVM 010 lsvg"
# ToDo 280-000 => *INTERNAL*
  exec_command "lsvg -o | lsvg -i | sed \"s/^\$/$SEP80/\"" "Volume Groups" "lsvg -o | lsvg -i"
 DBG "LVM 011 lsvg"
  exec_command "lsvg -o | xargs lsvg -p" "Volume Group State"
 DBG "LVM 012 lsvg"
# ToDo 280-000 => *INTERNAL*
  exec_command "lsvg | while read i; do \
     lsvg -l \$i; echo \$SEP80; done | uniq | sed '\$d'" "Logical Volume Groups" "lsvg -l <vg>"
#%%%%%%%%%DEVELOPMENT-ONLY%%%%%%%%%
 if [[ $AWDEBUG == 1 ]]; then
   : # DO NOT EXECUTE DURING DEBUGGING
   AWTRACE "PrtLayout - Disabled during debugging"
 else
  DBG "LVM 020 PrtLayout"
  exec_command PrtLayout "Print Disk Layout" # WARNING: LONG RUNNING
  DBG "LVM 030 PrintLVM"
  exec_command PrintLVM "List Volume Groups" # WARNING: LONG RUNNING
 fi;
#%%%%%%%%%DEVELOPMENT-ONLY%%%%%%%%%

 DBG "LVM 040 lsvg -l"
# ToDo 280-000 => *INTERNAL*
  output=$(lsvg | while read vg
  do
     echo --------------------------------
     echo "   Volume Group: $vg"
     echo --------------------------------
     lsvg -l $vg | egrep -v ":$|^LV" | while read lv rest; do lslv $lv; echo $SEP100; done | uniq | sed '$d'
  done)
  exec_command "echo \"\$output\"" "List Logical Volumes" "lslv <lvol>"  # ToDo 000-000 make it nicer

  if [ "$EXTENDED" = 1 ] ; then
    AWCONS "\nAWTRACE EXTENDED START"
    AWTRACE "EXTENDED START"
    DBG "LVM 050 lsvg"
# ToDo 280-000 => *INTERNAL*
     output=$(lsvg | while read vg
     do
      echo --------------------------------
      echo "   Volume Group: $vg"
      echo --------------------------------
      lsvg -l $vg | egrep -v ":$|^LV" | while read lv rest; \
         do lslv -m $lv | head; echo $SEP; done | uniq | sed '$d'
     done)
     exec_command "echo \"\$output\"" "List Logical/Physical Partition number (first 10 lines) (EXTENDED)" \
      "lslv -m <lv> | head"

     exec_command "lsvg | while read i; do \
      lsvg -M \$i; echo \$SEP; done | uniq | sed '\$d'" "List Logical Volume on Physical Volume (EXTENDED)" "lsvg -M <vg>"
   AWCONS "\nAWTRACE EXTENDED STOP"
   AWTRACE "EXTENDED STOP"
  fi

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "LVM"

 DBG "LVM 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_user: *col-07*U* User & Group Information
######################################################################
collect_user ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "USER 001"

  verbose_out "\n-=[ 07/${_maxcoll} User-Info ]=-\n"
  paragraph_start "Users & Groups"
  inc_heading_level
 #////////////////////////////////////////////////////////////////////

  exec_command "lsuser -f -a rlogin ALL|egrep -p "rlogin=true"|egrep -p -v '(^iz|^y|^is)'" "Rlogin enabled by Systemuser" # >CP001< add

  L40="----------------------------------------"
  exec_command "printf '%-10s %6s %-s\n' Name Id Home &&
     echo $L40 &&
      lsuser -c -a id home ALL | sed '/^#/d' |
         awk -F: '{printf \"%-10s %6s %-s\n\", \$1, \$2, \$3}'" \
     "Display User Account Attributes" "lsuser -c -a id home ALL"

  L80=${L40}""${L40}
  exec_command "printf '%-10s %6s %-6s %-8s %-s\n' Name Id Admin Registry Users &&
     echo $L80 &&
      lsgroup -c ALL | grep -v '^#' |
         awk -F: '
            NF==4 {printf \"%-10s %6s %-6s %-8s\n\", \$1, \$2, \$3, \$4}
            NF==5 {printf \"%-10s %6s %-6s %-8s %-s\n\", \$1, \$2, \$3, \$5, \$4}'" \
     "Display Group Account Attributes" "lsgroup -c ALL"

  exec_command "lsrole -f ALL | grep -v '=$'" "Display role attributes"

  # >AW043< tcbchk removed
  # -- TCB --
  # -- *** --
  # ToDo 000-000 move this to SYSTEM ??
  #AWTRACE ": tcbck -n ALL **"
  #exec_command "tcbck -n ALL" "Lists the security state of the system"

  # -- PASSWD --  # >AW029<
  # -- ****** --
  exec_command "cat /etc/passwd | \
     sed 's&:.*:\([-0-9][0-9]*:[-0-9][0-9]*:\)&:x:\1&'" "/etc/passwd" "cat /etc/passwd"  # ?????
  exec_command "cat /etc/group" "cat /etc/group" # >AW133<

  exec_command "pwdck -n ALL 2>&1" "Errors found in authentication" "pwdck -n ALL"
  exec_command "usrck -n ALL 2>&1" "Errors found in passwd" "usrck -n ALL"

  exec_command "cat /etc/group" "/etc/group"
  exec_command "grpck -n ALL 2>&1" "Errors found in group" "grpck -n ALL"

  # sysck -i -Nv  # ...
  # sysck: Checks the inventory information during installation and update procedures.

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "Users & Groups"

 DBG "USER 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_network: *col-08*N* Network Information
######################################################################
collect_network ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "NETWORK 001"

  verbose_out "\n-=[ 08/${_maxcoll} Network-Info ]=-\n"
  paragraph_start "Network Settings"
  inc_heading_level
 #////////////////////////////////////////////////////////////////////

  exec_command "netstat -in" "List of all IP addresses"
  # >AW303< BUG: sed will convert also for *.TXT output file, which is not necessary
  # >AW303< BUG: en0: flags=4e080863,80&lt;UP,BROADCAST,NOTRAILERS,RUNNING,SIMPLEX,MULTICAST,GROUPRT,64BIT,PSEG,CHAIN&gt;
  exec_command "netstat -taun" "List of Ports in use" # >GL02<

  exec_command "lsdev -Cc if" "List of all interfaces" # >AW098<
  exec_command "ifconfig -a" "Display information about all network interfaces"

  #++ >MP002< start *ethchan/vlan* -----------------------------------
  DBG "NETWORK 090"
  #########################################################################
  # START Addon MPH/BIT 19.03.2009
  output=$(ETHCHAN=`lsdev -Cc adapter -s pseudo -t ibm_ech -F name`
           if [ -n "${ETHCHAN}" ]
           then
             for i in ${ETHCHAN}
             do
                INTERFACE=`echo ${i} | sed 's/t//g'`
                IPADDR=`lsattr -El ${INTERFACE} | grep "^netaddr " | awk ' { print $2 } '`
                echo "${i} - ${IPADDR}"
                lsattr -El ${i} -F "   attribute value" |\
                  grep -e adapter_names -e backup_adapter -e auto_recovery -e netaddr -e mode| sed 's/netaddr  /ping_addr/'
                echo "   `entstat -d ${i} | grep 'Active channel' | sed 's/:/ /g'`"
                echo
             done
           else
             echo
             echo "   No Etherchannel is defined!"
             echo
           fi)
  exec_command "echo \"\$output\"" "Display information about all etherchannel interfaces"

  output=$(if [ "`lsdev -s vlan | awk '{print $1}'`" != "" ]
           then
           lsdev -s vlan | awk '{print $1}' | while read adapter
           do
             echo Adapter: $adapter
             lsattr -El $adapter
             echo
           done
           else
             echo "   No VLAN-adapter is defined!"
           fi)
  exec_command "echo \"\$output\"" "Display information about all VLANs on network interfaces"
  # END Addon MPH/BIT 19.03.2009
  #########################################################################
  #++ >MP002< end *ethchan/vlan* -------------------------------------

  #++ >CP001< start *lsdev* ------------------------------------------
  DBG "NETWORK 100"
  output=$(for i in $(lsdev -C -S a -F 'name'|grep en[0-9])
           do
              echo "$i:"
              entstat -d $i |egrep -i "Media|Status"
              entstat_rc=$?
# ToDo 281-000 ADD ERROR HANDLING
              ERRMSG  "AWDBG001I entstat RC=${entstat_rc}"
              ERRMSG  "AWDBG000I Sorry, ERROR Handling for entstat missing"
              AWCONST "AWDBG001I entstat RC=${entstat_rc}"
              AWCONST "AWDBG000I Sorry, ERROR Handling for entstat missing"
           done)
  exec_command "echo \"\$output\"" "Adapter Modes"
  #++ >CP001< end *lsdef* --------------------------------------------

  exec_command "no -a"       "Display current network attributes in the kernel"
  exec_command "nfso -a"     "List Network File System (NFS) network variables"

  DBG "NETWORK 150"
  # >AW303< BUG: sed will convert also for *.TXT output file, which is not necessary
  # >AW303< BUG: 10.30.0.0        aixw              UHSb      0        0  en0     -   -      -   =&gt;
  exec_command "netstat -r"  "List of all routing table entries by name"
  # >AW303< BUG: sed will convert also for *.TXT output file, which is not necessary
  # >AW303< BUG: 10.30.0.0        10.30.8.130       UHSb      0        0  en0     -   -      -   =&gt;
  exec_command "netstat -nr" "List of all routing table entries by IP-address"

  if [ "$EXTENDED" = 1 ] ; then
 AWCONS "\nAWTRACE EXTENDED START"
 AWTRACE "EXTENDED START"
     exec_command "netstat -an" "Show the state of all sockets (EXTENDED)"
     exec_command "netstat -An" "Show the address of any PCB associated with the sockets (EXTENDED)"
 AWCONS "\nAWTRACE EXTENDED STOP"
 AWTRACE "EXTENDED STOP"
  fi

  DBG "NETWORK 200"
  exec_command "netstat -s"  "Show statistics for each protocol"
  exec_command "netstat -sr" "Show the routing statistics"
  exec_command "netstat -v"  "Show statistics for CDLI-based communications adapters"
  exec_command "netstat -m"  "Show statistics recorded by memory management routines"
  exec_command "netstat -c"  "Show statistics" # >AW133<

  # ToDo 000-000 ...
  # output=$(entstat -d)
  # output=$(tokstat -d)
  # output=$(atmstat -d)
  # if [ $? != 0 ] ; then
  #    exec_command "echo \"\$output\"" "Show Asynchronous Transfer Mode adapters statistics" "XXXstat -d"
  # fi

  DBG "NETWORK 250"
  # -- NFS --
  # -- *** --
  exec_command "nfsstat" "Show NFS statistics"

  DBG "NETWORK 300"
  # -- RPC --
  # -- *** --
  if [ "$EXTENDED" = 1 ] ; then
 AWCONS "\nAWTRACE EXTENDED START"
 AWTRACE "EXTENDED START"
     exec_command "rpcinfo" "Display a List of Registered RPC Programs (EXTENDED)"
 AWCONS "\nAWTRACE EXTENDED STOP"
 AWTRACE "EXTENDED STOP"
  else
     exec_command "rpcinfo -p" "Display a List of Registered RPC Programs"
  fi
  exec_command "rpcinfo -m; echo \$SEP60; rpcinfo -s" "Display a List of RPC Statistics" \
     "rpcinfo -m; rpcinfo -s"


  DBG "NETWORK 350"
  # -- DNS --
  # -- *** --
  exec_command "lsnamsv -C 2>&1" "DNS Resolver Configuration" "lsnamsv -C"  # = /etc/resolv.conf
  exec_command "namerslv -s"     "Display all Name Server Entries"

  if [ "$EXTENDED" = 1 ] ; then
 AWCONS "\nAWTRACE EXTENDED START"
 AWTRACE "EXTENDED START"
     exec_command "nslookup $(hostname) 2>&1" "Nslookup hostname (EXTENDED)" "nslookup $(hostname)"
 AWCONS "\nAWTRACE EXTENDED STOP"
 AWTRACE "EXTENDED STOP"
  fi

  DBG "NETWORK 400"
  # -- NIS --
  # -- *** --
  NIS="INIT"
  ypwhich >/dev/null 2>&1
  nis_rc=$?
  if [[ $nis_rc = 0 ]]
  then
    NIS="YES"
    exec_command "domainname"      "NIS Domain Name"
    exec_command "ypwhich"         "NIS Server currently used"
    exec_command "lsclient -l"     "NIS Client Configuration"
  else
    NIS="NO"
    AWTRACE "C2H164W NIS n/a or not configured!"
  fi

  DBG "NETWORK 450"
  # -- other --
  # -- ***** --

  # show arp !! >AW034<
  # show arp - may run long if ip not in local hosts file
  # and DNS is not responding !!

  #Wait4BG $PID_pc_k "BG004" "pc_k" # %BG004 wait for specific process
  #BGRC_pc_k=$?

  if [[ -f $DSN_arp_a ]]
  then
    #AWCONST "\nC2H000I File DSN_arp_a available"
    : # dummy - DO NOT DELETE
  else
    #AWCONST "\nC2H000I File DSN_arp_a NOT available"
    : # dummy - DO NOT DELETE
  fi

  # ToDo 000-000 show in verbose mode
  #AWCONST "waiting for BG process: arp_a (PID=${PID_arp_a})"
  #date
  wait $PID_arp_a # %BG012 wait for specific process
  wait_rc=$?
  BGRC_arp_a=$wait_rc
  #date
  #ERRMSG "AWDBG001I wait cmd 'arp -a' PID=$PID_arp_a RC=$wait_rc"

  # use file created by BG Job
  if [[ -f $DSN_arp_a ]]
  then
    #AWCONST "C2H000I File DSN_arp_a available"
    exec_command "cat ${DSN_arp_a}" "arp -a (BG-Job Fileoutput)"
  else
    AWCONST "C2H000I File DSN_arp_a NOT available. Now running COMMAND"
    AWCONST "\nC2H000I DSN_arp_a=${DSN_arp_a}"
    ls -la ${DSN_arp_a}
    exec_command "arp -a | grep -v bucket:"     "show arp cache" # >AW034<
  fi

  DBG "NETWORK 500"
  #++ >AW203< start *ipcs* -------------------------------------------
  # cmd "ipcs" does NOT run on node aixn(5.3ML01) !
  #NODE=$(uname -n)
  #
  #case $NODE in
  #  aixn) ERRMSG "\nC2H004I CMD ipcs skipped on aixn !\n";
  #        ;;
  #     *) dummy=dummy
          exec_command "ipcs" "IPC info"
          exec_command "ipcs -apS1" "IPC -apS1" # >AW133<
  #        ;;
  #esac
  #++ >AW203< end *ipcs* ---------------------------------------------

 dec_heading_level
 paragraph_end "Network Settings"

 DBG "NETWORK 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_PPPPP9: *col-09*P* PPPPP Information
######################################################################
collect_PPPPP9 ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "PPPPP 001"

 verbose_out "\n-=[ 09/${_maxcoll} PPPPP-Info ]=-\n"
 paragraph_start "PPPPP"
 inc_heading_level
 #////////////////////////////////////////////////////////////////////

#
#

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "PPPPP"

 DBG "PPPPP 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_cron: *col-10*C* CRON Information
######################################################################
collect_cron ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "CRON 001"

  verbose_out "\n-=[ 10/${_maxcoll} CRON-Info ]=-\n"
  paragraph_start "Cron and At"
  inc_heading_level
 #////////////////////////////////////////////////////////////////////

#
# !! CRON moved to SYSTEM to free C for xxx ( s.c system.cron ??)

#
# collect_cron MOVED TO col-12*s "SOFTWARE"  >AW124<
#
# next 3 lines removed for version X.xx
# next 3 lines to be removed in next version (now 2.81, next X.xx)
 txt="C2H910I cron now part of 'SYSTEM' Collector. Use option -S to enable/disable"
 echo "\n${txt}"
 AddText "\n${txt}"

 echo "<h6>$txt<h6>" >>$HTML_OUTFILE_TEMP
 echo "Cmd: $txt"    >>$TEXT_OUTFILE_TEMP
#

 dec_heading_level
 paragraph_end "Cron and At"

 DBG "CRON 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_WWWW_info: *col-11*W* WWWW Information >AW772<
######################################################################
collect_WWWW ()  # >AW772<
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "WWWW 001"   # >AW772<

 verbose_out "\n-=[ 11/${_maxcoll} WWWW-Info ]=-\n"  # >AW772<
 paragraph_start "WWWW" # >AW772<
 inc_heading_level
 #////////////////////////////////////////////////////////////////////

#
#

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "WWWW" # >AW772<

 DBG "WWWW 998"  # >AW772<
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_software: *col-12*s* Patch Statistics
######################################################################
collect_software ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "SOFTWARE 001"

  verbose_out "\n-=[ 12/${_maxcoll} Software-Info ]=-\n"
  paragraph_start "Software"
  inc_heading_level
 #////////////////////////////////////////////////////////////////////

  # -- lslpp --
  # -- ***** --
 if [ "$XCFG_LSLPP" = "yes" ]
 then
  exec_command "lslpp -l"       "Filesets installed"
  exec_command "lslpp -La"      "Display all information about Filesets"
 else
  AWCONS "\nAW ToDo 281-999 Fileset Info REMOVED DURING DEBUGGING"
  AWTRACE "AW ToDo 281-999 Fileset Info REMOVED DURING DEBUGGING"
 fi # end XCFG_CSM

  # -- lppchk --
  # -- ****** --
  exec_command "lppchk -v 2>&1" "Verify Filesets" "lppchk -v"

# "Long running" try as backgroundtask !
if [[ -f $DSN_lppchk_f ]]
then
  #AWCONST "\nC2H000I File DSN_lppc_f available"
  : # dummy - DO NOT DELETE
else
  AWCONST "\nC2H000I File DSN_lppc_f NOT available"
fi

 #AWCONST "waiting for BG process: lppchk -f (PID=${PID_lppc_f})"
 #date
 wait $PID_lppc_f # %BG013 wait for specific process
 wait_rc=$?
 BGRC_lppc_f=$wait_rc
 #date
 #ERRMSG "AWDBG001I wait cmd 'lppchk -f' PID=$PID_lppc_f RC=$wait_rc"

  # lppchk -f  # Checks that the FileList items are present and the file size matches the SWVPD database.
  if [[ -f $DSN_lppchk_f ]]
  then
    #AWCONST "C2H000I File DSN_lppchk_f available"
    exec_command "cat ${DSN_lppchk_f}" "lppchk -f (BG-Job Fileoutput)"
  else
    AWCONST "C2H000I File DSN_lppchk_f NOT available. Now running COMMAND"
    AWCONST "\nC2H000I DSN_lppchk_f=${DSN_lppchk_f}"
    ls -la ${DSN_lppchk_f}
    exec_command "lppchk -f"  "lppchk -l"
  fi

  if [ "$EXTENDED" = 1 ] ; then
     AWCONS "\nAWTRACE EXTENDED START"
     AWTRACE "EXTENDED START"
     exec_command "lslpp -h all" "Display installation and update history (EXTENDED)" # >GL02<

     # -c Perform a checksum operation on the FileList items and verifies that the
     #    checksum and the file size are consistent with the SWVPD database.
     exec_command "lppchk -c 2>&1" "Check Filesets (EXTENDED)" "lppchk -c"

     # -l Verify symbolic links for files as specified in the SWVPD database.
     exec_command "lppchk -l 2>&1" "Verify symbolic links (SWVPD database) (EXTENDED)" "lppchk -l"

     # -wa ...
     # exec_command "lslpp -wa" "List fileset that owns this file (EXTENDED)"  # crasht; not enough memory (in eval)

     AWCONS "\nAWTRACE EXTENDED STOP"
     AWTRACE "EXTENDED STOP"
  fi

#++ >AW067< start *ssh*-----------------------------------------------
  # -- ssh --
  # -- *** --
  #echo "\n== ssh =="
  exec_command "ssh -V 2>&1"  "ssh: ssh -V"
# ToDo 000-000 show .ssh/Known_hosts

# ToDo 000-000 check openssl version
# check openssl
  SSL="INIT"
  MIN_SSL="0.0.0.000" # init
  fileset="openssl.base"
  lslpp -l ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|awk '{print $2}'|while read vv
  do
    ssl_installed=${vv}
  done
#
  ssl_base_u=$(lslpp -l openssl.base 2>/dev/null)
  ssl_base=$(lslpp -l openssl.base >/dev/null 2>&1)
  ssl_rc=$?
  #ERRMSG "SSL_BASE RC=${ssl_rc}"
  case $ssl_rc in
  0 )
    SSL="YES"
    AWTRACE "C2H100I SSL installed: ${ssl_installed}";
    #AWTRACE "${ssl_base_u}";
    lslpp -l | grep openssl. >>${AWTRACE_DSN} 2>&1
    ;;
  1 )
    SSL="NO"
    AWTRACE "C2H101W SSL NOT installed RC=${ssl_rc} (openssl.base missing)";
    ;;
  * )
    SSL="UNKNOWN"
    AWTRACE "C2H102I SSL error RC=${ssl_rc}";
    ;;
  esac

  if [[ ${SSL} = "YES" ]]
  then
    if [[ ${ssl_installed} < "0.9.8.1101" ]]
    then
      AWTRACE "C2H102W This SSL version is VULNERABLE ! Please install at least 0.9.8.1101 !";
    fi
  fi

# ToDo 000-000 check openssh version
# check openssh
  SSH="INIT"
  MIN_SSH="0.0.0.000" # init
  fileset="openssh.base.client"
  lslpp -l ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|awk '{print $2}'|while read vv
  do
    ssh_installed=${vv}
  done
#
  ssh_base_u=$(lslpp -l openssh.base.client 2>/dev/null)
  ssh_base=$(lslpp -l openssh.base.client >/dev/null 2>&1)
  ssh_rc=$?
  #ERRMSG "SSH_BASE RC=${ssh_rc}"
  case $ssh_rc in
  0 )
    SSH="YES"
    AWTRACE "C2H100I SSH installed: ${ssh_installed}";
    #AWTRACE "${ssh_base_u}";
    lslpp -l | grep openssh. >>${AWTRACE_DSN} 2>&1
    ;;
  1 )
    SSH="NO"
    AWTRACE "C2H101W SSH NOT installed RC=${ssh_rc} (openssh.base.client missing)";
    ;;
  * )
    SSH="UNKNOWN"
    AWTRACE "C2H102I SSH error RC=${ssh_rc}";
    ;;
  esac

  if [[ ${SSH} = "YES" ]]
  then
    if [[ ${ssh_installed} < "5.2.0.000" ]]
    then
      AWTRACE "C2H102W This SSH version is OUT OF DATE ! Please install at least 5.2.0.000 !";
    fi
  fi

#++ >AW067< end *ssh*-------------------------------------------------

#++ >AW069< start *rpm*-----------------------------------------------
  # -- rpm --
  # -- *** --
  exec_command "rpm --version"  "rpm: rpm --version"
  exec_command "rpm -qa | sort"  "rpm: rpm -qa" # >AW092<
#++ >AW069< end *rpm*-------------------------------------------------

#++ >AW091< start *LUM*-----------------------------------------------
  # >AW305< BUG: do not display "<file> file not found" in *.err file !
  files ()
  {
     ls /var/ifor/nodelock    2>/dev/null
     ls /var/ifor/i4ls.ini    2>/dev/null
     ls /var/ifor/i4ls.rc     2>/dev/null
     ls /etc/ncs/glb_site.txt 2>/dev/null
     ls /etc/ncs/glb_obj.txt  2>/dev/null
  }

  for FILE in $(files)
  do
     exec_command "cat ${FILE}" "${FILE}"
  done

  #AWTRACE ": i4cfg -list * Installed Floating Licenses **"
  # >AW307< BUG: check for "/var/ifor/i4cfg" Don't use if not available !
  # >AW307< BUG: else we will see entry in *.err file !
  if [ -x /var/ifor/i4cfg ]
  then
    /var/ifor/i4cfg -list | grep -q 'active'
    rc=$?
    if [[ $rc == 0 ]]
    then
      exec_command "/var/ifor/i4blt -ll -n $(uname -n)" "Installed Floating Licenses"
      exec_command "/var/ifor/i4blt -s -n $(uname -n)" "Status of Floating Licenses"
    fi
  else
    AWTRACE "C2H170W i4cfg NOT FOUND"
  fi
  #AWTRACE "** "

  exec_command "inulag -lc" "License Agreements Manager"
  exec_command "lslicense" "Display fixed and floating Licenses"
#++ >AW091< end *LUM*-------------------------------------------------

#++ >AW103< start *Perl*----------------------------------------------
  DBG "SOFTWARE 000 PERL"
  verbose_out "\n== Perl =="
  #AWTRACE "%%%%% Perl -start- %%%%%%%%%"

# show PERL info
  exec_command "perl -v"  "Perl -v info"
  exec_command "perl -V"  "Perl -V info"

# ToDo 281-001 More info about perl

  #AWTRACE "%%%%% Perl -end- %%%%%%%%%%%"
#++ >AW103< end *Perl*------------------------------------------------

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "Software"

 DBG "SOFTWARE 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_files: *col-13*f* File Statistics **5.3**
######################################################################
collect_files ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "FILESYS 001"

  verbose_out "\n-=[ 13/${_maxcoll} Filestat-Info ]=-\n"
  paragraph_start "Files"
  inc_heading_level
 #////////////////////////////////////////////////////////////////////

 EX_SAVE=$EXTENDED
 EXTENDED=1
  if [ "$EXTENDED" = 1 ] ; then
 AWCONS "\nAWTRACE EXTENDED START"
 AWTRACE "EXTENDED START"
     find /etc/rc.d/rc* -type f | while read i
     do
      exec_command "cat $i" "$i (EXTENDED)"
     done
 AWCONS "\nAWTRACE EXTENDED STOP"
 AWTRACE "EXTENDED STOP"
  else
     exec_command "find /etc/rc.d/rc* | xargs ls -ld" "Run Command files in /etc/rc.d"
  fi
 EXTENDED=$EX_SAVE

  DBG "FILESYS 010"
  # >AW303< BUG: sed will convert also for *.TXT output file, which is not necessary
  # >AW305< BUG: do not display "<file> file not found" in *.err file !
  files ()
  {
     ls /.rhosts                   2>/dev/null # >AW099<
     ls ${HOME}/.profile           2>/dev/null # >AW099<
     ls ${HOME}/.kshrc             2>/dev/null # >AW099<
     ls /etc/aliases               2>/dev/null
     ls /etc/automount.direct      2>/dev/null # >AW123<
     ls /etc/auto.master           2>/dev/null # >AW123<
     ls /etc/binld.cnf             2>/dev/null
     ls /etc/bootptab              2>/dev/null
     ls /etc/dhcpcd.ini            2>/dev/null
     ls /etc/dhcprd.cnf            2>/dev/null
     ls /etc/dhcpsd.cnf            2>/dev/null
     ls /etc/dlpi.conf             2>/dev/null
     ls /etc/environment           2>/dev/null
     ls /etc/ftpusers              2>/dev/null
     ls /etc/gated.conf            2>/dev/null
     ls /etc/hostmibd.conf         2>/dev/null
     ls /etc/hosts                 2>/dev/null
     ls /etc/hosts.equiv           2>/dev/null
     ls /etc/hosts.lpd             2>/dev/null
     ls /etc/inetd.conf            2>/dev/null
     ls /etc/inittab               2>/dev/null # comment ":"
#...............
# ToDo 000-000 removed during debugging ! creates too much output
# ToDo 000-000 show files in extra outfile like aix
#     ls /etc/mib.defs              2>/dev/null # comment "--"
#...............
     ls /etc/mrouted.conf          2>/dev/null
     ls /etc/netgroup              2>/dev/null
     ls /etc/netsvc.conf           2>/dev/null
     ls /etc/ntp.conf              2>/dev/null
     ls /etc/oratab                2>/dev/null
     ls /etc/policyd.conf          2>/dev/null
     ls /etc/protocols             2>/dev/null
     ls /etc/pse.conf              2>/dev/null
     ls /etc/pse_tune.conf         2>/dev/null
     ls /etc/pxed.cnf              2>/dev/null
     ls /etc/qconfig               2>/dev/null # comment "*"  # defined printers
     ls /etc/filesystems           2>/dev/null # comment "*"
     ls /etc/rc                    2>/dev/null
     ls /etc/rc.adtranz            2>/dev/null
     ls /etc/rc.bsdnet             2>/dev/null
     ls /etc/rc.licstart           2>/dev/null
     ls /etc/rc.net                2>/dev/null
     ls /etc/rc.net.serial         2>/dev/null
     ls /etc/rc.oracle             2>/dev/null
     ls /etc/rc.qos                2>/dev/null
     ls /etc/rc.shutdown           2>/dev/null
     ls /etc/rc.tcpip              2>/dev/null
#...............
# ToDo 000-000 does not work this way...
#    ls /etc/rc.*                  2>/dev/null # >AW131<
# see above. Maybe like "extended"...
#...............
     ls /etc/resolv.conf           2>/dev/null
     ls /etc/rsvpd.conf            2>/dev/null
#...............
# ToDo 000-000 removed during debugging ! creates too much output
# ToDo uncomment for production # >AW312<
#     ls /etc/sendmail.cf           2>/dev/null
#...............
     ls /etc/security/limits       2>/dev/null # comment "*"  # >AW025< add /etc/security/limits to files
     ls /etc/security/group        2>/dev/null # comment "*"  # >AW133<
     ls /etc/security/user         2>/dev/null # comment "*"  # >AW133<
     ls /etc/security/login.cfg    2>/dev/null # comment "*"  # >AW133<
     ls /etc/motd                  2>/dev/null # comment "*"  # >AW133<
#...............
# ToDo 000-000 removed during debugging ! creates too much output
#    ls /etc/services              2>/dev/null
#...............
     ls /etc/slip.hosts            2>/dev/null
     ls /etc/snmpd.conf            2>/dev/null
     ls /etc/snmpd.peers           2>/dev/null
     ls /etc/syslog.conf           2>/dev/null
     ls /etc/ssh/sshd_config       2>/dev/null # >CP001< add
     ls /etc/telnet.conf           2>/dev/null
     ls /etc/tunables/lastboot.log 2>/dev/null # >AW049<
     ls /etc/tunables/lastboot     2>/dev/null # >AW049<
     ls /etc/tunables/nextboot     2>/dev/null # >AW049<
     ls /etc/xtiso.conf            2>/dev/null
     ls /opt/ls3/ls3.sh            2>/dev/null
     ls /usr/tivoli/tsm/client/ba/bin/rc.dsmsched 2>/dev/null
     ls /usr/tivoli/tsm/server/bin/rc.adsmserv    2>/dev/null
     ls /usr/tivoli/tsm/client/ba/bin/dsm*.sys    2>/dev/null # >CP002< add TSM 32-Bit
     ls /usr/tivoli/tsm/client/ba/bin/dsm*.opt    2>/dev/null # >CP002< add TSM 32-Bit
     ls /usr/tivoli/tsm/client/ba/bin64/dsm*.sys  2>/dev/null # >AW001< add TSM 64-Bit
     ls /usr/tivoli/tsm/client/ba/bin64/dsm*.opt  2>/dev/null # >AW001< add TSM 64-Bit
  #++ >CP001< start *TSM inclexcl* -----------------------------------
  # Bugfix: inclexcl shown twice if more than one server defined in dsm.sys => add uniq
  # Bugfix: inclexcl on comment needs to be ignored => add grep -v "*"
     dsmsys="/usr/tivoli/tsm/client/ba/bin/dsm.sys"
     if [[ -f ${dsmsys} ]] # >AW042<
     then
        grep -i inclexcl $dsmsys |uniq|grep -v "*"|awk '{print $2}'|while read inc
          do
            ls $inc 2>/dev/null
          done
     else
       AWTRACE "C2H260W File 'dsm.sys' NOT Found."
       verbose_out "C2H260W File 'dsm.sys' NOT Found."
     fi
  #++ >CP001< end *TSM inclexcl* -------------------------------------
#...............
# ToDo 000-000 removed ! check...
   # ls /etc/rc2.d/*         2>/dev/null
   # ls /etc/rc3.d/*         2>/dev/null
#...............
  }

  DBG "FILESYS 011"
  files1 ()
  {
     ls /etc/qconfig               2>/dev/null # comment "*"  # defined printers
     ls /etc/filesystems           2>/dev/null # comment "*"
  }

# ToDo 281-000 APACHE files: httpd.conf / .htaccess

  DBG "FILESYS 100 CMT=#"
  COUNT=1     # n.u... ??
  for FILE in $(files)
  do
    DBG "FILESYS 101 File: ${COUNT} ${FILE} "wc -k ${FILE}
    DBG "FILESYS 102 File: $(ls -la ${FILE}) "
   #exec_command "grep -v '^#' ${FILE} | uniq" "${FILE}"
    exec_command "egrep -v '^#|^[ 	]*$' ${FILE} | uniq" "${FILE}"  # remove comment and empty lines

    COUNT=$(expr $COUNT + 1)
  done

  DBG "FILESYS 110 CMT=*"
  COUNT=1     # n.u... ??
  for FILE in $(files1)
  do
    DBG "FILESYS 111 File: ${COUNT} ${FILE} "wc -k ${FILE}
    DBG "FILESYS 112 File: $(ls -la ${FILE}) "
   #exec_command "grep -v '^#' ${FILE} | uniq" "${FILE}"
    exec_command "egrep -v '^\*|^[ 	]*$' ${FILE} | uniq" "${FILE}"  # remove comment and empty lines

    COUNT=$(expr $COUNT + 1)
  done

  exec_command "ls -al /var/log/*" "Content of /var/log" # >CP001< add

#  writeTF # >AW309< BUG: write temp output to final file

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "Files"

 DBG "FILESYS 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_nim: *col-14*n* NIM - Network Installation Management (available on NIM SERVER only
######################################################################
collect_nim ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "NIM 001"

  verbose_out "\n-=[ 14/${_maxcoll} NIM-Info ]=-\n"
  paragraph_start "NIM - Network Installation Management"
  inc_heading_level
 #////////////////////////////////////////////////////////////////////

#  AWTRACE "%%%%% niminv -start- %%%%%%%%%"
  nim_srv=$(lslpp -l bos.sysmgt.nim.master >/dev/null 2>&1)
  ns_rc=$?
# AIX >5.3.0.50 use niminv # >AW047<
  nim_cli=$(lslpp -l bos.sysmgt.nim.client >/dev/null 2>&1)
  nc_rc=$?
  #ERRMSG "NIM_SRV RC=${ns_rc}"
  #ERRMSG "NIM_CLI RC=${nc_rc}"
  if [[ $ns_rc = 0 ]]
  then
    AWTRACE "C2H220I This system is a NIM Server"
    AddText "\nC2H220I This system is a NIM Server"
    exec_command "lsnim -l" "Display information about NIM (lsnim)"
    if [[ ${NODE} = "_aixn" ]]
    then
      :
      AWCONST "\nC2H222I Running on AIXN try niminv"
      # niminv -o xxx -a targets=xxxe
      exec_command "niminv" "Display information about NIM (niminv)" # >AW047<
    fi
  fi
  if [[ $nc_rc = 0 ]]
  then
    AWTRACE "C2H221I This system is a NIM Client"
    AddText "\nC2H221I This system is a NIM Client"
# ToDo 000-000 write to HTML File
  fi
#  AWTRACE "%%%%% niminv -end- %%%%%%%%%%%"

 dec_heading_level
 paragraph_end "NIM - Network Installation Management"

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 DBG "NIM 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_lum: *col-15*l* LUM - License Usage Management
######################################################################
collect_lum ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "LUM 001"

 verbose_out "\n-=[ 15/${_maxcoll} LUM-Info ]=-\n"
 paragraph_start "LUM - License Use Manager"
 inc_heading_level
 #////////////////////////////////////////////////////////////////////

# !! moved to SOFTWARE to free L for LPAR ( s.h system.software ??)

#
# collect_lum MOVED TO col-12*s "SOFTWARE"  >AW091<
#
# next 3 lines removed for version X.xx
# next 3 lines to be removed in next version (now 2.80, next X.xx)
 txt="C2H910I LUM now part of 'SOFTWARE' Collector. Use option -s to enable/disable"
 echo "\n${txt}"
 AddText "\n${txt}"

 echo "<h6>$txt<h6>" >>$HTML_OUTFILE_TEMP
 echo "Cmd: $txt"    >>$TEXT_OUTFILE_TEMP

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "LUM - License Use Manager"

 DBG "LUM 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_appl: *col-16*a* APPLICATIONS
######################################################################
collect_appl ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "APPL 001"

 verbose_out "\n-=[ 16/${_maxcoll} APPL-Info ]=-\n"
 paragraph_start "APPLICATIONS"
 inc_heading_level
 #////////////////////////////////////////////////////////////////////

# AddText "Coming soon..."

 #exec_command "<cmd>" "<text>"

 # ToDo 281-000 ...APACHE... # >AW061<
 DBG "APPL 100 APACHE"
  AWTRACE "%%%%% APACHE -start- %%%%%%%%%"
 #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 # which apachectl => rc<>0 means NOT IN PATH
 # possible packages:
 #
 #  IHS2          IBM HTTP Server
 #  *Apache*      Apache
 #
 #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  APACHE="NO"
  http_srv=$(lslpp -l | grep -i http >/dev/null 2>&1)
  http_rc=$?
  #ERRMSG "HTTP_SRV RC=${http_rc}"
  if [[ $http_rc = 0 ]]
  then
    APACHE="YES"
    AWTRACE "C2H180I HTTP Server (Apache) package found"
  fi

  if [[ ${APACHE} = "YES" ]]
  then
    wx=$(which apachectl >/dev/null 2>&1)
    which_rc=$?
    if [[ $which_rc = 0 ]]
    then
      #exec_command "apachectl status" "HTTP Server status"
      AWTRACE "HTTP Server apachectl ${http_srv} wx=${wx}"
    fi
  fi
  AWTRACE "%%%%% APACHE -end- %%%%%%%%%%%"

 # ToDo 281-000 ...SAMBA... # >AW062<
 DBG "APPL 200 SAMBA"
  AWTRACE "%%%%% SAMBA -start- %%%%%%%%%"
 #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 # which smbstatus => rc<>0 means NOT IN PATH
 #
 # possible packages:
 #  *Samba*                    Version 2.0.7
 #  freeware.samba.rte   Samba Version 3.0.4
 #  *Samba*              Samba Version 3.0.24
 #
 # check for package:
 #  lslpp -l | grep samba
 #  rpm -q
 # if package found then get the path:
 #  lslpp -f <package> | grep <path/cmd>
 #  rpm -q -l <package>
 # if cmd found then get package
 #  lslpp -w <path/cmd>
 #  rpm -q --whatprovides <path/cmd>
 #
 #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 #
 # /var/locks/connections.tdb
 # /var/locks/brlock.tdb
 # sessionid.tdb
 #
 # -V  Version
 # -p  processes
 # -L  Locks
 # -S  Shares
 # -b  be brief
 # -B  Byterange
 # -n  numeric uid/guid
 # -v  verbose
 #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  SAMBA="NO"
  smb_srv=$(lslpp -l | grep -i samba >/dev/null 2>&1)
  smb_rc=$?
  #ERRMSG "SMB_SRV RC=${smb_rc}"
  if [[ $smb_rc = 0 ]]
  then
    SAMBA="YES"
    AWTRACE "C2H190I SAMBA package found"
  fi

  if [[ ${SAMBA} = "YES" ]]
  then
    wx=$(which swat >/dev/null 2>&1)
    which_rc=$?
    if [[ $which_rc = 0 ]]
    then
      AWTRACE "SAMBA swat ${smb_srv} wx=${wx}"
    fi
    if [ -x "/usr/sbin/smbstatus" ]
    then
      smb_path1="FOUND"
      exec_command "/usr/sbin/smbstatus -V 2>&1" "Samba Version"
      exec_command "/usr/sbin/smbstatus -S 2>&1" "Samba Shares"
    else
      smb_path1="NOTFOUND"
    fi
    if [ -x "/usr/bin/smbstatus" ]
    then
      smb_path2="FOUND"
      exec_command "/usr/bin/smbstatus -V 2>&1" "Samba Version"
      exec_command "/usr/bin/smbstatus -S 2>&1" "Samba Shares"
    else
      smb_path2="NOTFOUND"
    fi
    # ToDo 281-000 ...valid for freeware.samba 3.0.4...
    if [ -x "/usr/local/samba/bin/smbstatus" ]
    then
      smb_path3="FOUND"
      exec_command "/usr/local/samba/bin/smbstatus" "Samba (smbstatus)"
      #?? exec_command "/usr/local/samba/sbin/swat" "Samba (swat)"
    else
      smb_path3="NOTFOUND"
    fi
    AWTRACE "SAMBA found 1=$smb_path1 2=$smb_path2 3=$smb_path3"
  fi
  AWTRACE "%%%%% SAMBA -end- %%%%%%%%%%%"

# ToDo 281-200 ...ORACLE... # >AW048<
 DBG "APPL 300 ORACLE"
#++ >AW048< end *oratab*-----------------------------------------------
  AWTRACE "%%%%% Oracle -start- %%%%%%%%%"
  verbose_out "\n== Oracle =="

# ToDo 281-200 basic file checking's as shown in oracle document
  ORACLE="NO"

  if [ -f /etc/oratab ]
  then
    ORACLE="YES"
    AWTRACE "C2H080I file \"/etc/oratab\" found. Looks like you are using Oracle."
    # ToDo 281-200 show link to ora2html on Sourceforge !!
    O2HURL="http://ora2html.sourceforge.net"
    AddText "See ora2html at Sourceforge.net: <A HREF=${O2HURL}> ${O2HURL} </A>"
  fi
  AWTRACE "%%%%% Oracle -end- %%%%%%%%%%"
#++ >AW048< end *oratab*-----------------------------------------------

#++ >AW106< start *HPOpenView*-----------------------------------------
# ToDo 000-000 !! ( a.h application.hpopenview ??)
 DBG "APPL 400 HPOpenView"
  AWTRACE "%%%%% HPOpenView -start- %%%%%%%%%"
  HPOV="NO"
  hpo=$(lslpp -l | grep -i OPC >/dev/null 2>&1)
  hpo_rc=$?
  if [[ $hpo_rc = 0 ]]
  then
    HPOV="YES"
  else
    HPOV="NO"
    AWTRACE "C2H195W HP OpenView not installed."
  fi

  if [[ ${HPOV} = "YES" ]]
  then
#++ >CP001< start *HP OpenView*---------------------------------------
    exec_command "lslpp -L |grep -i OPC" "Installed HP OpenView Version"
    OPCINFO=$(lslpp -f OPC.obj | grep opcinfo)
    exec_command "cat $OPCINFO" "OPCINFO"
    OPCDCODE=$(lslpp -f OPC.obj | grep opcdcode)
    exec_command "$OPCDCODE /var/lpp/OV/conf/OpC/monitor | grep DESCRIPTION" "HP OpenView Configuration MONITOR"
    exec_command "$OPCDCODE /var/lpp/OV/conf/OpC/le | grep DESCRIPTION" "HP OpenView Configuration LOGGING"
#++ >CP001< end *HP OpenView*-----------------------------------------
  fi
  AWTRACE "%%%%% HPOpenView -end- %%%%%%"
#++ >AW106< end *HPOpenView*------------------------------------------

#++ >AW073< start *HACMP*---------------------------------------------
  DBG "APPL 500 HACMP"
  verbose_out "\n== HACMP =="
  AWTRACE "%%%%% HACMP -start- %%%%%%%%%"

  HACMP="NO"
  if [ -x /usr/es/sbin/cluster/utilities/cltopinfo ] ; then
    HACMP="YES"
    exec_command "/usr/es/sbin/cluster/utilities/cltopinfo" "List cluster topology information"
  else
    AWTRACE "C2H280W HACMP cltopinfo Not Found !"
  fi

  if [[ "$HACMP" = "YES" ]]
  then
    exec_command "/usr/es/sbin/cluster/utilities/cldump"    "HACMP Status"
  fi

  AWTRACE "%%%%% HACMP -end- %%%%%%%%%%%"
#++ >AW073< end *HACMP*-----------------------------------------------

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "APPLICATIONS"

 DBG "APPL 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_exp: *col-17*E* EXPERIMENTAL
######################################################################
collect_exp ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=1  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "EXP 001"

  verbose_out "\n-=[ 17/${_maxcoll} EXP-Info ]=-\n"
  paragraph_start "EXPERIMENTAL"
  inc_heading_level
 #////////////////////////////////////////////////////////////////////

#++ >AW...< start *lsparent*-------------------------------------------
  DBG "EXP 100"
  exec_command "lsparent -C -l hdisk0"  "lsparent hd0"
  exec_command "lsparent -C -l hdisk1"  "lsparent hd1"
  exec_command "lsparent -C -l hdisk2"  "lsparent hd2"
  exec_command "lsparent -C -l hdisk99" "lsparent hd99"
#++ >AW...< end   *lsparent*-------------------------------------------

#++ >AW...< start *aix-config*-----------------------------------------
  DBG "EXP 101"
  exec_command "lsconf"  "lsconf" # >AW133<
# ToDo 000-000 aix-config lvmo
  exec_command "lvmo -a" "lvmo" # >AW133<
  exec_command "lvmo -v rootvg -a" "lvmo rootvg" # >AW133<
  exec_command "schedo -a" "schedo" # >AW133<
  exec_command "showmount -a" "showmount" # >AW133<
  exec_command "lsfilt -s -v 4 -a -O" "lsfilt" # >AW133<
  exec_command "lsclass -C" "lsclass -C" # >AW133<
  exec_command "lsclass -f" "lsclass -f" # >AW133<
  exec_command "audit query" "audit query" # >AW133<
  exec_command "env" "env" # >AW133<
  exec_command "lsmcode -c" "lsmcode -c" # >AW133<
  exec_command "lsmcode -A" "lsmcode -A" # >AW133<
  exec_command "bosdebug -L" "bosdebug -L" # >AW133<
# ToDo 000-000 aix-config fcstat
  exec_command "fcstat fcs0" "fcstat fcs0" # >AW133<
# ToDo 000-000 aix-config lsvpcfg >> CHECK <<
# exec_command "lsvpcfg" "lsvpcfg" # >AW133<

  exec_command "lspcmcfg" "lspcmcfg" # Todo 000-000 check pre-rew SDDPCM 2.5.0.0

#++ >AW...< end   *aix-config*-----------------------------------------

#++ >AW134< start *XiV*------------------------------------------------
# ToDo 000-000 XiV >> CHECK <<
  exec_command "xiv_devlist" "xiv_devlist" # >AW134<

#++ >AW134< end   *XiV*------------------------------------------------

#++ >AW104< start *PLUGIN*---------------------------------------------
  DBG "EXP 300"
  verbose_out "\n== PLUGIN 0 =="
  AWTRACE "%%%%% plugin -start- %%%%%%%%%"

  if [[ -f ${PLUGINS}/c2h_plugin_0 ]]
  then
    if [[ -x ${PLUGINS}/c2h_plugin_0 ]]
    then
      AWTRACE "C2H704I Plugin 'c2h_plugin_0' has EXECUTE Bit ON."
    fi
    AWTRACE "C2H706I START Plugin 'c2h_plugin_0'."
external="ON"
    exec_command ${PLUGINS}/c2h_plugin_0 "Plugin 0"
external="OFF"
    AWTRACE "C2H707I END   Plugin 'c2h_plugin_0'."
    AWTRACE "C2H706I START Plugin 'c2h_plugin_1'."
    . /${PLUGINS}/c2h_plugin_1 "Plugin 1"
    AWTRACE "C2H707I END   Plugin 'c2h_plugin_1'."
    # ToDo 000-000 Show runtime of plugin
  else
    AWTRACE "C2H705W Plugin 'c2h_plugin_0' NOT Found."
    verbose_out "C2H705W Plugin 'c2h_plugin_0' NOT Found."
  fi
  AWTRACE "%%%%% plugin -end- %%%%%%%%%%%"
#++ >AW104< end *PLUGIN*-----------------------------------------------

#++ >AW...< start *...*------------------------------------------------
 if [ "$XCFG_PS4" = "yes" ]
 then
 DBG "EXP 400"
 PS4_org=${PS4}
 settings=${-}
 settings1=$-
 AWTRACE "%% PS4 ${PS4} %%%%%%%%%%"
 AWTRACE "%% Settings  ${settings} %%%%%%%%%%"
 AWTRACE "%% Settings1 ${settings1} %%%%%%%%%%"
 export PS4="DEBUG => "
#- set -x # start ksh debugging
#- settings2=$-
#- AWTRACE "%% Settings2 ${settings2} %%%%%%%%%%"
 fi # end XCFG_PS4
#++ >AW...< end *...*--------------------------------------------------

#++ >AW...< start *...*------------------------------------------------
# DBG "EXP 996"
# What if var is not available (=> OPCINFO)
#-AWTRACE "AWINFO=${AWINFO}<"
#-AWINFO="${AWINFO-DUMMY}"
#-AWTRACE "AWINFO=${AWINFO}<"
#-AWTRACE "\n== AWINFO-v =="
#-if [[ -f ${AWINFO} ]]
#-then
#-  exec_command "cat $AWINFO" "AWINFO"
#-else
#-  AWTRACE "File ${AWINFO} NOT Found<"
#-fi
#-AWTRACE "\n== AWINFO-n =="
#++ >AW...< end *...*--------------------------------------------------

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "EXPERIMENTAL"

 DBG "EXP 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
}

######################################################################
# collect_java_info: *col-18*J* JAVA
######################################################################
collect_java ()
{
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "JAVA 001"

 verbose_out "\n-=[ 18/${_maxcoll} JAVA-Info ]=-\n"
 paragraph_start "JAVA"
 inc_heading_level
 #////////////////////////////////////////////////////////////////////

 #:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+
 dsn_lvl=dsn_lvl+1
 TRACE_DSN[$dsn_lvl]=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${java_LOG}  # set AWTRACE_DSN
 ERRLOG ">>>> output > ${AWTRACE_DSN} LVL=${dsn_lvl}"
 infofile_header "JAVA"

#++ >AW052< start *java*-----------------------------------------------
# ToDo 000-000 Do Java checking's as PLUGIN !!
#------------------------------------------
# JAVA
# ====
#
# UNSUPPORTED
# -----------
# AIX 5.3.0
#  1.3.1-32 END OF SERVICE 30 Sep 2007
#  1.3.1-64 END OF SERVICE 30 Sep 2007
#  1.4.1-32 END OF SERVICE  1 Mar 2005
#  1.4.1-64 END OF SERVICE  1 Mar 2005
#
# SUPPORTED
# ---------
#
# AIX 5.3.0 ML02 + IY58143
#  1.4.2-32 ==> END OF SERVICE 30 Sep 2011
#  1.4.2-64 ==> END OF SERVICE 30 Sep 2011
# AIX 5.3.0 ML03
#  5.0.0-32 ==> END OF SERVICE 30 Sep 2012
#  5.0.0-64 ==> END OF SERVICE 30 Sep 2012
# AIX 5.3.0 TL07
#  6.0.0-32 ==> END OF SERVICE 30 Nov 2017
#  6.0.0-64 ==> END OF SERVICE 30 Nov 2017
#
# AIX 6.1.0 BASE
#  1.4.2-32 ==> END OF SERVICE 30 Sep 2011
#  1.4.2-64 ==> END OF SERVICE 30 Sep 2011
# AIX 6.1.0 BASE
#  5.0.0-32 ==> END OF SERVICE 30 Sep 2012
#  5.0.0-64 ==> END OF SERVICE 30 Sep 2012
# AIX 6.1.0 BASE
#  6.0.0-32 ==> END OF SERVICE 30 Nov 2017
#  6.0.0-64 ==> END OF SERVICE 30 Nov 2017
#
# Java131.rte.bin
# ---------------
#  1.3.1.17-32 APAR IY65310 + IY52512 + IY49074 + IY30887
#
# Java131_64.rte.bin
# ------------------
#  1.3.1.9-32 APAR IY65310 + IY52512 + IY49074 + IY30887
#
# Java14.sdk
# ----------
#  1.4.2.5-32 APAR IY72469 + IY70052 + IY54663
#
# Java14_64.sdk
# -------------
#  1.4.2.5-64 APAR IY72502 + IY70332 + IY54664
#
# Java5.sdk
# -------------
#  5.0.0.0-32 APAR IYxxxxx + IYxxxxx
#
# Java5_64.sdk
# -------------
#  5.0.0.0-64 APAR IYxxxxx + IYxxxxx
#
# Java6.sdk
# -------------
#  6.0.0.0-32 APAR IYxxxxx + IYxxxxx
#
# Java6_64.sdk
# -------------
#  6.0.0.0-64 APAR IYxxxxx + IYxxxxx
#
#------------------------------------------
#          Java6 Java5 Java142 Java141 Java131
# AIX 5.3    Y     Y     Y       U       U
#     6.1    Y     Y     Y       -       -
#     7.1    Y     ?     ?       -       -
# U=Unsupported
#------------------------------------------
  verbose_out "\n== JAVA =="

# show link to IBM's Java page !! >AW064<
# http://www.ibm.com/developerworks/java/jdk/aix/service.html
# see http://www.ibm.com/xxxxxxxxxxxx
  IBMJAVAURL="http://www.ibm.com/developerworks/java/jdk/aix/service.html"
  AddText "See IBMs Java page: <A HREF=${IBMJAVAURL}> ${IBMJAVAURL} </A>"
# ToDo 281-000 AddText / AddHTML
# ToDo 281-000 AddURL()
#

  case $osl in
    # >AW121< AIX 7.1 Toleration
    7100|6100 ) : # ...
           check_JAVA_131_32="NO";
           check_JAVA_131_64="NO";
           check_JAVA_141_32="NO";
           check_JAVA_141_64="NO";
           check_JAVA_142_32="YES";
           check_JAVA_142_64="YES";
           check_JAVA_500_32="YES";
           check_JAVA_500_64="YES";
           check_JAVA_600_32="YES";
           check_JAVA_600_64="YES";
           ;;
    5300 ) : # ...
           check_JAVA_131_32="U";
           check_JAVA_131_64="U";
           check_JAVA_141_32="U";
           check_JAVA_141_64="U";
           check_JAVA_142_32="YES";
           check_JAVA_142_64="YES";
           check_JAVA_500_32="YES";
           check_JAVA_500_64="YES";
           check_JAVA_600_32="YES";
           check_JAVA_600_64="YES";
           ;;
    *    ) : # KO
           check_JAVA_131="U";
           check_JAVA_131_32="U";
           check_JAVA_131_64="U";
           check_JAVA_141="U";
           check_JAVA_141_32="U";
           check_JAVA_141_64="U";
           check_JAVA_142="U";
           check_JAVA_142_32="U";
           check_JAVA_142_64="U";
           check_JAVA_500="NO";
           check_JAVA_500_32="NO";
           check_JAVA_500_64="NO";
           check_JAVA_600="NO";
           check_JAVA_600_32="NO";
           check_JAVA_600_64="NO";
           ;;
  esac

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Java 5 on 5.3 ONLY if TL is 03 or higher !!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if [[ "$os_vr" -eq 53 && "$tl" -lt 03 ]] ; then
  AWTRACE "Java 5 ONLY on 5.3-TL03 or higher"
  check_JAVA_500_32="NO";
  check_JAVA_500_64="NO";
fi

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Java 6 on 5.3 ONLY if TL is 07 or higher !!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if [[ "$os_vr" -eq 53 && "$tl" -lt 07 ]] ; then
  AWTRACE "Java 6 ONLY on 5.3-TL07 or higher"
  check_JAVA_600_32="NO";
  check_JAVA_600_64="NO";
fi

  check_JAVA_14x="NO"
  if [[ $check_JAVA_141 = "YES" ]]; then check_JAVA_14x="YES"; fi
  if [[ $check_JAVA_142 = "YES" ]]; then check_JAVA_14x="YES"; fi

# show installed Java Filesets
#=============================
  if [[ $check_JAVA_131 = "YES" ]]
  then
    exec_command "lslpp -lc | grep -i java13" "Java 1.3.x Filesets"
  fi
  if [[ $check_JAVA_14x = "YES" ]]
  then
    exec_command "lslpp -lc | grep -i java14" "Java 1.4.x Filesets"
  fi
  if [[ $check_JAVA_500 = "YES" ]]
  then
    exec_command "lslpp -lc | grep -i java5"  "Java 5.0.x Filesets"
  fi
  if [[ $check_JAVA_600 = "YES" ]]
  then
    exec_command "lslpp -lc | grep -i java6"  "Java 6.0.x Filesets"
  fi

#=============================
# UNSUPPORTED / END OF SERVICE
#=============================

 # Java 1.3.1 32-Bit
 #------------------
  JAVA_131_32="NO"
  if [[ $check_JAVA_131_32 = "YES" ]]
  then
    verbose_out "\n== Java 1.3.1 32-Bit=="
    java131_32=$(lslpp -l Java131.rte >/dev/null 2>&1)
    java131_32_rc=$?
    if [[ $java131_32_rc = 0 ]]
    then
      JAVA_131_32="YES"
      ERRMSG "C2H804W Note: You are running an unsupported version of Java !"
      ERRMSG "C2H805I Consider installing a newer version !"
      ERRMSG "C2H806I Java 1.3.1 End of Service was 30 September 2007 !"
    fi
  fi

 # Java 1.3.1 64-Bit
 #------------------
  JAVA_131_64="NO"
  if [[ $check_JAVA_131_64 = "YES" ]]
  then
    verbose_out "\n== Java 1.3.1 64-Bit=="
    java131_64=$(lslpp -l Java131_64.rte >/dev/null 2>&1)
    java131_64_rc=$?
    if [[ $java131_64_rc = 0 ]]
    then
      JAVA_131_64="YES"
      ERRMSG "C2H804W Note: You are running an unsupported version of Java !"
      ERRMSG "C2H805I Consider installing a newer version !"
      ERRMSG "C2H806I Java 1.3.1 End of Service was 30 September 2007 !"
    fi
  fi


 # Java 1.4.1 32-Bit
 #------------------
  JAVA_141_32="NO"
  if [[ $check_JAVA_141_32 = "YES" ]]
  then
    verbose_out "\n== Java 1.4.1 32-Bit=="
    java141=$(lslpp -l Java141.rte >/dev/null 2>&1)
    java141_rc=$?
    if [[ $java141_rc = 0 ]]
    then
      JAVA_141_32="YES"
      ERRMSG "C2H804W Note: You are running an unsupported version of Java !"
      ERRMSG "C2H805I Consider installing a newer version !"
      ERRMSG "C2H806I Java 1.4.1 End of Service was 1 March 2005 !"
    fi
  fi

 # Java 1.4.1 64-Bit
 #------------------
  JAVA_141_64="NO"
  if [[ $check_JAVA_141_64 = "YES" ]]
  then
    verbose_out "\n== Java 1.4.1 64-Bit=="
    java141_64=$(lslpp -l Java141_64.rte >/dev/null 2>&1)
    java141_64_rc=$?
    if [[ $java141_64_rc = 0 ]]
    then
      JAVA_141_64="YES"
      ERRMSG "C2H804W Note: You are running an unsupported version of Java !"
      ERRMSG "C2H805I Consider installing a newer version !"
      ERRMSG "C2H806I Java 1.4.1 End of Service was 1 March 2005 !"
    fi
  fi

#==========
# SUPPORTED
#==========
DEBUG_200=1
 if [[ ${DEBUG_200} = 1 ]] # if DEBUG 200 DBG JAVA
 then
   AWDEBUG=1 # AWdebugging 0=OFF 1=ON (200 JAVA =>ON)
 fi # fi DEBUG 200 DBG JAVA

FIX=AA0000 ; iFIX="NO"  ; FIXTXT="n/a" # dummy values to initialize the vars
check_fix="INIT" # INIT for JAVA Type=JAVA

 # Java 1.4.2 32-Bit
 #------------------
  JAVA_142_32="NO"
  verbose_out "\n== Java 1.4.2 32-Bit=="
  java142_32=$(lslpp -l Java14.sdk >/dev/null 2>&1)
  java142_32_rc=$?
  if [[ $java142_32_rc = 0 ]]
  then
    JAVA_142_32="YES"
  fi

  if [[ "$JAVA_142_32" = "YES" ]]
  then
    JAVA_142_32_FIXES
  fi #Java_142_32

 # Java 1.4.2 64-Bit
 #------------------
  JAVA_142_64="NO"
  verbose_out "\n== Java 1.4.2 64-Bit=="
  java142_64=$(lslpp -l Java14_64.sdk >/dev/null 2>&1)
  java142_64_rc=$?
  if [[ $java142_64_rc = 0 ]]
  then
    JAVA_142_64="YES"
  fi

  if [[ "$JAVA_142_64" = "YES" ]]
  then
    JAVA_142_64_FIXES
  fi  # Java_142_64

  AWTRACE "J142_32=${JAVA_142_32} J142_64=${JAVA_142_64} BIT64=${BIT64}"
  if [[ "$JAVA_142_32" = "YES" && "$JAVA_142_64" = "NO" ]]
  then
    if [[ "$BIT64" = "YES" ]]
    then
      txt1="C2H803W Note: You are running a 64-Bit Kernel but your Java 1.4.2 is 32-Bit"
# ToDo 280-009 check for 64-Bit ! If installed, MSG809I is obsolete !
      txt2="C2H809I Consider installing 64-Bit Version of Java 1.4.2"
      verbose_out "\n${txt1}"
      verbose_out ${txt2}
      ERRMSG "\n"${txt1}
      ERRMSG ${txt2}
      #-AWTRACE "\n"${txt1}
      #-AWTRACE ${txt2}
    fi
  fi

 # Java 5.0.0 32-Bit  >AW063<
 #------------------

# ToDo 710-710 AIX7 Java5
 # Note: AIX 6.1 ships with Java5.sdk (32-Bit) 5.0.0.130
 # Note: AIX 7.1 BETA ships with Java5.sdk (32-Bit) 5.0.0.290
 # Note: AIX 7.1 ships with Java5.sdk (32-Bit) 5.0.0.325
 # There are NO info in instfix database !
    fileset="Java5.sdk"
    lslpp -l ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|awk '{print $2}'|while read vv
    do
      j5_32=${vv}
    done
#

  JAVA_500_32="NO"
  if [[ $check_JAVA_500_32 = "YES" ]]
  then
    verbose_out "\n== Java 5.0.0 32-Bit=="
    java5_32=$(lslpp -l Java5.sdk >/dev/null 2>&1)
    java5_32_rc=$?
    if [[ $java5_32_rc = 0 ]]
    then
      JAVA_500_32="YES"
    fi

    if [[ "$JAVA_500_32" = "YES" ]]
    then
      JAVA_500_32_FIXES
    fi  # Java_500_32
  fi

 # Java 5.0.0 64-Bit  >AW063<
 #------------------
  JAVA_500_64="NO"
  if [[ $check_JAVA_500_64 = "YES" ]]
  then
    verbose_out "\n== Java 5.0.0 64-Bit=="
    java5_64=$(lslpp -l Java5_64.sdk >/dev/null 2>&1)
    java5_64_rc=$?
    if [[ $java5_64_rc = 0 ]]
    then
      JAVA_500_64="YES"
    fi
#
# ToDo 710-710 AIX7 Java5
    # Note: AIX 6.1 ships with Java5_64.sdk (64-Bit) 5.0.0.150
    # Note: AIX 7.1 BETA ships with Java5.sdk (64-Bit) 5.0.0.290
    # Note: AIX 7.1 ships with Java5.sdk (64-Bit) 5.0.0.325
    # There is NO info in instfix database !
    fileset="Java5_64.sdk"
    lslpp -l ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|awk '{print $2}'|while read vv
    do
      j5_64=${vv}
    done
#
    if [[ "$JAVA_500_64" = "YES" ]]
    then
      JAVA_500_64_FIXES
    fi  # Java_500_64
  fi

  AWTRACE "J500_32=${JAVA_500_32} J500_64=${JAVA_500_64} BIT64=${BIT64}"
  if [[ "$JAVA_500_32" = "YES" && "$JAVA_500_64" = "NO" ]]
  then
    if [[ "$BIT64" = "YES" ]]
    then
      txt1="C2H803W Note: You are running a 64-Bit Kernel but your Java 5.0.0 is 32-Bit"
      txt2="C2H809I Consider installing 64-Bit Version of Java 5.0.0"
      verbose_out "\n${txt1}"
      verbose_out ${txt2}
      ERRMSG "\n"${txt1}
      ERRMSG ${txt2}
      #-AWTRACE "\n"${txt1}
      #-AWTRACE ${txt2}
    fi
  fi

 # Java 6.0.0 32-Bit  >AW0xx<
 #------------------
  JAVA_600_32="NO"
  if [[ $check_JAVA_600_32 = "YES" ]]
  then
    verbose_out "\n== Java 6.0.0 32-Bit=="
    java6_32=$(lslpp -l Java6.sdk >/dev/null 2>&1)
    java6_32_rc=$?
    if [[ $java6_32_rc = 0 ]]
    then
      JAVA_600_32="YES"
    fi

# ToDo 710-710 AIX7 Java6
    # Note: AIX 7.1 BETA ships with Java6.sdk (32-Bit) 6.0.0.200
    # Note: AIX 7.1 ships with Java6.sdk (32-Bit) 6.0.0.215

    fileset="Java6.sdk"
    lslpp -l ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|awk '{print $2}'|while read vv
    do
      j6_32=${vv}
    done
#
    if [[ "$JAVA_600_32" = "YES" ]]
    then
      JAVA_600_32_FIXES
    fi  # Java_600_32
  fi

check_fix="NEXT" # global INIT Type=COMP

 # Java 6.0.0 64-Bit  >AW0xx<
 #------------------
  JAVA_600_64="NO"
  if [[ $check_JAVA_600_64 = "YES" ]]
  then
    verbose_out "\n== Java 6.0.0 64-Bit=="
    java6_64=$(lslpp -l Java6_64.sdk >/dev/null 2>&1)
    java6_64_rc=$?
    if [[ $java6_64_rc = 0 ]]
    then
      JAVA_600_64="YES"
    fi

    if [[ "$JAVA_600_64" = "YES" ]]
    then
      JAVA_600_64_FIXES
    fi  # Java_600_64
  fi

  AWTRACE "J600_32=${JAVA_600_32} J600_64=${JAVA_600_64} BIT64=${BIT64}"
  if [[ "$JAVA_600_32" = "YES" && "$JAVA_600_64" = "NO" ]]
  then
    if [[ "$BIT64" = "YES" ]]
    then
      txt1="C2H803W Note: You are running a 64-Bit Kernel but your Java 6.0.0 is 32-Bit"
      txt2="C2H809I Consider installing 64-Bit Version of Java 6.0.0"
      verbose_out "\n${txt1}"
      verbose_out ${txt2}
      ERRMSG "\n"${txt1}
      ERRMSG ${txt2}
      #-AWTRACE "\n"${txt1}
      #-AWTRACE ${txt2}
    fi
  fi

# Check if Java5 (32 or 64) is installed
# ======================================
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Java 5 on 5.3 ONLY if TL is 03 or higher !!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if [[ "$os_vr" -eq 53 && "$tl" -lt 03 ]] ; then
 :
else
 verbose_out "\n== Java5 32/64-Bit=="
 if [[ "$JAVA_500_32" = "NO" && "$JAVA_500_64" = "NO" ]]
 then
   txt1="C2H802W Java5 NOT Installed on this system !"
   verbose_out ${txt1}
   ERRMSG ${txt1}
 fi # 500-32+64
fi

# Check if Java6 (32 or 64) is installed
# ======================================
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Java 6 on 5.3 ONLY if TL is 07 or higher !!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if [[ "$os_vr" -eq 53 && "$tl" -lt 07 ]] ; then
 :
else
 verbose_out "\n== Java6 32/64-Bit=="
 if [[ "$JAVA_600_32" = "NO" && "$JAVA_600_64" = "NO" ]]
 then
   txt1="C2H802W Java6 NOT Installed on this system !"
   verbose_out ${txt1}
   ERRMSG ${txt1}
 fi # 600-32+64
fi

# Check if 32+64 => Only ONE is needed
# ====================================
 verbose_out "\n== Java 32/64-Bit=="

 if [[ "$JAVA_142_32" = "YES" && "$JAVA_142_64" = "YES" ]]
 then
   txt1="C2H807W Note: You are running a 32-Bit AND 64-Bit version of Java 1.4.2 !"
   txt2="C2H808I Consider de-installing 32-Bit version !"
   verbose_out ${txt1}
   verbose_out ${txt2}
# ToDo change errmsg to errlog
   ERRLOG ${txt1}
   ERRLOG ${txt2}
 fi # 142-32+64

 if [[ "$JAVA_500_32" = "YES" && "$JAVA_500_64" = "YES" ]]
 then
   txt1="C2H807W Note: You are running a 32-Bit AND 64-Bit version of Java 5.0.0 !"
   txt2="C2H808I Consider de-installing 32-Bit version !"
   verbose_out ${txt1}
   verbose_out ${txt2}
   ERRLOG ${txt1}
   ERRLOG ${txt2}
 fi # 500-32+64

 if [[ "$JAVA_600_32" = "YES" && "$JAVA_600_64" = "YES" ]]
 then
   txt1="C2H807W Note: You are running a 32-Bit AND 64-Bit version of Java 6.0.0 !"
   txt2="C2H808I Consider de-installing 32-Bit version !"
   verbose_out ${txt1}
   verbose_out ${txt2}
   ERRLOG ${txt1}
   ERRLOG ${txt2}
 fi # 600-32+64

# ToDo 000-000 get path where java is installed !!
# ToDo 000-000 show link to IBM's Java page !! >AW064<

# show exact Java version
# -----------------------
  verbose_out "\n== Java version=="
  exec_command "java -version 2>&1" "Java"
  exec_command "java -fullversion 2>&1" "Java (fullversion)"

  #AWTRACE ": JAVA_131_32=${JAVA_131_32} => UNSUPPORTED"  # OUTDATED
  #AWTRACE ": JAVA_131_64=${JAVA_131_64} => UNSUPPORTED"  # OUTDATED
  #AWTRACE ": JAVA_141_32=${JAVA_141_32} => UNSUPPORTED"  # OUTDATED
  AWTRACE " "
  AWTRACE ": JAVA_142_32=${JAVA_142_32}               "  # OK
  AWTRACE ": JAVA_142_64=${JAVA_142_64}               "  # OK
  AWTRACE ": JAVA_500_32=${JAVA_500_32}               "  # OK
  AWTRACE ": JAVA_500_64=${JAVA_500_64}               "  # OK
  AWTRACE ": JAVA_600_32=${JAVA_600_32}               "  # OK
  AWTRACE ": JAVA_600_64=${JAVA_600_64}               "  # OK

#++ >AW052< end *java*-------------------------------------------------

 AWTRACE "*>>> EOF <<<"
 AWTRACE_DSN_OLD=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${TRACE_DSN[$dsn_lvl]} # restore AWTRACE_DSN

 #:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-
 dsn_lvl=dsn_lvl-1
 ERRLOG "<<<< output > ${AWTRACE_DSN} was ${AWTRACE_DSN_OLD}"

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "JAVA"

 DBG "JAVA 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
 if [[ ${DEBUG_200} = 1 ]] # if DEBUG 200 DBG JAVA
 then
   AWDEBUG=0 # AWdebugging 0=OFF 1=ON (200 JAVA =>OFF)
 fi # fi DEBUG 200 DBG JAVA
}

#.....................................................................
#.....................................................................
# Collector Subroutines
#.....................................................................
#.....................................................................

#.....................................................................
# JAVA_142_32_FIXES: ...
#.....................................................................
JAVA_142_32_FIXES ()
{
 txt="== check Fixes for Java 1.4.2 32-Bit =="
 verbose_out "\n${txt}"
 #ERRLOG "${txt}"
 AddText "${txt}"

 check_fix="NEXT" # INIT for JAVA_142_32 Type=JAVA

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ90388 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.395 SR13FP8" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ85932 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.380 SR13FP6" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ78401 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.365 SR13FP5" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ70828 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.335 SR13FP4" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ65489 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.320 SR13FP3" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ62265 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.305 SR13FP2" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ56705 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.290 SR13FP1" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ47402 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.275 SR13" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ33546 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.250 SR12" # >AW095<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ23124 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.225 SR11" # >AW081<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ14148 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.200 SR10" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ01176 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.175 SR9" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY96843 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.150 SR8" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY91756 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.125 SR7" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY88395 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update 1.4.2.100 SR6"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY84053 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update SR5"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY81443 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update SR4 (REPACKAGED !!)"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY77460 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update SR4 (BAD !!)"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY75003 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update SR3"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY72469 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update SR2"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY70052 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Update"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY54663 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 32-Bit Base"
   check_JAVA_Fix
 fi
}

#.....................................................................
# JAVA_142_64_FIXES: ...
#.....................................................................
JAVA_142_64_FIXES ()
{
 txt="== check Fixes for Java 1.4.2 64-Bit =="
 verbose_out "\n${txt}"
 #ERRLOG "${txt}"
 AddText "${txt}"

 check_fix="NEXT" # INIT for JAVA_142_64 Type=JAVA

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ90387 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.395 SR13FP8" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ85933 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.380 SR13FP6" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ78471 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.365 SR13FP5" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ70829 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.335 SR13FP4" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ65490 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.320 SR13FP3" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ62264 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.305 SR13FP2" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ56710 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.290 SR13FP1" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ47404 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.275 SR13" # >AW118<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ33548 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.250 SR12" # >AW095<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ23125 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.225 SR11" # >AW081<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ14149 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.200 SR10" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ01178 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.175 SR9" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY96845 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.150 SR8" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY92312 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.125 SR7" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY88400 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.100 SR6"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY87795 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.81 n/a"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY84054 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.75 SR5"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY81444 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.51 SR4 (REPACKAGED)"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY77461 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.50 SR4 (BAD !!)"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY75004 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.20 SR3"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY72502 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.10 SR2"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY70332 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.5 n/a"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY68122 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.3 SR1a"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY62851 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Update 1.4.2.1 SR1"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY54664 ; iFIX="NO"  ; FIXTXT="Java 1.4.2 64-Bit Base 1.4.2.0 GA"
   check_JAVA_Fix
 fi
}

#.....................................................................
# JAVA_500_32_FIXES: ...
#.....................................................................
JAVA_500_32_FIXES ()
{
 txt="== check Fixes for Java 5.0.0 32-Bit =="
 verbose_out "\n${txt}"
 #ERRLOG "${txt}"
 AddText "${txt}"

 check_fix="NEXT" # INIT for JAVA_500_32 Type=JAVA

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ90860 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.390 SR12FP3 " # >AW117<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ86553 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.360 SR12FP2 " # >AW117<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ83153 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.345 SR12FP1 " # >AW117<
  check_JAVA_Fix
 fi

 # needed for AIX 7.1 Base installation
 if [[ "${j5_32}" = "5.0.0.325" ]] then check_fix="DONE"; fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ76420 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.305 SR11FP2 " # >AW117<
  check_JAVA_Fix
 fi

 # needed for AIX 7.1 BETA installation
 if [[ "${j5_32}" = "5.0.0.290" ]] then check_fix="DONE"; fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ70125 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.290 SR11FP1 " # >AW117<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ64936 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.275 SR11 " # >AW117<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ55273 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.250 SR10 " # >AW117<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ48295 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.235 SR9-SSU " # >AW117<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ39401 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.225 SR9 " # >AW116<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ29993 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.210 SR8a" # >AW084<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ27812 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.200 SR8" # >AW084<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ18002 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.175 SR7" # >AW080<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ07645 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.160 SR6" # >AW046<
   check_JAVA_Fix
 fi

 # needed for AIX 6.1 Base installation
 if [[ "${j5_32}" = "5.0.0.130" ]] then check_fix="DONE"; fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ02874 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.130 SR5a" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY96845 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.125 SR5" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY94334 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.100 SR4" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY90809 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.76 n/a" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY90224 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.75 SR3"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY88729 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.51 n/a"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY83355 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.50 SR2"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY82213 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.25 SR1"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY80649 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 32-Bit Update 5.0.0.10 n/a"
   check_JAVA_Fix
 fi
}

#.....................................................................
# JAVA_500_64_FIXES: ...
#.....................................................................
JAVA_500_64_FIXES ()
{
 txt="== check Fixes for Java 5.0.0 64-Bit =="
 verbose_out "\n${txt}"
 #ERRLOG "${txt}"
 AddText "${txt}"

 check_fix="NEXT" # INIT for JAVA_500_64 Type=JAVA

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ90861 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.390 SR12FP3 " # >AW117<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ86554 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.360 SR12FP2 " # >AW117<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ83154 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.345 SR12FP1 " # >AW117<
  check_JAVA_Fix
 fi

 # needed for AIX 7.1 Base installation
 if [[ "${j5_64}" = "5.0.0.325" ]] then check_fix="DONE"; fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ76421 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.305 SR11FP2 " # >AW117<
  check_JAVA_Fix
 fi

 # needed for AIX 7.1 BETA installation
 if [[ "${j5_64}" = "5.0.0.290" ]] then check_fix="DONE"; fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ70126 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.290 SR11FP1 " # >AW117<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ64937 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.275 SR11 " # >AW117<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ55274 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.250 SR10 " # >AW117<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ48294 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.235 SR9-SSU " # >AW117<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ39402 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.225 SR9 " # >AW116<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ29994 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.210 SR8a" # >AW084<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ27813 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.200 SR8" # >AW084<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ18003 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.175 SR7" # >AW080<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ07646 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.160 SR6" # >AW046<
   check_JAVA_Fix
 fi

 # needed for AIX 6.1 Base installation
 if [[ "${j5_64}" = "5.0.0.150" ]] then check_fix="DONE"; fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ02875 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.130 SR5a" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY98586 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.125 SR5" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY94335 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.100 SR4" # >AW046<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY90295 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.75 SR3"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY84055 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.50 SR2"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY82254 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.25 SR1"
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IY80650 ; iFIX="NO"  ; FIXTXT="Java 5.0.0 64-Bit Update 5.0.0.10 n/a"
   check_JAVA_Fix
 fi
}

#.....................................................................
# JAVA_600_32_FIXES: ...
#.....................................................................
JAVA_600_32_FIXES ()
{
 txt="== check Fixes for Java 6.0.0 32-Bit =="
 verbose_out "\n${txt}"
 #ERRLOG "${txt}"
 AddText "${txt}"

 check_fix="NEXT" # INIT for JAVA_600_32 Type=JAVA

# ToDo 710-710 FIXTXT not set => AND NOT DISPLYED
 # needed for AIX 7.1 Base installation
 if [[ "${j6_32}" = "6.0.0.215" ]] then check_fix="DONE"; fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ89819 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 32-Bit Update 6.0.0.250 SR9" # >AW117
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ78662 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 32-Bit Update 6.0.0.215 SR8FP1" # >AW117
  check_JAVA_Fix
 fi

 # needed for AIX 7.1 BETA installation
 if [[ "${j6_32}" = "6.0.0.200" ]] then check_fix="DONE"; fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ74890 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 32-Bit Update 6.0.0.200 SR8" # >AW117
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ67337 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 32-Bit Update 6.0.0.175 SR7" # >AW117
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ63956 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 32-Bit Update 6.0.0.152 SR6" # >AW117
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ62667 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 32-Bit Update 6.0.0.150 SR6" # >AW117
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ52817 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 32-Bit Update 6.0.0.125 SR5" # >AW117
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ50170 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 32-Bit Update 6.0.0.110 SR4+IZ48590" # >AW117
  check_JAVA_Fix
 fi

# Removed from Webpage by IBM as of 09/04/27 !!??
#if [[ "${check_fix}" = "NEXT" ]]
#then
#  FIX=IZ45341 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 32-Bit Update 6.0.0.100 SR4" # >AW117<
# check_JAVA_Fix
#fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ37672 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 32-Bit Update 6.0.0.75  SR3" # >AW112<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ30723 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 32-Bit Update 6.0.0.50  SR2" # >AW090<
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ20750 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 32-Bit Update 6.0.0.25  SR1" # >AW084<
   check_JAVA_Fix
 fi
}

#.....................................................................
# JAVA_600_64_FIXES: ...
#.....................................................................
JAVA_600_64_FIXES ()
{
 txt="== check Fixes for Java 6.0.0 64-Bit =="
 verbose_out "\n${txt}"
 #ERRLOG "${txt}"
 AddText "${txt}"

 check_fix="NEXT" # INIT for JAVA_600_64 Type=JAVA

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ89820 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 64-Bit Update 6.0.0.250 SR9" # >AW117
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ78668 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 64-Bit Update 6.0.0.215 SR8FP1" # >AW117
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ74891 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 64-Bit Update 6.0.0.200 SR8" # >AW117
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ67338 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 64-Bit Update 6.0.0.175 SR7" # >AW117
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ62671 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 64-Bit Update 6.0.0.150 SR6" # >AW117
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ52818 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 64-Bit Update 6.0.0.125 SR5" # >AW117
  check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ50167 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 64-Bit Update 6.0.0.110 SR4+IZ48590" # >AW117
  check_JAVA_Fix
 fi

# Removed from Webpage by IBM as of 09/04/27 !!??
#if [[ "${check_fix}" = "NEXT" ]]
#then
#  FIX=IZ45342 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 64-Bit Update 6.0.0.100 SR4" # >AW117<
#  check_JAVA_Fix
#fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ37674 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 64-Bit Update 6.0.0.75  SR3" # >AW112<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ30726 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 64-Bit Update 6.0.0.50  SR2" # >AW090<
   check_JAVA_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
   FIX=IZ20752 ; iFIX="NO"  ; FIXTXT="Java 6.0.0 64-Bit Update 6.0.0.25  SR1" # >AW084<
   check_JAVA_Fix
 fi
}

#.....................................................................
# check_JAVA_FIX: ...
#.....................................................................
check_JAVA_Fix ()
{
# 1=FIX 2=iFIX 3=FIXTXT
#echo "\n-=[ check_JAVA_Fix ]=-\n"
 check_fix="NEXT"

# fix=$(instfix -ivk $FIX 2>&1 | grep -v "not applied")
 instfix -ivk $FIX >/dev/null 2>&1 # Type=JAVA
 fix_rc=$?
#echo " "
 if [[ $fix_rc -ne 0 ]]
 then
   #check_fix="NEXT" # Type=JAVA
   txt="FIX ${FIX} NOT installed !! Missing ${FIXTXT}"
   AWTRACE $txt
   #AddText $txt
 else
   check_fix="DONE" # Type=JAVA
   txt="FIX ${FIX} installed. You are using ${FIXTXT}"
   AWTRACE $txt
   #AddText $txt
 fi

# ToDo 000-000 iFIX checking if necessary
 if [[ $iFIX = "YES" ]]
 then
   iFIX="NO"
   :
 fi

# ToDo 000-000 RC
 return $rc
}

######################################################################
# collect_compiler: *col-19*R* Compiler/Runtime info (gcc,xlC,vac,vacpp)
######################################################################
collect_compiler ()
{
#++ >AW088< start *Compiler/Runtime*----------------------------------
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=1  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 AWDEBUG=1 # AWdebugging 0=OFF 1=ON (789 COMPILER =>ON

 DBG ":---------------------------------------"
 DBG "Compiler 001"

  verbose_out "\n-=[ 19/${_maxcoll} Compiler-Info ]=-\n"
  paragraph_start "Compiler"
  inc_heading_level
 #////////////////////////////////////////////////////////////////////

  AWTRACE "== Compiler info =="

#++ >AW444< start *ibm c*---------------------------------------------
  DBG "Compiler 010"
  AWTRACE "== ibm c =="  # \n only needed for output to screen

  AWTRACE "%%%%% ibm c -start- %%%%%%%%%"
# ToDo 280-012 info about IBM C Compiler
  AWTRACE "%%%%% xlc -start- %%%%%%%%%"
  wx=$(which /usr/vac/bin/xlc >/dev/null 2>&1)
  which_rc=$?
  if [[ $which_rc = 0 ]]
  then
    exec_command "/usr/vac/bin/xlc -qversion 2>&1"  "xlc: xlc -qversion"
    exec_command "lslpp -l vac 2>/dev/null"   "lslpp -l vac"
  else
    txt=": xlc not found wx=${wx} rc=${which_rc}"
    AWTRACE ${txt}
    AddText "${txt}"
  fi
  AWTRACE "%%%%% xlc -end- %%%%%%%%%%%"

  AWTRACE "%%%%% ibm c -end- %%%%%%%%%%%"
#++ >AW444< end *ibm c*-----------------------------------------------

#++ >AW068< start *gcc*-----------------------------------------------
  DBG "Compiler 020"
  AWTRACE "== gcc =="  # \n only needed for output to screen

  AWTRACE "%%%%% gcc -start- %%%%%%%%%"
  wx=$(which gcc >/dev/null 2>&1)
  which_rc=$?
  if [[ $which_rc = 0 ]]
  then
    exec_command "gcc -v 2>&1"  "gcc: gcc -v"
    AWTRACE "== rpm gcc =="
# ToDo 280-013 on AIXI which gcc gives rc=0 but rpm -q gcc shows: Not Installed
# ToDo 280-013 2>&1 or 2>/dev/null for rpm
    exec_command "rpm -q gcc"   "rpm: rpm -q gcc"
    exec_command "rpm -qi gcc"  "rpm: rpm -qi gcc"
  else
    txt=": gcc not found wx=${wx} rc=${which_rc}"
    AWTRACE ${txt}
    AddText "${txt}"
  fi
  AWTRACE "%%%%% gcc -end- %%%%%%%%%%%"
#++ >AW068< end *gcc*-------------------------------------------------

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# check level of gcc compiler"
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#
#======================================================================
# gcc
#======================================================================
  DBG "GCC 001"
#

 #:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+
 dsn_lvl=dsn_lvl+1
 TRACE_DSN[$dsn_lvl]=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${gcc_LOG}  # set AWTRACE_DSN
 ERRLOG ">>>> output > ${AWTRACE_DSN} LVL=${dsn_lvl}"
 infofile_header "gcc"

 gccpath=$(which gcc 2>/dev/null)
 rc=$?
 if [[ ${rc} -ne 0 ]]
 then
   xgcc="NO"
   AWTRACE "NO gcc compiler installed ! (not found in path)"
   #exit 1
 else
   xgcc="YES"
   AWTRACE "gcc found at ${gccpath}"
 fi

 # get lslpp info for gcc if any
 gcclslpp=$(lslpp -l | grep gcc)
 if [[ ${rc} -ne 0 ]]
 then
   AWTRACE "NO lslpp package for gcc found"
 else
   AWTRACE "Following lslpp package for gcc found:"
   AWTRACE "${gcclslpp}"
   AWTRACE " "
 fi

 # get rpm info for gcc if any
 gccrpm=$(rpm -qa | grep gcc)
 if [[ ${rc} -ne 0 ]]
 then
   AWTRACE "NO rpm info for gcc found"
 else
   AWTRACE "Following rpm info for gcc found:"
   AWTRACE "${gccrpm}"
   AWTRACE " "
 fi

 # ask gcc for its version info, but only if it is installed
 if [[ ${xgcc} = "YES" ]]
 then
   gccv=$(gcc -v 2>&1)
   #
   set -A gcc_l
   typeset -i i
   i=0
   echo "${gccv}"| while read line
   do
     gcc_l[$i]=$line
     #AWTRACE "L$i=$line"
     i=i+1
   done
   i=i-1
   # i=number of lines return from gcc -v (start with 0 !!)
   DBG "GCC 010"

   case $i in
    4) test_gcc400;
       ;;
    3) test_gcc332;
       ;;
    1) test_gcc295;
       ;;
    *)
       AWTRACE "C2H203I Internal error checking GCC";
       AWTRACE "Error ! Output contains unexpected number of lines";
       AWTRACE "I<>4 ! I=$i";
       AWTRACE "L0=${gcc_l[0]}";
       AWTRACE "L1=${gcc_l[1]}";
       AWTRACE "L2=${gcc_l[2]}";
       AWTRACE "L3=${gcc_l[3]}";
       AWTRACE "L4=${gcc_l[4]}";
       AWTRACE "L5=${gcc_l[5]}";
       #exit 1;
       ;;
   esac
 fi

 DBG "GCC 011"

 AWTRACE "*>>> EOF <<<"
 AWTRACE_DSN_OLD=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${TRACE_DSN[$dsn_lvl]} # restore AWTRACE_DSN

 #:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-
 dsn_lvl=dsn_lvl-1
 ERRLOG "<<<< output > ${AWTRACE_DSN} was ${AWTRACE_DSN_OLD}"

 DBG "GCC 012"
#

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#   AWCONST "\nCheck for xlC, vac, vacpp =="
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#======================================================================
# xlC
#======================================================================
 DBG "XLC 001"

 #:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+
 dsn_lvl=dsn_lvl+1
 TRACE_DSN[$dsn_lvl]=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${xlc_LOG}  # set AWTRACE_DSN
 ERRLOG ">>>> output > ${AWTRACE_DSN} LVL=${dsn_lvl}"
 infofile_header "xlC"

 check="INIT"

 case $osl in
   7100|6100 ) check="YES"
        ;;
   5300 )
        case ${tl} in
          00 ) check="UNSUPPORTED";;
          01 ) check="UNSUPPORTED";;
          02 ) check="UNSUPPORTED";;
          03 ) check="UNSUPPORTED";;
          04 ) check="YES";; # > UNSUPPORTED
          05 ) check="YES";; # > UNSUPPORTED
           * )
              check="YES";
              ;;
        esac;
        ;;
      * )
        check="NO"
        AWTRACE "C2H203I Internal error checking xlC (ID=001)";
        AWTRACE "C2H030E Unknown AIX Level";
 esac;

 if [[ ${check} = "UNSUPPORTED" ]]
 then
   check="NO"
   AWTRACE "C2H203I Internal error checking xlC (ID=002)";
   AWTRACE "C2H039E Unsupported AIX ${mltl}-Level (${osl}-${tl})";
 fi

#----------------------------------------------------------------------
 if [[ ${check} = "YES" ]]
 then
   xlc_checks
 fi

 AWTRACE "*>>> EOF <<<"
 AWTRACE_DSN_OLD=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${TRACE_DSN[$dsn_lvl]} # restore AWTRACE_DSN

 #:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-
 dsn_lvl=dsn_lvl-1
 ERRLOG "<<<< output > ${AWTRACE_DSN} was ${AWTRACE_DSN_OLD}"

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "Compiler"

 DBG "Compiler 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
 AWDEBUG=0 # AWdebugging 0=OFF 1=ON (789 COMPILER =>OFF
#++ >AW088< end *Compiler/Runtime*------------------------------------
}

#.....................................................................
#.....................................................................
# Collector Subroutines
#.....................................................................
#.....................................................................

#.....................................................................
# test_gcc400:
#.....................................................................
test_gcc400 ()
{
 DBG "GCC-400 001"

 AWTRACE "AWGCC: "
 AWTRACE "AWGCC: expecting to find gcc 4.x.x"
 AWTRACE "AWGCC: "

# wc gives: lines words chars
# we expect w=12 (for 4.2.4)
#
 xxx=$(echo ${gcc_l[2]}| wc)
 echo "${xxx}" | read l w c # l=line(s) w=words c=chars
 if [[ $w = 12 ]]
 then
  :
 else
  AWTRACE "AWGCC: Error ! Output line contains unexpected number of words"
  AWTRACE "AWGCC: Line=${gcc_l[2]}"
  AWTRACE "AWGCC: w<>12 w=${w} (l=${l} c=${c})"
  AWTRACE "AWGCC: "
  #exit 1
 fi

# get version number of gcc
set -A L4 $(echo ${gcc_l[4]})
# AWTRACE "L4.0=${L4[0]}" # gcc
# AWTRACE "L4.1=${L4[1]}" # version:
# AWTRACE "L4.2=${L4[2]}" # 4.x.x
 gcc_version=${L4[2]}
 if [[ ${gcc_version} = "4.0.0" ]]
 then
   AWTRACE "AWGCC: WARNING ! Outdated gcc version (${gcc_version}) found."
 fi

# get "Target" os-version
set -A L1 $(echo ${gcc_l[1]})
# AWTRACE "L1.0=${L1[0]}" # Target:
# AWTRACE "L1.1=${L1[1]}" # powerpc-ibm-aix5.3.0.0
 gcc_target=${L1[1]}
#
 if [[ ${L1[0]} = "Target:" ]]
 then
  :
  ts="powerpc-ibm-aix"${OSLEVEL}
  if [[ ${gcc_target} = ${ts} ]]
  then
   AWTRACE "AWGCC: OK ! Your gcc version (${gcc_version}) matches your os"
   AWTRACE "AWGCC: ts=${ts}"
   AWTRACE "AWGCC: gcc_target=${gcc_target}"
   AWTRACE "AWGCC: "
  else
   AWTRACE "AWGCC: WARNING ! Your gcc version (${gcc_version}) does not match your os"
   AWTRACE "AWGCC: ts=${ts}"
   AWTRACE "AWGCC: gcc_target=${gcc_target}"
   AWTRACE "AWGCC: "
   #exit 1
  fi
 else
   AWTRACE "AWGCC: Internal error ! "Target:" does not match"
   #exit 1
 fi

#
# get the gcc config options
set -A array $(echo ${gcc_l[2]})
ts="--host=powerpc-ibm-aix"${OSLEVEL}
if [[ ${array[11]} = ${ts} ]]
then
 :
 AWTRACE "AWGCC: OK ! Your gcc version (${gcc_version}) matches your os"
 AWTRACE "AWGCC: TS=${ts}"
 AWTRACE "AWGCC: A11=${array[11]}"
 AWTRACE "AWGCC: "
else
 #
 AWTRACE "AWGCC: WARNING ! Your gcc version (${gcc_version}) does not match your os"
 AWTRACE "AWGCC: TS=${ts}"
 AWTRACE "AWGCC: A11=${array[11]}"
 AWTRACE "AWGCC: "
 AWTRACE " "
 if [[ ${DEBUG_999} = 1 ]] # DEBUG_998 GCC
 then
   AWTRACE "ARRAY-0  = ${array[0]}<"
   AWTRACE "ARRAY-1  = ${array[1]}<"
   AWTRACE "ARRAY-2  = ${array[2]}<"
   AWTRACE "ARRAY-3  = ${array[3]}<"
   AWTRACE "ARRAY-4  = ${array[4]}<"
   AWTRACE "ARRAY-5  = ${array[5]}<"
   AWTRACE "ARRAY-6  = ${array[6]}<"
   AWTRACE "ARRAY-7  = ${array[7]}<"
   AWTRACE "ARRAY-8  = ${array[8]}<"
   AWTRACE "ARRAY-9  = ${array[9]}<"
   AWTRACE "ARRAY-10 = ${array[10]}<"
   AWTRACE "ARRAY-11 = ${array[11]}<"
   AWTRACE " "
 fi
 #exit 1
fi
}

#.....................................................................
# test_gcc332:
#.....................................................................
test_gcc332 ()
{
 DBG "GCC-332 001"
 AWTRACE "AWGCC: expecting to find gcc 3.3.2"

# get version number of gcc
set -A L3 $(echo ${gcc_l[3]})
# AWTRACE "L3.0=${L3[0]}" # gcc
# AWTRACE "L3.1=${L3[1]}" # version:
# AWTRACE "L3.2=${L3[2]}" # 3.3.2
 gcc_version=${L3[2]}
#
 AWTRACE "AWGCC: WARNING ! Outdated gcc version (${gcc_version}) found."
#
# get the gcc config options
set -A array $(echo ${gcc_l[1]})
ts="--host=powerpc-ibm-aix"${OSLEVEL}
if [[ ${array[11]} = ${ts} ]]
then
 :
 AWTRACE "AWGCC: OK ! Your gcc version (${gcc_version}) matches your os"
 AWTRACE "AWGCC: TS=${ts}"
 AWTRACE "AWGCC: A11=${array[11]}"
else
 #
 AWTRACE "AWGCC: WARNING ! Your gcc version (${gcc_version}) does not match your os"
 AWTRACE "AWGCC: TS=${ts}"
 AWTRACE "AWGCC: OSL=${OSLEVEL}"
 AWTRACE "AWGCC: A11=${array[11]}"
 AWTRACE " "
 if [[ $opt_verbose = 1 ]]
 then
  AWTRACE "ARRAY-0  = ${array[0]}<"
  AWTRACE "ARRAY-1  = ${array[1]}<"
  AWTRACE "ARRAY-2  = ${array[2]}<"
  AWTRACE "ARRAY-3  = ${array[3]}<"
  AWTRACE "ARRAY-4  = ${array[4]}<"
  AWTRACE "ARRAY-5  = ${array[5]}<"
  AWTRACE "ARRAY-6  = ${array[6]}<"
  AWTRACE "ARRAY-7  = ${array[7]}<"
  AWTRACE "ARRAY-8  = ${array[8]}<"
  AWTRACE "ARRAY-9  = ${array[9]}<"
  AWTRACE "ARRAY-10 = ${array[10]}<"
  AWTRACE "ARRAY-11 = ${array[11]}<"
  AWTRACE " "
 fi
 #exit 1
fi
}

#.....................................................................
# test_gcc295:
#.....................................................................
test_gcc295 ()
{
 DBG "GCC-295 001"
 AWTRACE "AWGCC: expecting to find gcc 2.95.3"

# get os info from gcc build
# e.g.  Using builtin specs.
# e.g.  Reading specs from /usr/local/lib/gcc-lib/powerpc-ibm-aix4.3.2.0/2.95.3/specs
set -A L0 $(echo ${gcc_l[0]})
# AWTRACE "L0.0=${L0[0]}" # using
# AWTRACE "L0.1=${L0[1]}" # builtin
# AWTRACE "L0.2=${L0[2]}" # specs
if [[ ${L0[0]} = "using" ]]
then
 osinfo="NO"
else
 osinfo="YES"
 echo "${L0[3]}" | IFS="/" read a b c d e f
 gcc4os=${f}
fi

# get version number of gcc
# e.g.  gcc version 2.95.3 20010315 (release)
set -A L1 $(echo ${gcc_l[1]})
# AWTRACE "L1.0=${L1[0]}" # gcc
# AWTRACE "L1.1=${L1[1]}" # version:
# AWTRACE "L1.2=${L1[2]}" # 2.95.3
# AWTRACE "L1.3=${L1[3]}" # 20010315
# AWTRACE "L1.4=${L1[4]}" # (release)
 gcc_version=${L1[2]}
 gcc_build=${L1[3]}
#
 AWTRACE "AWGCC: WARNING ! Outdated gcc version (${gcc_version}) found."
#
 if [[ $osinfo = "NO" ]]
 then
   AWTRACE "AWGCC: Note: No os information from gcc available."
 else
   AWTRACE "AWGCC: Following os information from gcc available:"
   AWTRACE "${gcc4os}"
 fi
}

#.....................................................................
# check_COMP_Fix: ...
#.....................................................................
check_COMP_Fix ()
{
# 1=FIX 2=iFIX 3=FIXTXT
#echo "\n-=[ check_COMP_Fix ]=-\n"
 echo $OSLVLML $FIX "*" $FIXTXT >>${AWTRACE_DSN}
 check_fix="NEXT"

 instfix -ivk $FIX  2>/dev/null >>${AWTRACE_DSN} # Type=COMP
 fix_rc=$?
 if [[ ${fix_rc} = 0 ]]
 then
   check_fix="DONE" # Type=COMP
   txt="FIX ${FIX} installed."
   AWTRACE $txt
 else
   txt="FIX ${FIX} NOT installed ! (iFIX ${iFIX})"
   AWTRACE $txt
 fi

#Do iFIX checking if necessary
 if [[ $iFIX = "YES" ]]
 then
   iFIX="NO"
   :
 fi
}

#......................................................................
# checkfileset: ...
#......................................................................
checkfileset ()
{
_fileset=$1
xgrep=$2

if [[ ${_fileset} = "" ]]
then
 AWTRACE "INTERNAL Error: No Fileset given"
else
 AWTRACE " "
 AWTRACE "${_fileset} Filesets"
 AWTRACE "--------------"
 lslpp -l | grep ${_fileset}. >>${AWTRACE_DSN} 2>&1
 _fs=$(lslpp -l | grep ${_fileset}. >/dev/null 2>&1)
 _fs_rc=$?
 if [[ ${_fs_rc} = 0 ]]
 then
  : # OK
 else
  AWTRACE "'${_fileset}' Not installed. lslpp RC is ${_fs_rc}"
 fi
fi
}

#......................................................................
# xlc_checks: xxx
#......................................................................
xlc_checks ()
{
 DSN_xlc="${TMPDIR}/c2h_xlc_${PROCID}.tmp"
 lslpp -lc xlC.rte >${DSN_xlc} 2>/dev/null
 lslpp_rc=$?

AWTRACE " "
AWTRACE "Fileset Overview"
AWTRACE "================"
AWTRACE " "

#*********************************************************************
AWTRACE " "
AWTRACE "xlC Filesets"
AWTRACE "------------"
lslpp -l | grep xlC. >>${AWTRACE_DSN} 2>&1
xlC8=$(lslpp -lc xlC.rte | grep 8.0 | grep -v Fileset:Level)
xlC8_rc=$?
xlC9=$(lslpp -lc xlC.rte | grep 9. | grep -v Fileset:Level)
xlC9_rc=$?
xlC10=$(lslpp -lc xlC.rte | grep 10. | grep -v Fileset:Level)
xlC10_rc=$?
xlC11=$(lslpp -lc xlC.rte | grep 11. | grep -v Fileset:Level)
xlC11_rc=$?

#*********************************************************************
AWTRACE " "
AWTRACE "xlopt Filesets"
AWTRACE "--------------"
lslpp -l | grep xlopt. >>${AWTRACE_DSN} 2>&1
xlopt=$(lslpp -l xlopt. >/dev/null 2>&1)
xlopt_rc=$?
if [[ ${xlopt_rc} = 0 ]]
then
 : # OK
else
 AWTRACE "'xlopt' Not installed. lslpp RC is ${xlopt_rc}"
fi

#*********************************************************************
AWTRACE " "
AWTRACE "memdbg Filesets"
AWTRACE "--------------"
fileset="memdbg"
checkfileset ${fileset}
memdbg=${_fs}
memdbg_rc=${_fs_rc}
if [[ ${memdbg_rc} = 0 ]]
then
 : # OK
else
 AWTRACE "'${fileset}' Not installed. lslpp RC is ${memdbg_rc}"
fi

#*********************************************************************
AWTRACE " "
AWTRACE "xlsmp Filesets"
AWTRACE "--------------"
lslpp -l | grep xlsmp. >>${AWTRACE_DSN} 2>&1
xlsmp18=$(lslpp -lc xlsmp.rte 2>/dev/null | grep 1.8 | grep -v Fileset:Level)
xlsmp18_rc=$?
xlsmp21=$(lslpp -lc xlsmp.rte 2>/dev/null | grep 2.1 | grep -v Fileset:Level)
xlsmp21_rc=$?

#*********************************************************************
AWTRACE " "
AWTRACE "vac V8 Filesets"
AWTRACE "---------------"
lslpp -l | grep vac. | grep 8.0 | grep -v vacpp. >>${AWTRACE_DSN} 2>&1
vac8=$(lslpp -lc vac.C 2>/dev/null | grep 8.0 | grep -v Fileset:Level)
vac8_rc=$?

AWTRACE " "
AWTRACE "vacpp V8 Filesets"
AWTRACE "-----------------"
lslpp -l | grep vacpp. | grep 8.0 >>${AWTRACE_DSN} 2>&1
vacpp8=$(lslpp -lc vacpp.cmp.rte 2>/dev/null | grep 8.0 | grep -v Fileset:Level)
vacpp8_rc=$?

AWTRACE " "
AWTRACE "vac V9 Filesets"
AWTRACE "---------------"
lslpp -l | grep vac. | grep 9. | grep -v vacpp. >>${AWTRACE_DSN} 2>&1
vac9=$(lslpp -lc vac.C 2>/dev/null | grep 9. | grep -v Fileset:Level)
vac9_rc=$?

AWTRACE " "
AWTRACE "vacpp V9 Filesets"
AWTRACE "-----------------"
lslpp -l | grep vacpp. | grep 9. >>${AWTRACE_DSN} 2>&1
vacpp9=$(lslpp -lc vacpp.cmp.rte 2>/dev/null | grep 9. | grep -v Fileset:Level)
vacpp9_rc=$?

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# xlC 10.x on 5.3 ONLY if TL is 06 or higher !!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if [[ "$os_vr" -eq 53 && "$tl" -lt 06 ]] ; then
 :
else
  AWTRACE " "
  AWTRACE "vac V10 Filesets"
  AWTRACE "---------------"
  lslpp -l | grep vac. | grep 10. | grep -v vacpp. >>${AWTRACE_DSN} 2>&1
  vac10=$(lslpp -lc vac.C 2>/dev/null | grep 10. | grep -v Fileset:Level)
  vac10_rc=$?

  AWTRACE " "
  AWTRACE "vacpp V10 Filesets"
  AWTRACE "-----------------"
  lslpp -l | grep vacpp. | grep 10. >>${AWTRACE_DSN} 2>&1
  vacpp10=$(lslpp -lc vacpp.cmp.rte 2>/dev/null | grep 10. | grep -v Fileset:Level)
  vacpp10_rc=$?
fi

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# xlC 11.x on 5.3 ONLY if TL is 07 or higher !!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if [[ "$os_vr" -eq 53 && "$tl" -lt 07 ]] ; then
 :
else
  AWTRACE " "
  AWTRACE "vac V11 Filesets"
  AWTRACE "---------------"
  lslpp -l | grep vac. | grep 11. | grep -v vacpp. >>${AWTRACE_DSN} 2>&1
  vac11=$(lslpp -lc vac.C 2>/dev/null | grep 11. | grep -v Fileset:Level)
  vac11_rc=$?

  AWTRACE " "
  AWTRACE "vacpp V11 Filesets"
  AWTRACE "-----------------"
  lslpp -l | grep vacpp. | grep 11. >>${AWTRACE_DSN} 2>&1
  vacpp11=$(lslpp -lc vacpp.cmp.rte 2>/dev/null | grep 11. | grep -v Fileset:Level)
  vacpp11_rc=$?
fi

#*********************************************************************
#*********************************************************************

AWTRACE " "
AWTRACE "Check for FIXES"
AWTRACE "==============="
AWTRACE " "
check_fix="NEXT" # global INIT Type=COMP

#*********************************************************************
 # XL C V8 RUNTIME"
 # ----------------
 AWTRACE " "
 AWTRACE "XL C V8 RUNTIME"
 AWTRACE "---------------"
 AWTRACE "xlC8=${xlC8}"
 check_fix="NEXT" # INIT for xlC8 Type=COMP
 if [[ ${xlC8_rc} = 0 ]]
 then
   AWTRACE "xlC8 found"
   if [[ "${check_fix}" = "NEXT" ]]
   then
     FIX=IZ54593 ; iFIX="NO"  ; FIXTXT="July 2009 IBM C++ Runtime for AIX, V8"
     check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
     FIX=IZ38835 ; iFIX="NO"  ; FIXTXT="November 2008 IBM C++ Runtime for AIX, V8"
     check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
     FIX=IZ22840 ; iFIX="NO"  ; FIXTXT="May 2008 IBM C++ Runtime Headers for AIX, V8"
     check_COMP_Fix
   fi
 else
   AWTRACE "xlC8 NOT found"
 fi

 # XL C V9 RUNTIME"
 # ----------------
 AWTRACE " "
 AWTRACE "XL C V9 RUNTIME"
 AWTRACE "---------------"
 AWTRACE "xlC9=${xlC9}"
 check_fix="NEXT" # INIT for xlC9 Type=COMP
 if [[ ${xlC9_rc} = 0 ]]
 then
   AWTRACE "xlC9 found"
   if [[ "${check_fix}" = "NEXT" ]]
   then
     FIX=IZ54090 ; iFIX="NO"  ; FIXTXT="July 2009 IBM XL C++ Runtime, V9.0"
     check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
     FIX=IZ38836 ; iFIX="NO"  ; FIXTXT="November 2008 IBM XL C++ Runtime, V9.0"
     check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
     FIX=IZ23812 ; iFIX="NO"  ; FIXTXT="June 2008 IBM XL C++ Runtime, V9.0"
     check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
     FIX=IZ22839 ; iFIX="NO"  ; FIXTXT="May 2008 IBM C++ Runtime for AIX, V9"
     check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
     FIX=IZ20061 ; iFIX="NO"  ; FIXTXT="April 2008 IBM C++ Runtime, V9.0"
     check_COMP_Fix
   fi
 else
   AWTRACE "xlC9 NOT found"
 fi

 # XL C V10 RUNTIME"
 # ----------------
 AWTRACE " "
 AWTRACE "XL C V10 RUNTIME"
 AWTRACE "----------------"
 AWTRACE "xlC10=${xlC10}"
 check_fix="NEXT" # INIT for xlC10 Type=COMP
 if [[ ${xlC10_rc} = 0 ]]
 then
   AWTRACE "xlC10 found"
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ54091 ; iFIX="NO"; FIXTXT="July 2009 IBM XL C++ Runtime, V10.1"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ38837 ; iFIX="NO"; FIXTXT="November 2008 IBM XL C++ Runtime, V10.1"
    check_COMP_Fix
   fi
 else
   AWTRACE "xlC10 NOT found"
 fi

 # XL C V11 RUNTIME"
 # ----------------
 AWTRACE " "
 AWTRACE "XL C V11 RUNTIME"
 AWTRACE "----------------"
 AWTRACE "xlC11=${xlC11}"
 check_fix="NEXT" # INIT for xlC11 Type=COMP
 if [[ ${xlC11_rc} = 0 ]]
 then
   AWTRACE "xlC11 found"
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ84711 ; iFIX="NO"; FIXTXT="September 2010 IBM XL C++ Runtime, V11.1"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ74271 ; iFIX="NO"; FIXTXT="April 2010 IBM XL C++ Runtime, V11.1"
    check_COMP_Fix
   fi
 else
   AWTRACE "xlC11 NOT found"
 fi


#*********************************************************************
 # XL SMP V1.8
 # -----------
 AWTRACE " "
 AWTRACE "XL SMP V1.8"
 AWTRACE "-----------"
 # Note: xlsmp 1.8 used in AIX 5.3 TL06 and AIX 6.1
 AWTRACE "xlsmp18=${xlsmp18}"
 check_fix="NEXT" # INIT for xlsmp 1.8 Type=COMP
 if [[ ${xlsmp18_rc} = 0 ]]
 then
   AWTRACE "xlsmp 1.8 found"
   #AWTRACE "Currently NO Fixes to check"
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ65186 ; iFIX="NO"; FIXTXT="November 2009 XL SMP Runtime"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ56467 ; iFIX="NO"; FIXTXT="August 2009 XL SMP Runtime"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ40855 ; iFIX="NO"; FIXTXT="Januar 2009 XL SMP Runtime"
    check_COMP_Fix
   fi
  else
   AWTRACE "xlsmp 1.8 NOT found"
 fi

 # XL SMP V2.1
 # -----------
 AWTRACE " "
 AWTRACE "XL SMP V2.1"
 AWTRACE "-----------"
 # Note: xlsmp 2.1 used in AIX 5.3 TL06 and AIX 6.1
 AWTRACE "xlsmp21=${xlsmp21}"
 check_fix="NEXT" # INIT for xlsmp 2.1 Type=COMP
 if [[ ${xlsmp21_rc} = 0 ]]
 then
   AWTRACE "xlsmp 2.1 found"
   #AWTRACE "Currently NO Fixes to check"
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ91480 ; iFIX="NO"; FIXTXT="January 2011 XL SMP Runtime"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ86174 ; iFIX="NO"; FIXTXT="October 2010 XL SMP Runtime"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ84709 ; iFIX="NO"; FIXTXT="September 2010 XL SMP Runtime"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ74269 ; iFIX="NO"; FIXTXT="April 2010 XL SMP Runtime"
    check_COMP_Fix
   fi
  else
   AWTRACE "xlsmp 2.1 NOT found"
 fi

#*********************************************************************

 # XL C V8
 # -------
 AWTRACE " "
 AWTRACE "XL C V8"
 AWTRACE "-------"
 AWTRACE "vac8=${vac8}"
 check_fix="NEXT" # INIT for xlC V8 Type=COMP
 if [[ ${vac8_rc} = 0 ]]
 then
   AWTRACE "vac V8 found"
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ54591 ; iFIX="NO"  ; FIXTXT="July 2009 XL C V8.0 for AIX PTF"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ45608 ; iFIX="NO"  ; FIXTXT="April 2009 XL C V8.0 for AIX PTF"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ39399 ; iFIX="NO"  ; FIXTXT="November 2008 XL C V8.0 for AIX PTF"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ29562 ; iFIX="NO"  ; FIXTXT="August 2008 XL C V8.0 for AIX PTF"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ22842 ; iFIX="NO"  ; FIXTXT="May 2008 XL C V8.0 for AIX PTF"
    check_COMP_Fix
   fi
 else
   AWTRACE "vac V8 NOT found"
 fi

 # XL C++ V8
 # ---------
 AWTRACE " "
 AWTRACE "XL C++ V8"
 AWTRACE "---------"
 AWTRACE "vacpp8=${vacpp8}"
 check_fix="NEXT" # INIT for xlC++ V8 Type=COMP
 if [[ ${vacpp8_rc} = 0 ]]
 then
   AWTRACE "vacpp V8 found"
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ54592 ; iFIX="NO"  ; FIXTXT="July 2009 XL C/C++ V8.0 for AIX PTF"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ45609 ; iFIX="NO"  ; FIXTXT="April 2009 XL C/C++ V8.0 for AIX PTF"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ29563 ; iFIX="NO"  ; FIXTXT="August 2008 XL C/C++ V8.0 for AIX PTF"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ22850 ; iFIX="NO"  ; FIXTXT="May 2008 XL C/C++ V8.0 for AIX PTF"
    check_COMP_Fix
   fi
 else
  AWTRACE "vacpp V8 NOT found"
 fi


#*********************************************************************
 # XL C V9
 # -------
 AWTRACE " "
 AWTRACE "XL C V9"
 AWTRACE "-------"
 AWTRACE "vac9=${vac9}"
 check_fix="NEXT" # INIT for xlC V9 Type=COMP
 if [[ ${vac9_rc} = 0 ]]
 then
   AWTRACE "vac V9 found"
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ88686 ; iFIX="NO"  ; FIXTXT="November 2010 PTF for XL C for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ81214 ; iFIX="NO"  ; FIXTXT="August 2010 PTF for XL C for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ74939 ; iFIX="NO"  ; FIXTXT="May 2010 PTF for XL C for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ67270 ; iFIX="NO"  ; FIXTXT="January 2010 PTF for XL C for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ60854 ; iFIX="NO"  ; FIXTXT="September 2009 PTF for XL C for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ54088 ; iFIX="NO"  ; FIXTXT="July 2009 PTF for XL C for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ40792 ; iFIX="NO"  ; FIXTXT="January 2009 PTF for XL C for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ32365 ; iFIX="NO"  ; FIXTXT="September 2008 PTF for XL C EE for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ29111 ; iFIX="NO"  ; FIXTXT="August 2008 PTF for XL C EE for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ20693 ; iFIX="NO"  ; FIXTXT="April 2008 PTF for XL C for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ07470 ; iFIX="NO"  ; FIXTXT="October 2007 PTF for XL C for AIX, V9.0"
    check_COMP_Fix
   fi
 else
   AWTRACE "vac V9 NOT found"
 fi

 # XL C++ V9
 # ---------
 AWTRACE " "
 AWTRACE "XL C++ V9"
 AWTRACE "---------"
 AWTRACE "vacpp9=${vacpp9}"
 check_fix="NEXT" # INIT for xlC++ V9 Type=COMP
 if [[ ${vacpp9_rc} = 0 ]]
 then
   AWTRACE "vacpp V9 found"
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ88689 ; iFIX="NO"  ; FIXTXT="November 2010 PTF for XL C/C++ for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ81215 ; iFIX="NO"  ; FIXTXT="August 2010 PTF for XL C/C++ for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ74940 ; iFIX="NO"  ; FIXTXT="May 2010 PTF for XL C/C++ for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ67271 ; iFIX="NO"  ; FIXTXT="January 2010 PTF for XL C/C++ for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ60855 ; iFIX="NO"  ; FIXTXT="September 2009 PTF for XL C/C++ for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ54089 ; iFIX="NO"  ; FIXTXT="July 2009 PTF for XL C/C++ for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ40793 ; iFIX="NO"  ; FIXTXT="January 2009 PTF for XL C/C++ for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ32366 ; iFIX="NO"  ; FIXTXT="September 2008 PTF for XL C/C++ for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ29112 ; iFIX="NO"  ; FIXTXT="August 2008 PTF for XL C/C++ for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ20719 ; iFIX="NO"  ; FIXTXT="April 2008 PTF for XL C/C++ for AIX, V9.0"
    check_COMP_Fix
   fi
   if [[ "${check_fix}" = "NEXT" ]]
   then
    FIX=IZ07471 ; iFIX="NO"  ; FIXTXT="October 2007 PTF for XL C/C++ for AIX, V9.0"
    check_COMP_Fix
   fi
 else
   AWTRACE "vacpp V9 NOT found"
 fi


#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# xlC 10.x on 5.3 ONLY if TL is 06 or higher !!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if [[ "$os_vr" -eq 53 && "$tl" -lt 06 ]] ; then
 :
else
  # XL C V10
  # --------
  AWTRACE " "
  AWTRACE "XL C V10"
  AWTRACE "--------"
  AWTRACE "vac10=${vac10}"
  check_fix="NEXT" # INIT for xlC V10 Type=COMP
  if [[ ${vac10_rc} = 0 ]]
  then
    AWTRACE "vac V10 found"
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ86176 ; iFIX="NO"  ; FIXTXT="October 2010 PTF for XL C for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ76840 ; iFIX="NO"  ; FIXTXT="June 2010 PTF for XL C for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ73765 ; iFIX="NO"  ; FIXTXT="April 2010 PTF for XL C for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ70908 ; iFIX="NO"  ; FIXTXT="March 2010 PTF for XL C for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ65187 ; iFIX="NO"  ; FIXTXT="November 2009 PTF for XL C for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ56468 ; iFIX="NO"; FIXTXT="August 2009 IBM XL C++ Runtime, V10.1 ???"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ51719 ; iFIX="NO"  ; FIXTXT="May 2009 PTF for XL C for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ40864 ; iFIX="NO"  ; FIXTXT="Februar 2009 PTF for XL C for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ34913 ; iFIX="NO"  ; FIXTXT="October 2008 PTF for XL C for AIX, V10.1"
     check_COMP_Fix
    fi
  else
    AWTRACE "vac V10 NOT found"
  fi

  # XL C++ V10
  # ----------
  AWTRACE " "
  AWTRACE "XL C++ V10"
  AWTRACE "----------"
  AWTRACE "vacpp10=${vacpp10}"
  check_fix="NEXT" # INIT for xlC++ V10 Type=COMP
  if [[ ${vacpp10_rc} = 0 ]]
  then
    AWTRACE "vacpp V10 found"
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ86177 ; iFIX="NO"  ; FIXTXT="October 2010 PTF for XL C/C++ for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ74271 ; iFIX="NO"  ; FIXTXT="June 2010 PTF for XL C/C++ for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ73766 ; iFIX="NO"  ; FIXTXT="April 2010 PTF for XL C/C++ for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ70909 ; iFIX="NO"  ; FIXTXT="March 2010 PTF for XL C/C++ for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ65188 ; iFIX="NO"  ; FIXTXT="November 2009 PTF for XL C/C++ for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ56469 ; iFIX="NO"  ; FIXTXT="August 2009 PTF for XL C/C++ for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ51720 ; iFIX="NO"  ; FIXTXT="May 2009 PTF for XL C/C++ for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ40865 ; iFIX="NO"  ; FIXTXT="Februar 2009 PTF for XL C/C++ for AIX, V10.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ34914 ; iFIX="NO"  ; FIXTXT="October 2008 PTF for XL C/C++ for AIX, V10.1"
     check_COMP_Fix
    fi
  else
    AWTRACE "vacpp V10 NOT found"
  fi
fi

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# xlC 11.x on 5.3 ONLY if TL is 07 or higher !!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if [[ "$os_vr" -eq 53 && "$tl" -lt 07 ]] ; then
 :
else
  # XL C V11
  # --------
  AWTRACE " "
  AWTRACE "XL C V11"
  AWTRACE "--------"
  AWTRACE "vac11=${vac11}"
  check_fix="NEXT" # INIT for xlC V11 Type=COMP
  if [[ ${vac11_rc} = 0 ]]
  then
    AWTRACE "vac V11 found"
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ91476 ; iFIX="NO"  ; FIXTXT="January 2011 PTF for XL C for AIX, V11.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ84705 ; iFIX="NO"  ; FIXTXT="September 2010 PTF for XL C for AIX, V11.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ78409 ; iFIX="NO"  ; FIXTXT="July 2010 PTF for XL C for AIX, V11.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ74265 ; iFIX="NO"  ; FIXTXT="April 2010 PTF for XL C for AIX, V11.1"
     check_COMP_Fix
    fi
  else
    AWTRACE "vac V11 NOT found"
  fi

  # XL C++ V11
  # ----------
  AWTRACE " "
  AWTRACE "XL C++ V11"
  AWTRACE "----------"
  AWTRACE "vacpp11=${vacpp11}"
  check_fix="NEXT" # INIT for xlC++ V11 Type=COMP
  if [[ ${vacpp11_rc} = 0 ]]
  then
    AWTRACE "vacpp V11 found"
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ91477 ; iFIX="NO"  ; FIXTXT="January 2011 PTF for XL C/C++ for AIX, V11.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ84706 ; iFIX="NO"  ; FIXTXT="September 2010 PTF for XL C/C++ for AIX, V11.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ78410 ; iFIX="NO"  ; FIXTXT="July 2010 PTF for XL C/C++ for AIX, V11.1"
     check_COMP_Fix
    fi
    if [[ "${check_fix}" = "NEXT" ]]
    then
     FIX=IZ73208 ; iFIX="NO"  ; FIXTXT="April 2010 PTF for XL C/C++ for AIX, V11.1"
     check_COMP_Fix
    fi
  else
    AWTRACE "vacpp V11 NOT found"
  fi
fi
}

######################################################################
# collect_vio: *col-20*V* VIO - Virtual IO Server
######################################################################
collect_vio ()
{
#++ >AWxxx< start *VIO*----------------------------------------------
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "VIO 001"

 verbose_out "\n-=[ 20/${_maxcoll} VIO-Info ]=-\n"
 paragraph_start "VIO"
 inc_heading_level
 #////////////////////////////////////////////////////////////////////

# ...
 AWCONST "\nCheck for VIO-Server =="
 DBG "TEST 100 VIO"
#- AWCONST "\n---TESTOPT ${TESTOPT}"
 set +x # stop ksh debugging

 C2H_CHECK_VIO="YES"

 if [[ ${C2H_CHECK_VIO} = "YES" ]]
 then
# ToDo 281-000 p520T-VIO1 *.158 get IP from UserSettings() or cfg-file
# ToDo 281-000 p520T-VIO2 *.159
# ToDo 281-000 p520A-VIO1 *.135
# ToDo 281-000 p520A-VIO2 *.136
# ToDo 281-000 p520B-VIO1 *.161
# ToDo 281-000 p520B-VIO2 *.162

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# ToDo 280-000 Set these values in external cfg file !!
 if [[ ${NODE} = "aix6" ]]
 then
   vio1_user="padmin"
   vio1_pass="no_pass_use_sshkey"
   vio1_auth="passwd"
   vio1_status="UNKNOWN"

   vio2_user="padmin"
   vio2_pass="no_pass_use_sshkey"
   vio2_auth="passwd"
   vio2_status="UNKNOWN"
 fi
 if [[ ${NODE} = "aixw" ]] # WORK
 then
   vio1_user="padmin"
   vio1_pass="no_pass_use_sshkey"
   vio1_auth="passwd"
   vio1_status="UNKNOWN"

   vio2_user="padmin"
   vio2_pass="no_pass_use_sshkey"
   vio2_auth="passwd"
   vio2_status="UNKNOWN"
 fi
 if [[ ${NODE} = "aixn" ]] # NIMS
 then
   vio1_user="padmin"
   vio1_user="root" # !!! root on VIO
   vio1_pass="no_pass_use_sshkey"
   vio1_auth="passwd"
   vio1_status="UNKNOWN"

   vio2_user="padmin"
   vio2_pass="no_pass_use_sshkey"
   vio2_auth="passwd"
   vio2_status="UNKNOWN"
 fi
 if [[ ${NODE} = "aixt" ]]
 then
   vio1_user="padmin"
   vio1_user="root" # !!! root on VIO
   vio1_pass="no_pass_use_sshkey"
   vio1_auth="passwd"
   vio1_status="UNKNOWN"

   vio2_user="padmin"
   vio2_pass="no_pass_use_sshkey"
   vio2_auth="passwd"
   vio2_status="UNKNOWN"
 fi
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# ioslevel
# --------
# p520Tvio1 => 2.1.2.12-FP-22.1-SP01
# p520Tvio2 => 2.1.2.12-FP-22.1-SP01
# p520Avio1 => 2.1.2.12-FP-22.1-SP01
# p520Avio2 => 2.1.2.12-FP-22.1-SP01
# p520Bvio1 => 2.1.2.12-FP-22.1-SP01
# p520Bvio2 => 2.1.2.12-FP-22.1-SP01
#
# viostat
# -------

 DBG "TEST 101 VIO"
 ping_test "VIO" ${vio1_ip} ${vio1_name}
 vio1_status=${host_status}

 if [[ ${vio1_status} = "OK" ]]
 then
   AWTRACE "+++ ping to VIO1 successful"
   if [[ ${vio1_user} = "root" ]]
   then
     vio_cmd="ioscli ioslevel"
   else
     vio_cmd="ioslevel"
   fi
   ssh_cmd "VIO" ${vio1_ip} ${vio1_name} ${vio1_auth} ${vio1_user} ${vio1_pass}
   vio1_ssh=${host_status}
 fi

 DBG "TEST 102 VIO"
 ping_test "VIO" ${vio2_ip} ${vio2_name}
 vio2_status=${host_status}

 if [[ ${vio2_status} = "OK" ]]
 then
   AWTRACE "+++ ping to VIO2 successful"
   if [[ ${vio2_user} = "padmin" ]]
   then
     AWTRACE "User 'padmin' for ssh access to VIO currently NOT supported!"
   fi
   vio_cmd="ioslevel"
   ssh_cmd "VIO" ${vio2_ip} ${vio2_name} ${vio2_auth} ${vio2_user} ${vio2_pass}
   vio2_ssh=${host_status}
 fi

 else
   AWCONST "VIO check disabled !"
 fi # if C2H_CHECK_VIO

# ...

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "VIO"

 DBG "VIO 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
#++ >AWxxx< end *VIO*------------------------------------------------
}

######################################################################
# collect_svc: *col-21*C* SVC - SAN Volume Controler
######################################################################
collect_svc ()
{
#++ >AWxxx< start *SVC*----------------------------------------------
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=1  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing
 AWDEBUG=1 # AWdebugging 0=OFF 1=ON (789 COMPILER =>ON
 DBG ":---------------------------------------"
 DBG "SVC 001"

 verbose_out "\n-=[ 21/${_maxcoll} SVC-Info ]=-\n"
 paragraph_start "SVC"
 inc_heading_level
 #////////////////////////////////////////////////////////////////////

# ...
 AWCONST "\nCheck for SVC =="
 DBG "TEST 300 SVC"

 C2H_CHECK_SVC="YES"

 if [[ ${C2H_CHECK_SVC} = "YES" ]]
 then
# ToDo 280-999 SVC  *.116
# ToDo 280-999 SVCA *.117
# ToDo 280-999 SVCB *.118

# ToDo 280-999 ping to SVCA  >AW666<
# ToDo 280-999 ping to SVCB
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# ToDo 280-000 Set these values in external cfg file !!
 svc1_user="admin"
 svc1_pass="no_pass_use_sshkey"
 svc1_auth="sshkey" # sshkey or passwd
 svc1_status="UNKNOWN"
 svc1_cmd="svcinfo lsmdiskgrp"
#svc1_cmd="svcinfo lsmdiskgrp -bytes"
#svc1_cmd="svcinfo lsvdisk -bytes"
#svc1_cmd="svcinfo lscluster"
#svc1_cmd="svcinfo lscluster SVC-FVVAG1"
#svc1_cmd="svcinfo lscluster -delim : SVC-FVVAG1"

 svc2_user="admin"
 svc2_pass="no_pass_use_sshkey"
 svc2_auth="sshkey" # sshkey or passwd
 svc2_status="UNKNOWN"
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 DBG "TEST 301 SVC1"
#-------------------
 ping_test "SVC" ${svc1_ip} ${svc1_name}
 svc1_status=${host_status}

 if [[ ${svc1_status} = "OK" ]]
 then
   ssh_cmd "SVC" ${svc1_ip} ${svc1_name} ${svc1_auth} ${svc1_user} ${svc1_pass} ${svc1_cmd}
   svc1_ssh=${host_status}
 fi

 DBG "TEST 351 SVC2"
#-------------------
 ping_test "SVC" ${svc2_ip} ${svc2_name}
 svc2_status=${host_status}

 if [[ ${svc2_status} = "OK" ]]
 then
   ssh_cmd "SVC" ${svc2_ip} ${svc2_name} ${svc2_auth} ${svc2_user} ${svc2_pass} ${svc2_cmd}
   svc2_ssh=${host_status}
 fi

#----------------------------------------------------------------------

 #:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+
 dsn_lvl=dsn_lvl+1
 TRACE_DSN[$dsn_lvl]=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${svc_LOG}  # set AWTRACE_DSN
 ERRLOG ">>>> output > ${AWTRACE_DSN} LVL=${dsn_lvl}"
 infofile_header "SVC"

 DBG "TEST 400 SVC FixCheck"
 svc_fix_check

 AWTRACE "*>>> EOF <<<"
 AWTRACE_DSN_OLD=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${TRACE_DSN[$dsn_lvl]} # restore AWTRACE_DSN

 #:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-
 dsn_lvl=dsn_lvl-1
 ERRLOG "<<<< output > ${AWTRACE_DSN} was ${AWTRACE_DSN_OLD}"

#----------------------------------------------------------------------
 else
   AWCONST "SVC check disabled !"
 fi # if C2H_CHECK_SVC
# ...

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "SVC"

 DBG "SVC 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
 AWDEBUG=0 # AWdebugging 0=OFF 1=ON (789 COMPILER =>OFF
#++ >AWxxx< end *SVC*------------------------------------------------
}

######################################################################
# collect_gpfs: *col-22*G* GPFS - General Paralel File System
######################################################################
collect_gpfs ()
{
#++ >AWxxx< start *GPFS*----------------------------------------------
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=0  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing
 AWDEBUG=1 # AWdebugging 0=OFF 1=ON (789 COMPILER =>ON
 DBG ":---------------------------------------"
 DBG "GPFS 001"

 verbose_out "\n-=[ 22/${_maxcoll} GPFS-Info ]=-\n"
 paragraph_start "GPFS"
 inc_heading_level
 #////////////////////////////////////////////////////////////////////

# ...
#AWCONST "\nCheck for GPFS"
 DBG "TEST 500 GPFS"

 C2H_CHECK_GPFS="YES"

 if [[ ${C2H_CHECK_GPFS} = "YES" ]]
 then
   get_gpfs_Info
 else
   AWCONST "GPFS check disabled !"
 fi # C2H_CHECK_GPFS = yes
# ...

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "GPFS"

 DBG "GPFS 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
 AWDEBUG=0 # AWdebugging 0=OFF 1=ON (789 COMPILER =>OFF
#++ >AWxxx< end *GPFS*------------------------------------------------
}

#.....................................................................
# getGPFS_Info: ...
#.....................................................................
get_gpfs_Info ()
{
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 #:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+:+
 dsn_lvl=dsn_lvl+1
 TRACE_DSN[$dsn_lvl]=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${gpfs_LOG}  # set AWTRACE_DSN
 ERRLOG ">>>> output > ${AWTRACE_DSN} LVL=${dsn_lvl}"
 infofile_header "GPFS"

# check GPFS
  GPFS="INIT"
  fileset="gpfs.base"
  lslpp -l ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|awk '{print $2}'|while read vv
  do
    gpfs_installed=${vv}
  done
#
  gpfs_base_u=$(lslpp -l gpfs.base 2>/dev/null)
  gpfs_base=$(lslpp -l gpfs.base >/dev/null 2>&1)
  gpfs_rc=$?
  #ERRMSG "GPFS_BASE RC=${gpfs_rc}"
  case $gpfs_rc in
  0 )
    GPFS="YES"
    AWTRACE "C2H100I GPFS installed: ${gpfs_installed}";
    #AWTRACE "${gpfs_base_u}";
    lslpp -l | grep gpfs. >>${AWTRACE_DSN} 2>&1
    ;;
  1 )
    GPFS="NO"
    AWTRACE "C2H101W GPFS NOT installed RC=${gpfs_rc}";
    ;;
  * )
    GPFS="UNKNOWN"
    AWTRACE "C2H102 GPFS error RC=${gpfs_rc}";
    ;;
  esac

  if [[ "$GPFS" = "YES" ]]
  then
    verbose_out "\n== check Fixes for GPFS =="
    check_fix="NEXT" # INIT for GPFS Type=GPFS
    typeset -L5 gpfs_vrm=$gpfs_installed

    # check_fixes_GPFS_330

    # GPFS 3.3.0
    # ==========
    # Note: Planned Availability 9/25/2009
    #       IZ45231 GPFS 3.3.0.1
    if [[ "$gpfs_vrm" = "3.3.0" ]]
    then
      # 3.3.0.07 24.06.2010
      if [[ "${check_fix}" = "NEXT" ]]
      then
       # IZ70721 IZ75258 IZ76614 IZ76615 IZ76798 IZ76810 IZ76834 IZ76837 IZ76939 IZ75549
       FIX=IZ70721 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.7  (1/10" # >AW120<
       check_GPFS_Fix
      fi
      # 3.3.0.06 02.06.2010
      if [[ "${check_fix}" = "NEXT" ]]
      then
       # IZ73346 IZ74517 IZ74539 IZ74542 IZ74544 IZ74547 IZ74549 IZ74550 IZ75250 IZ75252 IZ75259
       FIX=IZ73346 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.6  (1/11)" # >AW120<
       check_GPFS_Fix
      fi
      # 3.3.0.05 01.04.2010
      if [[ "${check_fix}" = "NEXT" ]]
      then
       # IZ68715 IZ68725 IZ69476 IZ70073 IZ70074 IZ70396 IZ70409 IZ70599
       FIX=IZ68715 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.5  (1/8)" # >AW120<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ67659 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.4  (1/12)" # >AW120<
       check_GPFS_Fix
       FIX=IZ67660 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.4  (2/12)" # >AW120<
       check_GPFS_Fix
       FIX=IZ67661 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.4  (3/12)" # >AW120<
       check_GPFS_Fix
       FIX=IZ67662 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.4  (4/12)" # >AW120<
       check_GPFS_Fix
       FIX=IZ67663 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.4  (5/12)" # >AW120<
       check_GPFS_Fix
       FIX=IZ67664 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.4  (6/12)" # >AW120<
       check_GPFS_Fix
       FIX=IZ67665 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.4  (7/12)" # >AW120<
       check_GPFS_Fix
       FIX=IZ67666 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.4  (8/12)" # >AW120<
       check_GPFS_Fix
       FIX=IZ67667 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.4  (9/12)" # >AW120<
       check_GPFS_Fix
       FIX=IZ67723 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.4  (10/12)" # >AW120<
       check_GPFS_Fix
       FIX=IZ67746 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.4  (11/12)" # >AW120<
       check_GPFS_Fix
       FIX=IZ68028 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.4  (12/12)" # >AW120<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ63333 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.3  (1/4)" # >AW120<
       check_GPFS_Fix
       FIX=IZ65179 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.3  (2/4)" # >AW120<
       check_GPFS_Fix
       FIX=IZ65379 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.3  (3/4)" # >AW120<
       check_GPFS_Fix
       FIX=IZ65416 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.3  (4/4)" # >AW120<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ63058 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.2  (1/6)" # >AW120<
       check_GPFS_Fix
       FIX=IZ63080 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.2  (1/6)" # >AW120<
       check_GPFS_Fix
       FIX=IZ63171 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.2  (1/6)" # >AW120<
       check_GPFS_Fix
       FIX=IZ63307 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.2  (1/6)" # >AW120<
       check_GPFS_Fix
       FIX=IZ63308 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.2  (1/6)" # >AW120<
       check_GPFS_Fix
       FIX=IZ63320 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.2  (1/6)" # >AW120<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ45231 ; iFIX="NO"  ; FIXTXT="GPFS 3.3.0.1  (1/1)" # >AW120<
       check_GPFS_Fix
      fi

    fi # gpfs_vrm = 3.3.0

    # check_fixes_GPFS_321

    # GPFS 3.2.1
    # ==========
    # Note: IZ50837 as stated in Fixlist for gpfs.base 3.1.2.12 is SysRouted to IZ52033
    #       So check this number instead.
    if [[ "$gpfs_vrm" = "3.2.1" ]]
    then
      # 3.2.1.21 29.06.2010
      # IZ76391 IZ77298 IZ75263 IZ75575
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ76391 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.21 (1/4)" # >AW115<
       check_GPFS_Fix
      fi
      # 3.2.1.20 09.06.2010
      # IZ73005 IZ74241 IZ74537 IZ74541 IZ74545 IZ74546 IZ74548 IZ75128 IZ75249 IZ75251 IZ75257 IZ75771
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ73005 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.20 (1/12" # >AW115<
       check_GPFS_Fix
      fi
      # 3.2.1.19 01.04.2010
      # IZ72671 IZ72999 IZ72998 IZ72689 IZ73002 IZ73345
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ72671 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.19 (1/6)" # >AW115<
       check_GPFS_Fix
      fi
      # 3.2.1.18 25.02.2010
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ67745 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.18 (1/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ68029 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.18 (2/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ68724 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.18 (3/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ68773 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.18 (4/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ69478; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.18 (5/5)" # >AW115<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ63351 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (1/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ65194 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (2/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ65380 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (3/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ65414 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (4/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ65614 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (4/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ66577 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (5/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ66881 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (6/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ66894 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (7/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ67312 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (8/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ67542 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (9/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ67543 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (10/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ67545 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (11/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ67548 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (12/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ67624 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (13/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ66577 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.17 (5/5)" # >AW115<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ59644 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.16 (1/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ62776 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.16 (2/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ63168 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.16 (3/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ63170 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.16 (4/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ63206 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.16 (5/5)" # >AW115<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ59355 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.15 (1/7)" # >AW115<
       check_GPFS_Fix
       FIX=IZ60281 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.15 (2/7)" # >AW115<
       check_GPFS_Fix
       FIX=IZ60287 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.15 (3/7)" # >AW115<
       check_GPFS_Fix
       FIX=IZ60289 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.15 (4/7)" # >AW115<
       check_GPFS_Fix
       FIX=IZ60335 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.15 (5/7)" # >AW115<
       check_GPFS_Fix
       FIX=IZ60583 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.15 (6/7)" # >AW115<
       check_GPFS_Fix
       FIX=IZ60595 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.15 (7/7)" # >AW115<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ54485 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.14 (1/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ55419 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.14 (2/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ56130 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.14 (3/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ56131 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.14 (4/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ56249 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.14 (5/5)" # >AW115<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ52682 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.13 (1/9)" # >AW115<
       check_GPFS_Fix
       FIX=IZ53013 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.13 (2/9)" # >AW115<
       check_GPFS_Fix
       FIX=IZ53014 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.13 (3/9)" # >AW115<
       check_GPFS_Fix
       FIX=IZ53044 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.13 (4/9)" # >AW115<
       check_GPFS_Fix
       FIX=IZ53089 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.13 (5/9)" # >AW115<
       check_GPFS_Fix
       FIX=IZ53134 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.13 (6/9)" # >AW115<
       check_GPFS_Fix
       FIX=IZ53142 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.13 (7/9)" # >AW115<
       check_GPFS_Fix
       FIX=IZ53489 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.13 (8/9)" # >AW115<
       check_GPFS_Fix
       FIX=IZ53953 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.13 (9/9)" # >AW115<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ43334 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.12 (1/11)" # >AW115<
       check_GPFS_Fix
       FIX=IZ48161 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.12 (2/11)" # >AW115<
       check_GPFS_Fix
       FIX=IZ48580 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.12 (3/11)" # >AW115<
       check_GPFS_Fix
       FIX=IZ50228 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.12 (4/11)" # >AW115<
       check_GPFS_Fix
       FIX=IZ50229 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.12 (5/11)" # >AW115<
       check_GPFS_Fix
       FIX=IZ50230 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.12 (6/11)" # >AW115<
       check_GPFS_Fix
       FIX=IZ50231 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.12 (7/11)" # >AW115<
       check_GPFS_Fix
       FIX=IZ50233 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.12 (8/11)" # >AW115<
       check_GPFS_Fix
       FIX=IZ50359 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.12 (9/11)" # >AW115<
       check_GPFS_Fix
       FIX=IZ50369 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.12 (10/11)" # >AW115<
       check_GPFS_Fix
       FIX=IZ52033 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.12 (11/11)" # >AW115<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ44952 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.11 (1/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ47466 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.11 (2/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ47467 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.11 (3/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ47468 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.11 (4/5)" # >AW115<
       check_GPFS_Fix
       FIX=IZ47757 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.11 (5/5)" # >AW115<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ42315 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.10 (1/6)" # >AW115<
       check_GPFS_Fix
       FIX=IZ44240 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.10 (2/6)" # >AW115<
       check_GPFS_Fix
       FIX=IZ44271 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.10 (3/6)" # >AW115<
       check_GPFS_Fix
       FIX=IZ44272 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.10 (4/6)" # >AW115<
       check_GPFS_Fix
       FIX=IZ44273 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.10 (5/6)" # >AW115<
       check_GPFS_Fix
       FIX=IZ44274 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.10 (6/6)" # >AW115<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ41028 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.9 (1/2)" # >AW115<
       check_GPFS_Fix
       FIX=IZ41182 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.9 (2/2)" # >AW115<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ35703 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.8 (1/6)" # >AW113<
       check_GPFS_Fix
       FIX=IZ36685 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.8 (2/6)" # >AW113<
       check_GPFS_Fix
       FIX=IZ37398 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.8 (3/6)" # >AW113<
       check_GPFS_Fix
       FIX=IZ37419 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.8 (4/6)" # >AW113<
       check_GPFS_Fix
       FIX=IZ37689 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.8 (5/6)" # >AW113<
       check_GPFS_Fix
       FIX=IZ37691 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.8 (6/6)" # >AW113<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ28022 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.7 (1/3)" # >AW111<
       check_GPFS_Fix
       FIX=IZ32767 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.7 (2/3)" # >AW111<
       check_GPFS_Fix
       FIX=IZ32780 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.7 (3/3)" # >AW111<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ28046 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.6 (1/3)" # >AW111<
       check_GPFS_Fix
       FIX=IZ28595 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.6 (2/3)" # >AW111<
       check_GPFS_Fix
       FIX=IZ31296 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.6 (3/3)" # >AW111<
       check_GPFS_Fix
      fi
      if [[ "${check_fix}" = "NEXT" ]]
      then
       FIX=IZ24951 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.4 (1/2)" # >AW111<
       check_GPFS_Fix
       FIX=IZ25168 ; iFIX="NO"  ; FIXTXT="GPFS 3.2.1.4 (2/2)" # >AW111<
       check_GPFS_Fix
      fi

    fi # gpfs_vrm = 3.2.1

    # run_GPFS_cmds

    xcmd="/usr/lpp/mmfs/bin/mmlscluster 2>&1"
    exec_command $xcmd "gpfs: mmlscluster"

    /usr/lpp/mmfs/bin/mmlscluster >> ${AWTRACE_DSN} 2>&1
    mmfs_rc=$?
    #AWCONST "mmfs_rc=${mmfs_rc}"
    if [[ "${mmfs_rc}" = "0" ]]
    then
      #AWCONST "mmfs_rc=0"
      /usr/lpp/mmfs/bin/mmlsconfig    >> ${AWTRACE_DSN} 2>&1
      /usr/lpp/mmfs/bin/mmlsnsd       >> ${AWTRACE_DSN} 2>&1

      # GPFS 3.3.0-1 does not correctly operate with file systems created with GPFS V2.2 (or older).
      # Such file systems can be identified by running "mmlsfs all -u"
      # : if "no" is shown for any file system,
      # this file system uses the old format, and the use of GPFS 3.3.0-1 is not possible.
      # GPFS 3.3.0-2 corrects this issue.

      #AWCONST "mmlsfs..."
      #date
      /usr/lpp/mmfs/bin/mmlsfs all -u >> ${AWTRACE_DSN} 2>&1
      #date

    else
      # if rc<>0 (Does not belong to cluster) => no further commands
      AWCONST "C: mmfs_rc=1 further processing of GPFS commands supressed"
# ToDo 281-000 show in gpfs outfile instead of ERRLOG !
      ERRLOG  "C: mmfs_rc=1 further processing of GPFS commands supressed"
      :
    fi

# ToDo 281-000 check filesets on ALL nodes of cluster !

  fi # gpfs=yes

 AWTRACE "*>>> EOF <<<"
 AWTRACE_DSN_OLD=${AWTRACE_DSN} # save AWTRACE_DSN
 AWTRACE_DSN=${TRACE_DSN[$dsn_lvl]} # restore AWTRACE_DSN

 #:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-
 dsn_lvl=dsn_lvl-1
 ERRLOG "<<<< output > ${AWTRACE_DSN} was ${AWTRACE_DSN_OLD}"

#
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
}

#.....................................................................
# check_GPFS_Fix: ...
#.....................................................................
check_GPFS_Fix ()
{
 # use same code as for JAVA
 check_JAVA_Fix
}

######################################################################
# collect_tsm: *col-23*T* TSM Tivoli Storage Manager
######################################################################
collect_tsm ()
{
#++ >AW999< start *TSM*-----------------------------------------------
 DEBUG_SAVE=${DEBUG} # SAVE DEBUG
 DEBUG=1  # debugging 0=OFF 1=ON
 if [[ ${DEBUG_999} > 3 ]] ; then DEBUG=1 ; fi ; # set DEBUG=ON if CMD Timeing

 DBG ":---------------------------------------"
 DBG "TSM 001"

 verbose_out "\n-=[ 23/${_maxcoll} TSM-Info ]=-\n"
 paragraph_start "TSM"
 inc_heading_level
 #////////////////////////////////////////////////////////////////////

 verbose_out "\n== TSM info =="

#++ >AW000< start *TSM*------------------------------------------------
# ToDo 000-000 !! ( a.h application.tsm ??)
 if [ "$XCFG_TSM" = "yes" ]
 then
  AWTRACE "%%%%% TSM xcfg=yes %%%%%%%%"
 fi # end XCFG_TSM
#
 DBG "TSM 100 TSM"
  AWTRACE "%%%%% TSM -start- %%%%%%%%%"
 if [[ ${NODE} = "aixn" ]]
 then
  DBG "TSM 200 TSM"
  AWTRACE "%%%%% tsm -start- %%%%%%%%%"
  tsm_srv=$(lslpp -l | grep tivoli.tsm.server. >/dev/null 2>&1)
  ts_rc=$?
  tsm_cli=$(lslpp -l | grep tivoli.tsm.client. >/dev/null 2>&1)
  tc_rc=$?
  #ERRMSG "TSM_SRV RC=${ts_rc}"
  #ERRMSG "TSM_CLI RC=${tc_rc}"
  if [[ $ts_rc = 0 ]]
  then
  # ToDo 282-000 !!
  # ToDo 282-000 !! TSM 6.1 db2ls
  # ToDo 282-000 !!
  # ToDo 282-000 !! get_vrm of_lslpp
  # ToDo 282-000 !!
  # ToDo 282-000 !! TSM SRV/CLI OK now also API,Ora,Sysback,...
  # ToDo 282-000 !! tsm.client.api.32bit /64 + oracle.aix.64bit
  # ToDo 282-000 !! tsm.client.sysback.rte
  # ToDo 282-000 !!
  # instead of "echo ... IFS" also "...uniq|awk -F":"'{print $2}'|..."
  # possible
  fileset="tivoli.tsm.server.com" # TSM Server
  lslpp -lc ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|while read line
  do
    echo ${line} | IFS=":" read a b c d e f g h i
    tsmsrv_installed=${c}
  done
    txt="C2H220I This system is a TSM Server (${tsmsrv_installed})"
    AWTRACE ${txt}
    AddText "\n${txt}"
  AWTRACE "%%%%% TSM db2ls -start- %%%%%%%%%"
    exec_command "db2ls 2>&1"  "TSM: db2ls"
  AWTRACE "%%%%% TSM db2ls -end- %%%%%%%%%"
  fi
  if [[ $tc_rc = 0 ]]
  then
  # instead of "echo ... IFS" also "...uniq|awk -F":"'{print $2}'|..."
  # possible
  fileset="tivoli.tsm.client.ba.32bit.base" # TSM Client
  lslpp -lc ${fileset} 2>/dev/null | grep -i ${fileset} |uniq|while read line
  do
    echo ${line} | IFS=":" read a b c d e f g h i
    tsmcli_installed=${c}
  done
    txt="C2H221I This system is a TSM Client (${tsmcli_installed})"
    AWTRACE ${txt}
    AddText "\n${txt}"
    # ToDo 000-000 write to HTML File
  fi
  AWTRACE "%%%%% tsm -end- %%%%%%%%%%%"
 fi # node=aixn
  AWTRACE "%%%%% TSM -end- %%%%%%"
#++ >AW000< end *TSM*--------------------------------------------------
#----------------------------------------------------------------------
#----------------------------------------------------------------------
#----------------------------------------------------------------------

#*********************************************************************

 #\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 dec_heading_level
 paragraph_end "TSM"

 DBG "TSM 998"
 DBG ":---------------------------------------"
 DEBUG=${DEBUG_SAVE} # RESTORE DEBUG
#++ >AW999< end *TSM*.------------------------------------------------
}

#.....................................................................
# check_ip: is IP valid
#.....................................................................
check_ip ()
{
 set +x # stop ksh debugging
#++ >AW999< start *check_ip*------------------------------------------
 DEBUG=0  # debugging 0=OFF 1=ON
 DBG "check_ip 001"

# ToDo 280-000 check_ip

#++ >AW999< end *check_ip*--------------------------------------------
}

#.....................................................................
# ping_test: test host connection using ping
#.....................................................................
ping_test ()
{
 set +x # stop ksh debugging
#++ >AW999< start *ping_test*-----------------------------------------
 DEBUG=1  # debugging 0=OFF 1=ON
 DBG "ping_test 001"

# ToDo 281-999 new host_type WIN, UNIX, OTHER for mail, rcp!scp!ftp
 host_type="${1:-"UNKNOWN"}"  # HMC,VIO,SVC
 host_ip="${2:-"0.0.0.0"}"
 host_name="${3:-"HOST-NAME"}"

 host_status="UNKNOWN" # init

 AWTRACE "+++ ping_test ${host_type} IP ${host_ip} / ${host_name}"
 if [[ ${host_ip} = "0.0.0.0" ]]
 then
   AWCONST "ping_test: skipping host_ip is 0.0.0.0 ! Typ=${host_type} Name=${host_name}"
 else
  # ToDo ping_check IP/Name
   ping -c 1 -w 3 ${host_ip} >/dev/null
   ping_rc=$?
   if [[ ${ping_rc} -ne 0 ]]
   then
     host_status="KO"
     AWCONST "ping_test: ${host_type} ${host_name} IP ${host_ip} is unreachable! RC=${ping_rc}"
   else
     host_status="OK"
   fi
 fi # host_ip

#---------------------------------------------------------------------
 DBG "ping_test 998"
#++ >AW999< end *ping_test*-------------------------------------------
}

#.....................................................................
# ssh_cmd: ...
#.....................................................................
ssh_cmd ()
{
 set +x # stop ksh debugging
#++ >AW999< start *ssh_cmd*-------------------------------------------
 DEBUG=1  # debugging 0=OFF 1=ON
 DBG "ssh_cmd 001"

 host_type="${1:-"UNKNOWN"}"  # HMC,VIO,SVC
 host_ip="${2:-"0.0.0.0"}"
 host_name="${3:-"HOST-NAME"}"
 host_auth="${4:-"sshkey"}"   # Authentication: passwd or sshkey
 host_user="${5:-"userid"}"
 host_pass="${6:-"password"}"
#host_cmd="${7:-"cmd"}"

 # set default command for host_type
 case ${host_type} in
   HMC ) host_cmd="${7:-"lshmc -V"}";;
   VIO ) host_cmd="${7:-"ioslevel"}";;
   SVC ) host_cmd="${7:-"svcversion"}";;
     * )
         dummy=dummy;
         host_cmd="${7:-"help"}"
         ;;
 esac

 AWCONST "host_cmd: ${host_cmd} 7=${7} 8=${8} 9=${9}"
 if [[ ${8} = "" ]]
 then
   : # Dummy
 else
   host_cmd=${host_cmd}" "${8}
 fi
 AWCONST "host_cmd: ${host_cmd} 7=${7} 8=${8} 9=${9}"
 if [[ ${9} = "" ]]
 then
   : # Dummy
 else
   host_cmd=${host_cmd}" "${9}
 fi
 AWCONST "host_cmd: ${host_cmd} 7=${7} 8=${8} 9=${9}"

 host_status="UNKNOWN" # init
 key_status="UNKNOWN" # init

 AWTRACE "ssh_cmd <hostname>"
 if [[ ${ssh_status} = "OK" ]]
 then
   if [[ ${host_ip} = "0.0.0.0" ]]
   then
     AWCONST "ssh_cmd: skipping host_ip is 0.0.0.0 ! Typ=${host_type} Name=${host_name}"
   else
     # ToDo ssh_cmd IP/Name passwd/sshkey
     check_ssh_key
     if [[ ${key_status} = "OK" ]]
     then
       ssh -l ${host_user} ${host_ip} ${host_cmd} >${SSH_OUT}
       ssh_rc=$?
       AWCONST "ssh output -start-"
       #cat ${SSH_OUT} > $ERRLOG # writes to console
       exec_command "cat ${SSH_OUT}" "ssh output"
       AWCONST "ssh output -end-"
       if [[ ${ssh_rc} -ne 0 ]]
       then
         host_status="KO"
         AWCONST "ssh_cmd: TYP:${host_type} Name:${host_name} IP:${host_ip} ssh error ! RC=${ssh_rc}"
       else
         host_status="OK"
       fi # ssh_rc
     else
       AWCONST "ssh_cmd: key_status=KO ! NO ssh key available"
     # ToDo 281-000 ssh_status
     # ToDo 281-000 cannot ssh. No ssh key found
     fi # key_status
   fi # host_ip
 else
   AWCONST "ssh_cmd: ssh_status=KO ! ssh not available"
 fi # ssh_status

#---------------------------------------------------------------------
 DBG "ssh_cmd 998"
#++ >AW999< end *ssh_cmd*---------------------------------------------
}

#.....................................................................
# check_ssh_key: check for ssh key for given ip or host
#.....................................................................
check_ssh_key ()
{
 set +x # stop ksh debugging
#++ >AW999< start *ssh_key*-------------------------------------------
 DEBUG=1  # debugging 0=OFF 1=ON
 DBG "ssh_key 001"
#---------------------------------------------------------------------

 ssh_knownhost="$HOME/.ssh/known_hosts"
 ls -la $ssh_knownhost

  ls_ssh_knownhost=$(ls -la $ssh_knownhost 2>/dev/null)
  rc=$?
# RC=0 OK
# RC=2 > file does not exist <
AWTRACE "ssh_key: rc=${rc} ssh_knownhost=${ls_ssh_knownhost}<"

# rsa or dss
typeset -A sshkey
typeset -i i=0
grep "ssh-" ${ssh_knownhost} | awk '{print $1" "$2}' | while read sshhost sshkeytype
do
  i=$i+1
  echo ${sshhost} | IFS="," read hostip1 hostip2 hostip3
  if [[ ${hostip3} = "" ]]
  then
    if [[ ${hostip2} = "" ]]
    then
      : # only 1 entry
      sshkey[$i]=${hostip1}
    else
      : # two entries found
      sshkey[$i]=${hostip1}
      i=$i+1
      sshkey[$i]=${hostip2}
    fi
  else
    AWTRACE "Unexpected Error. hostip3=${hostip3}"
    i=$i-1 # more than two - nothing set
  fi

done # grep ssh_key
sshkey[0]=${i}
AWTRACE "ssh_key: sshkey[0]=${sshkey[0]}<"
AWTRACE "ssh_key: sshkey[1]=${sshkey[1]}<"
AWTRACE "ssh_key: sshkey[2]=${sshkey[2]}<"
AWTRACE "ssh_key: sshkey[3]=${sshkey[3]}<"
AWTRACE "ssh_key: sshkey[4]=${sshkey[4]}<"
AWTRACE "ssh_key: sshkey[5]=${sshkey[5]}<"
AWTRACE "ssh_key: sshkey[6]=${sshkey[6]}<"
AWTRACE "ssh_key: sshkey[7]=${sshkey[7]}<"
AWTRACE "ssh_key: sshkey[8]=${sshkey[8]}<"
 typeset -i idx=0
AWCONST "ssh_key: check for >${host_ip}<"
 while [[ $idx -le ${sshkey[0]} ]]
 do
   let idx=$idx+1
   if [[ ${host_ip} = ${sshkey[$idx]} ]]
   then
     : # FOUND !
     AWCONST "ssh_key: found ${host_ip}"
     key_status="OK"
     break # leave the loop as we are done
   else
     key_status="KO"
     if [[ ${ssh_key_trace} = "ON" ]]
     then
       ssh_key_trace="OFF" # set to OFF. (do it only once)
       AWTRACE "ssh_key: search >${sshkey[$idx]}<"
     fi # ssh_key_trace
   fi
 done
#---------------------------------------------------------------------
 DBG "ssh_key 998"
#++ >AW999< end *ssh_key*---------------------------------------------
}

#.....................................................................
# svc_fix_check: check for special SVC fixes
#.....................................................................
svc_fix_check ()
{
#++ >AW999< start *SVC_FIX_CHECK*-------------------------------------
  DEBUG=1  # debugging 0=OFF 1=ON
  DBG "SVC_FIX 001"

 AWTRACE "show HBA settings"
 AWTRACE "-----------------"
 # TODO 000-000 error on AIXK
 fscsi_hba=$(lsdev | grep fscsi)  # FC Adapter
 rc_fscsi=$?
 if [[ $rc_fscsi = 0 ]]  ;
 then
   AWTRACE "FC Adapter (fscsi) found"
   exec_command "lsattr -El fscsi0 -a fc_err_recov"    "HBA setting"
 else
   AWTRACE "NO FC Adapter (fscsi) found"
 fi;
 AWTRACE " "

 AWTRACE "check AIX Fixes for SVC 4.2.1.6 and higher"
 AWTRACE "------------------------------------------"

#---------------------------------------------------------------------
# SVC V.R.M EOS
# --------- ---
# SVC 5.1.x n/a
# SVC 4.3.x n/a
# SVC 4.2.x 2010-09-30
# SVC 4.1.x 2009-09-30
# SVC 3.1.x 2009-04-24
# SVC 2.1.x 2008-04-25
# SVC 1.2.x 2007-04-27
# SVC 1.1.x 2006-09-29
#----------------------------------------------------------------------

check="INIT"
case $osl in
  7100|6100 )
       case ${tl} in
         00 ) check="YES";;
         01 ) check="YES";;
          * )
             check="NO"
             AWTRACE "C2H000I No SVC-Fix checks needed for TL ${tl} of AIX 6.1";
             ;;
       esac;
       ;;
  5300 )
       case ${tl} in
         00 ) check="UNAVAILABLE";;
         01 ) check="UNAVAILABLE";;
         02 ) check="UNAVAILABLE";;
         03 ) check="UNAVAILABLE";;
         04 ) check="UNAVAILABLE";;
         05 ) check="UNAVAILABLE";;
         06 ) check="YES";;
         07 ) check="YES";;
         08 ) check="YES";;
          * )
             check="NO"
             AWTRACE "C2H000I No SVC-Fix checks needed for ${mltl} ${tl} of AIX 5.3";
             ;;
       esac;
       ;;
     * )
       check="NO"
       AWTRACE "C2H000I No SVC checks necessary for this AIX Level";
esac;

if [[ ${check} = "UNAVAILABLE" ]]
then
  check="NO"
  AWTRACE "C2H000I No SVC-Fix available for TL ${tl} of AIX 5.3";
  AWTRACE "C2H039E Unsupported AIX ${mltl}-Level (${osl}-${tl})";
fi
#----------------------------------------------------------------------
AWTRACE " "
AWTRACE "CHECK=${check}"

#*********************************************************************

# as of sddpcm.readme.2.2.0.3
# ---------------------------
#AIX53  TL06: APAR IZ06622  IZ20198  IZ28285
#AIX53  TL07: APAR IZ06490  IZ19199  IZ26561
#AIX53  TL08: APAR IZ07063  IZ20199  IZ26655
#AIX61  TL00: APAR IZ09534  IZ20201  IZ26657
#AIX61  TL01: APAR IZ06905  IZ20202  IZ26658
# The 3rd colon APAR may not be published yet, ifix available

iFIX="NO"

if [[ "$os_vr" -eq 53 && "$tl" -eq 06 ]] ; then
  svcfix_53_06
fi

if [[ "$os_vr" -eq 53 && "$tl" -eq 07 ]] ; then
  svcfix_53_07
fi

if [[ "$os_vr" -eq 53 && "$tl" -eq 08 ]] ; then
  svcfix_53_08
fi

# ToDo 281-000 CHECK 5.3 TL08 SP00 may include this fixes. Need to be checked for next version
# ToDo 281-000 CHECK 5.3 TL09 may include this fixes. Need to be checked for next version
# 5.3 TL09 includes the fixes
# 6.1 TL02 includes the fixes
if [[ "$os_vr" -eq 61 && "$tl" -eq 00 ]] ; then
  svcfix_61_00
fi

if [[ "$os_vr" -eq 61 && "$tl" -eq 01 ]]
then
  if [[ "$sp" -ge 03 ]]
  then
    : # SVC Fix included in 6.1-01-03
  else
    svcfix_61_01
  fi
fi

# ToDo 281-000 CHECK 6.1 TL01 SP03  may include this fixes. Need to be checked for next version
# ToDo 281-000 CHECK 6.1 TL02 may include this fixes. Need to be checked for next version

#
#

#*********************************************************************

  DBG "SVC_FIX 998"
#++ >AW999< end *SVC_FIX_CHECK*---------------------------------------
}

#.....................................................................
# check_SVC_Fix: ...
#.....................................................................
check_SVC_Fix ()
{
# 1=FIX 2=iFIX 3=FIXTXT
#echo "\n-=[ check_SVC_Fix ]=-\n"
 AWTRACE $OSLVLML $FIX "*" $TXT
 check_fix="NEXT"

 instfix -ivk $FIX  2>/dev/null >>${AWTRACE_DSN} # Type=SVC
 fix_rc=$?
 if [[ ${fix_rc} = 0 ]]
 then
   txt="FIX ${FIX} installed."
   AWTRACE $txt
   #We need to check for ALL fixes, so don't set DONE
   #check_fix="DONE" # Type=SVC
 else
   txt="FIX ${FIX} NOT installed ! (iFIX ${iFIX})"
   AWTRACE $txt
 fi

#Do iFIX checking if necessary
#if [[ $fix_rc > 0 && $iFIX = "YES" ]]
 if [[ $iFIX = "YES" ]]
 then
   iFIX="NO"
   AWTRACE "FIX ${FIX} may be installed as iFIX. instfix-rc was ${fix_rc} "
   AWTRACE " "
   AWTRACE "Display Filesets locked by EFIX manager"
   AWTRACE "---------------------------------------"
   /usr/sbin/emgr -P >>${AWTRACE_DSN} 2>&1
   AWTRACE " "
   /usr/sbin/emgr -l >>${AWTRACE_DSN} 2>&1

   exec_command "emgr -l 2>&1" "Filesets locked by EFIX manager (-l)"
   exec_command "emgr -P 2>&1" "Filesets locked by EFIX manager (-P)"
 fi
}

#.....................................................................
# svcfix_53_06: SVC Fixes for AIX 5.3 TL06
#.....................................................................
svcfix_53_06 ()
{
 AWTRACE "************************"
 AWTRACE "Fixes for AIX 5.3.0 TL06"
 AWTRACE "************************"

#
#AIX53  TL06: APAR IZ06622  IZ20198  IZ28285
#

 check_fix="NEXT" # global INIT Type=SVC

 AWTRACE " "
 AWTRACE "SINGLE fix check"
 AWTRACE "----------------"

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ06622 ; iFIX="NO";  FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ20198 ; iFIX="NO";  FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

# Note IZ28285 is (as of 10/10/08) ifix ONLY !!
# IF IZ28285 NOT FOUND -> check ifix !
 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ28285 ; iFIX="YES"; FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

}

#.....................................................................
# svcfix_53_07: SVC Fixes for AIX 5.3 TL07
#.....................................................................
svcfix_53_07 ()
{
 AWTRACE "************************"
 AWTRACE "Fixes for AIX 5.3.0 TL07"
 AWTRACE "************************"

#
#AIX53  TL07: APAR IZ06490  IZ19199  IZ26561
#

 AWTRACE " "
 AWTRACE "SINGLE fix check"
 AWTRACE "----------------"

 check_fix="NEXT" # global INIT Type=SVC

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ06490 ; iFIX="NO";  FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ19199 ; iFIX="NO";  FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

# Note IZ26651 is (as of 10/10/08) ifix ONLY !!
# IF IZ26651 NOT FOUND -> check ifix !
 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ26561 ; iFIX="YES"; FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

}

#.....................................................................
# svcfix_53_08: SVC Fixes for AIX 5.3 TL08
#.....................................................................
svcfix_53_08 ()
{
 AWTRACE "************************"
 AWTRACE "Fixes for AIX 5.3.0 TL08"
 AWTRACE "************************"

#
#AIX53  TL08: APAR IZ07063  IZ20199  IZ26655
#

 AWTRACE " "
 AWTRACE "SINGLE fix check"
 AWTRACE "----------------"

 check_fix="NEXT" # global INIT Type=SVC

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ07063 ; iFIX="NO";  FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ20199 ; iFIX="NO";  FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

# Note IZ26655 is (as of 10/10/08) ifix ONLY !!
# IF IZ26655 NOT FOUND -> check ifix !
 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ26655 ; iFIX="YES"; FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

}

#.....................................................................
# svcfix_61_00: SVC Fixes for AIX 6.1 TL00
#.....................................................................
svcfix_61_00 ()
{
 AWTRACE "************************"
 AWTRACE "Fixes for AIX 6.1.0 TL00"
 AWTRACE "************************"

#
#AIX61  TL00: APAR IZ09534  IZ20201  IZ26657
#

 AWTRACE " "
 AWTRACE "SINGLE fix check"
 AWTRACE "----------------"

 check_fix="NEXT" # global INIT Type=SVC

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ09534 ; iFIX="NO";  FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ20201 ; iFIX="NO";  FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

# Note IZ26655 is (as of 10/10/08) ifix ONLY !!
# IF IZ26655 NOT FOUND -> check ifix !
 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ26657 ; iFIX="YES"; FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

}

#.....................................................................
# svcfix_61_01: SVC Fixes for AIX 6.1 TL01
#.....................................................................
svcfix_61_01 ()
{
 AWTRACE "************************"
 AWTRACE "Fixes for AIX 6.1.0 TL01"
 AWTRACE "************************"

#
#AIX61  TL01: APAR IZ06905  IZ20202  IZ26658
#

 AWTRACE " "
 AWTRACE "SINGLE fix check"
 AWTRACE "----------------"

 check_fix="NEXT" # global INIT Type=SVC

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ06905 ; iFIX="NO";  FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ20202 ; iFIX="NO";  FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

# Note IZ26658 is (as of 10/10/08) ifix ONLY !!
# IF IZ26658 NOT FOUND -> check ifix !
 if [[ "${check_fix}" = "NEXT" ]]
 then
  FIX=IZ26658 ; iFIX="YES"; FIXTXT="SVC 4.2.1.6"
  check_SVC_Fix
 fi

}

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# AddHTMLNAV: navigation in HTML pages
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
AddHTMLNAV ()
{
 # -------------------------------------
 # &#91; [
 # &#124; |
 # &#93; ]
 # -------------------------------------
 DEBUG=0  # debugging 0=OFF 1=ON
 # $1 = SHORT | FULL | NONE
 html_nav_type=$1
 hns="&#91;"
 case $html_nav_type in
  SHORT ) : # ...
          hns=$hns"SHORT";
          ;;
  FULL  ) : # ...
          for S in ${collist}
          do
            hns=$hns" $S &#124;";
          done;
          ;;
  NONE  ) : # ...
          hns=$hns"NONE";
          ;;
  *     ) : # ...
          ;;
 esac
 hns=$hns"&nbsp;&#93;"
 AddHTML "<!--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-->"
 AddHTML "${hns}"
 AddHTML "<!--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-->"
}
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

######################################################################
######################################################################
# run_collection: ...
######################################################################
######################################################################
run_collection ()
{
 DEBUG=0  # debugging 0=OFF 1=ON

 DEBUG_001=0 # init DEBUG 001 DBG locking
 DEBUG_010=0 # init DEBUG 010 DBG cleanup
 DEBUG_100=0 # init DEBUG 100 DBG BG-Jobs
 DEBUG_200=0 # init DEBUG 200 DBG JAVA
 DEBUG_998=1 # init DEBUG 998 DBG GCC
 DEBUG_999=1 # init DEBUG 999 DBG TIMEING

 echo "\n-=[ Run-Collection ]=-"
#++ >AW077< start *HTML-NAV*------------------------------------------
#���������������������������������������������������������������������
#��� HTML-NAV
#��� create list of collectors which will be executed
#��� so we know, which to include in nav
 collist=""
 if [[ "$COL_SYSTEM" = "yes" ]]   then collist=$collist"SYSTEM "   ; fi; # *col-01*
 if [[ "$COL_KERNEL" = "yes" ]]   then collist=$collist"Kernel "   ; fi; # *col-02*
 if [[ "$COL_HMC" = "yes" ]]      then collist=$collist"HMC "      ; fi; # *col-03*
 if [[ "$COL_FILESYS" = "yes" ]]  then collist=$collist"Filesys "  ; fi; # *col-04*
#���������������������������������������������������������������������
#++ >AW077< end *HTML-NAV*--------------------------------------------

# ToDo 000-000 c2h_USR_00 => ...
# ToDo 000-000 c2h_SYS_00 => OS
# ToDo 000-000 c2h_SYS_01 => Java
# ToDo 000-000 c2h_SYS_02 => Oracle

# *col-01* System Information
#----------------------------

 if [ "$COL_SYSTEM" = "yes" ] # *col-01*
 then
   DEBUG=0
   DBG "SYSTEM 000"
   collect_system      # *col-01*
   DBG "SYSTEM 990"
   AddHTMLNAV "FULL" # >AW077<
   DBG "SYSTEM 999"
 else
   verbose_out "skipping SYSTEM   (COL_SYSTEM=${COL_SYSTEM})"
 fi # terminates COL_SYSTEM wrapper

# *col-02* Kernel Information
#----------------------------

 if [ "$COL_KERNEL" = "yes" ] # *col-02*
 then
   DEBUG=0
   DBG "KERNEL 000"
   collect_kernel   # *col-02*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "KERNEL 999"
 else
   verbose_out "skipping KERNEL   (COL_KERNEL=${COL_KERNEL})"
 fi # terminates COL_KERNEL wrapper

# *col-03* HMC Information
#-------------------------

 if [ "$COL_HMC" = "yes" ] # *col-03*
 then
   DEBUG=0
   DBG "HMC 000"
   collect_hmc # *col-03*
   AddHTMLNAV "NONE" # >AW077<
   DBG "HMC 999"
 else
   verbose_out "skipping HMC (COL_HMC=${COL_HMC})"
 fi # terminates COL_HMC wrapper

# *col-04* Filesystem Information
#--------------------------------

 if [ "$COL_FILESYS" = "yes" ] # *col-04*
 then
   DEBUG=0
   DBG "FILESYS 000"
   collect_filesys # *col-04*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "FILESYS 000"
 else
   verbose_out "skipping FILESYS  (COL_FILESYS=${COL_FILESYS})"
 fi # terminates COL_FILESYS wrapper

# *col-05 Device Information
#----------------------------------

 if [ "$COL_DEVICES" = "yes" ] # *col-05*
 then
   DEBUG=0
   DBG "DEVICES 000"
   collect_devices # *col-05*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "DEVICES 999"
 else
   verbose_out "skipping DEVICES    (COL_DEVICES=${COL_DEVICES})"
 fi # terminates COL_DEVICES wrapper

# *col-06 Logical Volume Manager Information
#-------------------------------------------

 if [ "$COL_LVM" = "yes" ] # *col-06*
 then
   DEBUG=0
   DBG "LVM 000"
   collect_lvm # *col-06*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "LVM 999"
 else
   verbose_out "skipping LVM      (COL_LVM=${COL_LVM})"
 fi # terminates COL_LVM wrapper

# *col-07 User & Group Information
#---------------------------------

 if [ "$COL_USERS" = "yes" ] # *col-07*
 then
   DEBUG=0
   DBG "USERS 000"
   collect_user # *col-07*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "USERS 999"
 else
   verbose_out "skipping USERS    (COL_USERS=${COL_USERS})"
 fi # terminates COL_USERS wrapper

# *col-08 Network Information
#----------------------------

 if [ "$COL_NETWORK" = "yes" ] # *col-08*
 then
   DEBUG=0
   DBG "NETWORK 000"
   collect_network # *col-08*
   DBG "NETWORK 999"
 else
   verbose_out "skipping NETWORK  (COL_NETWORK=${COL_NETWORK})"
 fi # terminate COL_NETWORK wrapper

# *col-09 PPPPP Information
#--------------------------

 if [ "$COL_PPPPPP" = "yes" ] # *col-09*
 then
   DEBUG=0
   DBG "PPPPP 000"
   collect_PPPPP9 # *col-09*
   DBG "PPPPP 999"
 else
   verbose_out "skipping PPPPPP  (COL_PPPPPP=${COL_PPPPPP})"
 fi # terminate COL_PPPPPP wrapper

# *col-10 Cron Information
#-------------------------

 if [ "$COL_CRON" = "yes" ] # *col-10*
 then
   DEBUG=0
   DBG "CRON 000"
   collect_cron # *col-10*
   DBG "CRON 999"
 else
   verbose_out "skipping CRON     (COL_CRON=${COL_CRON})"
 fi # terminate COL_CRON wrapper

# *col-11 WWWW Information # >AW772<
#-----------------------------------

 if [ "$FUNC_PUSH" = "yes" ] # *col-11* # >AW772<
 then
   DEBUG=0
   DBG "WWWW 000"      # >AW772<
   collect_WWWW # *col-11* # >AW772<
   DBG "WWWW 999"      # >AW772<
 else
   verbose_out "skipping WWWW   (FUNC_PUSH=${FUNC_PUSH})" # >AW772<
 fi # terminate FUNC_PUSH wrapper # >AW772<

# *col-12 Software Statistics (Patch)
#------------------------------------

 if [ "$COL_SOFTWARE" = "yes" ] # *col-12*
 then
   DEBUG=0
   DBG "SOFTWARE 000"
   collect_software # *col-12*
   DBG "SOFTWARE 999"
 else
   verbose_out "skipping SOFTWARE (COL_SOFTWARE=${COL_SOFTWARE})"
 fi # terminates COL_SOFTWARE wrapper

# *col-13 Files Statistics
#-------------------------

 if [ "$COL_FILES" = "yes" ] # *col-13*
 then
   DEBUG=0
   DBG "FILES 000"
   collect_files # *col-13*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "FILES 999"
 else
   verbose_out "skipping FILES    (COL_FILES=${COL_FILES})"
 fi # terminates COL_FILES wrapper

# *col-14 NIM Configuration
#--------------------------

 if [ "$COL_NIM" = "yes" ] # *col-14*
 then
   DEBUG=0
   DBG "NIM 000"
   collect_nim  # *col-14*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "NIM 999"
 else
   verbose_out "skipping NIM      (COL_NIM=${COL_NIM})"
 fi # terminates COL_NIM wrapper

# *col-15 LUM License Configuration
#----------------------------------

 if [ "$COL_LUM" = "yes" ] # *col-15*
 then
   DEBUG=0
   DBG "LUM 000"
   collect_lum # *col-15*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "LUM 999"
 else
   verbose_out "skipping LUM      (COL_LUM=${COL_LUM})"
 fi # terminates COL_LUM wrapper

# *col-16 APPLICATIONS
#---------------------

 if [ "$COL_APPL" = "yes" ] # *col-16*
 then
   DEBUG=0
   DBG "APPL 000"
   collect_appl # *col-16*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "APPL 999"
 else
   verbose_out "skipping APPL     (COL_APPL=${COL_APPL})"
 fi # terminates COL_APPL wrapper

# *col-17 EXPERIMENTAL
#---------------------

 if [ "$COL_EXP" = "yes" ] # *col-17*
 then
   DEBUG=0
   DBG "EXP 000"
   collect_exp # *col-17*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "EXP 999"
 else
   verbose_out "skipping EXP      (COL_EXP=${COL_EXP})"
 fi # terminates COL_EXP wrapper

# *col-18 JAVA
#-------------

 if [ "$COL_JAVA" = "yes" ] # *col-18*
 then
   DEBUG=0
   DBG "JAVA 000"
   collect_java # *col-18*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "JAVA 999"
 else
   verbose_out "skipping JAVA     (COL_JAVA=${COL_JAVA})"
 fi # terminates COL_JAVA wrapper

#++ >AW088< start *Compiler/Runtime*----------------------------------
# *col-19 Compiler Information
#-----------------------------

 if [ "$COL_COMPILER" = "yes" ] # *col-19*
 then
   DEBUG=0
   DBG "COMPILER 000"
   collect_compiler # *col-19*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "COMPILER 999"
 else
   verbose_out "skipping Compiler (COL_COMPILER=${COL_COMPILER})"
 fi # terminates COL_COMPILER wrapper

#++ >AW088< end *Compiler/Runtime*------------------------------------

#++ >AW...< start *VIO*-----------------------------------------------
# *col-20 VIO
#------------

 if [ "$COL_VIO" = "yes" ] # *col-20*
 then
   DEBUG=0
   DBG "VIO 000"
   collect_vio # *col-20*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "VIO 999"
 else
   verbose_out "skipping VIO (COL_VIO=${COL_VIO})"
 fi # terminates COL_VIO wrapper

#++ >AW...< end *VIO*-------------------------------------------------

#++ >AW...< start *SVC*-----------------------------------------------
# *col-21 SVC
#------------

 if [ "$COL_SVC" = "yes" ] # *col-21*
 then
   DEBUG=0
   DBG "SVC 000"
   collect_svc # *col-21*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "SVC 999"
 else
   verbose_out "skipping SVC (COL_SVC=${COL_SVC})"
 fi # terminates COL_SVC wrapper

#++ >AW...< end *SVC*-------------------------------------------------

#++ >AW...< start *GPFS*----------------------------------------------
# *col-22 GPFS
#-------------

 if [ "$COL_GPFS" = "yes" ] # *col-22*
 then
   DEBUG=0
   DBG "GPFS 000"
   collect_gpfs # *col-22*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "GPFS 999"
 else
   verbose_out "skipping GPFS (COL_GPFS=${COL_GPFS})"
 fi # terminates COL_GPFS wrapper

#++ >AW...< end *GPFS*------------------------------------------------

#++ >AW999< start *TSM*-----------------------------------------------
# *col-23 TSM
#------------

 if [ "$COL_TSM" = "yes" ] # *col-23*
 then
   DEBUG=1
   DBG "TSM 000"
   collect_tsm # *col-23*
   AddHTMLNAV "SHORT" # >AW077<
   DBG "TSM 999"
 else
   verbose_out "skipping TSM (COL_TSM=${COL_TSM})"
 fi # terminates COL_TSM wrapper

#++ >AW999< end *TSM*-------------------------------------------------

 paragraph_end "*LAST*"

# ToDo 000-000 implement FUNCTION
 if [ "$FUNC_PUSH" = "yes" ] # *func-01* # >AW773<
 then
   DEBUG=0
   DBG "WWWW 000"      # >AW773<
   func_push # *func-01* # >AW773<
   DBG "WWWW 999"      # >AW773<
 else
   verbose_out "skipping WWWW   (FUNC_PUSH=${FUNC_PUSH})" # >AW773<
 fi # terminate FUNC_PUSH wrapper # >AW773<
}

######################################################################
# Handle_SIGINT: SIGINT 2 ctrl-c
######################################################################
Handle_SIGINT ()
{
  AWTRACE "==SIGINT"

  sig_type="SIGINT (2) ctrl-c"

  HandleInterrupt

}

######################################################################
# Handle_SIGINT: SIGTSTP ?? ctrl-z
######################################################################
Handle_SIGTSTP ()
{
  AWTRACE "==SIGSTP"

  sig_type="SIGTSTP (??) ctrl-z"

  HandleInterrupt

}

######################################################################
# Handle_SIGTERM: SIGTERM 15 kill
######################################################################
Handle_SIGTERM ()
{
  AWTRACE "==SIGTERM"

  sig_type="SIGTERM (15) kill"

  HandleInterrupt

}

######################################################################
# HandleInterrupt: ...
######################################################################
HandleInterrupt ()
{

 ERRMSG "\nC2H901S PROGRAM INTERRUPTED by ${sig_type}! \n"

# cleanup

 xexit 1 # >AW018<
}

######################################################################
# dummy: ...
######################################################################
dummy ()
{
  DEBUG=0  # debugging 0=OFF 1=ON

  echo "\n-=[ DUMMY ]=-\n"
}

######################################################################
# START
######################################################################
#::::::::::::::::::::::::::::::::::::::::::::::
# ... execution starts here ...
#::::::::::::::::::::::::::::::::::::::::::::::

 if [[ ${NODE} = "aixi" ]]
 then
   AWDEBUG=0 # AWdebugging 0=OFF 1=ON
 else
   AWDEBUG=1 # AWdebugging 0=OFF 1=ON
 fi
 ssh_key_trace="ON" # init set to ON. (do it only once)

# set -m # Necessary for BG Job Monitoring !!

 SYSLANG=${LANG}   # >AW110< save current system language
 export LANG=en_US # >AW110< now set to "English" this makes debugging easier
 C2H_START_TIME=$(date "+%Y-%m-%d - %H:%M:%S")  # ISO8601 compliant date and time string
 C2H_START_HMS=$(date "+%H:%M:%S") # >AW078<
 TRACE_TIME=0 # TIME in TRACE Output 0=OFF 1=ON
 HTML_STATUS="CLOSE"
 TEXT_STATUS="CLOSE"
 CONF_STATUS="CLOSE"

# >AW017< define trap (see /usr/include/sys/signal.h)
# trap 2=SIGINT / 13=SIGPIPE / 15=SIGTERM / 18=SIGTSTP
 trap " "               HUP
 trap "Handle_SIGINT"   2  # ctrl-c
#trap "Handle_SIGPIPE  13  # ??
 trap "Handle_SIGTERM" 15  # kill
#trap "Handle_SIGTSTP" 18  # ctrl-z

 PROCID=$$

 typeset -i collector_cmd_count=0     # collector_cmd_count
 typeset -i paragraph_count=0 # init
 typeset -i HEADL=0     # Headinglevel
 typeset -i CLEAN=0     # cleanup
 cons_continue="OFF" # init

 InitVars         # initialize variables

# check options
#--------------
 EXTENDED=0
 VERBOSE=0
 YESNO="no"

 C2H_CMDLINE=$*  # used for later  >AW021<
 C2H_DATE_TYP=9  # 9=UNDEFINED
# >AW308< BUG: lower "f" missing in getopts list
 while getopts ":^aCDeEfFhHJKlLmMnNo:OPRsStT:UvVyY012:" Option
 do
    case $Option in
       "^" ) YESNO="yes"   ;
         COL_APPL="no"     ; # a   *col-16*  1
#                              A
#                              b
#                              B
#                              c -c <host/hostlist> [copy]
         COL_CRON="no"     ; # C   *col-10*  2
#                              d
         COL_DEVICES="no"  ; # D   *col-05*  4
#                              e -e = extended
         COL_EXP="no"      ; # E   *col-17*  .
         COL_FILES="no"    ; # f   *col-13*  5
         COL_FILESYS="no"  ; # F   *col-04*  6
#                              g
         COL_GPFS="no"     ; # G   *col-22* 29  >AW...<
#                              h -h = help
         COL_HMC="no"      ; # H   *col-03*  7  >AW126<
#                              i
#                              I
#                              j
         COL_JAVA="no"     ; # J   *col-18* 22  >AW035<
#                              k
         COL_KERNEL="no"   ; # K   *col-02*  8
         COL_LUM="no"      ; # l   *col-15*  9  >AW091< => to be DELETED
         COL_LVM="no"      ; # L   *col-06* 10
#                              m
#                              M
         COL_NIM="no"      ; # n   *col-14* 11
         COL_NETWORK="no"  ; # N   *col-08* 12
#                              o -o OUTDIR
#                              O
#                              p -p <host/hostlist> [push]
#        COL_?="no"       ; # ?   *col-11* 13  >AW772<
#        FUNC_PUSH="no"   ; # p   *func-01* 01  >AW773<
         COL_PPPPPP="no"  ; # P   *col-09* 14
#                              q
#                              Q
#                              r
         COL_COMPILER="no" ; # R   *col-19* 26  >AW088<
         COL_SOFTWARE="no" ; # s   *col-12* 16
         COL_SYSTEM="no"   ; # S   *col-01* 17
         CFG_TEST="no"     ; # t   *col-tt* tt
         COL_TSM="no"      ; # T   *col-23* 30
#                              u
         COL_USERS="no"    ; # U   *col-07* 18
#                              v -v VERSION
         COL_VIO="no"      ; # V   *col-20* 27  >AW777<
#                              W  >>> WPAR <<<
#                              w
#                              xX EXTENDED
#                              y  VERBOSE
         COL_SVC="no"      ; # Y   *col-21* 28  >AW...<
#                              z
         ;;
       a   ) COL_APPL=$YESNO     ;; # *col-16* Applications (e.g. SAMBA)
#       c
       C   ) COL_CRON=$YESNO     ;; # *col-10* Cron(tab)
       D   ) COL_DEVICES=$YESNO    ;; # *col-05* Devices
       E   ) COL_EXP=$YESNO      ;; # *col-17* Experimental (for developer use)
       f   ) COL_FILES=$YESNO    ;; # *col-13* List various files
       F   ) COL_FILESYS=$YESNO  ;; # *col-04* File System Info
       G   ) COL_GPFS=$YESNO     ;; # *col-22* GPFS >AW777<
       H   ) COL_HMC=$YESNO      ;; # *col-03* HMC Info
       J   ) COL_JAVA=$YESNO     ;; # *col-18* JAVA Info >AW035<
       K   ) COL_KERNEL=$YESNO   ;; # *col-02* Kernel Info
       l   ) COL_LUM=$YESNO      ;; # *col-15* License Use Manager >AW091< => to be DELETED
       L   ) COL_LVM=$YESNO      ;; # *col-06* Logical Volume Manager
#       L   ) CFG_LPAR=$YESNO      ;; # *col-..* >> LPAR <<
       n   ) COL_NIM=$YESNO      ;; # *col-14* Network Installation Management
       N   ) COL_NETWORK=$YESNO  ;; # *col-08* Network Info
#      p   ) FUNC_PUSH=$YESNO   ;; # *func-01* push >AW773<
       P   ) COL_PPPPPP=$YESNO  ;; # *col-09* PPPPP
       R   ) COL_COMPILER=$YESNO ;; # *col-19* Compiler/Runtime Info >AW088<
       s   ) COL_SOFTWARE=$YESNO ;; # *col-12* Installed Software
       S   ) COL_SYSTEM=$YESNO   ;; # *col-01* System Information
       T   ) COL_TSM=$YESNO      ;; # *col-23* TSM
       U   ) COL_USERS=$YESNO    ;; # *col-07* User Information
       V   ) COL_VIO=$YESNO      ;; # *col-20* VIO >AW777<
#       W   ) COL_WPAR=$YESNO      ;; # *col-..* >> WPAR <<
       2   ) C2H_DATE_TYP=2;
             C2H_DATE="_"$(date +$OPTARG) ;;           # >AW022<
       1   ) C2H_DATE_TYP=1;
             C2H_DATE="_"$(date +%d-%b-%Y) ;;          # >AW022<
       0   ) C2H_DATE_TYP=0;
             C2H_DATE="_"$(date +%d-%b-%Y-%H%M) ;;     # >AW022<
       h   ) usage; exit         ;; #   Usage # >AW018<
       o   ) OUTDIR=$OPTARG      ;; #   -o OUTDIR >AW020<
       t   ) TESTOPT=$OPTARG;       #   -t TESTOPT
             CFG_TEST=$YESNO     ;; # ...
       v   ) echo $VERSION; exit ;; #   Print version # >AW018< >AW000<
       e   ) EXTENDED=1  ;; # Extra Information
       y   ) VERBOSE=1   ;; # show more Info on screen
       Y   ) COL_SVC=$YESNO      ;; # *col-21* SVC >AW777<
       *   ) echo "Unimplemented option (${Option}) chosen! OPTARG=${OPTARG}"; usage; exit 1 ;; # >AW018<
    esac
 done

 shift $(($OPTIND - 1))
# Decrements the argument pointer so it points to next argument.

#%%%%%%%%%%%%
 echo "AWDBG100I CFG_TEST=$CFG_TEST"
 echo "AWDBG100I TESTOPT=$TESTOPT"
#%%%%%%%%%%%%

 if [[ $EXTENDED == 0 ]]; then     # parameter  -e not used, so give info about it
    echo "\n  >> Use option '$(tput rev)[-e]$(tput sgr0)' for 'Extended' output <<$(tput bel)\n"
 else
    echo "\n  WARNING: -e for 'Extended' output currently NOT fully tested ! USE ON YOUR OWN RISK ! \n"
# ToDo 280-000 !!! may run 20 min or longer !!!
 fi

 set ''  # clear vars $1, $2 and so on...; or they will be misinterpreted....

# ToDo 710-710 >remove<
#ERROR_LOG=aw_71Beta.log
 exec 2> $ERROR_LOG  # send all error messages to ERROR_LOG file

 Init_Part2

######################################################################
######################################################################
# Main program which calls above functions with their parameters
######################################################################
#######################  M A I N  ####################################
######################################################################

check_term="INIT"
# check "Terminal"
if [[ -t 0 ]] ; then
  # echo "running with TERM"
  # ToDo 000-000 !!! set var => show if extended/verbose
  check_term="TERM"
else
  # echo "running in BATCH"
  check_term="BATCH"
fi

# ToDo 000-000 !!! CHECK ! seems to NOT work correctly
check_iact="INIT"
# check "interactiv"
if [[ "$-" = *i* ]] ; then
  # echo "running interactiv"
  check_iact="INTERACTIV"
 else
  # echo "running NOT interactiv"
  check_iact="NON-INTERACTIV"
fi

# ToDo 000-000 special var "${0##*/}" contains name of script without path
 AWTRACE ": xxxx => ${0##*/}"  # ...

 line
 echo "Starting........: "$VERSION" on an ${SYSTEM} box"
 echo "Path to cfg2html: "$0
 echo "Path to plugins.: "${PLUGINS}
 echo "Node............: "$NODE
 echo "SysModel........: "$SysModel
 echo "OSLevel.........: "$OSLEVEL_R
 if [[ $mltl = "TL" ]]; then
 echo "ServicePac......: "$OSLEVEL_S
 fi;
 echo "User............: "$USER
 echo "ProcessID.......: "$PROCID
 echo "HTML Output File: "$PWD/$HTML_OUTFILE
 echo "Text Output File: "$PWD/$TEXT_OUTFILE
 echo "Errors logged to: "$PWD/$ERROR_LOG
 echo "Started at......: "${C2H_START_TIME}
 echo "Commandline used: "$C2H_CMDLINE  # >AW021<
#  echo "Problem         : If cfg2Html hangs on Hardware, press twice ENTER"
#  echo "                  or Ctrl-D. Then check or update your Diagnostics!"
 echo "WARNING.........: USE AT YOUR OWN RISK!!! :-))"
 echo "License.........: Freeware"
 line

  AWTRACE ": TERM => ${check_term}"  # ...
  AWTRACE ": IACT => ${check_iact}"  # ...

# logger "Start of $VERSION"

 open_html
 inc_heading_level

 run_collection

 dec_heading_level
# >AW309< BUG: if execution fails or script is interrupted, output is missing !
#close_html

# logger "End of $VERSION"

 echo "\n"
 line

 if [ "$1" != "-x" ]
 then
    xexit 0 # >AW018<
 fi
 xexit 0 # >AW018<
#>>> EOF <<<