param 
(
	[Parameter(Position=0,ValuefromPipeline=$true)][string][alias("cn")]$computer,
	[Parameter(Position=1,ValuefromPipeline=$false)][string]$computerlist
)

If (-not ($computer -or $computerlist))
{
	$computers = $Env:COMPUTERNAME
}

If ($computer)
{
	$computers = $computer
}

If ($computerlist)
{
	$computers = Get-Content $computerlist
}

foreach ($computer in $computers)
{
$obj = @{ "ServerName" = $computer; "TimeStamp" = (Get-Date -f s) }
	if (Test-Connection $computer -Count 1 -ea 0 -Quiet)
    { 
		$wmi = Get-WmiObject -ComputerName $computer -Query "SELECT LastBootUpTime FROM Win32_OperatingSystem"
		$now = Get-Date
		$boottime = $wmi.ConvertToDateTime($wmi.LastBootUpTime)
		$uptime = $now - $boottime
		$d =$uptime.days
		$h =$uptime.hours
		$m =$uptime.Minutes
		$s = $uptime.Seconds
		$obj["Reachable"] = "Yes"
		$obj["uptime"] = "$d Days $h Hours $m Min $s Sec"
		$obj["LastReboot"] = $boottime
	}
	else
	{
	$obj["Reachable"] = "No(down)"
	}
	New-Object -TypeName PSObject -Property $obj -OutVariable uptimeStatus
    $collection += $uptimeStatus
}

$collection | select ServerName,Reachable, uptime, LastReboot, TimeStamp | Export-Csv -path .\uptimeStatus.csv -NoTypeInformation