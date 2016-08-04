Add datafile.sql

spool adddatafile.log

select name,open_mode from v$database;

select name,total_mb,free_mb,TYPE, DECODE(total_mb,0,0,((free_mb/total_mb)*100)) "%Free" from v$asm_diskgroup;

set lines 250
set pages 500
col FILE_NAME format a60
col tablespace_name format a25
select tablespace_name, FILE_NAME,sum(a.bytes)/1024/1024,sum(MAXbytes)/1024/1024 ,AUTOEXTENSIBLE,to_char(CREATION_TIME,'DD-MON-YYYY HH:MI:SS')
from dba_data_files A,v$datafile b
where a.file_name=b.name
and TABLESPACE_NAME = '&TBSNAME'
group by FILE_NAME,tablespace_name,file_id,autoextensible,file_id,CREATION_TIME order by tablespace_name,CREATION_TIME, FILE_NAME ;

alter tablespace &TBSNAME add datafile '&DGGROUP' size 500M autoextend on;


select name,total_mb,free_mb,TYPE, DECODE(total_mb,0,0,((free_mb/total_mb)*100)) "%Free" from v$asm_diskgroup;

set lines 250
set pages 500
col FILE_NAME format a60
col tablespace_name format a25
select tablespace_name, FILE_NAME,sum(a.bytes)/1024/1024,sum(MAXbytes)/1024/1024 ,AUTOEXTENSIBLE,to_char(CREATION_TIME,'DD-MON-YYYY HH:MI:SS')
from dba_data_files A,v$datafile b
where a.file_name=b.name
and TABLESPACE_NAME = '&TBSNAME'
group by FILE_NAME,tablespace_name,file_id,autoextensible,file_id,CREATION_TIME order by tablespace_name,CREATION_TIME, FILE_NAME ;


spool off;

exit;