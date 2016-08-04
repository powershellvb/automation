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
    } 
    else 
    { 
        $status["Results"] = "Not reachable (down)"
    }
    New-Object -TypeName PSObject -Property $status -OutVariable serverStatus
    $collection += $serverStatus
}
$collection | Export-Csv -LiteralPath .\ServerStatus.csv -NoTypeInformation