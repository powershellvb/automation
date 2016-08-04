# Email notification for servers not rebooted in more than 100days
#
#  This script  is used to collect all the servers if the server is notrebooted more than 100 days those servers will collect the data into HTML  view

# This Power shell will  works on  above 2.0  version .

# History:
#  07-14-2016: Original created by Nataraja Moorthy


#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope CurrentUser
#Change value of following variables as needed
$ErrorActionPreference = 'SilentlyContinue'
cls
$ServerList = Get-Content "D:\Automation\DatabaseSizeAutomation\NonProd.txt"
$OutputFile = "D:\Automation\DatabaseSizeAutomation\ServerLastRebootedNonProd.htm"
$currdate = (Get-Date).ToString('yyyy/MM/dd')
$HTML = '<style type="text/css">
                #Header{font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;width:100%;border-collapse:collapse;}
                #Header td, #Header th {font-size:14px;border:1px solid #98bf21;padding:3px 7px 2px 7px 7px;}
                #Header th {font-size:14px;text-align:left;padding-top:6px;padding-bottom:4px;background-color:#A7C942;color:#fff;}
                #Header tr.alt td {color:#000;background-color:#EAF2D3;}
                </Style>'

                $HTML += "<HTML><BODY><Table border=1 cellpadding=0 cellspacing=0 width=100% id=Header>
  <TR> <td colspan=4 align=center align=center width:100px >Non-Prod-Servers Last rebooted time for the  SQL Server  hosted in  SHC More than 100 Days   $currdate  
                                               
                          </td>                      

                                                                                                
                                </TR>"
  $HTML += "</Table></BODY></HTML>"
$HTML += "<HTML><BODY><Table border=1 cellpadding=0 cellspacing=0 width=100% id=Header>
                                <TR> 
                                                <TH><B>Server Name</B></TH>
                                                <TH><B>Server OS</B></TH>
                                                <TH><B>Server Last Rebooted up Time</B></TH>
                                                 <TH><B>No of Days</B></TH>
                                                

                                                                                                
                                </TR>"
$Enddate=  (get-date).AddDays(-100).ToString('yyyy/MM/dd')
ForEach ($ServerName in $ServerList)
{
             
    #$HTML += "<TR bgColor='#ccff66'><TD colspan=8 align=center>$ServerName  </TD></TR>"

    try 
    {

   # $computerOs=Get-WmiObject -Class win32_OperatingSystem -ComputerName $ServerName -ErrorAction Continue
 $computerOs=Get-WmiObject -Class win32_OperatingSystem -ComputerName $ServerName 
    $ServerOs =$computerOs.Caption 
   $serverLastRebooted=($computerOs.ConvertToDateTime($computerOs.LastBootUpTime)).ToString('yyyy/MM/dd')
  if($Enddate -gt $serverLastRebooted)
   {
#write-host $computerOs.ConvertToDateTime($computerOs.LastBootUpTime) $computerOs.Caption $computerOs.FreePhysicalMemory/1024 $computerOs.FreeVirtualMemory


 $startdate = (Get-Date).ToString('yyyy/MM/dd')
$enddate = $serverLastRebooted
$difference = New-TimeSpan -Start $startdate -End $enddate
 "Days in all: " + $difference.Days
  $HTML += "<TR>
                                                                                <TD>$($ServerName)</TD>
                                                                                <TD>$($ServerOs)</TD>
                                                                                <TD>$($serverLastRebooted)</TD>
                                                                                <TD>$($difference.Days)</TD>
                                                                                
                                                                                 
                                                                                                                             
                                                                </TR>"

   
}
}  catch 
{ } 

}
$HTML += "</Table></BODY></HTML>"
$HTML | Out-File $OutputFile