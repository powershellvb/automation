create newuser.sql

spool createnewuser.log


select USERNAME,ACCOUNT_STATUS,DEFAULT_TABLESPACE,TEMPORARY_TABLESPACE,profile from dba_users where username='&USERNAME';

CREATE USER "&USER"
IDENTIFIED BY start123
DEFAULT TABLESPACE "&TABLESPACE"
TEMPORARY TABLESPACE "&TEMPTABLESPACE"
PROFILE "&PROFILE"
ACCOUNT UNLOCK;


grant "connect","&ROLE" to "&USER";


--Verify user created


select USERNAME,ACCOUNT_STATUS from dba_users where USERNAME='&USERNAME';


spool off;

exit;