--Lab2
--Part 1 (3 problems)

--1. Write a query to display the name (first name and last name) for those employees who gets more salary than the employee whose ID is 163. */
SELECT first_name, last_name FROM employees WHERE salary > (SELECT salary FROM employees WHERE employee_id = 163);

--2. Write a query to display the name (first name and last name), salary, department id, job id for those employees who works in the same designation as the employee works whose id is 169. */
SELECT first_name, last_name, salary, department_id, job_id FROM employees WHERE job_id = (SELECT job_id FROM employees  WHERE employee_id = 169);

--3. Write a query to display the name (first name and last name), salary, department id for those employees who earn such amount of salary which is the smallest salary of any of the departments. */
SELECT first_name, last_name, salary, department_id FROM employees WHERE salary IN (SELECT MIN(salary) FROM employees GROUP BY department_id);


--Part 2 (10 problems)
--8. Display all the information of an employee whose id is any of the number 134, 159 and 183. 
SELECT *  FROM employees  WHERE employee_id IN (134, 159, 183);

--9. Write a query to display all the information of the employees whose salary is within the range 1000 and 3000.
SELECT * FROM employees WHERE salary BETWEEN 1000.00 AND 3000.00;

--10. Write a query to display all the information of the employees whose salary is within the range of smallest salary and 2500.
SELECT *  FROM employees  WHERE salary BETWEEN (SELECT MIN(salary) FROM employees) AND 2500.00;

--11. Write a query to display all the information of the employees who does not work in those departments where some employees works whose manager id within the range 100 and 200. 
SELECT * FROM employees WHERE department_id NOT IN (SELECT department_id FROM departments WHERE employee_id BETWEEN 100 AND 200);

--12. Write a query to display all the information for those employees whose id is any id who earn the second highest salary.
SELECT * FROM employees WHERE employee_id IN (SELECT employee_id FROM employees WHERE salary IN (SELECT MAX(salary) FROM employees  WHERE salary < (SELECT MAX(salary) FROM employees)));

--13. Write a query to display the employee name( first name and last name ) and hiredate for all employees in the same department as Clara. Exclude Clara.
SELECT first_name, last_name, hire_date FROM employees WHERE department_id = (SELECT department_id FROM employees WHERE first_name = 'Clara') AND first_name != 'Clara';

--14. Write a query to display the employee number and name( first name and last name ) for all employees who work in a department with any employee whose name contains a T.
SELECT employee_id, first_name, last_name FROM employees WHERE department_id IN (SELECT department_id FROM employees WHERE first_name LIKE '%T%');

--15.Write a query to display the employee number, name (first name and last name), and salary for all employees who earn more than the average salary and who work in a department with any employee with a J in their name.
SELECT employee_id, first_name, last_name, salary FROM employees  WHERE salary > (SELECT AVG(salary) FROM employees) AND department_id IN (SELECT department_id FROM employees WHERE first_name LIKE '%J%');

--17. Write a query to display the employee number, name (first name and last name) and job title for all employees whose salary is smaller than any salary of those employees whose job title is MK_MAN.
SELECT employee_id, first_name, last_name, job_id FROM employees WHERE salary < ANY (SELECT salary FROM employees  WHERE job_id = 'MK_MAN');

--20.Write a query to display the employee number, name( first name and last name ) and job title for all employees whose salary is more than any average salary of any department.
SELECT employee_id, first_name, last_name, job_id FROM employees WHERE salary > ANY (SELECT AVG(salary) FROM employees GROUP BY department_id);


--Part3(5 problrms)
--26. Write a subquery that returns a set of rows to find all departments that do actually have one or more employees assigned to them. 
SELECT department_name FROM departments WHERE department_id IN (SELECT DISTINCT department_id FROM employees);

-- 29. Write a query to determine who earns more than Mr. Ozer.
SELECT first_name, last_name, salary  FROM employees WHERE salary > (SELECT salary FROM employees WHERE last_name = 'Ozer');

--32. Write a query to get the details of employees who are managers.
SELECT * FROM employees  WHERE employee_id IN (SELECT manager_id FROM departments);

--33. Write a query to get the details of employees who manage a department.
SELECT *  FROM employees  WHERE employee_id = ANY (SELECT manager_id FROM departments);

