. .\Get-Installedsoftware.ps1
$computers = gc -path .\servers.txt
$app = gc -path .\app_name.txt
$temp = $null
foreach ($computer in $computers)
{
if (Get-InstalledSoftware $computer | ?{$_.name -eq $app})
	{
	$temp += ,(Get-InstalledSoftware $computer | ?{$_.name -eq $app}| select computername, name, version)
	}
else
	{
	write-host "'$app' application not available on $computer" -ForegroundColor "yellow"
	}
}

$temp | export-csv -path .\Applicationversion.csv -notypeinformation

