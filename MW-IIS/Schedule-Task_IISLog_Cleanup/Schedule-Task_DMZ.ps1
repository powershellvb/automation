# ******
# Script to schedule a task on multiple servers
# This script will copy the batch script to the destination and crete the task
# path will be vary to server to server, Hence that needs to be modified before executing this script
# History:
# 07-26-2016: Original created by Thameem J
# ******
$servers = gc .\servers.txt
$src = Read-Host ("Enter the batch file location where it is located")
$uname = Read-Host("Enter the UserName for DMZ servers, Task will be scheduled with this id")
$pass = Read-Host -Prompt "Enter password"
$collection = $()
foreach($server in $servers)
{
	$username = "$server\$uname"
	$status = @{ "ServerName" = $server; "TimeStamp" = (Get-Date -f s) }
    if (Test-Connection $server -Count 1 -ea 0 -Quiet)
    { 
		$status["Results"] = "Reachable"
		net use k: \\$server\c$ /user:$username $pass
		$dest = "k:\scripts\IISLog-Purge"
		robocopy $src $dest *
		schtasks /create /s $server /tn "IIS-LogPurge" /tr C:\scripts\IISLog-Purge\IISlog-Purge.bat /sc weekly /u $username /p $pass /ru system /d sun /st 02:00 > .\log.txt
		$status["Sch_Status"] = gc -path .\log.txt
		$tst_path = Test-Path -path .\log.txt
		if($tst_path)
		{
			remove-item -path .\log.txt
		}
		net use /delete k:
	}
	else
	{	
		$status["Results"] = "Not reachable (down)"
	}
	New-Object -TypeName PSObject -Property $status -OutVariable serverStatus
    $collection += $serverStatus
}
$collection | select ServerName, Results, TimeStamp | Export-Csv -LiteralPath .\ServerStatus.csv -NoTypeInformation