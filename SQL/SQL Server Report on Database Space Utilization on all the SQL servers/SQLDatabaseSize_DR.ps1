#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope CurrentUser
#Change value of following variables as needed
cls
$FileName = "D:\Automation\DatabaseSizeAutomation\SQLDatabaseSize_DR_output.htm"
if (Test-Path $FileName) {
  Remove-Item $FileName
}
$ServerList = Get-Content "D:\Automation\DatabaseSizeAutomation\DR.txt"
$OutputFile = "D:\Automation\DatabaseSizeAutomation\SQLDatabaseSize_DR_output.htm"
$HTML = '<style type="text/css">
                #Header{font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;width:100%;border-collapse:collapse;}
                #Header td, #Header th {font-size:14px;border:1px solid #98bf21;padding:3px 7px 2px 7px 7px;}
                #Header th {font-size:14px;text-align:left;padding-top:6px;padding-bottom:4px;background-color:#A7C942;color:#fff;}
                #Header tr.alt td {color:#000;background-color:#EAF2D3;}
                </Style>'
$HTML += "<HTML><BODY><Table border=1 cellpadding=0 cellspacing=0 width=100% id=Header>
                                <TR>
                                                 <TH><B>Server Name</B></TH>
                                                <TH><B>Database Name</B></TH>
                                                <TH><B>Database Size (MB)</B></TH>
                                                <TH><B>Database Used Space (MB)</B></TH>
                                                <TH><B>Database Free Space (MB)</B></TH>
                                                <TH><B>Database Total Size Space (GB)</B></TH>
                                                <TH><B>Database Total Used Space (GB)</B></TH>
                                                <TH><B>Database Total Free Space (GB)</B></TH>
                                                                                                
                                </TR>"
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null
ForEach ($ServerName in $ServerList)
{
                $s = New-Object "Microsoft.SqlServer.Management.Smo.Server" $ServerName
    $HTML += "<TR bgColor='#ccff66'><TD colspan=8 align=center>$ServerName  </TD></TR>"
    $SQLServer = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $ServerName
Foreach($Database in $SQLServer.Databases | Where-Object {   $_.DatabaseOptions.ReadOnly -eq $false }) 
          #          Foreach($Database in $SQLServer.Databases )
  
                {   

               # Write-Host $Database.IsAccessible
                #Write-Host $Database.DatabaseOptions.State
               if($Database.IsAccessible-eq $true)
                {
                        $TotalSizeMB= [math]::round($Database.Size,2)
                      $FreeSizeMB= [math]::round($Database.SpaceAvailable/1024,2)
                      $usedSpaceMB =[math]::round(([math]::round($Database.Size,2)  - [math]::round($Database.SpaceAvailable,2)/1024),2)


                        $TotalSize = $TotalSizeMB/1024
                        $TotalGB= [math]::round($TotalSize,2) 

                        $TotalfreeSize = $FreeSizeMB/1024
                        $TotalfreeSizeGB= [math]::round($TotalfreeSize,2) 

                        $TotalSizeused = $usedSpaceMB/1024
                        $TotalUsedGB= [math]::round($TotalSizeused,2) 
                                                                                               
                    $HTML += "<TR>
                                                                                <TD>$($ServerName)</TD>
                                                                                <TD>$($Database.Name)</TD>
                                                                                <TD>$($TotalSizeMB)</TD>
                                                                                <TD>$($usedSpaceMB)</TD>
                                                                                <TD>$($FreeSizeMB)</TD>
                                                                                <TD>$($TotalGB)</TD>
                                                                                <TD>$($TotalUsedGB)</TD>
                                                                                <TD>$($TotalfreeSizeGB)</TD>
                                                                                 
                                                                                                                             
                                                                </TR>"


                }

                }
}
$HTML += "</Table></BODY></HTML>"
$HTML | Out-File $OutputFile