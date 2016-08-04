execute SP_Configure 'Show Advanced Options', 1
reconfigure
execute SP_Configure 'xp_cmdshell', 1
reconfigure 





use master
go
sp_configure 'show advanced options',1
go
reconfigure with override
go
sp_configure 'Database Mail XPs',1
--go
--sp_configure 'SQL Mail XPs',0
go
reconfigure
go

--#################################################################################################
-- BEGIN Mail Settings DL-HCL-SQL
--#################################################################################################
IF NOT EXISTS(SELECT * FROM msdb.dbo.sysmail_profile WHERE  name = 'DL-HCL-SQL') 
  BEGIN
    --CREATE Profile [DL-HCL-SQL]
    EXECUTE msdb.dbo.sysmail_add_profile_sp
      @profile_name = 'DL-HCL-SQL',
      @description  = 'SQL DBA';
  END --IF EXISTS profile
  
  IF NOT EXISTS(SELECT * FROM msdb.dbo.sysmail_account WHERE  name = 'DL-HCL-SQL')
  BEGIN
    --CREATE Account [DL-HCL-SQL]
    EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name            = 'DL-HCL-SQL',
    @email_address           = 'DL-HCL-SQL@stanfordhealthcare.org',
    @display_name            = 'SQL DBA',
    @replyto_address         = 'DL-HCL-SQL@stanfordhealthcare.org',
    @description             = 'SQL DBA',
    @mailserver_name         = 'smtp.stanfordmed.org',
    @mailserver_type         = 'SMTP',
    @port                    = '25',
    @username                =  NULL ,
    @password                =  NULL , 
    @use_default_credentials =  0 ,
    @enable_ssl              =  0 ;
  END --IF EXISTS  account
  
IF NOT EXISTS(SELECT *
              FROM msdb.dbo.sysmail_profileaccount pa
                INNER JOIN msdb.dbo.sysmail_profile p ON pa.profile_id = p.profile_id
                INNER JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id  
              WHERE p.name = 'DL-HCL-SQL'
                AND a.name = 'DL-HCL-SQL') 
  BEGIN
    -- Associate Account [DL-HCL-SQL] to Profile [DL-HCL-SQL]
    EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
      @profile_name = 'DL-HCL-SQL',
      @account_name = 'DL-HCL-SQL',
      @sequence_number = 1 ;
  END --IF EXISTS associate accounts to profiles
--#################################################################################################
-- Drop Settings For DL-HCL-SQL
--#################################################################################################
/*
IF EXISTS(SELECT *
            FROM msdb.dbo.sysmail_profileaccount pa
              INNER JOIN msdb.dbo.sysmail_profile p ON pa.profile_id = p.profile_id
              INNER JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id  
            WHERE p.name = 'DL-HCL-SQL'
              AND a.name = 'DL-HCL-SQL')
  BEGIN
    EXECUTE msdb.dbo.sysmail_delete_profileaccount_sp @profile_name = 'DL-HCL-SQL',@account_name = 'DL-HCL-SQL'
  END 
IF EXISTS(SELECT * FROM msdb.dbo.sysmail_account WHERE  name = 'DL-HCL-SQL')
  BEGIN
    EXECUTE msdb.dbo.sysmail_delete_account_sp @account_name = 'DL-HCL-SQL'
  END
IF EXISTS(SELECT * FROM msdb.dbo.sysmail_profile WHERE  name = 'DL-HCL-SQL') 
  BEGIN
    EXECUTE msdb.dbo.sysmail_delete_profile_sp @profile_name = 'DL-HCL-SQL'
  END
*/
USE [msdb]
GO

/****** Object:  Operator [DL-HCL-SQL]    Script Date: 10/14/2015 3:31:16 AM ******/
EXEC msdb.dbo.sp_add_operator @name=N'DL-HCL-SQL', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=N'DL-HCL-SQL@stanfordhealthcare.org', 
		@category_name=N'[Uncategorized]'
GO
USE [msdb]
GO

/****** Object:  Alert [Log File Usage Alert]    Script Date: 3/7/2016 11:49:24 PM ******/
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
