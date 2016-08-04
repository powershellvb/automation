cd D:\Scheduled_Tasks\File_server_cluster_owner_notification
if(Test-Path D:\Scheduled_Tasks\File_server_cluster_owner_notification\Test.htm)
{
remove-item -path D:\Scheduled_Tasks\File_server_cluster_owner_notification\Test.htm
}

$a = "<style>"
$a = $a + "BODY{background-color:White;}"
$a = $a + "TABLE{border-spacing: 2px;border-width: 1px;border-style: solid;border-color: black;border-collapse: separate;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:SteelBlue; color: white; width: 100px;}"
$a = $a + "TD{border-width: 1px;padding: 5px 2px ;border-style: solid;border-color: black;background-color:White;width: 100px;}"
$a = $a + "</style>"

Get-ClusterGroup -Cluster corp-file-vs7 | where {$_.name -like 'corp-file-vs*'} | select Cluster, Name, Ownernode, State |  ConvertTo-HTML -head $a -body "Hi Team, <br><br> Please find the file server cluster owner, we need to immediately take action if more than one cluster resouses have same owner node. <h4> CORP-FILE-VS7</h4>. " | Out-File D:\Scheduled_Tasks\File_server_cluster_owner_notification\Test.htm

Get-ClusterGroup -Cluster corp-file-vs8 | where {$_.name -like 'corp-file-vs*'} | select Cluster, Name, Ownernode, State |  ConvertTo-HTML -head $a -body "<h4> CORP-FILE-VS8</h4>." | Out-File D:\Scheduled_Tasks\File_server_cluster_owner_notification\Test1.htm

get-content .\Test1.htm | add-content .\Test.htm

Get-ClusterGroup -Cluster corp-file-vs11 | where {$_.name -like 'corp-file-vs*'} | select Cluster, Name, Ownernode, State |  ConvertTo-HTML -head $a -body "<h4> CORP-FILE-VS11</h4>. " | Out-File D:\Scheduled_Tasks\File_server_cluster_owner_notification\Test1.htm

get-content .\Test1.htm | add-content .\Test.htm

add-content -path D:\Scheduled_Tasks\File_server_cluster_owner_notification\Test.htm -value "<H4><br>Regards,<br>Windows Team</H4>"

$datetime = Get-Date -Format "MM-dd-yyyy_HH:mm:ss";
$smtpServer = "smtp.stanfordmed.org"
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$msg = New-Object Net.Mail.MailMessage
#$msg.To.Add("TJafarullah@stanfordhealthcare.org")
$msg.To.Add("DL-HCL-Wintel@stanfordhealthcare.org")
$msg.From = "file_server@stanfordhealthcare.org"
$msg.Subject = "File server cluster owner $datetime"
$msg.IsBodyHTML = $true
$msg.Body = get-content D:\Scheduled_Tasks\File_server_cluster_owner_notification\Test.htm
$smtp.Send($msg)

