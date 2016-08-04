cls
$Filename="D:\Automation\SQLInventory\SQLMonthlyContractualReport.xls" 
if (Test-Path $FileName) {
  Remove-Item $FileName
}
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
       [ENVIRONMENT] as 'Enviroment'
      ,[INSTANCE_NAME] as 'SQL Server DB Name with Instance'
        ,[SQL_VERSION]  as 'SQL Version'
      ,[EDITION]  as 'SQL Edition'
      ,[SERVICE_PACK]  as 'Service Pack level'
      ,[Availability_Type] as 'High Availability'
      ,[APPLICATION_NAME]  as 'Application'
      , [Backup_type] as  'Backup Type'
      ,[Compressed_Backup] as 'Compressed Backup'
      ,[Archive] as 'Archive'
        FROM [dbo].[Inventory]
"@  
 
#Create a Excel file to save the data 
# if the directory doesn't exist, then create it 
 
#if (!(Test-Path -path "$DirectoryToSave")) #create it if not existing 
 # { 
 # New-Item "$DirectoryToSave" -type directory | out-null 
 # } 
 
$excel = New-Object -Com Excel.Application #open a new instance of Excel 
$excel.Visible = $True #make it visible (for debugging more than anything) 
$wb = $Excel.Workbooks.Add() #create a workbook 
$currentWorksheet=1 #there are three open worksheets you can fill up 
      if ($currentWorksheet-lt 4)  
      { 
        $ws = $wb.Worksheets.Item($currentWorksheet) 
      } 
      else   
      { 
        $ws = $wb.Worksheets.Add() 
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
      
#$filename = "$DirectoryToSaveTo$filename.xlsx" #save it according to its title 
#if (test-path $filename ) { rm $filename } #delete the file if it already exists 
$wb.SaveAs($Filename,  $xlOpenXMLWorkbook) #save as an XML Workbook (xslx) 
$wb.Saved = $True #flag it as being saved 
$wb.Close() #close the document 
$Excel.Quit() #and the instance of Excel 
$wb = $Null #set all variables that point to Excel objects to null 
$ws = $Null #makes sure Excel deflates 
$Excel=$Null #let the air out 
 
############################################################################


$date1=Get-Date
$date=$date1.ToShortDateString()
send-mailmessage -from "DL-HCL-SQL@stanfordhealthcare.org" -to "MSelvaraj@stanfordhealthcare.org;DL-HCL-SQL@stanfordhealthcare.org" -subject "SQL Monthly Inventory Report +  $date " -body "SQL DB Monthly Inventory Reports"
 -Attachments "D:\Automation\SQLInventory\SQLMonthlyContractualReport.xls" -smtpServer smtp.stanfordmed.org