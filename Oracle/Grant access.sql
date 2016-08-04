
---Grant role to user---

grant "&role" to "&user";

---Grant privileges on particular table  to user---

grant select,insert,update,delete on "&TABOWNER"."&TABNAME" to "&user";

---Grant privileges on all tables of a schema to a user---
spool grant.sql
select 'grant select,insert,update,delete  on '||&owner||'.'||table_name||' to &user;' from dba_tables where owner = '&owner';
spool off
 
