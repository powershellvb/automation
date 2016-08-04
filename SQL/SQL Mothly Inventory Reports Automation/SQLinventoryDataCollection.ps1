
# SQL Monthly  report Automation
##  This report will run on monthly  once will collect all the server and inventory information and generate in a excel sheet 

# This Power shell will  works on  above 2.0  version .

# History:
#  07-14-2016: Original created by Nataraja Moorthy



#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope CurrentUser
#Change value of following variables as needed
cls

$ServerList = Get-Content "F:\Automation\SQLMonthlyInventory\serverlist.txt"

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null
ForEach ($ServerName in $ServerList)
{
$SQLServer = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $ServerName
   Write-Host $SQLServer.PhysicalMemory
   Write-Host $SQLServer.Processors    
Foreach($Database in $SQLServer.Databases | Where-Object {   $_.DatabaseOptions.ReadOnly -eq $false }) 
                  #  Foreach($Database in $SQLServer.Databases )
  
                {   

               # Write-Host $Database.IsAccessible
                #Write-Host $Database.DatabaseOptions.State
               if($Database.IsAccessible-eq $true)
                {  $DBName=$Database.Name
                        $TotalSizeMB= [math]::round($Database.Size,2)
                      $FreeSizeMB= [math]::round($Database.SpaceAvailable/1024,2)
                      $usedSpaceMB =[math]::round(([math]::round($Database.Size,2)  - [math]::round($Database.SpaceAvailable,2)/1024),2)


                        $TotalSize = $TotalSizeMB/1024
                        $TotalGB= [math]::round($TotalSize,2) 

                        $TotalfreeSize = $FreeSizeMB/1024
                        $TotalfreeSizeGB= [math]::round($TotalfreeSize,2) 

                        $TotalSizeused = $usedSpaceMB/1024
                        $TotalUsedGB= [math]::round($TotalSizeused,2) 

                         $TotalPhysicalMemory= [math]::round($SQLServer.PhysicalMemory/1024,0)
                         $TotalSQLPhysicalMemory= [math]::round($SQLServer.PhysicalMemoryUsageInKB/1024,0)
                        $CPU=$SQLServer.Processors
                        Write-Host $TotalPhysicalMemory
                        Write-Host $TotalSQLPhysicalMemory
                        Write-Host $CPU

                        $server = "SHSCMSTSCDQ501\CMS"
$Database = "DBADB"
$Connection = New-Object System.Data.SQLClient.SQLConnection
$Connection.ConnectionString = "server='$Server';database='$Database';trusted_connection=true;"
$Connection.Open()
$Command = New-Object System.Data.SQLClient.SQLCommand
$Command.Connection = $Connection
$SQLQuery2="Insert into [DBADB].[dbo].[InventoryDBCollection2] ([SERVER_NAME]
      ,[DBNAME]
      ,[TotalSizeMB]
      ,[usedSpaceMB]
      ,[FreeSizeMB]
      ,[TotalSizeGB]
      ,[usedSpaceGB]
      ,[FreeSizeGB]
      ,[CPU]
     , [Memory]
      ) values('"+ $ServerName + "','"+ $DBName + "','"+ $TotalSizeMB + "','"+ $usedSpaceMB + "','"+ $FreeSizeMB + "','"+ $TotalGB + "','"+ $TotalUsedGB + "','"+ $TotalfreeSizeGB + "','"+ $CPU + "','"+ $TotalPhysicalMemory + "');"
    $Command.CommandText = $SQLQuery2
    $Command.ExecuteNonQuery();
                   
$Connection.Close()

                }


                }
}