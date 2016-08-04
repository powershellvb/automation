Import-Module "C:\Program Files\Microsoft System Center 2012 R2\Operations Manager\Powershell\OperationsManager\OperationsManager.psm1"
$servers = Get-Content .\servers.txt

$collection = $()
foreach ($server in $servers)
{
    $status = @{ "ServerName" = $server; "TimeStamp" = (Get-Date -f s) }
    if (Test-Connection $server -Count 1 -ea 0 -Quiet)
    { 
        $status["Results"] = "Reachable"
		$ping = Test-Connection $server -Count 1
		$status["IpAddress"] = $ping.IPV4Address.tostring();
		get-service -name HealthService -computername $server | stop-service 
		pskill \\$server healthservice.exe, monitoringhost.exe
		get-service -name HealthService -computername $server | start-service
		start-sleep -s 120
		$AgentStatus = Get-SCOMAgent -DNSHostName $server.enterprise.stanfordmed.org | select HealthState
		If ( $AgentStatus.HealthState -eq "Success")
		{
			$status["SCOMAgentstatus"] = $AgentStatus.HealthState
		}
		else
		{
			get-service -name HealthService -computername $server | stop-service 
			pskill \\$server healthservice.exe, monitoringhost.exe
			Rename-Item "\\$server\C$\Program Files\Microsoft Monitoring Agent\Agent\Health Service State" "\\$server\C$\Program Files\Microsoft Monitoring Agent\Agent\Health Service State_old"
			get-service -name HealthService -computername $server | start-service
			start-sleep -s 120
			$status["SCOMAgentstatus"] = $AgentStatus.HealthState
		}
    } 
    else 
    { 
        $status["Results"] = "Not reachable (down)"
    }
    New-Object -TypeName PSObject -Property $status -OutVariable serverStatus
    $collection += $serverStatus
}
$collection | Export-Csv -LiteralPath .\SSCOMAgentStatus.csv -NoTypeInformation