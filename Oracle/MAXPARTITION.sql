MAXPARTITION.sql

spool MAXPARTITION.log

select name,open_mode from v$database;

set lines 100
col PARTITION_NAME fro a10
select PARTITION_NAME,PARTITION_POSITION,HIGH_VALUE from dba_tab_partitions where table_name='&TABNAME';

col TABLE_OWNER for a10
col TABLE_NAME for a30
select TABLE_OWNER,TABLE_NAME,PARTITION_POSITION,HIGH_VALUE from dba_tab_partitions where table_name='&TABNAME' and PARTITION_POSITION in (select max(PARTITION_POSITION) from dba_tab_partitions where table_name='&TABNAME' and PARTITION_NAME NOT IN 'PMAX');


spool off;
exit
