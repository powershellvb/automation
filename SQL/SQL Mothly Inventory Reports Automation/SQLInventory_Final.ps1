
# SQL Monthly  report Automation
##  This report will run on monthly  once will collect all the server and inventory information and generate in a excel sheet 

# This Power shell will  works on  above 2.0  version .

# History:
#  07-14-2016: Original created by Nataraja Moorthy



cls
$date= Get-Date -Format MMM-yyy
#$Filename = "F:\Automation\SQLMonthlyInventory\SQLMonthlyInventory_" +$date +".xls"
$Filename="F:\Automation\SQLMonthlyInventory\SQLMonthlyInventoryReport.xls" 
Write-Host $Filename

if (test-path $Filename ) { rm $filename } #delete the file if it already exists 
$Filename="F:\Automation\SQLMonthlyInventory\SQLMonthlyInventoryReport.xls" 
#$Filename = "F:\Automation\SQLMonthlyInventory\SQLMonthlyInventory_" +$date +".xls"
$DSN='DBADB' 

# constants. 
$xlCenter=-4108 
$xlTop=-4160 
$xlOpenXMLWorkbook=[int]51 
# and we put the queries in here 
 
# You can replace the SQL 
 cls
$SQL=@" 
USE [DBADB]
  SELECT 
T1.[ENVIRONMENT]  as 'Environment'
,T1.[LOCATION]  as 'Location'
,T1.[METALLURGY] as'Metallurgy'
,T1.[INSTANCE_NAME] as 'Server Name'
,T1.[APPLICATION_NAME] as 'Application'
,T1.[SQL_VERSION]  as 'SQL Version'
,T1.[EDITION]  as 'SQL Edition'
,T1.[SERVICE_PACK] as 'SP level'
,T2.[DBNAME]  as 'DBName'
,T2.[CPU]  as 'CPU'
,T2.[MEMORY]  as 'Memory'
,T2.[TOTALSIZEGB] as 'DB Allocated Space(GB)'
,T2.[USEDSPACEGB] as 'DB Space Utilized(GB)'
,T2.[FREESIZEGB] as 'DB Available Free Space(GB)'
FROM [DBADB].[DBO].INVENTORY AS T1 INNER JOIN INVENTORYDBCOLLECTION2 AS T2  ON T1.[INSTANCE_NAME]=T2.[SERVER_NAME]   WHERE T1.SERVER_STATE='ACTIVE'   order by  T1.METALLURGY   ASC
"@  
 
#Create a Excel file to save the data 
# if the directory doesn't exist, then create it 
 
#if (!(Test-Path -path "$DirectoryToSave")) #create it if not existing 
 # { 
 # New-Item "$DirectoryToSave" -type directory | out-null 
 # } 
 
$excel = New-Object -Com Excel.Application #open a new instance of Excel 
$excel.Visible = $True #make it visible (for debugging more than anything) 
#$excel.Enabled =$True
$wb = $Excel.Workbooks.Add() #create a workbook 
$currentWorksheet=1 #there are three open worksheets you can fill up 
      if ($currentWorksheet-lt 4)  
      { 
        $ws = $wb.Worksheets.Item($currentWorksheet) 
$date= Get-Date -Format MMM-yyy
$ws.Name="SQLMonthlyInventory_" +$date
        
      } 
      else   
      { 
        $ws = $wb.Worksheets.Add() 
        $date= Get-Date -Format MMM-yyy
$ws.Name="SQLMonthlyInventory_" +$date
        
      } #add if it doesn't exist 
      $currentWorksheet += 1 #keep a tally 
     
  # You can refresh it 
 
      $qt = $ws.QueryTables.Add("ODBC;DSN=$DSN", $ws.Range("A1"), $SQL) 
      # and execute it 
      if ($qt.Refresh()) #if the routine works OK 
            { 
            $ws.Activate() 
            $ws.Select() 
            $excel.Rows.Item(1).HorizontalAlignment = $xlCenter 
            $excel.Rows.Item(1).VerticalAlignment = $xlTop 
            $excel.Rows.Item("1:1").Font.Name = "Calibri" 
            $excel.Rows.Item("1:1").Font.Size = 11 
            $excel.Rows.Item("1:1").Font.Bold = $true 
            $Excel.Columns.Item(1).Font.Bold = $true 
            } 
      


#if (test-path $filename ) { rm $filename } #delete the file if it already exists 
$wb.SaveAs($Filename,  $xlOpenXMLWorkbook) #save as an XML Workbook (xslx) 
$wb.Saved = $True #flag it as being saved 
$wb.Close() #close the document 
$Excel.Quit() #and the instance of Excel 
$wb = $Null #set all variables that point to Excel objects to null 
$ws = $Null #makes sure Excel deflates 
$Excel=$Null #let the air out 
 
############################################################################

#Function to send email with an attachment 
 


#Call Function  
#sendEmail -emailFrom  "NMoorthy@stanfordhealthcare.org" -emailTo "NMoorthy@stanfordhealthcare.org"  -subject "Database Details" -body "Database Information" -smtpServer smtp.stanfordmed.org -filePath $Filename 
 
send-mailmessage -from "NMoorthy@stanfordhealthcare.org" -to "NMoorthy@stanfordhealthcare.org" -subject "SQLMonthly Inventory Reports $date" -body "  Hi Aravind ,  Attached is the SQL inventory  Report. Regards , DatabaseTeam "  -Attachments  "F:\Automation\SQLMonthlyInventory\SQLMonthlyInventoryReport.xls"  -smtpServer smtp.stanfordmed.org
 