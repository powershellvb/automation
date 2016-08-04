# SQL Backup report Automation
#
#  This report will run on daily basis and capture the list of all the databases in all the servers that gives out the size of the databases.
#In this way, SQL Team will be able to identify all the key databases where size is huge and also the databases where database growth rate is #alarmingly high.


# This Power shell will  works on  above 2.0  version .

# History:
#  07-14-2016: Original created by Nataraja Moorthy

#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope CurrentUser
#Change value of following variables as needed
$ServerList = Get-Content "F:\Automation\DbList\DR.txt"
$OutputFile = "F:\Automation\Backup\SQLDatabaseBackupinfo_DR_output.htm"
$HTML = '<style type="text/css">
                #Header{font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;width:100%;border-collapse:collapse;}
                #Header td, #Header th {font-size:14px;border:1px solid #98bf21;padding:3px 7px 2px 7px 7px;}
                #Header th {font-size:14px;text-align:left;padding-top:6px;padding-bottom:4px;background-color:#A7C942;color:#fff;}
                #Header tr.alt td {color:#000;background-color:#EAF2D3;}
                </Style>'
$HTML += "<HTML><BODY><Table border=1 cellpadding=0 cellspacing=0 width=100% id=Header>
                                <TR>
                                                <TH><B>Database Name</B></TH>
                                                <TH><B>RecoveryModel</B></TH>
                                                <TH><B>Last Full Backup Date</B></TH>
                                                <TH><B>Last Differential Backup Date</B></TH>
                                                <TH><B>Last Log Backup Date</B></TH>                                                
                                </TR>"
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null
ForEach ($ServerName in $ServerList)
{
                $s = New-Object "Microsoft.SqlServer.Management.Smo.Server" $ServerName
    $HTML += "<TR bgColor='#ccff66'><TD colspan=5 align=center>$ServerName  </TD></TR>"
    $SQLServer = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $ServerName 
                    Foreach($Database in $SQLServer.Databases | Where-Object {$_.Name -ne "tempdb" -and $_.DatabaseOptions.ReadOnly -eq $false })
                {                                                              
                    $HTML += "<TR>
                                                                                <TD>$($Database.Name)</TD>
                                                                                <TD>$($Database.RecoveryModel)</TD>
                                                                                <TD>$($Database.LastBackupDate)</TD>
                                                                                <TD>$($Database.LastDifferentialBackupDate)</TD>
                                                                                <TD>$($Database.LastLogBackupDate)</TD>                                              
                                                                </TR>"
                }
}
$HTML += "</Table></BODY></HTML>"
$HTML | Out-File $OutputFile