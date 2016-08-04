


#  Email notifications for new Database creation & any database deletion.
#
#  This script  is used to identify  whenever the  database  created or deleted automatically send an email notification to our DL

# This Power shell will  works on  above 2.0  version .

# History:
#  07-14-2016: Original created by Nataraja Moorthy

USE [master]
GO

/****** Object:  DdlTrigger [trg_SGMS_DeleteDBTrigger]    Script Date: 7/8/2016 2:59:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




 Create TRIGGER [trg_SGMS_DeleteDBTrigger]
ON ALL SERVER
FOR DROP_DATABASE
AS
declare @results varchar(max)
declare @servername varchar(max)
declare @username nvarchar(100)
declare @subjectText varchar(max)
declare @databaseName VARCHAR(255)
SET @subjectText = 'Database deleted on ' + @@SERVERNAME + ' by ' +  SUSER_SNAME() + '      '  +convert( varchar(40), GETDATE())
set @servername= @@SERVERNAME
set @username=  SUSER_SNAME()
SET @results = 'This Database  has been deleted  by  ' +  SUSER_SNAME()  +  ' on server'+ '    ' + @@SERVERNAME + '     '+ convert( varchar(40), GETDATE()) + ' .'+ '       ' + 
  (SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)'))
SET @databaseName = (SELECT EVENTDATA().value('(/EVENT_INSTANCE/DatabaseName)[1]', 'VARCHAR(255)'))


--INSERT INTO [SHSCMSTSCDQ501\CMS].[DBADB].[dbo].[tbl_db_status_dbcreated_dropped](servername,status,username,databasename)valUES(@servername,'Created',@username,@results)
--Uncomment the below line if you want to not be alerted on certain DB names
--IF @databaseName NOT LIKE '%Snapshot%'
EXEC msdb.dbo.sp_send_dbmail
 @profile_name = 'DL-HCL-SQL',
 @recipients = 'NMoorthy@Stanfordhealthcare.org;DL-HCL-SQL@Stanfordhealthcare.org',
 @body = @results,
 @subject = @subjectText,
 @exclude_query_output = 1 --Suppress 'Mail Queued' message



GO

ENABLE TRIGGER [trg_SGMS_DeleteDBTrigger] ON ALL SERVER
GO

