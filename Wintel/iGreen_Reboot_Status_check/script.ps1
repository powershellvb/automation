$a = "<style>"
$a = $a + "BODY{background-color:White;}"
$a = $a + "TABLE{border-spacing: 2px;border-width: 1px;border-style: solid;border-color: black;border-collapse: separate;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:SteelBlue; color: white; width: 150px;}"
$a = $a + "TD{border-width: 1px;padding: 5px 2px ;border-style: solid;border-color: black;background-color:White;width: 150px;}"
$a = $a + "</style>"

#Get-WmiObject -Class win32_service -ComputerName IGREEN-PWEB02-S | where {$_.state -ne 'Running' -and $_.startmode -eq 'auto'} | Export-Clixml -Path "C:\temp\web02\before.xml"
$Bfr_Rbt = Import-Clixml -Path "C:\temp\web02\before.xml"
Get-WmiObject -Class win32_service -ComputerName IGREEN-PWEB02-S | where {$_.state -ne 'Running' -and $_.startmode -eq 'auto'} | Export-Clixml -Path "C:\temp\web02\after.xml"
$Aft_Rbt = Import-Clixml -Path "C:\temp\web02\after.xml"
$Serv = Compare-Object $Bfr_Rbt $Aft_Rbt -Property name,state
$serv
if($serv) 
{ 
try
   {
     $services = $serv.name
	foreach ($service in $services)
	{
		get-service -computername IGREEN-PWEB02-S -name $service | Start-Service
	}
	Write-output "IGREEN-PWEB01-S : successfully started the service which are stopped"
   }
catch
   {
      Write-output "Unable start the service"
   }
}
else 
{ 
      Write-output "IGREEN-PWEB02-S : All the auto services are in started state"
}

gwmi win32_service -ComputerName IGREEN-PWEB02-S | where {$_.name -eq 'iisadmin'} | select Systemname, Displayname, State, Startmode | ConvertTo-HTML -head $a -body "<br>IGREEN-PWEB02-S <br><br>" | Out-File c:\temp\web02\web02.htm
c:\temp\web02\uptime.ps1 -computer igreen-pweb02-s | select Servername, Reachable, Uptime, LastReboot | ConvertTo-HTML -head $a | Out-File c:\temp\web02\up_web02.htm