cd D:\Scheduled_Tasks\shcvcenter_logon_notification
if(Test-Path D:\Scheduled_Tasks\shcvcenter_logon_notification\Test.htm)
{
remove-item -path D:\Scheduled_Tasks\shcvcenter_logon_notification\Test.htm
}

$a = "<style>"
$a = $a + "BODY{background-color:White;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:SteelBlue; color: white}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:White}"
$a = $a + "</style>"

.\get-logon.ps1 -computername shcvcenter |  ConvertTo-HTML -head $a -body "Hi Team, <br><br> Find the logged in user details below from shcvcenter server, Please logg off, if you find any disconnected sessions to improve the performance. Thanks<br>. " | Out-File D:\Scheduled_Tasks\shcvcenter_logon_notification\Test.htm

add-content -path D:\Scheduled_Tasks\shcvcenter_logon_notification\Test.htm -value "<H4><br><br>Regards,<br>Windows Team</H4>"

$datetime = Get-Date -Format "MM-dd-yyyy_HH:mm:ss";
$smtpServer = "smtp.stanfordmed.org"
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$msg = New-Object Net.Mail.MailMessage
#$msg.To.Add("TJafarullah@stanfordhealthcare.org")
$msg.To.Add("DL-HCL-Wintel@stanfordhealthcare.org")
$msg.From = "vcsessions@stanfordhealthcare.org"
$msg.Subject = "Shcvcenter logged in session $datetime"
$msg.IsBodyHTML = $true
$msg.Body = get-content D:\Scheduled_Tasks\shcvcenter_logon_notification\Test.htm
$smtp.Send($msg)

