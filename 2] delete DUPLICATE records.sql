# 2. How to delete DUPLICATE records from a table using a SQL Query?
use analysis_db;

create database analysis_db;
use analysis_db;

CREATE TABLE EMPLOYEE (
	EMPLOYEE_ID int, NAME VARCHAR(20), SALARY int
);
 
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(100,'Jennifer',4400);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(100,'Jennifer',4400);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(101,'Michael',13000);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(101,'Michael',13000);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(101,'Michael',13000);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(102,'Pat',6000);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(102,'Pat',6000);
INSERT INTO EMPLOYEE(EMPLOYEE_ID,NAME,SALARY) VALUES(103,'Den',11000);

select * from employee;

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

# METHOD-1: Using ROWID and ROW_NUMBERAnalytic Function
-- An Oracle server assigns each row in each table with a unique ROWID to identify the row in the table. The ROWID is the address of the row which contains the data object number, the data block of the row, the row position and data file.

# STEP-1: Using ROW_NUMBER Analytic function, assign row numbers to each unique set of records. Select ROWID of the rows along with the source columns
	-- first assigning row_number to all records
select rowid, employee_id, name, salary,
row_number() over(
	partition by employee_id, name, salary
    order by salary) as Row_No
from employee;

	-- Next, assign row_number to each unique set of records
    -- select rowid of record with row_number >= 1
select rowid from (
	select rowid, employee_id, name, salary,
    row_number() over(
		partition by employee_id, name, salary
        order by employee_id) as Row_No
	from employee) as E
where Row_No > 1;

# STEP-3: Delete the records from the source table using the ROWID values fetched in previous step

delete from employee
where rowid in (
	select rowid from (
	select rowid, employee_id, name, salary,
    row_number() over(
		partition by employee_id, name, salary
        order by employee_id) as Row_No
	from employee) as E
where Row_No > 1);

select * from employee;
