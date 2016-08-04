cls
$ServerList = Get-Content "D:\Automation\DatabaseStatusCheckerReport\NonProd.txt"
$OutputFile = "D:\Automation\DatabaseStatusCheckerReport\NonProdDBAvailabilty_Report.htm"
$currdate = (Get-Date).ToString('yyyy/MM/dd')
  $HTML = '<style type="text/css">
                #Header{font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;width:100%;border-collapse:collapse;}
                #Header td, #Header th {font-size:14px;border:1px solid #98bf21;padding:3px 7px 2px 7px 7px;}

                #Header td, #Header th {font-size:14px;border:1px solid #D0A9F5;padding:3px 7px 2px 7px 7px;}
                #Header th {font-size:14px;text-align:left;padding-top:6px;padding-bottom:4px;background-color:#D0A9F5;color:#fff;}
                #Header 333 {font-size:14px;text-align:left;padding-top:6px;padding-bottom:4px;background-color:#A7C942;color:#fff;}#F781F3
                #Header tr.alt td {color:#00000;background-color:#D0A9F5;}
                 #Header tr.alt td22 {color:#000;background-color:#EAF2D3;}
                td1 { color:#000;background-color:#EAF2D3;}

                </Style>'


                 $HTML += "<HTML><BODY><Table border=1 cellpadding=0 cellspacing=0 width=100% id=Header>
  <TR> <td colspan=3 align=center align=center width:100px >Non Prod-Servers Database  Availabilty Report   $currdate  
                                               
                          </td>                      

                                                                                                
                                </TR>"
  $HTML += "</Table></BODY></HTML>"
$HTML += "<HTML><BODY><Table border=1 cellpadding=0 cellspacing=0 width=100% id=Header>
                                <TR>
                                                <TH><B>ServerName</B></TH>
                                                <TH><B>Database Name</B></TH>
                                                <TH><B>Status</B></TH>
                                               
                                              
                                </TR>"
$dt = new-object "System.Data.DataTable"

$intRow1 = 0
foreach ($instance in  $ServerList)
{

$SqlQuery = "
IF EXISTS (SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#tmp_database'))
BEGIN
drop table #tmp_database
END

declare @count int
declare @name varchar(128)
declare @state_desc varchar(128)

select @count = COUNT(*) from sys.databases where state_desc not in ('ONLINE','RESTORING','EMERGENCY')
create table #tmp_database (name nvarchar(128),state_desc nvarchar(128))
if @count > 0
        begin
            Declare Cur1 cursor for select name,state_desc from sys.databases 
            where state_desc not in ('ONLINE','RESTORING')
        open Cur1
            FETCH NEXT FROM Cur1 INTO @name,@state_desc
            WHILE @@FETCH_STATUS = 0
                BEGIN
                    insert into #tmp_database values(@name,@state_desc)
                FETCH NEXT FROM Cur1 INTO @name,@state_desc
                END
            CLOSE Cur1
            DEALLOCATE Cur1
        end
else 
    begin
        insert into #tmp_database values('ALL DATABASES ARE','ONLINE')
    end

select name as DBName ,state_desc as DBStatus from #tmp_database
"
   

$SQLConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "server=$instance;database=msdb;Integrated Security=sspi"

$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection

$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd

$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
$SqlConnection.Close()

# This code outputs the retrieved data
$DataSet.Tables | Format-Table -Auto
 foreach ($row in $DataSet.Tables.Rows)
{ 
 if($row[1].ToString() -ne "ONLINE")
 {
$HTML += "<TR>
                                                                                <TD> "+ $instance + "</TD>
                                                                                <TD> "+ $row[0] + "</TD>
                                                                                <TD bgcolor='#009933' align=center width=100px> "+ $row[1] + "</TD>
                                                                               
                                                                                                         
                                                                </TR>"

                                                                
$intRow1 = $intRow1+ 1
}

  
}
 

 
 }

 
if($intRow1 -le 1)
{
 $HTML += "<TR bgColor='#EFECF9'> <TD colspan=3 align=center  height=25 color #F9F8FC>All servers &  databases  are online  &nbsp;&nbsp;&nbsp;&nbsp;<TD></TR>"
}
 
$HTML += "</Table></BODY></HTML>"
$HTML | Out-File $OutputFile

#send-mailmessage -from "DL-HCL-SQL@stanfordhealthcare.org" -to "DL-HCL-SQL@stanfordhealthcare.org" -subject "Database Status Report Prod &  Non Prod servers" -body "Database Status Report Prod &  Non Prod servers" -Attachments "D:\Automation\DatabaseStatusCheckerReport\NonProdDBStatus_Report.htm ,D:\Automation\DatabaseStatusCheckerReport\ProdDBStatus_Report.htm" -smtpServer smtp.stanfordmed.org

#Email Settings for delevring the report.
$smtpServer = "smtp.stanfordmed.org"
$smtpFrom = "NMoorthy@stanfordhealthcare.org"
$smtpTo = "NMoorthy@stanfordhealthcare.org"
#$smtpTo = "DL-HCL-SQL@stanfordhealthcare.org"
#$smtpCc = "AUdaykumar@stanfordhealthcare.org,BPatil@stanfordhealthcare.org"
$date1=Get-Date
$date=$date1.ToShortDateString()
$messageSubject = " Non-Prod-Servers Database Status Report $date"
$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto
$message.Subject = $messageSubject
$message.IsBodyHTML = $true
$message.Cc.Add($smtpCc)
$message.Body = Get-Content -Path $OutputFile
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($message)