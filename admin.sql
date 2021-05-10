grant execute on utl_file to public;
CREATE OR REPLACE DIRECTORY MYDIR AS 'C:\Users\dandusya\Desktop\DB';

select * from ALL_DIRECTORIES ;

GRANT READ, WRITE ON DIRECTORY MYDIR TO PUBLIC;

grant execute on DBMS_SCHEDULER to PUBLIC;
grant create job to PUBLIC;