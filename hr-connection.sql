create or replace procedure employee_report(p_dir in varchar2, p_filename in varchar2)
is f utl_file.file_type;
cursor cur_avg is 
select last_name, department_id, salary from employees outer
where salary > (select avg(salary)
from employees inner
group by outer.department_id) order by department_id;
begin 
f := utl_file.fopen(p_dir, p_filename, 'W');
utl_file.put_line(f, 'Employees with average salary:');
utl_file.put_line(f, 'Report generated on ' ||SYSDATE);
utl_file.new_line(f);
for emp in cur_avg loop
utl_file.put_line(f, RPAD(emp.last_name, 30)|| ' ' ||
LPAD(NVL(to_char (emp.department_id, '9999'), '-'), 5)|| ' ' ||
lpad(to_char(emp.salary, '$99,999.00'), 12)); end loop;
utl_file.new_line(f);
utl_file.put_line(f, 'END OF REPORT'); utl_file.fclose(f);
end employee_report;

execute employee_report('MYDIR', 'sal_rpt02.txt');

alter table books add description clob;
delete from books;