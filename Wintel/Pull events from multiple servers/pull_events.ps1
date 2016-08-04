$date = read-host("Enter the Start date")
[Datetime]$startdate = get-date($date)
$date = read-host("Enter the End date")
[Datetime]$enddate = get-date($date)
$servers = gc -Path ".\servers.txt"
$logname = read-host("Pls enter application log name")
foreach($server in $servers)
{
Get-EventLog -ComputerName $server -LogName $logname -After $startdate -Before $enddate | select EventID,MachineName,Index,Category,EntryType,Message,Source,InstanceId,TimeGenerated,TimeWritten,UserName
}