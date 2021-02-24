--1. Write a PL/SQL block to find the total monthly salary paid by the company
--for a given department number from the employees table. Display a message 
--indicating whether the total salary is greater than or less than $19,000. Test
--your block twice using the Administration department (department_id =10) and
--the IT department (department_id =60).
SET SERVEROUTPUT ON;
DECLARE
v_salary NUMBER;
BEGIN
SELECT SUM(salary) INTO v_salary
From employees
WHERE department_id = 60;
IF v_salary > 19000 THEN 
DBMS_OUTPUT.PUT_LINE(v_salary || '  Greater than 19000');
ELSE
DBMS_OUTPUT.PUT_LINE(v_salary || 'Smaller than 19000');
END IF;
END;

--2. Write a PL/SQL block to select the number of countries in requested region
--(Ex. Europe, Asia). If the number of countries is greater than 20, display “More
--than 20 countries”. If the number of countries is between 10 and 20, display
--“Between 10 and 20 countries”. If the number of countries is less than 10,
--display “Fewer than 10 countries”. Use a CASE statement.
DECLARE
v_count NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count FROM countries
WHERE region_id in (SELECT region_id FROM regions WHERE region_name in ('Asia', 'Europe'));
CASE
WHEN v_count < 10 THEN DBMS_OUTPUT.PUT_LINE('Fewer thqn 10 countries');
WHEN v_count < 10 AND v_count < 20 THEN DBMS_OUTPUT.PUT_LINE('Between 10 and 20');
ELSE 
DBMS_OUTPUT.PUT_LINE('MORE THAN 20 COUNTRIES');
END CASE;
END;

--3. Write a PL/SQL block to display the employee_id and employee’s first_name
--values from the EMPLOYEES table for employee_id whose values range from
--107 through 109. Use a basic loop. Increment a variable from 107 through
--109. Use an IF statement to test your variable and EXIT the loop after you have
--displayed the first 3 employees.
DECLARE
starts NUMBER :=0;
v_name VARCHAR(20);
v_count NUMBER:=107;
BEGIN
LOOP
SELECT employee_id, first_name INTO starts, v_name FROM employees
WHERE employee_id = v_count;
v_count := v_count+1;
DBMS_OUTPUT.PUT_LINE(starts|| '  '||v_name);
EXIT WHEN v_count>109;
END LOOP;
END;

--4.Write a PL/SQL block to produce a list of available vehicle license plate
--numbers. These numbers must be in the following format: NN-MMM, where
--NN is between 60 and 65, and MMM is between 100 and 110. Use nested
--FOR loops. The outer loop should choose numbers between 60 and 65. The
--inner loop should choose numbers between 100 and 110, and concatenate
--the two numbers together.
BEGIN 
FOR v_out IN 60..65 LOOP
FOR v_inn IN 100..110 LOOP
DBMS_OUTPUT.PUT_LINE(v_out||'  '||v_inn);
END LOOP;
END LOOP;
END;

--5. Before starting, create a COPY_EMP table.
--Write a PL/SQL block, for DML functions.
--UPDATE< INSERT<DELETE<MERGE  
------------------5.1 Increase the salary of employees by 10% who work in the state of California.---------------
BEGIN
UPDATE copy_emp
SET salary = salary + (salary*0.1)
WHERE department_id in (select department_id from departments where location_id = (select location_id
from locations where state_province='California') OR
location_id = (select location_id from locations where state_province='Alaska'));
END;
------------------5.2 Increase the salary of employees in that department, which has a minimum average salary by 10%. -------
SET SERVEROUTPUT ON;
BEGIN
UPDATE copy_emp
SET salary = salary + (salary*0.1)
WHERE salary = (SELECT MIN(AVG(salary)) FROM copy_emp  group by department_id);
END;
 
 --5.3 Update the status of employee to manager, if he/she works more than 15
--years. Add a status column to your table, by default all of them have status
--“EMPLOYEE”. All managers should have status of “MANAGER”. 
select * from copy_emp;
alter table copy_emp
add status varchar(30);
update copy_emp
set status = 'Employee';
update copy_emp
set status = 'Manager';
where hire_dite < '01.01.2005';

--5.4 Update the email address of employees in the appropriate way. Ex: First
--letter of last name + name +@department name + country_id ex (.us, .uk)
--LCalvin@education.us . But before updating check your table, if there exists
--email in this pattern, leave it without update. 

ALTER TABLE COPY_EMP 
MODIFY email VARCHAR(255);

BEGIN
    UPDATE COPY_EMP 
    SET email = SUBSTR(last_name,1,1) || first_name || '@' || 
    (SELECT LOWER((select department_name from departments where copy_emp.department_id = departments.department_id)) FROM DUAL) || '.' || 
    (SELECT LOWER((select country_id from locations where location_id = (select location_id from departments where copy_emp.department_id = departments.department_id))) FROM DUAL);
END;


--5.5 Delete those employees who work more than 18 years, but create a
--SAVEPOINT for future usage.
BEGIN
DELETE FROM copy_emp 
WHERE 18 < (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date));
SAVEPOINT DEL;
END;







































