

#  Pro-active Monitor for Log file usage Alert.
#
#  This script  is used to find out  whenever the database logfile reaches above  80  we will  receive an alert and send mail to our DL. .

# This Power shell will  works on  above 2.0  version .

# History:
#  07-14-2016: Original created by Nataraja Moorthy

USE [msdb]
GO

/****** Object:  Alert [Log File Usage Alert]    Script Date: 7/8/2016 2:45:45 PM ******/
EXEC msdb.dbo.sp_add_alert @name=N'Log File Usage Alert', 
		@message_id=0, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=900, 
		@include_event_description_in=1, 
		@category_name=N'[Uncategorized]', 
		@performance_condition=N'SQLServer:Databases|Percent Log Used|_Total|>|85', 
		@job_id=N'00000000-0000-0000-0000-000000000000'
GO

