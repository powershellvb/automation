

# SQL serverlist Generation
##  This script is used to collect all the servers and each and every  database  current total size and prevoius 5 months  database growth size will  generated in a html report

# This Power shell will  works on  above 2.0  version .

# History:
#  07-14-2016: Original created by Nataraja Moorthy



Cls

$ServerList = Get-Content "D:\Automation\MonthlyReportsAravind\Prod.txt"

$dt = new-object "System.Data.DataTable"
foreach ($instance in  $ServerList)
{

$SqlQuery = "
DECLARE @startDate DATETIME;
SET @startDate = GetDate();

SELECT  @@SERVERNAME,PVT.DatabaseName
    ,PVT.[0]
    ,PVT.[-1]
    ,PVT.[-2]
    ,PVT.[-3]
    ,PVT.[-4]
    ,PVT.[-5]
   
    
FROM (
    SELECT BS.database_name AS DatabaseName
        ,DATEDIFF(mm, @startDate, BS.backup_start_date) AS MonthsAgo
        ,CONVERT(NUMERIC(10, 1), AVG(BF.file_size / 1048576.0)) AS AvgSizeMB
    FROM msdb.dbo.backupset AS BS
    INNER JOIN msdb.dbo.backupfile AS BF ON BS.backup_set_id = BF.backup_set_id
    WHERE BS.database_name NOT IN (
            'master'
            ,'msdb'
            ,'model'
            ,'tempdb'
            )
        AND BS.database_name IN (
            SELECT db_name(database_id)
            FROM master.SYS.DATABASES
            WHERE state_desc = 'ONLINE'
            )
        AND BF.[file_type] = 'D'
        AND BS.backup_start_date BETWEEN DATEADD(yy, - 1, @startDate)
            AND @startDate
    GROUP BY BS.database_name
        ,DATEDIFF(mm, @startDate, BS.backup_start_date)
    ) AS BCKSTAT
PIVOT(SUM(BCKSTAT.AvgSizeMB) FOR BCKSTAT.MonthsAgo IN (  
            [0]  
            ,[-1]
            ,[-2]
            ,[-3]
            ,[-4]
            ,[-5]
           
            
            )) AS PVT
ORDER BY PVT.DatabaseName;
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
#$DataSet.Tables | Format-Table -Auto

 foreach ($row in $DataSet.Tables.Rows)
{ 
<#  Data store into CMS  server    #>
$server = "SHSCMSTSCDQ501\CMS"
$Database = "DBADB"
$Connection = New-Object System.Data.SQLClient.SQLConnection
$Connection.ConnectionString = "server='$Server';database='$Database';trusted_connection=true;"
$Connection.Open()
$Command = New-Object System.Data.SQLClient.SQLCommand
$Command.Connection = $Connection
$SQLQuery2="Insert into [DBADB].[dbo].[tbl_DBTrend] ([servername]
      ,[Databasename]
      ,[CurMonth]
      ,[Prev1]
      ,[Prev2]
      ,[Prev3]
      ,[Prev4]
      ,[Prev5]) values('"+ $row[0] + "','"+ $row[1] + "','"+ $row[2] + "','"+ $row[3] + "','"+ $row[4] + "','"+ $row[5] + "','"+ $row[6] + "','"+ $row[7] + "')"
    $Command.CommandText = $SQLQuery2
    $Command.ExecuteNonQuery()

$Connection.Close()
<#  Data store into CMS  server  completed   #>
  
}

}