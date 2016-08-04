# ******
# Automated SCOM-agent fix for grayed servers
# ******
# This script will get the grayed server list from the SCOM mangement server 
# Take Grayed servers list as input and provide the fix automatically
# Final status of the Scom agent will be mailed to Tools team
#
# History:
# ******
#  06-30-2016: Original created by Thameem J
#  07-14-2016: made single script for collecting grayed server list and push the fix for them
# ******

Import-Module "C:\Program Files\Microsoft System Center 2012 R2\Operations Manager\Powershell\OperationsManager\OperationsManager.psm1"
$WCC = get-scomclass -name "Microsoft.SystemCenter.Agent"
$MO = Get-SCOMMonitoringObject -class:$WCC | where {$_.IsAvailable –eq $false}
$MO |Select-Object -ExpandProperty DisplayName | ft -hidetableheaders | Out-File .\GreyAgents.txt

$scom = Get-SCOMClass -name "Microsoft.SystemCenter.HealthServiceWatcher"
$servers = Get-Content .\GreyAgents.txt

$collection = $()
foreach ($server in $servers)
{
	Write-Output "Connecting to $server"
    $status = @{ "ServerName" = $server; "TimeStamp" = (Get-Date -f s) }
	$AgentStatus = @{"HealthState" = ""}
    if (Test-Connection $server -Count 1 -ea 0 -Quiet)
    { 
		Write-Output "$server : connection successfull, fixing the scom issue"
        $status["Ping_Results"] = "Reachable"
		$ping = Test-Connection $server -Count 1
		$status["IpAddress"] = $ping.IPV4Address.tostring();
		Write-Output " $server : Checking initial SCOM agent status"
		try
		{
			$AgentStatus["HealthState"] = get-scomclassinstance -Class $scom | where {$_.displayname -eq "$server"} | select Healthstate
		}
		catch
		{
			$AgentStatus["HealthState"] = ""
		}
		if ($AgentStatus.HealthState -eq "Success")
		{
			Write-Output " $server : SCOM agent is already healthy"
			$status["SCOMAgentstatus"] = $AgentStatus.HealthState
		}
		elseif($AgentStatus.HealthState -eq "")
		{
			Write-Output " $server : Unable to fetch the SCOM status, maybe access/permission issue"
			$status["SCOMAgentstatus"] = "Unable to fetch the SCOM status"
		}
		else
		{
			Write-Output "$server : Initiating fix Process"
			$sname = get-service -DisplayName 'microsoft monitoring agent' -computername $server
			if ($sname.status -eq 'running')
			{
			$sname.stop()
			write-Output "$server : Stopping microsoft monitoring agent service"
			}
			else
			{
			write-Output "$server : microsoft monitoring agent already in stopped state"
			}
			Get-WmiObject -computer $server -class win32_process  -filter "name = 'healthservice.exe'"| %{$_.terminate()}
			Get-WmiObject -computer $server -class win32_process  -filter "name = 'monitoringhost.exe'"| %{$_.terminate()}
			write-Output "$server : Starting the microsoft monitoring agent service"
			$sname.start()
			write-Output "$server : Entering in to sleep mode for 10 mins"
			start-sleep -s 300
			write-Output "$server : Checking scom agent health status"
			$AgentStatus["HealthState"] = get-scomclassinstance -Class $scom | where {$_.displayname -eq "$server"} | select Healthstate
			If ( $AgentStatus.HealthState -eq "Success")
			{
				$status["SCOMAgentstatus"] = $AgentStatus.HealthState
			}
			else
			{
				write-Output "$server : Proceeding with Health Service State folder Rename, Since scom agent status is still not successfull"
				$path = test-path -path "\\$server\C$\Program Files\Microsoft Monitoring Agent\Agent\Health Service State"
				if($path)
				{
					write-Output "$server : Path found proceeding with folder rename"
					$sname.stop()
					Get-WmiObject -computer $server -class win32_process  -filter "name = 'healthservice.exe'"| %{$_.terminate()}
					Get-WmiObject -computer $server -class win32_process  -filter "name = 'monitoringhost.exe'"| %{$_.terminate()}
					Rename-Item "\\$server\C$\Program Files\Microsoft Monitoring Agent\Agent\Health Service State" "\\$server\C$\Program Files\Microsoft Monitoring Agent\Agent\Health Service State_old"
					$sname.start()
					write-Output "$server : Again Entering in to sleep mode for 10 mins"
					start-sleep -s 300
					write-Output "$server : Checking scom agent health status after health service state folder rename"
					$AgentStatus["HealthState"] = get-scomclassinstance -Class $scom | where {$_.displayname -eq "$server"} | select Healthstate
					If ( $AgentStatus.HealthState -eq "Success")
					{
						$status["SCOMAgentstatus"] = $AgentStatus.HealthState
					}
					else 
					{
						$status["SCOMAgentstatus"] = "Need Manual intervention unable to fix the issue"
					}
				}
				else
				{
					write-Output "$server : \\$server\C$\Program Files\Microsoft Monitoring Agent\Agent\Health Service State, path not found"
					$status["SCOMAgentstatus"] = "Action required : Health Service State Folder not found"
				}
			}
			write-Output "$server : Fix Process completed"
		}
	} 
    else 
    { 
        $status["Ping_Results"] = "Not reachable (down)"
    }
    New-Object -TypeName PSObject -Property $status -OutVariable serverStatus
    $collection += $serverStatus
}
$collection | select ServerName, Ping_Results, IpAddress, SCOMAgentstatus, TimeStamp  | Export-Csv -Path .\SSCOMAgentStatus.csv -NoTypeInformation

#Sending mail to Scom team about the status

if(Test-Path c:\temp\Test.htm)
{
remove-item -path c:\temp\\Test.htm
}

$a = "<style>"
$a = $a + "BODY{background-color:White;}"
$a = $a + "TABLE{border-spacing: 2px;border-width: 1px;border-style: solid;border-color: black;border-collapse: separate;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:SteelBlue; color: white; width: 150px;}"
$a = $a + "TD{border-width: 1px;padding: 5px 2px ;border-style: solid;border-color: black;background-color:White;width: 150px;}"
$a = $a + "</style>"

$collection | select ServerName, Ping_Results, IpAddress, SCOMAgentstatus, TimeStamp | ConvertTo-HTML -head $a -body "Hi Team, <br><br> please find the grayed server list status after auto fixing scom issues. Thanks<br>. " | Out-File "c:\temp\test.htm"
#get-content -path "c:\temp\Test2.htm" | add-content -path "c:\temp\Test.htm"
$datetime = Get-Date -Format "MM-dd-yyyy_HH:mm:ss"
$smtpServer = "smtp.stanfordmed.org"
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$msg = New-Object Net.Mail.MailMessage
#$msg.To.Add("TJafarullah@stanfordhealthcare.org")
$msg.To.Add("DL-HCL-Tools@stanfordhealthcare.org")
$msg.From = "DL-HCL-Tools@stanfordhealthcare.org"
$msg.Subject = "Staus of SCOM greyed server list"
$msg.IsBodyHTML = $true
$msg.Body = get-content c:\temp\Test.htm
$smtp.Send($msg)