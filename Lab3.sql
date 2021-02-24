--2. SET SERVEROUTPUT ON in order to display the output
SET SERVEROUTPUT ON;

-- 3. Write your first “Hello world!” on PL/SQL. 
BEGIN 
DBMS_OUTPUT.PUT_LINE('Hello World');
END;


--4. Write an anonymous PL/SQL block to calculate the salary of an employee whose ID is 110. 
DECLARE v_salary employees.salary%TYPE := 0;
BEGIN
SELECT SALARY INTO v_salary
FROM EMPLOYEES
WHERE EMPLOYEE_ID=110;
DBMS_OUTPUT.put_line(v_salary);
END;

--5. Write an anonymous PL/SQL block to display the name ( first name and
--last name ) for those employee who gets more salary than the employee
--whose ID is 163. (Handle an exception if it occurs.)
SET SERVEROUTPUT ON;
DECLARE 
fname VARCHAR(20);
lname VARCHAR(20);
BEGIN 
   SELECT first_name,
          last_name
   INTO fname,
        lname
   FROM employees 
   WHERE salary > (SELECT salary  FROM employees WHERE employee_id = 163);
   DBMS_OUTPUT.PUT_LINE(fname || lname);
   
   EXCEPTION
   WHEN TOO_MANY_ROWS THEN 
   DBMS_OUTPUT.PUT_LINE('Too many rows!');
END;

-- 6.Write an anonymous PL/SQL block to find the difference between the highest and lowest salaries of employees. 
DECLARE 
max_salary number;
min_salary number;
BEGIN
  SELECT MAX(salary), MIN(salary) 
  INTO max_salary, min_salary
  FROM employees;
  DBMS_OUTPUT.PUT_LINE('Max salary:   '||max_salary|| ' min_salary  ' ||min_salary||' the difference between max salary and min salary:'||(max_salary - min_salary)|| '' );
 END;
 
 --10. Using the DECODE function, write a query that displays the grade of a
--defined employee (ex. employee_id = 102) based on the value of the
--column JOB_ID, using the following data: 
SELECT job_id, decode (job_id,
'AD_PRES',   'A',
'ST_MAN',    'B',
'IT_PROG',   'C',
'SA_REP',    'D',
'ST_CLERK',  'E',
             'O')GRADE
FROM employees
group by job_id
order by grade;


--8 . Write an anonymous PL/SQL block to find the job with the highest average salary. 
DECLARE
max_salary number;
BEGIN
SELECT MAX(AVG(salary))
INTO
max_salary
FROM employees
GROUP BY job_id;
DBMS_OUTPUT.PUT_LINE(max_salary);
END;


--9. Write an anonymous PL/SQL block to display the employee number, last
--name, and salary of all employees who earn more than the average
--salary, and who work in a department with any employee whose last
--name contains a “u” letter. Handle an exception if it occurs. 
DECLARE
emp_id number;
fname VARCHAR2(30);
lname VARCHAR2(30);
sal number;
BEGIN
SELECT employee_id, first_name, last_name, salary
INTO emp_id, fname, lname, sal
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees) and department_id in (SELECT department_id FROM departments WHERE last_name LIKE '%U%');
DBMS_OUTPUT.put_line(emp_id||' '|| fname||' '|| lname||' '|| sal);
EXCEPTION
WHEN TOO_MANY_ROWS THEN
DBMS_OUTPUT.put_line('TOO MANY ROWS');
END;


--7. Write a named PL/SQL block to display the total number of employees
--and, of that total, the number of employees hired in 1995, 1996, 1997,
--and 1998. Create appropriate headings for extracted records. Handle an
--exception if it occurs. Think of what column could be a parameter and
--include it in your named block. 

DECLARE 
    v_total_count NUMBER;
    v_count NUMBER;
        
        
BEGIN 
    SELECT count(*) INTO v_count
    FROM employees
    WHERE hire_date>='01-01-95' AND hire_date<'01-01-99';
    
    SELECT count(*) INTO v_total_count 
    FROM employees;
    DBMS_OUTPUT.PUT_LINE('Total number of employees is '|| v_total_count ||' and the count of employees ,who hired between 1995 and 1998, is '|| v_count);
END;












