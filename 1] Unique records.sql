-- 1. How to select UNIQUE records from a table using a SQL Query?
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

# METHOD-1: Using GROUP BY Function
select employee_id, name, salary
from employee
group by employee_id, name, salary;

# METHOD-2: Using ROW_NUMBER Analytic Function
# Row_number analytic function
select *,
row_number() over(partition by employee_id, name, salary order by employee_id) as Row_No
from employee;

# Once row numbers are assigned, by querying the rows with row number 1 will give the unique records from the table.
select employee_id, name, salary
from (select
		employee_id,
        name,
        salary,
        row_number() over (
        partition by employee_id, name, salary
        order by employee_id) as Row_No
from employee) as R
where Row_No = 1;
