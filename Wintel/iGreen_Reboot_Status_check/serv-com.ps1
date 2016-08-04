#data purging#
if (Test-path g:\thameem\prit\igreen\success.htm)
{
	Remove-item -path g:\thameem\prit\igreen\success.htm
}
if(Test-path g:\thameem\prit\igreen\success_1.htm)
{
	Remove-item -path g:\thameem\prit\igreen\success_1.htm
}
#HTML formatting #
$a = "<style>"
$a = $a + "BODY{background-color:White;}"
$a = $a + "TABLE{border-spacing: 2px;border-width: 1px;border-style: solid;border-color: black;border-collapse: separate;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:SteelBlue; color: white; width: 150px;}"
$a = $a + "TD{border-width: 1px;padding: 5px 2px ;border-style: solid;border-color: black;background-color:White;width: 150px;}"
$a = $a + "</style>"

#Initializing Mail Notification#
$datetime = Get-Date -Format "MM-dd-yyyy_HH:mm:ss";
$smtpServer = "smtp.stanfordmed.org"
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$msg = New-Object Net.Mail.MailMessage

$pass = '$t@nf#r3h3l'

g:\thameem\prit\psexec.exe \\igreen-pweb02-s cmd.exe /c 'echo . | powershell.exe -file "c:\temp\web02\script.ps1" ' -u igreen-pweb02-s\!shchcl! -p $pass

net use z: '\\igreen-pweb02-s\c$' /user:igreen-pweb02-s\!shchcl! '$t@nf#r3h3l'

robocopy.exe "z:\temp\web02" "G:\Thameem\prit\igreen\web02" /COPYALL /SEC /E /ZB /TEE /R:1 /W:1 /DCOPY:T

net use z: /d /y

#Web01 Reboot Check#
#Get-WmiObject -Class win32_service -ComputerName IGREEN-PWEB01-S | where {$_.state -ne 'Running' -and $_.startmode -eq 'auto'} | Export-Clixml -Path "g:\thameem\prit\igreen\web01\before.xml"
$web01_Bfr_Rbt = Import-Clixml -Path "g:\thameem\prit\igreen\web01\before.xml"
Get-WmiObject -Class win32_service -ComputerName IGREEN-PWEB01-S | where {$_.state -ne 'Running' -and $_.startmode -eq 'auto'} | Export-Clixml -Path "g:\thameem\prit\igreen\web01\after.xml"
$web01_Aft_Rbt = Import-Clixml -Path "g:\thameem\prit\igreen\web01\after.xml"

#Web02 Reboot Check#

$web02_Bfr_Rbt = Import-Clixml -Path "g:\thameem\prit\igreen\web02\before.xml" 
$web02_Aft_Rbt = Import-Clixml -Path "g:\thameem\prit\igreen\web02\after.xml"

$wb01_Serv = Compare-Object $web01_Bfr_Rbt $web01_Aft_Rbt -Property name,state
$wb02_Serv = Compare-Object $web02_Bfr_Rbt $web02_Aft_Rbt -Property name,state

$wb01_serv
$wb02_serv

if($wb01_serv -or $wb02_serv) 
{ 
	if($wb01_serv)
	{
	$services = $wb01_serv.name
	foreach ($service in $services)
	{
		get-service -computername IGREEN-PWEB01-S -name $service | Start-Service
	}
	Write-output "IGREEN-PWEB01-S : successfully started the service which are stopped"
	}
    gwmi win32_service -ComputerName IGREEN-PWEB01-S | where {$_.name -like '*igreen*' -and $_.startmode -eq 'auto'} | select Systemname, Displayname, State, Startmode | ConvertTo-HTML -head $a -body "IGREEN-PWEB01-S <br><br>" | Out-File g:\thameem\prit\igreen\web01.htm
	get-content -path g:\thameem\prit\igreen\success_1_base.htm | add-content -path g:\thameem\prit\igreen\success_1.htm
	get-content -path g:\thameem\prit\igreen\web01.htm | add-content -path g:\thameem\prit\igreen\success_1.htm
	get-content -path g:\thameem\prit\igreen\web02\web02.htm | add-content -path g:\thameem\prit\igreen\success_1.htm
	add-content -path g:\thameem\prit\igreen\success_1.htm -value "<br><br> <H4>Thanks<br>Wintel Team</H4>"
	#$msg.To.Add("TJafarullah@stanfordhealthcare.org")
    $msg.To.Add("DL-HCL-Wintel@stanfordhealthcare.org")
	#$msg.CC.Add("TJafarullah@stanfordhealthcare.org")
    $msg.From = "Igreen_Status@stanfordhealthcare.org"
    $msg.Subject = "Action Required : Schedule reboot servers IGREEN-PWEB01-S & IGREEN-PWEB02-S"
    $msg.IsBodyHTML = $true
    $msg.Body = get-content g:\thameem\prit\igreen\success_1.htm
    $smtp.Send($msg)
}
else 
{ 
	G:\Thameem\prit\uptime.ps1 -computer igreen-pweb01-s | select Servername, Reachable, Uptime, LastReboot | ConvertTo-HTML -head $a | Out-File g:\thameem\prit\igreen\up_web01.htm
	get-content -path g:\thameem\prit\igreen\success_base.htm | add-content -path g:\thameem\prit\igreen\success.htm
	get-content -path g:\thameem\prit\igreen\up_web01.htm | add-content -path g:\thameem\prit\igreen\success.htm
	get-content -path g:\thameem\prit\igreen\web02\up_web02.htm | add-content -path g:\thameem\prit\igreen\success.htm
	add-content -path g:\thameem\prit\igreen\success.htm -value "<br><br> <H4>Thanks<br>Wintel Team</H4>"
    Write-output "igreen-pweb01-s : All the services are in started state"
    #$msg.To.Add("TJafarullah@stanfordhealthcare.org")
    $msg.To.Add("DL-IT-SHC-HRTeam@stanfordhealthcare.org")
	$msg.CC.Add("DL-HCL-Wintel@stanfordhealthcare.org")
    $msg.From = "DL-HCL-Wintel@stanfordhealthcare.org"
    $msg.Subject = "Schedule reboot servers IGREEN-PWEB01-S & IGREEN-PWEB02-S"
    $msg.IsBodyHTML = $true
    $msg.Body = get-content g:\thameem\prit\igreen\success.htm
    $smtp.Send($msg)
}