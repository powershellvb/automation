

# SQL serverlist Generation
##  This script is used to collect all the servers and each and every  database  current total size and prevoius 5 months  database growth size will  generated in a html report

# This Power shell will  works on  above 2.0  version .

# History:
#  07-14-2016: Original created by Nataraja Moorthy






$OutputFile = "D:\Automation\MonthlyReportsAravind\AutoGrowth\DatabaseGrowthTop25Servers.htm"

$CurrMonth=(Get-Date).AddMonths(0).ToString('yyyy MMM')
$Prev1=(Get-Date).AddMonths(-1).ToString('yyyy MMM')
$Prev2=(Get-Date).AddMonths(-2).ToString('yyyy MMM')
$Prev3=(Get-Date).AddMonths(-3).ToString('yyyy MMM')
$Prev4=(Get-Date).AddMonths(-4).ToString('yyyy MMM')
$Prev5=(Get-Date).AddMonths(-5).ToString('yyyy MMM')
  $HTML = '<style type="text/css">
                #Header{font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;width:100%;border-collapse:collapse;}
                #Header td, #Header th {font-size:14px;border:1px solid #98bf21;padding:3px 7px 2px 7px 7px;}
                #Header th {font-size:14px;text-align:left;padding-top:6px;padding-bottom:4px;background-color:#A7C942;color:#fff;}
                #Header tr.alt td {color:#000;background-color:#EAF2D3;}
                </Style>'
   $HTML += "<HTML><BODY><Table border=1 cellpadding=0 cellspacing=0 width=100% id=Header>
  <TR> <td colspan=8 align=center align=center width:100px > Database Growth Trend  Prod-Servers  Report   $currdate  
                                               
                          </td>                      

                                                                                                
                                </TR>"
  $HTML += "</Table></BODY></HTML>"
$HTML += "<HTML><BODY><Table border=1 cellpadding=0 cellspacing=0 width=100% id=Header>
                                <TR> <TH><B>Environment</B></TH>
                                <TH><B>Location</B></TH>    <TH><B>Metallurugy</B></TH>       
                                <TH><B>ServerName</B></TH>
                                                <TH><B>Database Name</B></TH>
                                                <TH><B>$CurrMonth (GB)</B></TH>
                                                <TH><B>$Prev1(GB)</B></TH>
                                                <TH><B>$Prev2(GB)</B></TH>
                                                <TH><B>$Prev3(GB)</B></TH>
                                                <TH><B>$Prev4(GB)</B></TH>
                                                <TH><B>$Prev5(GB)</B></TH>
                                                
                                                                                            
                                </TR>"
$dt = new-object "System.Data.DataTable"


$SqlQuery = "SELECT T1.ENVIRONMENT,
T1.LOCATION, 
T1.METALLURGY ,
T2.[SERVERNAME] , 
T2.[DATABASENAME]
,T2.[CURMONTH]
,T2.[PREV1]
,T2.[PREV2]
,T2.[PREV3]
,T2.[PREV4]
,T2.[PREV5]
FROM  [TBL_DBTREND] AS T2
INNER JOIN INVENTORY AS T1 ON T2.SERVERNAME=T1.SERVER_NAME  ORDER  BY T2.CurMonth  DESC;
"
  $instance ="SHSCMSTSCDQ501\CMS"

$SQLConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "server=$instance;database=DBADB;Integrated Security=sspi"

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
$HTML += "<TR>
                                                                                <TD> "+ $row[0] + "</TD>
                                                                                <TD> "+ $row[1] + "</TD>
                                                                                <TD> "+ $row[2] + "</TD>
                                                                                <TD> "+ $row[3] + "</TD>
                                                                                <TD> "+ $row[4] + "</TD> 
                                                                                <TD> "+ $row[5]% 1024 + "</TD>   
                                                                                <TD> "+ $row[6]% 1024 + "</TD>  
                                                                                <TD> "+ $row[7]% 1024 + "</TD>
                                                                                <TD> "+ $row[8]% 1024 + "</TD>   
                                                                                <TD> "+ $row[9]% 1024 + "</TD>  
                                                                                <TD> "+ $row[10]% 1024 + "</TD>  
                                                                                                                           
                                                                </TR>"

  
}
#$HTML += "<TR bgColor='#EFECF9'> <TD colspan=7 align=center  height=25 color #F9F8FC>&nbsp;&nbsp;&nbsp;&nbsp;<TD></TR>"





$HTML += "</Table></BODY></HTML>"
$HTML | Out-File $OutputFile

$smtpServer = "smtp.stanfordmed.org"
$smtpFrom = "NMoorthy@stanfordhealthcare.org"
$smtpTo = "NMoorthy@stanfordhealthcare.org"
#$smtpCc = "AUdaykumar@stanfordhealthcare.org,BPatil@stanfordhealthcare.org"
$date1=Get-Date
$date=$date1.ToShortDateString()
$messageSubject = "SQL Monthly DatabaseSize Contractual Report $date"
$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto
$message.Subject = $messageSubject
$message.IsBodyHTML = $true
#$message.Cc.Add($smtpCc)
$MailMessage.Attachments.Add($OutputFile)
$Bodyoutput=Get-Content -Path $OutputFile
$message.Body =" <p> Hi Aravind, </p> "  

$message.Body +=  "             " + "<p>         Please find the below SQL Monthly DatabaseSize Contractual Report.  </p>   "  +  $Bodyoutput 

$message.Body += "<p>    Regards,</p>"
$message.Body += "<p>	 Database Team </p>  "
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($message)
