# 2. How to delete DUPLICATE records from a table using a SQL Query?
use analysis_db;

# add new column rowid
alter table employee
add column rowid varchar(100);

# insert record in this
insert into employee (employee_id, rowid) values
	(101, 'AAASnBAAEAAACrWAAC'),
	(101, 'AAASnBAAEAAACrWAAD'),
	(101, 'AAASnBAAEAAACrWAAE'),
	(102, 'AAASnBAAEAAACrWAAF'),
	(102, 'AAASnBAAEAAACrWAAF'),
	(102, 'AAASnBAAEAAACrWAAG'),
	(103, 'AAASnBAAEAAACrWAAH');
    
select * from employee;

# delte the null value expect rowid column
delete from employee
where name is null
	and salary is null
    and rowid is not null;

-- (how to fix error code 1175 (fix this by: go to edit --> prefrences --> SQL Editor --> uncheck SQL safe update & delete mode)

# insert value into rowid column in existance table
update employee
set rowid = case employee_id
	when 100 then 'AAASnBAAEAAACrWAAA'
    when 101 then 'AAASnBAAEAAACrWAAC'
    when 102 then 'AAASnBAAEAAACrWAAF'
    when 103 then 'AAASnBAAEAAACrWAAH'
end 
where employee_id in (100, 101, 102, 103);

select * from employee;



