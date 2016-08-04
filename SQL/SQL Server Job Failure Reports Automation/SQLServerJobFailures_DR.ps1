#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope CurrentUser
#Change value of following variables as needed
$FileName = "D:\Automation\JobFailures\SQLServerJobFailure_DR_servers.htm"
if (Test-Path $FileName) {
  Remove-Item $FileName
}
#"D:\Automation\JobFailures\SQLServerJobFailure_DR_servers.htm
$sqlservers = Get-Content "D:\Automation\JobFailures\DR.txt"
$OutputFile = "D:\Automation\JobFailures\SQLServerJobFailure_DR_servers.htm"
$Enddate=  (get-date).AddDays(-1)
write-host $Enddate
$date = ( get-date ).ToString('yyyy/MM/dd') 
#write-host $date
$HTML = '<style type="text/css">
                #Header{font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;width:100%;border-collapse:collapse;}
                #Header td, #Header th {font-size:14px;border:1px solid #98bf21;padding:3px 7px 2px 7px 7px;}
                #Header th {font-size:14px;text-align:left;padding-top:6px;padding-bottom:4px;background-color:#6F70C4;color:#fff;}
                #Header tr.alt td {color:#000;background-color:#6F70C4;}
                </Style>'
               

$HTML += "<HTML><BODY><Table border=1 cellpadding=0 cellspacing=0 width=100% id=Header> 

 <TR bgColor='#EFECF9'><TD colspan=5 align=center height=25 color:#F9F8FC><B>SQL Server Job Failures With in Last 24 hours Reports DR-Servers : $date <B> </TD></TR>"
 $HTML += "
                                <TR>
                                                <TH><B>Server Name</B></TH>
                                                <TH><B>SQL Job Name</B></TH>
                                                <TH><B> SQL Jobs Enabled</B></TH>
                                                <TH><B>Last Run (Failed Jobs)</B></TH>
                                                                                              
                                </TR>"
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null
#ForEach ($ServerName in $ServerList)
foreach($sqlserver in $sqlservers)
{
# Create an SMO Server object
	  $srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $sqlserver;
 
	  # Jobs counts
	  $totalJobCount = $srv.JobServer.Jobs.Count;
	  $failedCount = 0;
	  $successCount = 0;


#write-host $totalJobCount
   # $HTML += "<TR bgColor='#EFECF9'><TD colspan=5 align=center>$sqlserver </TD></TR>"
  
 # For each jobs on the server
	  foreach($job in $srv.JobServer.Jobs)
	  {
			# Default write colour
			$colour = "Green";
			$jobName = $job.Name;
			$jobEnabled = $job.IsEnabled;
			$jobLastRunOutcome = $job.LastRunOutcome;
            $jobLastRunDate=$job.LastRunDate;
           Write-Host $Enddate 
          Write-Host  $jobLastRunDate;
          foreach($jobd in $job.LastRunDate)
           
           {
     
   if($Enddate -lt  $jobLastRunDate -and $jobEnabled -eq "True"  -and $jobLastRunOutcome -eq "Failed")
   {
			# Set write text to red for Failed jobs
			
  
				  $failedCount += 1;
         if($failedCount -ge 1)
           {
           
           Write-Host $failedCount

           $HTML += "<TR>
                                                                                <TD>$($sqlserver )</TD>
                                                                                <TD>$($jobName )</TD>
                                                                                <TD>$($jobEnabled)</TD>
                                                                                <TD>$($jobLastRunOutcome)</TD>
                                                                                                                            
                                                                </TR>"
			
			
             }

	  }
    }
}
if($failedCount -ge 1)
{
           
$HTML += "<TR bgColor='#EFECF9'> <TD colspan=5 align=center  height=25 color #F9F8FC>&nbsp;&nbsp;&nbsp;&nbsp;<TD></TR>"
}

                                                                    
}
$HTML += "</Table></BODY></HTML>"
$HTML | Out-File $OutputFile
send-mailmessage -from "NMoorthy@stanfordhealthcare.org" -to "NMoorthy@stanfordhealthcare.org" -subject "SQL Server Job Failures With in Last 24 hours Report - DR Servers" -body "SQLServer JOb Failure with in  Last 24 hours Report - DR Servers" -Attachments "D:\Automation\JobFailures\SQLServerJobFailure_DR_servers.htm" -smtpServer smtp.stanfordmed.org
BREAK
